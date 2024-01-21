function [population] = generate(pop_size, dim, opt_set)
        population = zeros(pop_size, dim);
        for i = 1:dim
            a = opt_set(i, 1);
            b = opt_set(i, 2);
            population(:, i) = unifrnd(a, b, pop_size, 1);   
        end 
    end