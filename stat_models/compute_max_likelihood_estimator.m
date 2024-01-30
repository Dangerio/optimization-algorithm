function [params] = compute_max_likelihood_estimator( ...
    data, model, param_opt_set, solver ...
    )
    
    [~, params] = solver.maximize(@compute_log_likelihood_vectorized, param_opt_set);

    function log_likelihoods = compute_log_likelihood_vectorized(params_matrix)
        points_count = size(params_matrix, 1);
        log_likelihoods = zeros(points_count, 1);
        for row_index = 1:points_count
            log_likelihoods(row_index) = model.compute_log_likelihood( ...
                data, params_matrix(row_index, :) ...
            );
        end
    end
end

