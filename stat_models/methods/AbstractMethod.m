classdef (Abstract) AbstractMethod
    %ABSTACTMETHOD Abstact class for estimation procedures of statistical
    %models
    %   Detailed explanation goes here
    
    properties (Abstract)
        use_baseline
    end

    methods (Abstract = true)       
        compute_estimates(obj, data, model, param_opt_set, solver, initial_param_guess)
    end

    methods
        function obj = enable_multidatagen(obj, ~, ~, ~, ~)
        end

        function initial_point = get_initial_point(obj, data, model, param_opt_set, solver, initial_param_guess)
            if nargin == 5
                initial_point = initial_param_guess;
            elseif obj.use_baseline && size(model.baseline, 1) > 0
                initial_point = model.baseline.compute_estimates(data, model, param_opt_set, solver);
            else
                initial_point = [];
            end
        end
    end
end

