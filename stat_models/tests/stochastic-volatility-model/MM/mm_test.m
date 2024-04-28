simulation_count = 500;
sv_model = StochVolModel;
mm_method = StochVolMMEstimator;


true_params = [-0.7, 0.9, 0.4];
params_opt_set = [-Inf, Inf; -1+1e-6, 1-1e-6; 1e-3, Inf];

solver = [];

num_handles = 1;
trajectory_length = 500;

num_workers = 1;
tic
    one_worker_sim = run_simulation_in_parallel("shvedov_params_estimation", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, mm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_one_worker_new", "summary_table_one_worker");
% assert(all(one_worker_sim.compute_estimates_rmse() < 0.15))

% assert(all(test_sim.compute_estimates_rmse() < 0.15))