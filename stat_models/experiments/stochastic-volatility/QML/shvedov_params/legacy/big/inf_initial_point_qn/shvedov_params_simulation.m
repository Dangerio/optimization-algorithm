simulation_count = 500;
sv_model = StochVolModel;
initial_params = [-0.9, 0.9, 0.3];
sv_model = sv_model.set_apriori_params(initial_params);
qml_method = MLEstimator();
qml_method.use_baseline = true;


true_params = [-0.7, 0.9, 0.4];
params_opt_set = [-Inf, Inf; -1 + 1e-3, 1 - 1e-3; 1e-3, Inf];

solver = QuasiNewtonSolver();
num_handles = 1;
trajectory_length = 4000;

num_workers = 5;
tic
    simulation_result = run_simulation_in_parallel("shvedov_params_estimation", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, qml_method, solver, num_handles);
toc

summary_table = EstimationSimulationResult.aggregate_results([simulation_result]);
save("summary_table", "summary_table");
