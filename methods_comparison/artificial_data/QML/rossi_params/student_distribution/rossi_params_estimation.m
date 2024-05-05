dgp_model = StochVolModel;
dgp_model.is_gaussian = false;
dgp_model.t_freedom = 1;

assumed_model = StochVolModel;
assumed_model.is_gaussian = true;
assumed_model.fix_inlier_problem = false;

qml_method = MLEstimator();
qml_method.use_baseline = false;

solver = GlobalSearchSolver(false);
solver.gs_solver.NumTrialPoints = 50;
solver.gs_solver.NumStageOnePoints = 25;

true_params = [
    -0.821, 0.9, 0.675;
    % -0.368, 0.95, 0.26;
    % -0.1412, 0.98, 0.0614;
];
simulation_count = 500;
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 2];
trajectory_lengths = [4000];

num_handles = 1;
num_workers = 1;

tic
    simulations = [];
    for length_idx = 1:size(trajectory_lengths, 2)
        trajectory_length = trajectory_lengths(length_idx);
        for idx = 1:size(true_params, 1)
            params = true_params(idx, :);   
            sim_name = "rossi_params" + "_" + idx + "_T=" + trajectory_length;
            tic
                disp("start " + sim_name)
                
                simulation_result = run_simulation_in_parallel( ...
                   sim_name, num_workers, simulation_count, dgp_model, assumed_model, params, ...
                   params_opt_set, trajectory_length, qml_method, solver, num_handles ...
               );
                simulations = [simulations, simulation_result];
                
                disp("finish " + sim_name)
            toc
        end
    end
toc


summary_table = EstimationSimulationResult.aggregate_results(simulations);
save("summary_table", "summary_table");
