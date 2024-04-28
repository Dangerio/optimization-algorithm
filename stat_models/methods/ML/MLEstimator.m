classdef MLEstimator < AbstractMethod
    %MLESTIMATOR Maximum Likelihood Estimator
    properties
        use_baseline = true
    end
   
    methods
        function [params] = compute_estimates(obj, data, model, param_opt_set, solver, initial_param_guess)
            if nargin < 6
                initial_param_guess = [];
            end
            
            likelihood_function = @(params_matrix) obj.compute_log_likelihood_vectorized(data, model, params_matrix);
            [~, params] = solver.maximize(likelihood_function, param_opt_set, obj.get_initial_point(data, model, param_opt_set, solver, initial_param_guess));
        end
    end

    methods (Access = protected)
        function log_likelihoods = compute_log_likelihood_vectorized(~, data, model, params_matrix)
            points_count = size(params_matrix, 1);
            log_likelihoods = zeros(points_count, 1);
            for row_index = 1:points_count
                log_likelihoods(row_index) = model.compute_log_likelihood( ...
                    data, params_matrix(row_index, :) ...
                );
            end
        end 
        
    end
end

