hs_first_small = load("small\harvey_first_params_estimation.mat").result_object;
hs_second_small = load("small\harvey_second_params_estimation.mat").result_object;
hs_third_small = load("small\harvey_third_params_estimation.mat").result_object;
small_summary = EstimationSimulationResult.aggregate_results([hs_first_small, hs_second_small, hs_third_small]);


hs_first_big = load("big\first\harvey_first_params_estimation.mat").result_object;
hs_second_big = load("big\second\harvey_second_params_estimation.mat").result_object;
hs_third_big = load("big\third\harvey_third_params_estimation.mat").result_object;
big_summary = EstimationSimulationResult.aggregate_results([hs_first_big, hs_second_big, hs_third_big]);

fprintf("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tHarvey-Shephard Parameters\n")

disp("T = 1000")
disp(small_summary)

disp("T = 4000")
disp(big_summary)
