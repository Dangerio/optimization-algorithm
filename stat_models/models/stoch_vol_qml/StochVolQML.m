classdef StochVolQML < LinearDynamicModel


    properties (Constant = true)
        exp_log_sq_stdnorm = -double((eulergamma + log(2)));
        var_log_sq_stdnorm = double(eulergamma^2 + eulergamma * log(4)) + log(2)^2 + pi^2 / 2 - double((eulergamma + log(2))^2);
    end

    methods
        function trajectory = generate_trajectory(obj, params, length)
            trajectory = Trajectory(zeros(length, 1));
            hidden_ar_values = obj.generate_hidden_ar_one_process(params, length);
            noise = obj.generate_noise_for_observed_variable(length);
            drift = params(1) / (1 - params(2)) - double(eulergamma) - log(2);
            trajectory.endog = drift + hidden_ar_values + noise;
        end
    end

    methods (Access = private)
        function ar_values = generate_hidden_ar_one_process(~, params, length)
            ar_values = zeros(length, 1);
            ar_values(1) = normrnd(0, sqrt(params(3)^2 / (1 - params(2)^2)));
            noise_values = normrnd(0, params(3), length - 1, 1);
            for time = 2:length
                ar_values(time) = params(2) * ar_values(time - 1) + noise_values(time - 1);
            end
        end

        function noise_values = generate_noise_for_observed_variable(obj, length)
            noise_values = log(normrnd(0, 1, length, 1).^2) - obj.exp_log_sq_stdnorm;
        end
    end


    methods (Access = protected)
        % params = [theta_1, theta_2, theta_3]
        function state_transformation = compute_state_transformation( ...
            ~, ~, params ...
            )
            state_transformation = [
                params(2) 0;
                0 0;
            ];
        end

        function endog_transformation =  compute_endog_transformation( ...
            ~, ~, ~ ...
            )
            endog_transformation = [1 1];
        end

        function endog_shift = compute_endog_shift(...
            obj, ~, params ...
            )
            endog_shift = params(1) / (1 - params(2)) + obj.exp_log_sq_stdnorm;
        end

        function residuals_variance = compute_residuals_variance( ...
            obj, ~, params ...
            )
            residuals_variance = [...
                params(3)^2 0;
                0 obj.var_log_sq_stdnorm
            ];
        end

        function initial_state_expectation = get_initial_state_expectation(...
            ~, ~ ...
            )
            initial_state_expectation = [0;0];
        end

        function initial_state_variance = get_initial_state_variance(...
            obj, params ...
            )
            initial_state_variance = [
                params(3)^2 / (1 - params(2)^2) 0;
                0 obj.var_log_sq_stdnorm
            ];
        end
    end
end

