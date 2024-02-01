rng("default");

simulation_count = 15; % should be 400
ma_model = MovingAverageModel(1);
drift = 0;
noise_std = 1.2;
lag_coef = 0.75;
true_params = [drift, noise_std, lag_coef];
params_opt_set = [drift, drift; 1, sqrt(2); 0.3, 1.2];
trajectory_length = 125;
solver = GlobalSearchSolver();
save_handler = SaveHandler("test");

tic
   estimation_result = make_estimation_simulation( ...
       simulation_count, ma_model, true_params, params_opt_set, ...
       trajectory_length, @compute_max_likelihood_estimator, solver, ...
       save_handler...
   );
toc
mean_estimates = estimation_result.compute_mean_estimates()
rmse = estimation_result.compute_estimates_rmse(true_params)
