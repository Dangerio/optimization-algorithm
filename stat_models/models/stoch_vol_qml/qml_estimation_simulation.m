rng("default");

% simulation_count = 60;
% trajectory_length = 4000;
% num_workers = 4;

simulation_count = 1;
trajectory_length = 125;
num_workers = 1;

cv_qml_model = StochVolQML;
true_params = [-0.7, 0.9, 0.4];
params_opt_set = [-1.5, 0; 1e-8, 1; 1e-8, 1.2];
solver = GlobalSearchSolver(true);
num_handles = 10;

tic
    sim_result = run_simulation_in_parallel("test", num_workers, simulation_count, cv_qml_model, true_params, params_opt_set, ...
           trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
toc


 summary_table = EstimationSimulationResult.aggregate_results(sim_result);
 save("result_summary", "summary_table");
 
