simulation_count = 5;
sv_model = StochVolModel;
smm_method = WSMMEstimator;
smm_method.verbose = true;


true_params = [-0.7, 0.9, 0.4];
params_opt_set = [-1.5, 0; 1e-8, 1; 1e-8, 1.2];

solver = GlobalSearchSolver();
num_handles = 10;
trajectory_length = 4000;

num_workers = 1;
tic
    one_worker_sim = run_simulation_in_parallel("one_worker_new", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_one_worker_new", "summary_table_one_worker");
% assert(all(one_worker_sim.compute_estimates_rmse() < 0.15))

% assert(all(test_sim.compute_estimates_rmse() < 0.15))