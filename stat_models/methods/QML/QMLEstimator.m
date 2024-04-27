classdef QMLEstimator < MLEstimator
    %MLESTIMATOR QuasiMaximum Likelihood Estimator

   methods
        function [params] = compute_estimates(obj, data, model, param_opt_set, solver)
            mult = mean(log(data.endog.^2)) + 1.27;
            likelihood_function = @(params_matrix) obj.compute_log_likelihood_vectorized( ...
                data, model, params_matrix ...
            );
            [~, params] = solver.maximize(likelihood_function, param_opt_set);
            params = obj.add_theta_one(params(:, end-1:end), mult);
        end
   end

   methods (Access = private)
       function params_matrix = add_theta_one(~, params_matrix, mult)
            params_matrix = [(1 - params_matrix(:, 1)) * mult, params_matrix];
       end
   end

end

