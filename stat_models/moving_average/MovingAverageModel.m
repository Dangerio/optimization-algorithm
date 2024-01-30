classdef MovingAverageModel < LinearDynamicModel
    %MOVINGAVERAGEMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        lag_count
    end
    
    methods
        function obj = MovingAverageModel(lag_count)
            obj.lag_count = lag_count;
        end
    end
    

    methods (Access = protected)
        % params = [mu, sigma^2, theta_1, ... theta_q]
        function state_transformation = compute_state_transformation( ...
            obj, ~, ~ ...
            )
            state_transformation = [
                zeros(1, obj.lag_count) 0; ...
                eye(obj.lag_count) zeros(obj.lag_count, 1) ...
            ];
        end

        function endog_transformation =  compute_endog_transformation( ...
            ~, ~, params ...
            )
            endog_transformation = [1 params(1, 3:end)];
        end

        function endog_shift = compute_endog_shift(...
            ~, ~, params ...
            )
            endog_shift = params(1);
        end

        function residuals_variance = compute_residuals_variance( ...
            obj, ~, params ...
            )
            residuals_variance = [...
                params(2) zeros(1, obj.lag_count);
                zeros(obj.lag_count, 1) zeros(obj.lag_count)
            ];
        end

        function initial_state_expectation = get_initial_state_expectation(...
            obj, ~ ...
            )
            initial_state_expectation = zeros(obj.lag_count + 1, 1);
        end

        function initial_state_variance = get_initial_state_variance(...
            obj, params ...
            )
            initial_state_variance = eye(obj.lag_count + 1) * params(2);
        end
    end
end

