classdef (Abstract) Solver
    %SOLVER Summary of this class goes here
    %   Detailed explanation goes here
        
    methods (Abstract)   
        minimize(obj, func, opt_set);
    end

    methods
        function [y, x] = maximize(obj, func, opt_set)
            minus_func = @(X) -func(X);
            [y, x] = obj.minimize(minus_func, opt_set);
            y = -y;
        end
    end
end

