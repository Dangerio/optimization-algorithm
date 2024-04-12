simulation_count = 500;
sv_model = StochVolModel;
qml_method = MLEstimator();


true_params = [-0.7, 0.9, 0.4];
params_opt_set = [-1.5, 0; 1e-8, 1; 1e-8, 1.2];

solver = GlobalSearchSolver();
num_handles = 10;
trajectory_length = 4000;

num_workers = 5;
tic
    simulation_result = run_simulation_in_parallel("qml_shvedov_params_gs", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, qml_method, solver, num_handles);
toc

summary_table = EstimationSimulationResult.aggregate_results([simulation_result]);
save("summary_table", "summary_table");
