clc
clear
%1
simulation_count = 500;
sv_model = StochVolModel;
smm_method = SMMEstimator3;
smm_method.initial_indentity = false;



true_params = [-0.821, 0.9, 0.675];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

    
solver.gs_solver.FunctionTolerance = eps(0);


num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("WSMM_rossi_1", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_WSMM_rossi_1", "summary_table_one_worker");


clc
clear
%2
%%%%%%%%%%%%%%%%%%%%%%


simulation_count = 500;
sv_model = StochVolModel;
smm_method = SMMEstimator3;
smm_method.initial_indentity = false;



true_params = [-0.368, 0.95, 0.26];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.FunctionTolerance = eps(0);


num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("WSMM_rossi_2", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_WSMM_rossi_2", "summary_table_one_worker");

%3
%%%%%%%%%%%%%%%%%%%%%%
clc
clear

simulation_count = 500;
sv_model = StochVolModel;
smm_method = SMMEstimator3;
smm_method.initial_indentity = false;



true_params = [-0.1412, 0.98, 0.0614];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.FunctionTolerance = eps(0);


num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("WSMM_rossi_3", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_WSMM_rossi_3", "summary_table_one_worker");




%%%%%%%%%%%%%%%%% 4

simulation_count = 500;
sv_model = StochVolModel;
smm_method = SMMEstimator3;
smm_method.initial_indentity = true;



true_params = [-0.821, 0.9, 0.675];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.FunctionTolerance = eps(0);


num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("SMM_rossi_1", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_SMM_rossi_1", "summary_table_one_worker");


clc
clear
%4
%%%%%%%%%%%%%%%%%%%%%%


simulation_count = 500;
sv_model = StochVolModel;
smm_method = SMMEstimator3;
smm_method.initial_indentity = true;



true_params = [-0.368, 0.95, 0.26];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.FunctionTolerance = eps(0);


num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("SMM_rossi_2", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_SMM_rossi_2", "summary_table_one_worker");

%5
%%%%%%%%%%%%%%%%%%%%%%
clc
clear

simulation_count = 500;
sv_model = StochVolModel;
smm_method = SMMEstimator3;
smm_method.initial_indentity = true;



true_params = [-0.1412, 0.98, 0.0614];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.FunctionTolerance = eps(0);


num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("SMM_rossi_3", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_SMM_rossi_3", "summary_table_one_worker");























