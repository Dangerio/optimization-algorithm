classdef WSMMEstimator_IVC < AbstactSMMEstimator
    %WSMMESTIMATOR Implementation of SMM with weight matrix (WSMM)
    
    properties
        stream_batch_size = 3;
        stream_batch_loader
        use_baseline = true
        moments_calculator = MomentsCalculator;
        simulational_length_factor = 10
        sim_length_for_alpha_estimate = 2.5e6
        length_cycle_weight = 10
        smoothing_factor = 0.5
        max_iter = 2
        tolerance = 2.5e-3
        verbose = true
    end
    
    methods
        function obj = WSMMEstimator(moments_calculator, simulational_length_factor, sim_length_for_alpha_estimate, length_cycle_weight, smoothing_factor, max_iter, tolerance, verbose)
            obj = obj.initialize_dummy_rs_pool();
            if nargin >= 1
                obj.moments_calculator = moments_calculator;
            end
            
            if nargin >= 2
                obj.simulational_length_factor = simulational_length_factor;
            end

            if nargin >= 3
                obj.sim_length_for_alpha_estimate = sim_length_for_alpha_estimate;
            end

            if nargin >= 4
                obj.length_cycle_weight = length_cycle_weight;
            end
            
            if nargin >= 5
                obj.smoothing_factor = smoothing_factor;
            end

            if nargin >= 6
                obj.max_iter = max_iter;
            end

            if nargin >= 7
                obj.tolerance = tolerance;
            end

            if nargin >= 8
                obj.verbose = verbose;
            end

        end


        function params = compute_estimates(obj, data, model, param_opt_set, solver)
            initial_param_guess = [];
            % weight_matrix = inv(diag(std(obj.moments_calculator.compute_moments(data.endog.'),1)));

            weight_matrix = obj.compute_weight_matrix(model, data);
            % weight_matrix = eye(obj.moments_calculator.get_moments_count()); 

            old_weight_matrix = inf;
            old_params = Inf;
            for iter = 1:obj.max_iter
                params = obj.minimize_smm_objective_function(data, model, param_opt_set, weight_matrix, solver, initial_param_guess);
                if norm(abs(params - old_params)) < obj.tolerance
                    disp(params)
                    disp('Params norm')
                    disp(norm(abs(params - old_params)))
                    disp('Matrix norm')
                    disp(norm(weight_matrix-old_weight_matrix))
                    disp("Algorithm terminated as tolerance exceeded")
                    break
                end
                if obj.verbose
                    disp(params)
                    disp('Params norm')
                    disp(norm(abs(params - old_params)))
                    disp('Matrix norm')
                    disp(norm(weight_matrix-old_weight_matrix))
                end
                old_weight_matrix = weight_matrix;     
                % weight_matrix = obj.compute_weight_matrix(model, data, params, obj.simulational_length_factor * data.get_length());
                if iter == 1
                    weight_matrix = obj.compute_weight_matrix(model, data, params, obj.simulational_length_factor * data.get_length());
                else
                    weight_matrix = (1 - obj.smoothing_factor) * obj.compute_weight_matrix(model, data, params, obj.simulational_length_factor * data.get_length()) + obj.smoothing_factor * old_weight_matrix;
                end
                old_params = params;     
            end

            if iter == obj.max_iter
                warning("Algorithm terminated as the number of iterations exceeds max_iter.")
            end
            obj.stream_batch_loader.next();
        end
    end

    methods
       function alpha_estimate = compute_alpha_estimate(obj, data, model, params)
            if nargin == 2
                alpha_estimate = obj.compute_mean_moments(data);
            else
                obj.stream_batch_loader.pool.reset();
                is_initial_value_random = false;
                trajectory = model.generate_trajectory( ...
                     params, obj.sim_length_for_alpha_estimate, ...
                     is_initial_value_random, obj.stream_batch_loader.get_random_stream(2) ...
                 );
                alpha_estimate = obj.compute_mean_moments(trajectory);
            end
       end

        function moments_matrix = compute_moments_matrix(obj, model, params, simulated_length)
            obj.stream_batch_loader.pool.reset();
            is_initial_value_random = false;
            trajectory = model.generate_trajectory( ...
                 params, simulated_length, ...
                 is_initial_value_random, obj.stream_batch_loader.get_random_stream(1) ...
             );
            moments_matrix = obj.moments_calculator.compute_moments(trajectory.endog.'); 
        end
        
        function error_matrix = compute_error_matrix(obj, model, data, params, simulated_length)
            if nargin == 3
                alpha_estimate = obj.compute_alpha_estimate(data);
                moments_matrix = obj.moments_calculator.compute_moments(data.endog.');
                error_matrix = (moments_matrix - alpha_estimate);
            else
                alpha_estimate = obj.compute_alpha_estimate(data, model, params);
                % alpha_estimate = obj.compute_alpha_estimate(data);
                moments_matrix = obj.compute_moments_matrix(model, params, simulated_length);
                error_matrix = (moments_matrix - alpha_estimate);
            end
        end
   
   
        function weight_matrix = compute_weight_matrix(obj, model, data, params, simulated_length)
            if nargin == 3
                error_matrix = obj.compute_error_matrix(model, data);
                simulated_length = data.get_length;
            else
                error_matrix = obj.compute_error_matrix(model, data, params, simulated_length);
            end
            weight_matrix = (error_matrix.' * error_matrix)/simulated_length;
            weight_matrix = (weight_matrix + weight_matrix.')/2;
            weight_matrix = pinv(weight_matrix);
            weight_matrix = (weight_matrix + weight_matrix.')/2;
        end
      
    end
end


