classdef (Abstract) AbstactSMMEstimator < AbstractMethod
    %ABSTACTSMMESTIMATOR Abstact class for vanilla and weighed SMM.
   
    properties (Abstract = true)
        stream_batch_size;
        stream_batch_loader;
        moments_calculator
        simulational_length_factor
    end

    properties
        has_multidatagen_enabled = false;
    end

    methods
        function obj = enable_multidatagen(obj, first_free_substream, substream_count, num_workers, cur_worker_idx)
            if ~obj.has_multidatagen_enabled
                obj.has_multidatagen_enabled = true;
                obj.stream_batch_loader = RandomStreamPool(obj.stream_batch_size, num_workers, first_free_substream, substream_count).get_loader(cur_worker_idx);
            end
        end

        function obj = initialize_dummy_rs_pool(obj)
            obj.has_multidatagen_enabled = false;
            obj.stream_batch_loader = RandomStreamPool(obj.stream_batch_size, 1, 1).get_loader(1);
        end
    end

    
    methods (Access = protected)
        function params = minimize_smm_objective_function(obj, data, model, param_opt_set, weight_matrix, solver)
            moments_mse = @(params_matrix) obj.estimate_moments_and_compute_mse(data, model, params_matrix, weight_matrix);
            [~, params] = solver.minimize(moments_mse, param_opt_set);
        end
        
        function mse_vector = estimate_moments_and_compute_mse(obj, data, model, params_matrix, weight_matrix)
            points_count = size(params_matrix, 1);
            mse_vector = zeros(points_count, 1);

            data_moments = obj.compute_mean_moments(data);
            for row_index = 1:points_count
                simulated_data = obj.generate_simulated_data( ...
                    obj.simulational_length_factor * data.get_length(), ...
                    params_matrix(row_index, :), model ...
                );
                simulated_data_moments = obj.compute_mean_moments(simulated_data);

                mse_vector(row_index) = obj.compute_moments_mse( ...
                    data_moments, simulated_data_moments, weight_matrix ...
                );
            end
        end

        function mean_moments = compute_mean_moments(obj, trajectory)
            time_series = trajectory.endog.';
            moments_matrix = obj.moments_calculator.compute_moments(time_series);
            mean_moments = obj.moments_calculator.compute_mean_moments(moments_matrix);
        end
    end

    methods (Access = private)

        function time_series_simulated = generate_simulated_data(obj, length, params, model)
            obj.stream_batch_loader.pool.reset();
            is_initial_value_random = false;
            time_series_simulated = model.generate_trajectory(params, length, is_initial_value_random, obj.stream_batch_loader.get_random_stream(1));
        end
        
        
        
        function mse = compute_moments_mse(~, real_moments, simulated_moments, weight_matrix)
            error = real_moments - simulated_moments;
            mse = error * weight_matrix * error.';
        end

    end
end

