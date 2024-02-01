function [estimation_result] = run_simulation_in_parallel(...
    simulation_name, num_workers, simulation_count, model, true_params, params_opt_set, ...
    trajectory_length, compute_estimates, solver, num_handles ...
    )
    if num_workers > 1
        pool = gcp("nocreate");
        if isempty(pool)
            pool = parpool('Processes', num_workers);
        end
        
        for worker_idx = num_workers:-1:1
            result_handler = SaveHandler(simulation_name + "_" + worker_idx);
            future_results(worker_idx) = parfeval(@make_estimation_simulation, ...
                1, simulation_name, ceil(simulation_count / num_workers), model, true_params, ...
                params_opt_set, trajectory_length, compute_estimates, ...
                solver, result_handler, num_handles ...
            );
        end
        future_merged = afterAll(future_results, @(in) EstimationSimulationResult.merge(in'), 1);


        store = pool.FileStore;
        progress = 0;
        store.KeyUpdatedFcn = @handle_file_update;
        estimation_result = future_merged.fetchOutputs();
    

        estimation_result.simulation_name = simulation_name;
        for worker_idx = 1:num_workers
            delete(simulation_name + "_" + worker_idx + ".mat");
        end
        SaveHandler(simulation_name).handle(estimation_result);
        delete(pool);
    else
        result_handler = SaveHandler(simulation_name);
        estimation_result = make_estimation_simulation( ...
            simulation_name, simulation_count, model, true_params, ...
            params_opt_set, trajectory_length, compute_estimates, ...
            solver, result_handler, num_handles ...
        );
    end


    function [] = handle_file_update(~, key)
            if key == simulation_name + "_" + 1
                progress = progress + 100 / num_handles;
                if progress <= 100
                    disp("Finished " + progress + "%");
                end
            end
    end
end

