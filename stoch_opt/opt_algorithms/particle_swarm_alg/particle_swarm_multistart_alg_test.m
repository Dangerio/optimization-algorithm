% add all functions to path
addpath(genpath(fileparts(pwd)));

ps_solver = ParticleSwarmSolver();
count = 3;

disp("Test on Shvedov function")
opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];
tic
    [y, x] = multistart(ps_solver, @shvedov_func, opt_set, count)
toc

disp("Test on Shvedov unvectorized function")
opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];
tic
    [y, x] = multistart(ps_solver, @shvedov_unvectorized_func, opt_set, count)
toc

disp("Test on fucntion with sinus")
opt_set = repmat([-10, 10], 5, 1);
tic
    [y, x] = multistart(ps_solver, @square_sin_func, opt_set, count)
toc


disp("Test on Rosenbrock function")
opt_set = repmat([-1000, 1000], 2, 1);
tic
    [y, x] = multistart(ps_solver, @rosenbrock_func, opt_set, count)
toc


disp("Test on Rastrigin function")
opt_set = repmat([-5.12, 5.12], 3, 1);
tic
    [y, x] = multistart(ps_solver, @rastrigin_func, opt_set, count)
toc

disp("Test on Ackley function")
opt_set = repmat([-5, 5], 2, 1);
tic
    [y, x] = multistart(ps_solver, @ackley_func, opt_set, count)
toc

