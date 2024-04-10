sim_count = 500;
model = StochVolModel;
method = MLEstimator;
solver = GlobalSearchSolver;
true_params =  [0, 0, 0];
params_opt_set = [-1.5, 0; 1e-8, 1; 1e-8, 1.2];
trajectory_length = 4000;
gen_type = "mt19937ar";
stream = RandStream(gen_type);

esrs = [];
data_arr = [];
for i = 1:3
    esr = EstimationSimulationResult(sim_count, trajectory_length, gen_type, true_params, params_opt_set, model, method, solver, "test" + i);
    
    state = stream.State;
    data_arr = [data_arr, model.generate_trajectory(true_params, trajectory_length, true, stream).endog];
    estimate = true_params + i;
    esr.add_new_estimate(estimate, state, 1, 2);

    esrs = [esrs, esr];
end
data_arr = data_arr';


merged = EstimationSimulationResult.merge(esrs);
agg_table = EstimationSimulationResult.aggregate_results(merged);


assert(all(merged.compute_mean_estimates() == [2, 2, 2]))

for i = 1:3
    data = merged.get_trajectory(i).endog;
    expected_data = data_arr(i, 1:end)';
    assert(all(data == expected_data));
end