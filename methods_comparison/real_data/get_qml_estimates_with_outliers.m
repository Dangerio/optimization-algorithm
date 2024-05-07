data_path =  'data\merged_data.csv';
output_path = 'qml_estimates_with_outliers.csv';
num_workers = 5;

sv_model = StochVolModel;
sv_model.fix_inlier_problem = true;

qml_method = MLEstimator();
qml_method.use_baseline = false;

solver = GlobalSearchSolver(false);
solver.gs_solver.NumTrialPoints = 50;
solver.gs_solver.NumStageOnePoints = 25;

params_opt_set = [-3, 0; 0.75, 0.995; 1e-3, 2];

tic
    result_csv = estimate_real_data_in_parallel( ...
        data_path, output_path, num_workers, sv_model, params_opt_set, ...
        qml_method, solver ...
    );
toc


