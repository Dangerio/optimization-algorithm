% add all functions to path
addpath(genpath(fileparts(pwd)));

disp("Test on Shvedov function")
opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];
tic
    [y, x] = shvedov_minimize(@shvedov_func, opt_set, 1e-16, 1e-16, 100, 10000, 0.5, 100, 0.0001, 1, 1e-16)
toc

disp("Test on fucntion with sinus")
opt_set = repmat([-10, 10], 5, 1);
tic
    [y, x] = shvedov_minimize(@square_sin_func, opt_set, 1e-16, 1e-16, 100, 10000, 0.5, 100, 0.0001, 1, 1e-16)
toc