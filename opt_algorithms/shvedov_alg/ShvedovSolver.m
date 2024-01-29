classdef ShvedovSolver < Solver
    %SHVEDOVSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        eps = 1e-16;
        alpha = 0.5;
        max_r = 100;
        beta = 1;
        num_iter = 1000;
        tolerance = 1e-16;
        verbose = false;
        golden_search_solver = GoldenRatioSolver(50, 0);
        population
        
    end
    
    methods
        function obj = ShvedovSolver(eps, alpha, max_r, beta, num_iter, tolerance, verbose)
            if nargin == 7
                obj.eps = eps;
                obj.alpha = alpha;
                obj.max_r = max_r;
                obj.beta = beta;
                obj.num_iter = num_iter;
                obj.tolerance = tolerance;
                obj.verbose = verbose;
            end
        end

        function [final_value, best_argument] = minimize(obj, func, opt_set)
            dim = size(opt_set, 1);
            pop_size = 3 + dim * 2;
            drop_size = floor(pop_size / 2);
            
            iter = 1;
            obj.population = generate(pop_size, opt_set);
            obj = obj.update_population(func, opt_set);
            func_diff = Inf;
            while iter <= obj.num_iter && func_diff > obj.tolerance
                if mod(iter, 100) == 1
                    y_old = func(obj.population(1, :));
                end
            
                obj.population(end - (drop_size - 1) : end, :) = generate(drop_size, opt_set);
                obj = obj.update_population(func, opt_set);
            
                iter = iter + 1;
                if mod(iter, 100) == 99
                    func_diff = abs(func(obj.population(1, :)) - y_old);
                end
            
                if obj.verbose && mod(iter, 50) == 0
                    format short e
                    disp('Точки')
                    disp(obj.population)
                    disp('Значение функции')
                    disp(func(obj.population))
                end
            end
            
            
            if iter > obj.num_iter
                disp("WARNING")
                disp("Max limit on iterations has reached, probably the algorithm fails to converge.")
            end

            best_argument = obj.population(1,:);
            final_value = func(best_argument);
        end
    end

    methods (Access = private, Static = true)
        function [new_population] = sort_by_func_value(population, func)
            values = func(population);
            new_population = [values population];
            new_population = sortrows(new_population, 1, "ascend");
            new_population = new_population(:, 2:end);
        end
     
        function [shift] = find_intersection(from, direction, limits, index, limit_index)
            dim = size(limits, 1);
            shift = (limits(index, limit_index) - from(index)) / direction(index);
            intersection = from + shift .* direction;
        
            for i = 1:dim 
                lower_bound = limits(i, 1);
                upper_bound = limits(i, 2);
                if shift < 0 || intersection(i) < lower_bound - 1e-6 || intersection(i) > upper_bound + 1e-6
                    shift = "N";
                    break
                end
            end
        end


        function [max_shift] = calc_max_shift(population_s, opt_set, c_r)
            dim = size(population_s, 2);
            max_shift = "N";
            direction = c_r - population_s;
            for i = 1:dim
                shift_until_lower_bound = ShvedovSolver.find_intersection(population_s, direction, opt_set, i, 1);
                if ~isstring(shift_until_lower_bound)
                    if isstring(max_shift)
                        max_shift = shift_until_lower_bound;
                    else 
                        max_shift = min(max_shift, shift_until_lower_bound);
                    end
                end
    
                shift_until_upper_bound = ShvedovSolver.find_intersection(population_s, direction, opt_set, i, 2);
                if ~isstring(shift_until_upper_bound)
                    if isstring(max_shift)
                        max_shift = shift_until_upper_bound;
                    else 
                        max_shift = min(max_shift, shift_until_upper_bound);
                    end
                end
            end
        end
    end

    methods (Access = private)

        function [c_r] = calc_c(obj, r)
            s = size(obj.population, 1);
            gamma = r^(-obj.beta);
            alpha_1 = 1 - gamma * (s - 2) / (s - 1);
            alpha_oth = gamma / (s - 1);
            c_r = alpha_1 * obj.population(1, :) + alpha_oth * sum(obj.population(2:end - 1, :));
        end
        
 
    
        function [obj] = update_population(obj, func, opt_set)
            obj.population = ShvedovSolver.sort_by_func_value(obj.population, func);
            big_r = true;
            previous_value = Inf;
            while abs(previous_value - func(obj.population(end, :))) > obj.eps &&  big_r
                r = 1;
                population_s = obj.population(end,:);
                previous_value = func(population_s);
                while r < obj.max_r
                    c_r = obj.calc_c(r);
    
                    population_star = obj.find_star(func, opt_set, c_r);
                    if ~isstring(population_star)
                        obj.population(end, :) = population_star;
                        obj.population = ShvedovSolver.sort_by_func_value(obj.population, func);
                        break
                    else
                        r = r + 1;
                    end
                    
                end
                if r == obj.max_r
                    big_r = false;
                end
            end
        end

        function [population_star] = find_star(obj, func, opt_set, c_r)
            population_s = obj.population(end,:);

            max_shift = ShvedovSolver.calc_max_shift(population_s, opt_set, c_r);
            helper_func = @(shift) func(population_s + shift .* (c_r - population_s));
            [best_value, best_shift] = obj.golden_search_solver.minimize(helper_func, [0, max_shift]);
    
            func_value_x1 = func(obj.population(1,:));
            func_value_xs = func(population_s);
            if best_value < func_value_xs - obj.alpha * (func_value_xs - func_value_x1)
                population_star = population_s + best_shift .* (c_r - population_s);
            else
                population_star = "N";
            end
          
        end

    end
end

