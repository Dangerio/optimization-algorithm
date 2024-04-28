classdef StochVolMMEstimator < AbstractMethod
    %STOCHVOLMMESTIMATOR Summary of this class goes here
    %   Detailed explanation goes here
    properties
        use_baseline = false;
    end
    
    methods
        function [params] = compute_estimates(obj, data, ~, param_opt_set, ~, ~)
            params = zeros(1, 3);

            log_sq_traj = log(data.endog.^2);
            traj_mean = mean(log_sq_traj);
            traj_cov_mat = cov(log_sq_traj(2:end, :), log_sq_traj(1:end - 1, :));
            traj_var = traj_cov_mat(1, 1);
            traj_corr = traj_cov_mat(1, 2) / traj_var;

            params(1, 2) = traj_corr * traj_var / (abs(traj_var - 0.5*pi^2));
            params = obj.clip_param(params, param_opt_set, 2);
            params(1, 3) = sqrt(abs(traj_var - 0.5*pi^2) * (1 - params(1, 2)^2));
            params = obj.clip_param(params, param_opt_set, 3);
            params(1, 1) = (1 - params(1, 2)) * (1.27 + traj_mean);
            params = obj.clip_param(params, param_opt_set, 1);
        end
    end


    methods (Access = private)
        function [params] = clip_param(~, params, param_opt_set, param_idx)
            lower = param_opt_set(param_idx, 1);
            upper = param_opt_set(param_idx, 2);
            param = params(1, param_idx);
            if param < lower
                param = lower;
            elseif param > upper
                param = upper;
            end
            params(1, param_idx) = param;
        end

    end
end

