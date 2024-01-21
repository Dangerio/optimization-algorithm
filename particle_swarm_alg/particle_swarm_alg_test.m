% add all functions to path
addpath(genpath(fileparts(pwd)));

disp("Test on Shvedov function")
opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];
tic
    [y, x] = particle_swarm(@shvedov_func, opt_set, 0.95, 0.2, 0.2, 100, 10^6)
toc

disp("Test on fucntion with sinus")
opt_set = repmat([-10, 10], 5, 1);
tic
    [y, x] = particle_swarm(@square_sin_func, opt_set, 0.95, 0.2, 0.2, 100, 10^6)
toc
