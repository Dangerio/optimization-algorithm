rng("default");
% simulation_count = 1;
% trajectory_length = 4000;
% num_workers = 1;
% solver = GlobalSearchSolver(true);


trajectory_length = 4000;
num_workers = 6;
solver = GlobalSearchSolver();

cv_qml_model = StochVolQML;
true_params = [-0.7, 0.9, 0.4];
params_opt_set = [-1.5, 0; 1e-8, 1; 1e-8, 1.2];

num_handles = 10;

% simulation_count = 120;
% tic
%     sim_result_part_one = run_simulation_in_parallel("GlobalSearchSimulationPart1", num_workers, simulation_count, cv_qml_model, true_params, params_opt_set, ...
%            trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
% toc
sim_result_part_one = load("GlobalSearchSimulationPart1.mat").result_object;

simulation_count = 880;
tic
    sim_result_part_two = run_simulation_in_parallel("GlobalSearchSimulationPart2", num_workers, simulation_count, cv_qml_model, true_params, params_opt_set, ...
           trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
toc


 summary_table = EstimationSimulationResult.aggregate_results([sim_result_part_one, sim_result_part_two]);
 save("result_summary", "summary_table");
 