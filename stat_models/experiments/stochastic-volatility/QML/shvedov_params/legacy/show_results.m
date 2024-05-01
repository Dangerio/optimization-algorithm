sh_small = load("small\shvedov_params_estimation.mat").result_object;
small_summary = EstimationSimulationResult.aggregate_results([sh_small]);

sh_big = load("big\shvedov_params_estimation.mat").result_object;
big_summary = EstimationSimulationResult.aggregate_results([sh_big]);

fprintf("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t Shvedov Parameters\n")

disp("T = 1000")
disp(small_summary)

disp("T = 4000")
disp(big_summary)
