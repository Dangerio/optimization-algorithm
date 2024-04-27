classdef QuasiNewtonSolver < Solver
    %SHVEDOVSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        options = optimoptions('fmincon');
    end
    
    methods
        function obj = QuasiNewtonSolver(verbose)
            if nargin < 1
                verbose = false;
            end
            if verbose
                obj.options = optimoptions(obj.options, 'Display','iter','Algorithm','sqp');
            else
                obj.options = optimoptions(obj.options, 'Display', 'off');
            end
        end

        function [y, x] = minimize(obj, func, opt_set)
            problem.options = obj.options;
            problem.solver = 'fmincon';
            problem.x0 = generate_population(1, opt_set);
            problem.lb = opt_set(:, 1);
            problem.ub = opt_set(:, 2);
            problem.objective = func;
             
            [x, y] = fmincon(problem);
        end
    end
end

