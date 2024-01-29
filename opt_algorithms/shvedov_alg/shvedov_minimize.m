function [final_value, best_argument] = shvedov_minimize(func, opt_set, eps, num_iter, alpha, max_r, beta, tolerance)
% add all functions to path
addpath(genpath(fileparts(pwd)));


dim = size(opt_set, 1);
pop_size = 3 + dim * 2;
drop_size = floor(pop_size / 2);

iter = 1;
population = generate(pop_size);
update_population();
func_diff = Inf;
while iter <= num_iter && func_diff > tolerance
    if mod(iter, 100) == 1
        y_old = func(population(1, :));
    end

    population(end - (drop_size - 1) : end, :) = generate(drop_size);
    update_population();

    iter = iter + 1;
    if mod(iter, 100) == 99
        func_diff = abs(func(population(1, :)) - y_old);
    end

    % if mod(iter, 50) == 0
    %     format short e
    %     disp('Точки')
    %     disp(population)
    %     disp('Значение функции')
    %     disp(func(population))
    % end
end


if iter > num_iter
    disp("WARNING")
    disp("Max limit on iterations has reached, probably the algorithm fails to converge.")
end

best_argument = population(1,:);
final_value = func(best_argument);

    function [population] = generate(pop_size)
        population = zeros(pop_size, dim);
        for i = 1:dim
            a = opt_set(i, 1);
            b = opt_set(i, 2);
            population(:, i) = unifrnd(a, b, pop_size, 1);   
        end 
    end
    
    function [new_population] = my_sort(population) 
        values = func(population);
        new_population = [values population];
        new_population = sortrows(new_population, 1, "ascend");
        new_population = new_population(:, 2:end);
    end

    function [c_r] = calc_c(population, r)
        s = size(population, 1);
        gamma = r^(-beta);
        alpha_1 = 1 - gamma * (s - 2) / (s - 1);
        alpha_oth = gamma / (s - 1);
        c_r = alpha_1 * population(1, :) + alpha_oth * sum(population(2:end - 1, :));
    end


    function [] = update_population()
        population = my_sort(population);
        big_r = true;
        previous_value = Inf;
        while abs(previous_value - func(population(end, :))) > eps &&  big_r
            r = 1;
            population_s = population(end,:);
            previous_value = func(population_s);
            while r < max_r
                c_r = calc_c(population, r);

                population_star = find_star(population_s, c_r);
                if ~isstring(population_star)
                    % if mod(iter, 50) == 0
                    %     disp(r)
                    % end
                    population(end, :) = population_star;
                    population = my_sort(population);
                    break
                else
                    r = r + 1;
                end
                
            end
            if r == max_r
                big_r = false;
            end
        end
    end
     
            
    
    function [shift] = find_intersection(from, direction, limits, index, limit_index)
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

    
    function [max_shift] = calc_max_shift(population_s, c_r)
        max_shift = "N";
        direction = c_r - population_s;
        for i = 1:dim
            shift_until_lower_bound = find_intersection(population_s, direction, opt_set, i, 1);
            if ~isstring(shift_until_lower_bound)
                if isstring(max_shift)
                    max_shift = shift_until_lower_bound;
                else 
                    max_shift = min(max_shift, shift_until_lower_bound);
                end
            end

            shift_until_upper_bound = find_intersection(population_s, direction, opt_set, i, 2);
            if ~isstring(shift_until_upper_bound)
                if isstring(max_shift)
                    max_shift = shift_until_upper_bound;
                else 
                    max_shift = min(max_shift, shift_until_upper_bound);
                end
            end
  
        end

    end
    

    function [population_star] = find_star(population_s, c_r)
        
        max_shift = calc_max_shift(population_s, c_r);
        helper_func = @(shift) func(population_s + shift .* (c_r - population_s));
        [best_value, best_shift] = GoldenRatioSolver(50, 0).minimize(helper_func, [0, max_shift]);

        func_value_x1 = func(population(1,:));
        func_value_xs = func(population_s);
        if best_value < func_value_xs - alpha * (func_value_xs - func_value_x1)
            population_star = population_s + best_shift .* (c_r - population_s);
        else
            population_star = "N";
        end
      
    end
end
