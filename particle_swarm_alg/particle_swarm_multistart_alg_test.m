% add all functions to path
addpath(genpath(fileparts(pwd)));

alpha = 0.95;
beta = 0.2;
gamma = 0.2;
M = 100;
L = 10^6;
tolerance = 0;
count = 5;

disp("Test on Shvedov function")
opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];
tic
    [y, x] = particle_swarm_multistart(@shvedov_func, opt_set, alpha, beta, gamma, M, L, tolerance, count)
toc

disp("Test on Shvedov unvectorized function")
opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];
tic
    [y, x] = particle_swarm_multistart(@shvedov_unvectorized_func, opt_set, alpha, beta, gamma, M, L, tolerance, count)
toc

disp("Test on fucntion with sinus")
opt_set = repmat([-10, 10], 5, 1);
tic
    [y, x] = particle_swarm_multistart(@square_sin_func, opt_set, alpha, beta, gamma, M, L, tolerance, count)
toc


disp("Test on Rosenbrock function")
opt_set = repmat([-1000, 1000], 2, 1);
tic
    [y, x] = particle_swarm_multistart(@rosenbrock_func, opt_set, alpha, beta, gamma, M, L, tolerance, count)
toc


disp("Test on Rastrigin function")
opt_set = repmat([-5.12, 5.12], 3, 1);
tic
    [y, x] = particle_swarm_multistart(@rastrigin_func, opt_set, alpha, beta, gamma, M, L, tolerance, count)
toc

disp("Test on Ackley function")
opt_set = repmat([-5, 5], 2, 1);
tic
    [y, x] = particle_swarm_multistart(@ackley_func, opt_set, alpha, beta, gamma, M, L, tolerance, count)
toc

