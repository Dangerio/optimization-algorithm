classdef SurrogateOptSolver < Solver
    %GENETICALGORITHMSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        options = optimoptions(@surrogateopt,'UseVectorized',true)
    end
    
    methods
        function obj = SurrogateOptSolver(verbose)
            if nargin == 0
                verbose = false;
            end
            if verbose
                obj.options = optimoptions(obj.options, 'PlotFcn', 'surrogateoptplot');
            else 
                obj.options = optimoptions(obj.options, 'PlotFcn', []);
            end
            
        end
        
        function [y, x] = minimize(obj, func, opt_set, initial_point)
            if nargin == 4
                opt = optimoptions(obj.options, "InitialPoints", [initial_point]);
            else
                opt = obj.options;
            end
            [x,y] = surrogateopt(func, opt_set(:, 1), opt_set(:, 2), ...
                opt);
        end
    end
end

