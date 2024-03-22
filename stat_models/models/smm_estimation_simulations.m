rng("default");

trajectory_length = 4000;
num_workers = 1;
solver = SurrogateOptSolver(true);

cv_smm_model = StochVolSMM;
true_params = [-0.7, 0.9, 0.4];
params_opt_set = [-1.5, 0; 1e-8, 1; 1e-8, 1.2];

num_handles = 10;
simulation_count = 4;
tic
    sim_result_part_one = run_simulation_in_parallel("GlobalSearchSimulationPart2", num_workers, simulation_count, cv_smm_model, true_params, params_opt_set, ...
           trajectory_length, @compute_simulated_method_moments_estimator, solver, num_handles);
toc


summary_table = EstimationSimulationResult.aggregate_results(sim_result_part_one);
save("result_summary", "summary_table");
