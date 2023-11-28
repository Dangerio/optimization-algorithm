function [final_value, population] = minimize(func, opt_set, eps, thr, grid, num_iter, alpha, max_r)
dim = size(opt_set, 1);
pop_size = dim * 2;

iter = 1;
population = generate();
while dist(population) >= thr && iter <= num_iter
    new_population = generate();
    new_population = calc_new_pop(new_population);
    population = population(1:pop_size / 2, :);
    new_population = new_population(1:pop_size / 2, :);
    population = my_sort(cat(1, population, new_population));
    iter = iter + 1;
    if mod(iter, 10) == 0
        disp(func(population(1,:)))
    end
end
final_value = func(population(1,:));

    function [population] = generate()
        population = zeros(pop_size, dim);
        for i = 1:dim
            a = opt_set(i, 1);
            b = opt_set(i, 2);
            population(:, i) = unifrnd(a, b, pop_size, 1);   
        end 
    end

    function [val] = dist(population)
        center = mean(population);
        val = max(pdist2(population, center));    
    end
    
    function [new_population] = my_sort(population) 
        values = func(population);
        new_population = [values population];
        new_population = sortrows(new_population, 1, "ascend");
        new_population = new_population(:, 2:end);
    end

    function [c_r] = calc_c(population, r)
        s = size(population, 1);
        gamma = 1 / r;
        alpha_1 = 1 - gamma * (s - 2) / (s - 1);
        alpha_oth = gamma / (s - 1);
        c_r = alpha_1 * population(1, :) + alpha_oth * sum(population(2:end - 1, :));
    end

    function [population] = calc_new_pop(population)
        big_r = true;
        previous_value = Inf;
        while abs(previous_value - func(population(end, :))) > 1e-16 && func(population(end, :)) -  func(population(1, :)) >= eps &&  big_r == true
            r = 1;
            population_s = population(end,:);
            previous_value = func(population_s);
            while r < max_r
                c_r = calc_c(population, r);
                population_star = find_star(population_s, c_r);
                if ~isstring(population_star)
                    population(end, :) = [];
                    population = [population; population_star];
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
        shifts = repmat(linspace(0, max_shift, grid)', 1, dim);
        
        population_s_streched = repmat(population_s, grid, 1);
        delta_stretched = repmat(c_r - population_s, grid, 1); 
       
        grid_population = population_s_streched + shifts.* delta_stretched;
    
        func_value_x_star = func(grid_population);
        func_value_x1 = func(population(1,:));
        func_value_xs = func(population_s);
        
        grid_condition = func_value_x_star < func_value_xs - alpha * (func_value_xs - func_value_x1);
    
        if any(grid_condition)
            population_star_index = find(grid_condition, 1, 'first');
            population_star = grid_population(population_star_index,:);
    
        else 
            population_star = "N";
        end

    end
end
