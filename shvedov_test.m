opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];

[y, x] = minimize(@Shvedov, opt_set, 1e-16, 1e-16, 100, 1000, 0.5, 300);