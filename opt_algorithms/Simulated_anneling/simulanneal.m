classdef simulanneal < Solver
    %GENETICALGORITHMSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        options = optimoptions('simulannealbnd', 'ObjectiveLimit', 0)
    end
    
    methods
        function obj = simulanneal(verbose)
            if nargin == 0
                verbose = false;
            end
            if verbose
                obj.options = optimoptions(obj.options, 'PlotFcn', 'saplotbestf');
            else 
                obj.options = optimoptions(obj.options, 'PlotFcn', []);
            end
            
        end
        
        function [y, x] = minimize(obj, func, opt_set)
            problem.options = obj.options;
            problem.solver = 'simulannealbnd';
            problem.x0 = generate_population(1, opt_set);
            problem.lb = opt_set(:, 1);
            problem.ub = opt_set(:, 2);
            problem.objective = func;
             
            [x, y] = simulannealbnd(problem);
        end
    end
end


