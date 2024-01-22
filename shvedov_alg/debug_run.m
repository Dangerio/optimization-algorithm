% add all functions to path
addpath(genpath(fileparts(pwd)));


eps = 1e-16;
num_iter = 1000;
alpha = 0.5;
max_r = 100;
beta = 1;
tolerance = 1e-16;


opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];

tic
[y, x] = shvedov_minimize(@shvedov_func, opt_set, eps, num_iter, alpha, max_r, beta, tolerance)
toc
