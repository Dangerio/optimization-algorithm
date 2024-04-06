classdef WSMMEstimator < AbstactSMMEstimator
    %WSMMESTIMATOR Implementation of SMM with weight matrix (WSMM)
    
    properties
        moments_calculator
        simulational_length_factor = 10
        sim_length_for_alpha_estimate = 2.5e6
        length_cycle_weight = 10
        smoothing_factor = 0.5
        max_iter = 20
        tolerance = 2.5e-3
        verbose = true
    end

    properties (Access = private)
        stream = RandStream("mt19937ar", "Seed", 1)
    end
    
    methods
        function obj = WSMMEstimator(moments_calculator, simulational_length_factor, sim_length_for_alpha_estimate, length_cycle_weight, smoothing_factor, max_iter, tolerance, verbose)
            obj.moments_calculator = moments_calculator;
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
            weight_matrix = eye(obj.moments_calculator.get_moments_count());
            
            old_params = Inf;
            for iter = 1:obj.max_iter
                params = obj.minimize_smm_objective_function(data, model, param_opt_set, weight_matrix, solver);
                if norm(abs(params - old_params)) < obj.tolerance
                    break
                end
                if obj.verbose
                    disp(params)
                    disp(norm(abs(params - old_params)))
                end
                weight_matrix = (1 - obj.smoothing_factor) * obj.compute_weight_matrix(model, params, obj.simulational_length_factor * data.get_length()) + obj.smoothing_factor * weight_matrix;
                old_params = params;            
            end

            if iter == obj.max_iter
                warning("Algorithm terminated as the number of iterations exceeds max_iter.")
            end
        end
    end

    methods (Access = private)
        function alpha_estimate = compute_alpha_estimate(obj, model, params)
            is_initial_value_random = true;
            trajectory = model.generate_trajectory( ...
                 params, obj.sim_length_for_alpha_estimate, ...
                 is_initial_value_random, obj.stream ...
             );
            alpha_estimate = obj.compute_mean_moments(trajectory);
        end

        function moments_matrix = compute_moments_matrix(obj, model, params, simulated_length)
            is_initial_value_random = true;
            trajectory = model.generate_trajectory( ...
                 params, simulated_length, ...
                 is_initial_value_random, obj.stream ...
             );
            moments_matrix =  obj.moments_calculator.compute_moments(trajectory.endog.');
        end

        function error_matrix = compute_error_matrix(obj, model, params, simulated_length)
            alpha_estimate = obj.compute_alpha_estimate(model, params);
            moments_matrix = obj.compute_moments_matrix(model, params, simulated_length);
            error_matrix = moments_matrix - alpha_estimate;
        end

        function Q = compute_Q_matrix(~, error_matrix, j)
            Q = zeros(size(error_matrix, 2));
            size_of_series = size(error_matrix, 1);
            for s = j+1:size_of_series
                Q = Q + error_matrix(s - j,:).' * error_matrix(s,:);
            end
            Q = Q./(size_of_series);
        end

        function B_matrix = compute_B_matrix(obj, error_matrix)
            B_matrix = obj.compute_Q_matrix(error_matrix, 0);
            
            for k = 1:obj.length_cycle_weight
                Q_j = obj.compute_Q_matrix(error_matrix, k);
                weight_inside = (obj.length_cycle_weight + 1 - k) / (obj.length_cycle_weight + 1);
                B_matrix = B_matrix + weight_inside * (Q_j + Q_j.');
            end
        end

        function weight_matrix = compute_weight_matrix(obj, model, params, simulated_length)
            error_matrix = obj.compute_error_matrix(model, params, simulated_length);
            B_matrix = obj.compute_B_matrix(error_matrix);
            weight_matrix = pinv(B_matrix);
        end


    end
end

