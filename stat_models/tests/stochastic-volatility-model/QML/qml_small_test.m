simulation_count = 1;
sv_model = StochVolModel;
qml_method = MLEstimator();


true_params = [-0.7, 0.9, 0.4];
params_opt_set = [-1.5, 0; 1e-8, 1; 1e-8, 1.2];

solver = GlobalSearchSolver(true);
num_handles = 1;
trajectory_length = 4000;

num_workers = 1;
tic
    small_sim = run_simulation_in_parallel("small_sim", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, qml_method, solver, num_handles);
toc
disp(small_sim.estimates)
