function [estimation_result] = make_estimation_simulation( ...
    simulation_name, current_sim_idx, current_sim_count, simulation_count, model, true_params, params_opt_set, ...
    trajectory_length, estimation_method, solver, result_handler, num_handles...
    )
    
    gen_type = "threefry4x64_20";
    estimation_result = EstimationSimulationResult( ...
        simulation_count, trajectory_length, gen_type, ...
        true_params, params_opt_set, model, estimation_method, solver, simulation_name ...
    );
    
    data_generation_stream = RandomStreamPool(current_sim_count, 1, 1, current_sim_count, gen_type).get_loader(1).get_random_stream(current_sim_idx);
    
    for sim_index = 1:simulation_count
        gen_state = data_generation_stream.State;
        trajectory = model.generate_trajectory( ...
            true_params, trajectory_length, true, data_generation_stream ...
        );

        start_cpu = cputime;
        timer_wall = tic;
        estimates = estimation_method.compute_estimates(trajectory, model, ...
            params_opt_set, solver ...
        );
        time_cpu = cputime - start_cpu;
        time_wall = toc(timer_wall);

        estimation_result.add_new_estimate(estimates, gen_state, time_wall, time_cpu);

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

