function [population] = minimize(func, opt_set, alpha, eps, thr)
dim = size(opt_set, 1);
pop_size = dim / 2;

population = generate();
population = calc_new_pop(population, alpha, eps);
while closeness(population) < thr
    new_population = generate();
    new_population = calc_new_pop(new_population, alpha, eps);
    population = population(1:opt_size / 2, :);
    new_population = new_population(1:opt_size / 2, :);
    population = my_sort(cat(1, population, new_population));
end

    function [population] = generate()
        population = zeros(pop_size, dim);
        for i = 1:dim
            a = opt_set(dim, 1);
            b = opt_set(dim, 2);
            population(:, dim) = unifrnd(a, b, pop_size, 1);   
        end 
    end

    function [val] = closeness(population)
        center = mean(population);
        val = mean(pdist2(population, center));    
    end
    
    function [new_population] = my_sort(population) 
        values = func(population);
        
    end

end