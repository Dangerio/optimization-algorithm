classdef SMMEstimator < AbstactSMMEstimator
    %SMMESTIMATOR Implementation of vanilla SMM (with Identity weight matrix)
    properties 
        moments_calculator
        simulational_length_factor = 10
    end
    
    methods
        function obj = SMMEstimator(moments_calculator, simulational_length_factor)
            obj.moments_calculator = moments_calculator;
            if nargin == 2
                obj.simulational_length_factor = simulational_length_factor;
            end
        end
        
        function params = compute_estimates(obj, data, model, param_opt_set, solver)
            weight_matrix = eye(obj.moments_calculator.get_moments_count());
            moments_mse = @(params_matrix) obj.estimate_moments_and_compute_mse(data, model, params_matrix, weight_matrix);
            [~, params] = solver.minimize(moments_mse, param_opt_set);
        end
    end

end

