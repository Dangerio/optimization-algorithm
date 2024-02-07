classdef GlobalSearchSolver < Solver
    %GLOBALSEARCHSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        gs_solver = GlobalSearch
    end
    
    methods
        function obj = GlobalSearchSolver(verbose)
            if nargin == 0
                verbose = false;
            end
            if verbose
                obj.gs_solver.PlotFcn = {@gsplotbestf, @gsplotfunccount};
            end
        end
        
        function [y, x] = minimize(obj, func, opt_set)
            problem = createOptimProblem( ...
                'fmincon', 'objective', func, ...
                'x0', generate_population(1, opt_set), ...
                'lb', opt_set(:, 1), 'ub', opt_set(:, 2) ...
            );
            [x, y] = run(obj.gs_solver, problem);
        end
    end
end

