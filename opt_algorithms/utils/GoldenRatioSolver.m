classdef GoldenRatioSolver < Solver
    %GOLDENRATIOSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_iter = 100
        tolerance = 0
    end
    
    methods
        function obj = GoldenRatioSolver(num_iter, tolerance)
            if nargin == 2
                obj.num_iter = num_iter;
                obj.tolerance = tolerance;
            end
        end
        
        function [y, x] = minimize(obj, func, opt_set)
            GOLDEN_RATIO = (1 + sqrt(5)) / 2;
            lower_bound = opt_set(1);
            upper_bound = opt_set(2);
    
            iter = 1;
            func_diff = Inf;
            y = Inf;
            while iter <= obj.num_iter && func_diff > obj.tolerance
                if mod(iter, 10) == 1
                    y_old = y;
                end
          
                x_left = upper_bound - (upper_bound - lower_bound) / GOLDEN_RATIO;
                x_right = lower_bound + (upper_bound - lower_bound) / GOLDEN_RATIO;
                y_left = func(x_left);
                y_right = func(x_right);
        
                if y_left > y_right
                    y = y_right;
                    x = x_right;
        
                    lower_bound = x_left;
                else
                    y = y_left;
                    x = x_left;
        
                    upper_bound = x_right;
                end
        
                if mod(iter, 10) == 9
                    func_diff = abs(y - y_old);
                end
                iter = iter + 1;
            end
        end
    end
end

