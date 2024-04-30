simulation_count = 1000;
sv_model = StochVolModel;
smm_method = SMMEstimator;
% smm_method.verbose = true;


true_params = [-0.736, 0.9, 0.363];
params_opt_set = [-inf, inf; -0.995, 0.995; 1e-3, inf];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 2000;

num_workers = 5;
tic
    one_worker_sim = run_simulation_in_parallel("1", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_1", "summary_table_one_worker");

clc
clear

%%%%%%%%%%%
simulation_count = 1000;
sv_model = StochVolModel;
smm_method = SMMEstimator;

true_params = [-0.736, 0.9, 0.363];
params_opt_set = [-inf, inf; -0.995, 0.995; 1e-3, inf];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 4000;

num_workers = 5;
tic
    one_worker_sim = run_simulation_in_parallel("2", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_2", "summary_table_one_worker");
clc
clear

%%%%%%%%%%%



simulation_count = 1000;
sv_model = StochVolModel;
smm_method = SMMEstimator;

true_params = [-0.368, 0.95, 0.26];
params_opt_set = [-inf, inf; -0.995, 0.995; 1e-3, inf];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 2000;

num_workers = 5;
tic
    one_worker_sim = run_simulation_in_parallel("3", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_3", "summary_table_one_worker");
clc
clear
%%%%%%%%%%%

simulation_count = 1000;
sv_model = StochVolModel;
smm_method = SMMEstimator;

true_params = [-0.368, 0.95, 0.26];
params_opt_set = [-inf, inf; -0.995, 0.995; 1e-3, inf];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 4000;

num_workers = 5;
tic
    one_worker_sim = run_simulation_in_parallel("4", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_4", "summary_table_one_worker");















