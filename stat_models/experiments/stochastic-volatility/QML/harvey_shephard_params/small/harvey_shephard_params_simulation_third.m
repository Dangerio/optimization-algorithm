simulation_count = 500;
sv_model = StochVolModel;
qml_method = MLEstimator();


true_params = [0, 0.995, 0.1];
params_opt_set = [-0.7, 0.3; -1 + 1e-6, 1 - 1e-6; 1e-6, 0.7];

solver = GlobalSearchSolver();
num_handles = 10;
trajectory_length = 1000;

num_workers = 5;
tic
    simulation_result = run_simulation_in_parallel("harvey_third_params_estimation", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, qml_method, solver, num_handles);
toc

summary_table = EstimationSimulationResult.aggregate_results([simulation_result]);
save("summary_table_third", "summary_table");
