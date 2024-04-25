simulation_count = 500;
sv_model = StochVolModel;
qml_method = MLEstimator();


true_params = [0, 0.995, 0.0707];
% params_opt_set = [-0.7, 0.3; -1 + 1e-6, 1 - 1e-6; 1e-6, 0.7];
params_opt_set = [0., 0.; 0.5, 1 - 1e-6; 3e-3, 0.7];

solver = GlobalSearchSolver();
num_handles = 10;
% trajectory_length = 4000;
trajectory_length = 3000;

num_workers = 5;
tic
    simulation_result = run_simulation_in_parallel("harvey_first_params_estimation", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, qml_method, solver, num_handles);
toc

summary_table = EstimationSimulationResult.aggregate_results([simulation_result]);
save("summary_table", "summary_table");
