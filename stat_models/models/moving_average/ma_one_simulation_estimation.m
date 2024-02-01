rng("default");

simulation_count = 100; % should be 400
ma_model = MovingAverageModel(1);
drift = 0;
noise_std = 1.2;
lag_coef = 0.75;
true_params = [drift, noise_std, lag_coef];
params_opt_set = [drift, drift; 1, sqrt(2); 0.3, 1.2];
trajectory_length = 125;
solver = GlobalSearchSolver();
save_handler = SaveHandler("test");


% tic
%     non_par_res = run_simulation_in_parallel("nonpar_sim", 1, simulation_count, ma_model, true_params, params_opt_set, ...
%            trajectory_length, @compute_max_likelihood_estimator, solver)
% toc


tic
    par_res = run_simulation_in_parallel("par_sim", 4, simulation_count, ma_model, true_params, params_opt_set, ...
           trajectory_length, @compute_max_likelihood_estimator, solver)
toc
