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
        
        function [y, x] = minimize(obj, func, opt_set, initial_point)
            
            if nargin == 4
                x0 = initial_point;
            else
                x0 = generate_population(1, opt_set);
            end
            problem = createOptimProblem( ...
                'fmincon', 'objective', func, ...
                'x0', x0, ...
                'lb', opt_set(:, 1), 'ub', opt_set(:, 2) ...
            );
            [x, y] = run(obj.gs_solver, problem);
        end
    end
end

