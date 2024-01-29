function [population] = generate(pop_size, opt_set)
    dim = size(opt_set, 1);
    population = zeros(pop_size, dim);
    for i = 1:dim
        x_lower = opt_set(i, 1);
        x_upper = opt_set(i, 2);
        population(:, i) = unifrnd(x_lower, x_upper, pop_size, 1);
    end
end

