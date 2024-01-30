function [population] = generate_population(pop_size, opt_set)
    dim = size(opt_set, 1);
    population = zeros(pop_size, dim);
    for i = 1:dim
        x_lower = opt_set(i, 1);
        x_upper = opt_set(i, 2);
        if x_lower == -Inf && x_upper == Inf
            population(:, i) = cauchyrnd(0, 10, pop_size, 1);
        elseif x_upper == Inf
            population(:, i) = gprnd(1, 10, x_lower, pop_size, 1);
        elseif x_lower == -Inf
            population(:, i) = 2 * x_upper - gprnd(1, 10, x_upper, pop_size, 1);
        else
            population(:, i) = unifrnd(x_lower, x_upper, pop_size, 1);
        end
    end
end

