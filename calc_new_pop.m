function [population] = calc_new_pop(func, population, grid, eps)
while func(population(end, :)) -  func(population(1, :)) >= eps
    r = 1;
    population_s = population(end,:);
    while True
        c_r = calc_c(population);
        population_star = find_star(population_s, c_r, grid);
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