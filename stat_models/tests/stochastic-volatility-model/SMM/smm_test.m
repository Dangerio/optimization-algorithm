%1
simulation_count = 300;
sv_model = StochVolModel;
smm_method = SMMEstimator2;
smm_method.initial_indentity = true;



true_params = [-0.7, 0.9, 0.4];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("SMM_shvedov", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_SMM_shvedov", "summary_table_one_worker");


clc
clear
%2
%%%%%%%%%%%%%%%%%%%%%%


simulation_count = 300;
sv_model = StochVolModel;
smm_method = SMMEstimator2;
smm_method.initial_indentity = false;



true_params = [-0.7, 0.9, 0.4];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("WSMM_shvedov", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_WSMM_shvedov", "summary_table_one_worker");

%3
%%%%%%%%%%%%%%%%%%%%%%
clc
clear

simulation_count = 1000;
sv_model = StochVolModel;
smm_method = SMMEstimator;
smm_method.initial_indentity = true;



true_params = [-0.736, 0.9, 0.363];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 2000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("SMM_AS1_2k", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_SMM_AS1_2k", "summary_table_one_worker");

%4
%%%%%%%%%%%%%%%%%%%%%%

clc
clear

simulation_count = 1000;
sv_model = StochVolModel;
smm_method = SMMEstimator;
smm_method.initial_indentity = false;



true_params = [-0.736, 0.9, 0.363];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 2000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("WSMM_AS1_2k", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_WSMM_AS1_2k", "summary_table_one_worker");


%5
%%%%%%%%%%%%%%%%%%%%%%
clc
clear

simulation_count = 1000;
sv_model = StochVolModel;
smm_method = SMMEstimator;
smm_method.initial_indentity = true;



true_params = [-0.736, 0.9, 0.363];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("SMM_AS1_4k", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_SMM_AS1_4k", "summary_table_one_worker");


%6
%%%%%%%%%%%%%%%%%%%%%%

clc
clear

simulation_count = 1000;
sv_model = StochVolModel;
smm_method = SMMEstimator;
smm_method.initial_indentity = false;



true_params = [-0.736, 0.9, 0.363];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("WSMM_AS1_4k", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_WSMM_AS1_4k", "summary_table_one_worker");



%7
%%%%%%%%%%%%%%%%%%%%%%
clc
clear

simulation_count = 1000;
sv_model = StochVolModel;
smm_method = SMMEstimator;
smm_method.initial_indentity = true;



true_params = [-0.368, 0.95, 0.260];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 2000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("SMM_AS2_2k", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_SMM_AS2_2k", "summary_table_one_worker");



%8
%%%%%%%%%%%%%%%%%%%%%%
clc
clear

simulation_count = 1000;
sv_model = StochVolModel;
smm_method = SMMEstimator;
smm_method.initial_indentity = false;



true_params = [-0.368, 0.95, 0.260];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 2000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("WSMM_AS2_2k", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_WSMM_AS2_2k", "summary_table_one_worker");



%9
%%%%%%%%%%%%%%%%%%%%%%
clc
clear

simulation_count = 1000;
sv_model = StochVolModel;
smm_method = SMMEstimator;
smm_method.initial_indentity = true;



true_params = [-0.368, 0.95, 0.260];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("SMM_AS2_4k", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_SMM_AS2_4k", "summary_table_one_worker");


%10
%%%%%%%%%%%%%%%%%%%%%%
clc
clear

simulation_count = 1000;
sv_model = StochVolModel;
smm_method = SMMEstimator;
smm_method.initial_indentity = false;


true_params = [-0.368, 0.95, 0.260];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 3];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 500;
solver.gs_solver.FunctionTolerance = 1e-12;


num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("WSMM_AS2_4k", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_WSMM_AS2_4k", "summary_table_one_worker");




























