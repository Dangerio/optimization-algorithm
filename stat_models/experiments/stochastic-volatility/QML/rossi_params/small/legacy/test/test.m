sv_model = StochVolModel;

qml_method = MLEstimator();
qml_method.use_baseline = false;

solver = GlobalSearchSolver(false);
solver.gs_solver.NumTrialPoints = 50;
solver.gs_solver.NumStageOnePoints = 25;

true_params = [
    -0.821, 0.9, 0.675;
    % -0.4106, 0.95, 0.4835;
    % -0.1642, 0.98, 0.308;
    % -0.736, 0.9, 0.363;
    % -0.368, 0.95, 0.26;
    % -0.1472, 0.98, 0.166;
    % -0.706, 0.9, 0.135;
    % -0.353, 0.95, 0.0964;
    % -0.1412, 0.98, 0.0614;
];
simulation_count = 500;
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 2];
trajectory_length = 500;

num_handles = 1;
num_workers = 5;

tic
    simulations = [];
    for idx = 1:size(true_params, 1)
        params = true_params(idx, :);
        simulation_result = run_simulation_in_parallel("rossi_params" + idx, num_workers, simulation_count, sv_model, params, params_opt_set, ...
               trajectory_length, qml_method, solver, num_handles);
        simulations = [simulations, simulation_result];
    end
toc


summary_table = EstimationSimulationResult.aggregate_results(simulations);
save("summary_table", "summary_table");
