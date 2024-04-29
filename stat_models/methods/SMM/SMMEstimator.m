classdef SMMEstimator < AbstactSMMEstimator
    %SMMESTIMATOR Implementation of vanilla SMM (with Identity weight matrix)
    
    properties
        stream_batch_size = 1;
        stream_batch_loader

        moments_calculator = MomentsCalculator;

        simulational_length_factor = 10;
        verbose = false;
        use_baseline = true
    end
    
    methods
        function obj = SMMEstimator(moments_calculator, simulational_length_factor)
            obj = obj.initialize_dummy_rs_pool();
            if nargin >= 1
                obj.moments_calculator = moments_calculator;
            end
            if nargin >= 2
                obj.simulational_length_factor = simulational_length_factor;
            end
            if nargin >= 3
                obj.verbose = verbose;
            end
            
        end
        
        function params = compute_estimates(obj, data, model, param_opt_set, solver, initial_param_guess)
            if nargin < 6
                initial_param_guess = [];
            end
            weight_matrix = inv(diag(std(obj.moments_calculator.compute_moments(data.endog.'),1)));
            params = obj.minimize_smm_objective_function(data, model, param_opt_set, weight_matrix, solver, initial_param_guess);
            if obj.verbose
                disp(params)
            end
            obj.stream_batch_loader.next();
        end
    end

end

