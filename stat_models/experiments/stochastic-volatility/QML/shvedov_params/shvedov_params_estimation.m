sv_model = StochVolModel;

qml_method = MLEstimator();
qml_method.use_baseline = false;

solver = GlobalSearchSolver(false);
solver.gs_solver.NumTrialPoints = 50;
solver.gs_solver.NumStageOnePoints = 25;

true_params = [-0.7, 0.9, 0.4];
simulation_count = 500;
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 1.3];
trajectory_length = 4000;

num_handles = 1;
num_workers = 5;

tic
    simulations = [];
    for idx = 1:size(true_params, 1)
        params = true_params(idx, :);
        simulation_result = run_simulation_in_parallel("shvedov_params" + idx, num_workers, simulation_count, sv_model, params, params_opt_set, ...
               trajectory_length, qml_method, solver, num_handles);
        simulations = [simulations, simulation_result];
    end
toc


summary_table = EstimationSimulationResult.aggregate_results(simulations);
save("summary_table", "summary_table");
