format short
simulation_count = 300;
sv_model = StochVolModel;
smm_method = WSMMEstimator;
smm_method.verbose = true;

true_params =   [-0.7, 0.9, 0.4];
params_opt_set = [-1, 0; -1+1e-6, 1-1e-6; 1e-6, 1];

 
solver = GlobalSearchSolver(true);

solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-10;
% solver.gs_solver.MaxTime = 30;


num_handles = 10;
trajectory_length = 4000;
% data = sv_model.generate_trajectory(true_params, trajectory_length, true, RandStream("mt19937ar", "Seed", 2);
% smm_method.compute_estimates(data)
 

num_workers = 1;
tic
    one_worker_sim = run_simulation_in_parallel("shvedov_params_estimation", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc
    
summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_one_worker_new", "summary_table_one_worker");
% assert(all(one_worker_sim.compute_estimates_rmse() < 0.15))

% assert(all(test_sim.compute_estimates_rmse() < 0.15))