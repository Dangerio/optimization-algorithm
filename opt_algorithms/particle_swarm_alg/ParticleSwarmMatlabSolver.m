classdef ParticleSwarmMatlabSolver < Solver
    %GENETICALGORITHMSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        options = optimoptions(@particleswarm,'UseVectorized',true);
    end
    
    methods
        function obj = ParticleSwarmMatlabSolver()
        end
        
        function [y, x] = minimize(obj, func, opt_set)
            [x,y] = particleswarm(func, size(opt_set, 1), ...
                opt_set(:, 1),opt_set(:, 2), obj.options);
        end
    end
end

