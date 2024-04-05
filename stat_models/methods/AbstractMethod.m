classdef (Abstract) AbstractMethod
    %ABSTACTMETHOD Abstact class for estimation procedures of statistical
    %models
    %   Detailed explanation goes here
    
    methods (Abstract = true)       
        compute_estimates(obj, data, model, param_opt_set, solver)
    end
end

