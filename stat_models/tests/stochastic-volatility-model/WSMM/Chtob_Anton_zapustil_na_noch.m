simulation_count = 300;
sv_model = StochVolModel;
smm_method = WSMMEstimator;
smm_method.matrix_type = 2;

true_params = [-0.7, 0.9, 0.4];
params_opt_set = [-1, 0; -0.995, 0.995; 1e-3, inf];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;



num_handles = 10;
trajectory_length = 4000;
    
num_workers = 5;
tic
    one_worker_sim = run_simulation_in_parallel("Shvedov1", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_Shvedov1", "summary_table_one_worker");

clear
clc
simulation_count = 1000;
sv_model = StochVolModel;
smm_method = WSMMEstimator;
smm_method.matrix_type = 2;


true_params = [-0.736, 0.9, 0.363];
params_opt_set = [-1, 0; -0.995, 0.995; 1e-3, inf];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;



num_handles = 10;
trajectory_length = 4000;
    
num_workers = 5;
tic
    one_worker_sim = run_simulation_in_parallel("AS1", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_AS1", "summary_table_one_worker");

clear
clc
simulation_count = 1000;
sv_model = StochVolModel;
smm_method = WSMMEstimator;
smm_method.matrix_type = 2;

true_params = [-0.736, 0.9, 0.363];
params_opt_set = [-1, 0; -0.995, 0.995; 1e-3, inf];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;



num_handles = 10;
trajectory_length = 2000;
    
num_workers = 5;
tic
    one_worker_sim = run_simulation_in_parallel("AS2", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_AS2", "summary_table_one_worker");


clear
clc
simulation_count = 1000;
sv_model = StochVolModel;
smm_method = WSMMEstimator;
smm_method.matrix_type = 2;

true_params = [-0.736, 0.9, 0.363];
params_opt_set = [-1, 0; -0.995, 0.995; 1e-3, inf];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;



num_handles = 10;
trajectory_length = 500;
    
num_workers = 5;
tic
    one_worker_sim = run_simulation_in_parallel("AS3", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_AS3", "summary_table_one_worker");

