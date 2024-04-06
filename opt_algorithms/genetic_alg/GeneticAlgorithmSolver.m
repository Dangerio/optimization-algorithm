classdef GeneticAlgorithmSolver < Solver
    %GENETICALGORITHMSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        options = optimoptions(@ga,'UseVectorized',true);
    end
    
    methods
        function obj = GeneticAlgorithmSolver(verbose)
            if nargin == 0
                verbose = false;
            end

            if verbose
                obj.options = optimoptions(obj.options, 'PlotFcn', @gaplotbestf);
            end
        end
        
        function [y, x] = minimize(obj, func, opt_set)
            [x,y] = ga(func, size(opt_set, 1),[],[],[],[], ...
                opt_set(:, 1),opt_set(:, 2),[], obj.options);
        end
    end
end

