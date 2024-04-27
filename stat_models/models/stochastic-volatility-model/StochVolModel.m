classdef StochVolModel < LinearDynamicModel


    properties (Constant = true)
        exp_log_sq_stdnorm = -double((eulergamma + log(2)));
        var_log_sq_stdnorm = double(eulergamma^2 + eulergamma * log(4)) + log(2)^2 + pi^2 / 2 - double((eulergamma + log(2))^2);
    end

    methods
        function trajectory = generate_trajectory(obj, params, length, is_initial_value_random, stream)
            trajectory = Trajectory(zeros(length, 1));
            
            hidden_ar_values = obj.generate_hidden_ar_one_process(params, length, is_initial_value_random, stream);
            sigma = exp(params(1) / (2 * (1 - params(2))));
            noise = randn(stream, length, 1);
            trajectory.endog = exp(hidden_ar_values / 2) .* noise * sigma;
        end

        function volatiles = get_volatiles(obj, trajectory, params)
            % get hiddens from Approx. Kalman Filtering
            hiddens = obj.get_predictions(trajectory, params);
            % calculate standard deviations
            volatiles = exp(0.5 * (hiddens(:, 1) + params(1) / (1 - params(2)))); 
        end

    end

    methods (Access = private)
        function ar_values = generate_hidden_ar_one_process(~, params, length, is_initial_value_random, stream)
            ar_values = zeros(length, 1);

            if is_initial_value_random
                ar_values(1) = randn(stream) * sqrt(params(3)^2 / (1 - params(2)^2));
            else
                ar_values(1) = 0;
            end
            
            noise_values = randn(stream, length - 1, 1) * params(3);
            for time = 2:length
                ar_values(time) = params(2) * ar_values(time - 1) + noise_values(time - 1);
            end
        end
    end


    methods (Access = protected)
        % params = [theta_1, theta_2, theta_3]

        function [transformed_trajectory] = transform_data_to_ldm(~, trajectory)
            transformed_trajectory = Trajectory(log(trajectory.endog.^2));
        end


        
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

