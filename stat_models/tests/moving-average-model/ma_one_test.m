simulation_count = 10;
ma_model = MovingAverageModel(1);
max_lik_method = MLEstimator();
drift = 0;
noise_std = 1.2;
lag_coef = 0.75;
true_params = [drift, noise_std, lag_coef];
params_opt_set = [drift, drift; 1, sqrt(2); 0.3, 1.2];
solver = GlobalSearchSolver();
num_handles = 10;
trajectory_length = 125;

num_workers = 1;
tic
    one_worker_sim = run_simulation_in_parallel("one_worker", num_workers, simulation_count, ma_model, true_params, params_opt_set, ...
           trajectory_length, max_lik_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_one_worker", "summary_table_one_worker");
assert(all(one_worker_sim.compute_estimates_rmse() < 0.15))


num_workers = 4;
tic
    several_workers_sim = run_simulation_in_parallel("multiple_workers", num_workers, simulation_count, ma_model, true_params, params_opt_set, ...
           trajectory_length, max_lik_method, solver, num_handles);
toc

summary_table_several_workers = EstimationSimulationResult.aggregate_results([several_workers_sim]);
save("summary_several_workers", "summary_table_several_workers");
assert(all(several_workers_sim.compute_estimates_rmse() < 0.15))

 
