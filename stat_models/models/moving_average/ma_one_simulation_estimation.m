% rng("default");
% 
simulation_count = 400;
ma_model = MovingAverageModel(1);
drift = 0;
noise_std = 1.2;
lag_coef = 0.75;
true_params = [drift, noise_std, lag_coef];
params_opt_set = [drift, drift; 1, sqrt(2); 0.3, 1.2];
solver = GlobalSearchSolver();
num_workers = 4;
num_handles = 10;
% 
% 
% trajectory_length = 125;
% tic
%     sim_small_first = run_simulation_in_parallel("simulation_125_first", num_workers, simulation_count, ma_model, true_params, params_opt_set, ...
%            trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
% toc
% tic
%     sim_small_second = run_simulation_in_parallel("simulation_125_second", num_workers, simulation_count, ma_model, true_params, params_opt_set, ...
%            trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
% toc
% tic
%     sim_small_third = run_simulation_in_parallel("simulation_125_third", num_workers, simulation_count, ma_model, true_params, params_opt_set, ...
%            trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
% toc
% 
% 
% 
% trajectory_length = 500;
% tic
%     sim_medium_first = run_simulation_in_parallel("simulation_500_first", num_workers, simulation_count, ma_model, true_params, params_opt_set, ...
%            trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
% toc
% tic
%     sim_medium_second = run_simulation_in_parallel("simulation_500_second", num_workers, simulation_count, ma_model, true_params, params_opt_set, ...
%            trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
% toc
% tic
%     sim_medium_third = run_simulation_in_parallel("simulation_500_third", num_workers, simulation_count, ma_model, true_params, params_opt_set, ...
%            trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
% toc
% 
% 
% 
% trajectory_length = 2000;
% tic
%     sim_big_first = run_simulation_in_parallel("simulation_2000_first", num_workers, simulation_count, ma_model, true_params, params_opt_set, ...
%            trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
% toc

trajectory_length = 2000;
tic
    sim_big_second = run_simulation_in_parallel("simulation_2000_second", num_workers, simulation_count, ma_model, true_params, params_opt_set, ...
           trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
toc
tic
    sim_big_third = run_simulation_in_parallel("simulation_2000_third", num_workers, simulation_count, ma_model, true_params, params_opt_set, ...
           trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
toc



 results = [sim_small_first, sim_small_second, sim_small_third, sim_medium_first, sim_medium_second, sim_medium_third, sim_big_first, sim_big_second, sim_big_third];
 lengths = [125, 125, 125, 500, 500, 500, 2000, 2000, 2000];
 simulation_names = ["small_first", "small_second", "small_third", "medium_first", "medium_second", "medium_third", "big_first", "big_second", "big_third"];
 summary_table = EstimationSimulationResult.aggregate_results(results, lengths, true_params, simulation_names);;
 save("result_summary", "summary_table");
 
