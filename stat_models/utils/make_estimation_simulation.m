function [estimation_result] = make_estimation_simulation( ...
    simulation_name, simulation_count, model, true_params, params_opt_set, ...
    trajectory_length, estimation_method, solver, result_handler, num_handles...
    )

    estimation_result = EstimationSimulationResult(simulation_count, trajectory_length, true_params, simulation_name);
    data_generation_stream = RandStream("mt19937ar", "Seed", StringHasher().compute_hash(simulation_name));

    
    for sim_index = 1:simulation_count
        trajectory = model.generate_trajectory( ...
            true_params, trajectory_length, true, data_generation_stream ...
        );
        estimates = estimation_method.compute_estimates(trajectory, model, ...
            params_opt_set, solver ...
        );
        estimation_result.add_new_estimate(estimates);

        if ~isempty(result_handler) && ...
                simulation_count >= 2 * num_handles && ...
                mod(sim_index, floor(simulation_count / num_handles)) == 0
            result_handler.handle(estimation_result)
        end
    end
   
    if ~isempty(result_handler)
        result_handler.handle(estimation_result);
    end
end

