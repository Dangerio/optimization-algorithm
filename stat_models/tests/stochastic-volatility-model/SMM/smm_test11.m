sv_model = StochVolModel;

qml_method = SMMEstimator2();
qml_method.use_baseline = false;
qml_method.initial_indentity = true;

solver = GlobalSearchSolver(false);
solver.gs_solver.NumTrialPoints = 50;
solver.gs_solver.NumStageOnePoints = 25;
solver.gs_solver.FunctionTolerance = eps(0);


true_params = [-0.7, 0.9, 0.4];

simulation_count = 300;
params_opt_set = [-1, -0.4; 0.6, 0.99; 0.1, 1];


trajectory_lengths = [4000];

num_handles = 1;
num_workers = 6;

tic
    simulations = [];
    for length_idx = 1:size(trajectory_lengths, 2)
        trajectory_length = trajectory_lengths(length_idx);
        for idx = 1:size(true_params, 1)
            params = true_params(idx, :);   
            sim_name = "shvedov_params_19m_SMM" + "_" + idx + "_T=" + trajectory_length;
            tic
                disp("start " + sim_name)
                
                simulation_result = run_simulation_in_parallel( ...
                   sim_name, num_workers, simulation_count, sv_model, sv_model, params, ...
                   params_opt_set, trajectory_length, qml_method, solver, num_handles ...
               );
                simulations = [simulations, simulation_result];
                
                disp("finish " + sim_name)
            toc
        end
    end
toc


summary_table = EstimationSimulationResult.aggregate_results(simulations);
save("shvedov_params_19m_SMM", "summary_table");


%%%%%%%
clc
clear

sv_model = StochVolModel;

qml_method = SMMEstimator2();
qml_method.use_baseline = false;
qml_method.initial_indentity = false;

solver = GlobalSearchSolver(false);
solver.gs_solver.NumTrialPoints = 50;
solver.gs_solver.NumStageOnePoints = 25;
solver.gs_solver.FunctionTolerance = eps(0);


true_params = [-0.7, 0.9, 0.4];

simulation_count = 300;
params_opt_set = [-1, -0.4; 0.6, 0.99; 0.1, 1];


trajectory_lengths = [4000];

num_handles = 1;
num_workers = 6;

tic
    simulations = [];
    for length_idx = 1:size(trajectory_lengths, 2)
        trajectory_length = trajectory_lengths(length_idx);
        for idx = 1:size(true_params, 1)
            params = true_params(idx, :);   
            sim_name = "shvedov_params_19m_WSMM" + "_" + idx + "_T=" + trajectory_length;
            tic
                disp("start " + sim_name)
                
                simulation_result = run_simulation_in_parallel( ...
                   sim_name, num_workers, simulation_count, sv_model, sv_model, params, ...
                   params_opt_set, trajectory_length, qml_method, solver, num_handles ...
               );
                simulations = [simulations, simulation_result];
                
                disp("finish " + sim_name)
            toc
        end
    end
toc


summary_table = EstimationSimulationResult.aggregate_results(simulations);
save("shvedov_params_19m_WSMM", "summary_table");

clc
clear

