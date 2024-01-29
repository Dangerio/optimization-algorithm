classdef ParticleSwarmSolver < Solver
    %PARTICLESWARMSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    properties
        alpha = 0.95;
        beta = 0.2;
        gamma = 0.2;
        population_size = 100;
        num_iter = 10^6;
        tolerance = 0;
    end
    
    methods
        function obj = ParticleSwarmSolver(alpha, beta, gamma, population_size, num_iter, tolerance)
            %PARTICLESWARMSOLVER Construct an instance of this class
            %   Detailed explanation goes here
            if nargin == 6
                obj.alpha = alpha;
                obj.beta = beta;
                obj.gamma = gamma;
                obj.population_size = population_size;
                obj.num_iter = num_iter;
                obj.tolerance = tolerance;
            end
        end
     
        
        function [value_global, argmin_global] = minimize(obj, func, opt_set)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            dim = size(opt_set, 1);
            direction_set = [(opt_set(:, 1) - opt_set(:, 2))'; (opt_set(:, 2) - opt_set(:, 1))']';


            X = generate(obj.population_size, opt_set);
            V = generate(obj.population_size, direction_set);            
            X = correct_population(X + V, opt_set);
            y = func(X);
            value_local = y;
            argmin_local = X;
            
            [value_global, idxmin_global] = min(value_local);
            argmin_global = argmin_local(idxmin_global, :);
            
            iter = 1;
            func_value_diff = Inf;
            while iter <= obj.num_iter && func_value_diff > obj.tolerance
                if mod(iter, 1000) == 1
                    old_value = value_global;
                end
                
               
                xi_1 = repmat(unifrnd(0, 1, obj.population_size, 1), 1, dim);
                xi_2 = repmat(unifrnd(0, 1, obj.population_size, 1), 1, dim);
                V = obj.alpha * V + obj.beta * xi_1 .* (argmin_local - X) +  obj.gamma * xi_2 .* (argmin_global - X);
                X = correct_population(X + V, opt_set);
                y = func(X);
            
                [value_local, idxmin_local] = min([value_local, y], [], 2);
                mask_idx = find(idxmin_local == 2);
                argmin_local(mask_idx, :) = X(mask_idx, :);
                [value_global, idxmin_global] = min(value_local);
                argmin_global = argmin_local(idxmin_global, :);
            
                if mod(iter, 1000) == 999
                    func_value_diff = abs(old_value - value_global);
                end
                iter = iter + 1;
            end
            
            if iter > obj.num_iter
                disp("WARNING")
                disp("Max limit on iterations has reached, probably the algorithm fails to converge.")
            end

        end
    end
end

