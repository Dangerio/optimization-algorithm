sv_model = StochVolModel;

qml_method = SMMEstimator5();
qml_method.use_baseline = false;

solver = GlobalSearchSolver(false);
solver.gs_solver.NumTrialPoints = 50;
solver.gs_solver.NumStageOnePoints = 25;
solver.gs_solver.FunctionTolerance = eps(0);

true_params = [
    -0.4106, 0.95, 0.4835;
    -0.1642, 0.98, 0.308;
    -0.736, 0.9, 0.363;
    -0.1472, 0.98, 0.166;
    -0.706, 0.9, 0.135;
    -0.353, 0.95, 0.0964;
];
simulation_count = 500;
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 2];
trajectory_lengths = [1000, 2000]; 

num_handles = 1;
num_workers = 6;

tic
    simulations = [];
    for length_idx = 1:size(trajectory_lengths, 2)
        trajectory_length = trajectory_lengths(length_idx);
        for idx = 1:size(true_params, 1)
            params = true_params(idx, :);   
            sim_name = "rossi_params_46m" + "_" + idx + "_T=" + trajectory_length;
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
save("summary_table_46m", "summary_table");