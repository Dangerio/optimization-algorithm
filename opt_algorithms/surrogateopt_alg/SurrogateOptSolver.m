classdef SurrogateOptSolver < Solver
    %GENETICALGORITHMSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        options = optimoptions(@surrogateopt,'UseVectorized',true, ...
            'PlotFcn', []);
    end
    
    methods
        function obj = SurrogateOptSolver(verbose)
            if nargin == 0
                verbose = false;
            end
            if verbose
                obj.options =  optimoptions(@surrogateopt,'UseVectorized',true);
            else
                obj.options =  optimoptions(@surrogateopt,'UseVectorized',true, ...
                'PlotFcn', []);
            end
            
        end
        
        function [y, x] = minimize(obj, func, opt_set)
            [x,y] = surrogateopt(func, opt_set(:, 1), opt_set(:, 2), ...
                obj.options);
        end
    end
end

