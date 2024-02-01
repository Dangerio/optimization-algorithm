sim_small_first = load("simulation_125_first.mat").result_object;
sim_small_second = load("simulation_125_second.mat").result_object;
sim_small_third = load("simulation_125_third.mat").result_object;
sim_med_first = load("simulation_500_first.mat").result_object;
sim_med_second = load("simulation_500_second.mat").result_object;
sim_med_third = load("simulation_500_third.mat").result_object;
sim_big_first = load("simulation_2000_first.mat").result_object;
sim_big_second = load("simulation_2000_second.mat").result_object;
sim_big_third = load("simulation_2000_third.mat").result_object;

sim_big_first.simulation_name = "simulation_big_first";
sim_big_second.simulation_name = "simulation_big_second";
sim_big_third.simulation_name = "simulation_big_third";
sim_med_third.simulation_name = "simulation_medium_third";
sim_med_second.simulation_name ="simulation_medium_second";
sim_med_first.simulation_name = "simulation_medium_first";
sim_small_first.simulation_name = "simulation_small_first";
sim_small_second.simulation_name = "simulation_small_second";
sim_small_third.simulation_name ="simulation_small_third";


sim_big_first.length = 2000;
sim_big_second.length = 2000;
sim_big_third.length = 2000;
sim_med_third.length = 500;
sim_med_second.length =500;
sim_med_first.length = 500;
sim_small_first.length = 125;
sim_small_second.length = 125;
sim_small_third.length =125;


sim_big_first.true_params = true_params;
sim_big_second.true_params = true_params;
sim_big_third.true_params = true_params;
sim_med_third.true_params = true_params;
sim_med_second.true_params =true_params;
sim_med_first.true_params = true_params;
sim_small_first.true_params = true_params;
sim_small_second.true_params = true_params;
sim_small_third.true_params =true_params;

results = [sim_small_third, sim_small_second, sim_small_first, sim_med_first, sim_med_second, sim_med_third, sim_big_third, sim_big_second, sim_big_first];

for i = 1:9
    obj = results(i);
    save(results(i).simulation_name, "obj");
end

 summary_table = EstimationSimulationResult.aggregate_results(results);
 save("result_summary", "summary_table");


simulation_count = 20;
ma_model = MovingAverageModel(1);
drift = 0;
noise_std = 1.2;
lag_coef = 0.75;
true_params = [drift, noise_std, lag_coef];
params_opt_set = [drift, drift; 1, sqrt(2); 0.3, 1.2];
solver = GlobalSearchSolver();
num_workers = 4;
num_handles = 10;

trajectory_length = 125;
tic
    sim_test = run_simulation_in_parallel("test", num_workers, simulation_count, ma_model, true_params, params_opt_set, ...
           trajectory_length, @compute_max_likelihood_estimator, solver, num_handles);
toc
summary_table = EstimationSimulationResult.aggregate_results([sim_test])

