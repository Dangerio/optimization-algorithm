sim_count = 10;
num_handles = 10;
model = StochVolModel;
method = MLEstimator;
solver = SurrogateOptSolver;
true_params = [-0.7, 0.9, 0.4];
params_opt_set = [-1.5, 0; 1e-8, 1; 1e-8, 1.2];
trajectory_length = 4000;

num_workers = 1;
test_sim_first = run_simulation_in_parallel("test_sim_one_worker", num_workers, sim_count, model, true_params, params_opt_set, ...
           trajectory_length, method, solver, num_handles);

num_workers = 5;
test_sim_second = run_simulation_in_parallel("test_sim_multiple_workers", num_workers, sim_count, model, true_params, params_opt_set, ...
           trajectory_length, method, solver, num_handles);

