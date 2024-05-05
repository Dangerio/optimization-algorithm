sv_model = StochVolModel;
sv_model.is_gaussian = false;

qml_method = SMMEstimator3;
% qml_method = MLEstimator();
qml_method.use_baseline = false;

solver = GlobalSearchSolver(true);
solver.gs_solver.NumTrialPoints = 50;
solver.gs_solver.NumStageOnePoints = 25;
solver.gs_solver.FunctionTolerance = eps(0);


true_params = [
    -0.821, 0.9, 0.675;
    -0.1412, 0.98, 0.0614;
];
simulation_count = 10;
params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 2];
trajectory_length = 4000;

num_handles = 1;
num_workers = 1;

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
