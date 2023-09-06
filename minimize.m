function [population] = minimize(func, opt_set, alpha, eps, thr, grid, num_iter)
dim = size(opt_set, 1);
pop_size = dim * 2;

population = generate();
population = calc_new_pop(population, alpha, eps);
iter = 1;
while closeness(population) < thr || iter <= num_iter
    new_population = generate();
    new_population = calc_new_pop(new_population, alpha, eps);
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

    function [val] = closeness(population)
        center = mean(population);
        val = mean(pdist2(population, center));    
    end
    
    function [new_population] = my_sort() 
        values = func(population);
        new_population = [values population];
        new_population = sortrows(new_population, 1, "ascend");
        new_population = new_population(:, 2:end);
    end
end