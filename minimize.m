function [population] = minimize(func, opt_set, eps, thr, grid, num_iter, alpha)
dim = size(opt_set, 1);
pop_size = dim * 2;

iter = 1;
population = generate();
population = calc_new_pop(population);
while dist(population) >= thr && iter <= num_iter
    new_population = generate();
    new_population = calc_new_pop(new_population);
    population = population(1:pop_size / 2, :);
    new_population = new_population(1:pop_size / 2, :);
    population = my_sort(cat(1, population, new_population));
    iter = iter + 1;
end

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
        val = mean(pdist2(population, center));    
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
        while func(population(end, :)) -  func(population(1, :)) >= eps
            r = 1;
            population_s = population(end,:);
            while true
                c_r = calc_c(population, r);
                population_star = find_star(population_s, c_r);
                if population_star ~= 'N'
                    population(end, :) = [];
                    population = [population; population_star];
                    population = my_sort(population);
                    break
                else
                    r = r + 1;
                end
                
            end
        end
    end
    

    function [population_star] = find_star(population_s, c_r)
        
        grid_denomerator = [1:(grid - 1)].'/grid;
        grid_denomerator = repmat(grid_denomerator, 1, dim);
        
        
        population_r_streched = repmat(population_s, grid - 1, 1);
        c_r_streched = repmat(c_r,grid - 1, 1);
        
        
        grid_population = grid_denomerator .* population_r_streched + (1 - grid_denomerator) .* c_r_streched;
    
        func_value_x_star = func(grid_population);
        func_value_x1 = func(population(1,:));
        func_value_xs = func(population_s);
        
        grid_condition = func_value_x_star < func_value_xs - alpha * (func_value_xs - func_value_x1);
    
        if any(grid_condition)
            population_star_index = find(grid_condition, 1, 'first');
            population_star = grid_population(population_star_index,:);
    
        else 
            population_star = 'N';
        end

    end
end
