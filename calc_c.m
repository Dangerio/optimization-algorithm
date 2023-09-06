function [c_r] = calc_c(population, r)
s = size(population, 1);
gamma = 1 / r;
alpha_1 = 1 - gamma * (s - 2) / (s - 1);
alpha_oth = gamma / (s - 1);
c_r = alpha_1 * population(1, :) + alpha_oth * sum(population(2:end - 1, :));
end

