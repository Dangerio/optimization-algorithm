function [new_population] = my_sort(func, population) 
    values = func(population);
    new_population = [values population];
    new_population = sortrows(new_population, 1, "ascend");
    new_population = new_population(:, 2:end);
end