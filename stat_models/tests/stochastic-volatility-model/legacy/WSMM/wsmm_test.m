
simulation_count = 100;
sv_model = StochVolModel;
smm_method = WSMMEstimator;
smm_method.matrix_type = 1;
smm_method.verbose = true;


true_params = [-0.821, 0.9, 0.675];
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 1.3];

solver = GlobalSearchSolver();
solver.gs_solver.NumTrialPoints = 50;
solver.gs_solver.NumStageOnePoints = 25;
solver.gs_solver.FunctionTolerance = eps(0);

num_handles = 10;
trajectory_length = 4000;

num_workers = 6;
tic
    one_worker_sim = run_simulation_in_parallel("Shvedov_unlim1", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
           trajectory_length, smm_method, solver, num_handles);
toc

summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
save("summary_Shvedov_unlim", "summary_table_one_worker");

% %%%%%%%%%%%%%%%%%%%
% clc
% clear
% 
% simulation_count = 300;
% sv_model = StochVolModel;
% smm_method = WSMMEstimator;
% smm_method.matrix_type = 1;
% 
% true_params = [-0.7, 0.9, 0.4];
% params_opt_set = [-1, 0; -0.995, 0.995; 1e-3, 1];
% 
% solver = GlobalSearchSolver();
% solver.gs_solver.NumTrialPoints = 500;
% solver.gs_solver.FunctionTolerance = 1e-10;
% 
% num_handles = 10;
% trajectory_length = 4000;
% 
% num_workers = 6;
% tic
%     one_worker_sim = run_simulation_in_parallel("Shvedov_lim", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
%            trajectory_length, smm_method, solver, num_handles);
% toc
% 
% summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
% save("summary_Shvedov_lim", "summary_table_one_worker");
% clc
% clear
% 
% %%%%%%%%%%%%%%%%%%%
% 
% 
% 
% simulation_count = 1000;
% sv_model = StochVolModel;
% smm_method = WSMMEstimator2;
% smm_method.matrix_type = 1;
% 
% true_params = [-0.368, 0.95, 0.26];
% params_opt_set = [-inf, inf; -0.995, 0.995; 1e-3, inf];
% 
% solver = GlobalSearchSolver();
% solver.gs_solver.NumTrialPoints = 500;
% solver.gs_solver.FunctionTolerance = 1e-10;
% 
% num_handles = 10;
% trajectory_length = 2000;
% 
% num_workers = 6;
% tic
%     one_worker_sim = run_simulation_in_parallel("AS_unlim", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
%            trajectory_length, smm_method, solver, num_handles);
% toc
% 
% summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
% save("summary_AS_unlim", "summary_table_one_worker");
% clc
% clear
% 
% %%%%%%%%%%%%%%%%%%%
% 
% simulation_count = 1000;
% sv_model = StochVolModel;
% smm_method = WSMMEstimator2;
% smm_method.matrix_type = 1;
% 
% true_params = [-0.368, 0.95, 0.26];
% params_opt_set = [-1, 0; -0.995, 0.995; 1e-3, 1];
% 
% solver = GlobalSearchSolver();
% solver.gs_solver.NumTrialPoints = 500;
% solver.gs_solver.FunctionTolerance = 1e-10;
% 
% num_handles = 10;
% trajectory_length = 2000;
% 
% num_workers = 6;
% tic
%     one_worker_sim = run_simulation_in_parallel("AS_lim", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
%            trajectory_length, smm_method, solver, num_handles);
% toc
% 
% summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
% save("summary_AS_lim", "summary_table_one_worker");
% clc
% clear
% 
% 
% %%%%%%%%%%%%%%%%%%%
% 
% 
% 
% simulation_count = 1000;
% sv_model = StochVolModel;
% smm_method = WSMMEstimator2;
% smm_method.matrix_type = 1;
% 
% true_params = [-0.368, 0.95, 0.26];
% params_opt_set = [-inf, inf; -0.995, 0.995; 1e-3, inf];
% 
% solver = GlobalSearchSolver();
% solver.gs_solver.NumTrialPoints = 500;
% solver.gs_solver.FunctionTolerance = 1e-10;
% 
% num_handles = 10;
% trajectory_length = 4000;
% 
% num_workers = 6;
% tic
%     one_worker_sim = run_simulation_in_parallel("AS2_unlim", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
%            trajectory_length, smm_method, solver, num_handles);
% toc
% 
% summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
% save("summary_AS2_unlim", "summary_table_one_worker");
% clc
% clear
% 
% %%%%%%%%%%%%%%%%%%%
% 
% simulation_count = 1000;
% sv_model = StochVolModel;
% smm_method = WSMMEstimator2;
% smm_method.matrix_type = 1;
% 
% true_params = [-0.368, 0.95, 0.26];
% params_opt_set = [-1, 0; -0.995, 0.995; 1e-3, 1];
% 
% solver = GlobalSearchSolver();
% solver.gs_solver.NumTrialPoints = 500;
% solver.gs_solver.FunctionTolerance = 1e-10;
% 
% num_handles = 10;
% trajectory_length = 4000;
% 
% num_workers = 6;
% tic
%     one_worker_sim = run_simulation_in_parallel("AS2_lim", num_workers, simulation_count, sv_model, true_params, params_opt_set, ...
%            trajectory_length, smm_method, solver, num_handles);
% toc
% 
% summary_table_one_worker = EstimationSimulationResult.aggregate_results([one_worker_sim]);
% save("summary_AS2_lim", "summary_table_one_worker");
% clc
% clear