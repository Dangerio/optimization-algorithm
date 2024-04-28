classdef ConstantEstMethod < AbstractMethod
    %DUMMYMETHOD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        params
        use_baseline = false;
    end
    
    methods

        function obj = ConstantEstMethod(params)
            obj.params = params;
        end


        function [params] = compute_estimates(obj, ~, ~, ~, ~, ~)
            params = obj.params;
        end
    end
end

