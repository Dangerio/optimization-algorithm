function [params] = compute_simulated_method_moments_estimator( ...
    data, model, param_opt_set, solver ...
    )
    
    [~, params] = solver.minimize(@compute_smm_vectorized, param_opt_set);

    function mse_vector = compute_smm_vectorized(params_matrix)
        points_count = size(params_matrix, 1);
        mse_vector = zeros(points_count, 1);
        for row_index = 1:points_count
            mse_vector(row_index) = model.compute_smm_mse( ...
                data, params_matrix(row_index, :) ...
            );
        end
    end
end
