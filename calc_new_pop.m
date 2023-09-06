function [population] = calc_new_pop(population)
    r = 1;
    cur_iter = 0;
    population_s = population(end,:);
    while True
        c_r = calc_c(population);
        population_star = find(population_s, c_r);
        if population_star ~= 'N'
            population(end, :) = [];
            population = [population;population_star];
            population = my_sort(population);

            break
        else
            r = r + 1;
        end
    end