% add all functions to path
addpath(genpath(fileparts(pwd)));

eps = 1e-16;
num_iter = 1000;
alpha = 0.5;
max_r = 100;
beta = 1;
tolerance = 1e-16;

disp("Test on Shvedov function")
opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];
tic
    [y, x] = shvedov_minimize(@shvedov_func, opt_set, eps, num_iter, alpha, max_r, beta, tolerance)
toc


disp("Test on Shvedov unvectorized function")
opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];
tic
    [y, x] = shvedov_minimize(@shvedov_unvectorized_func, opt_set, eps, num_iter, alpha, max_r, beta, tolerance)
toc

disp("Test on fucntion with sinus")
opt_set = repmat([-10, 10], 5, 1);
tic
    [y, x] = shvedov_minimize(@square_sin_func, opt_set, eps, num_iter, alpha, max_r, beta, tolerance)
toc


disp("Test on Rosenbrock function")
opt_set = repmat([-1000, 1000], 2, 1);
tic
    [y, x] = shvedov_minimize(@rosenbrock_func, opt_set, eps, num_iter, alpha, max_r, beta, tolerance)
toc


disp("Test on Rastrigin function")
opt_set = repmat([-5.12, 5.12], 3, 1);
tic
    [y, x] = shvedov_minimize(@rastrigin_func, opt_set, eps, num_iter, alpha, max_r, beta, tolerance)
toc

disp("Test on Ackley function")
opt_set = repmat([-5, 5], 2, 1);
tic
    [y, x] = shvedov_minimize(@ackley_func, opt_set, eps, num_iter, alpha, max_r, beta, tolerance)
toc