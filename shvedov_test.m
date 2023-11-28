opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];

% [y, x] = minimize(@Shvedov, opt_set, 1e-16, 1e-16, 100, 1000, 0.5, 300);


% population(end - 1:end, :) = population(end - 1:end, :) + normrnd(0, 0.0001, size(population(end - 1:end, :),1), size(population(end - 1:end, :),2));
% population(end - 3:end - 2, :) = population(end - 3:end - 2, :) + normrnd(0, 0.00001, size(population(end - 3:end - 2, :),1), size(population(end - 3:end - 2, :),2));
% population(end - 4, :) = population(end - 4, :) + normrnd(0, 0.0000001, size(population(end - 4, :),1), size(population(end - 4, :),2));

[y, x] = minimize(@Shvedov, opt_set, 1e-16, 1e-16, 100, 10000, 0.5, 100, 0.0001, 1, 1e-16);