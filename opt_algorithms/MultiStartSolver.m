classdef MultiStartSolver < Solver    
    properties
        solver
        count
    end
    
    methods
        function obj = MultiStartSolver(solver, count)
            obj.solver = solver;
            obj.count = count;
        end
        
        function [y, x] = minimize(obj, func, opt_set)
            [y, x] = multistart(obj.solver, func, opt_set, ...
                obj.count, true);
        end
    end
end

