function [population] = correct_population(population, opt_set)
    lower_bounds = repmat(opt_set(:, 1)', size(population, 1), 1);
    upper_bounds = repmat(opt_set(:, 2)', size(population, 1), 1);
    mask_less_lb = population < lower_bounds;
    mask_big_ub = population > upper_bounds;

    generated_population = generate(size(population, 1), opt_set);
    population(mask_less_lb) = generated_population(mask_less_lb);
    population(mask_big_ub) = generated_population(mask_big_ub);
end

