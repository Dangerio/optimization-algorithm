classdef MLEstimator < AbstractMethod
    %MLESTIMATOR Maximum Likelihood Estimator
    
   
    methods
        function [params] = compute_estimates(obj, data, model, param_opt_set, solver)
            likelihood_function = @(params_matrix) obj.compute_log_likelihood_vectorized(data, model, params_matrix);
            [~, params] = solver.maximize(likelihood_function, param_opt_set);
        end
    end

    methods (Access = private)
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

