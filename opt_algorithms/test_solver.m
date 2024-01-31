function [] = test_solver(solver)
    disp("Test on Shvedov function")
    opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];
    tic
        [y, x] = solver.minimize(@shvedov_func, opt_set)
    toc
    
    disp("Test on Shvedov unvectorized function")
    opt_set = [[ -0.2, 1]; [-0.3, 1]; [-0.5, 1]];
    tic
        [y, x] = solver.minimize(@shvedov_unvectorized_func, opt_set)
    toc
    
    disp("Test on fucntion with sinus")
    opt_set = repmat([-10, 10], 5, 1);
    tic
        [y, x] = solver.minimize(@square_sin_func, opt_set)
    toc
    
    
    disp("Test on Rosenbrock function")
    opt_set = repmat([-1000, 1000], 2, 1);
    tic
        [y, x] = solver.minimize(@rosenbrock_func, opt_set)
    toc
    
    
    disp("Test on Rastrigin function")
    opt_set = repmat([-5.12, 5.12], 3, 1);
    tic
        [y, x] = solver.minimize(@rastrigin_func, opt_set)
    toc
    
    disp("Test on Ackley function")
    opt_set = repmat([-5, 5], 2, 1);
    tic
        [y, x] = solver.minimize(@ackley_func, opt_set)
    toc

end

