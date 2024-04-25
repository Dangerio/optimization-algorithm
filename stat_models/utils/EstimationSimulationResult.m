classdef EstimationSimulationResult < handle
    %ESTIMATIONSIMULATIONRESULT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        true_params
        param_opt_set
        length
        gen_type
        current_simulation = 1
        simulation_name = "Simulation"
        model
        method
        solver
        
        
        estimates % Mat[sim_count, param_count]
        gen_states % Mat[sim_count, gen_state_size]
        wall_time % Mat[sim_count, 1]
        cpu_time % Mat[sim_count, 1]
    end
    
    methods
        function obj = EstimationSimulationResult(sim_count, length, gen_type, true_params, param_opt_set, model, method, solver, simulation_name)
            obj.true_params = true_params;
            obj.param_opt_set = param_opt_set;
            obj.length = length;
            obj.gen_type = gen_type;
            obj.model = model;
            obj.method = method;
            obj.solver = solver;
            if nargin == 7
                obj.simulation_name = simulation_name;


            obj.estimates = zeros(sim_count, size(true_params, 2));
            obj.wall_time = zeros(sim_count, 1);
            obj.cpu_time = zeros(sim_count, 1);
            obj.gen_states = zeros(sim_count, size(RandStream(gen_type).state, 1));
            end
        end

        function add_new_estimate(obj, estimate, gen_state, wall_time, cpu_time)
            obj.estimates(obj.current_simulation, :) = estimate;
            obj.gen_states(obj.current_simulation, :) = gen_state;
            obj.wall_time(obj.current_simulation, :) = wall_time;
            obj.cpu_time(obj.current_simulation, :) = cpu_time;

            obj.current_simulation = obj.current_simulation + 1;
        end
        
        function mean_estimates = compute_mean_estimates(obj)
            mean_estimates = mean(obj.estimates, 1);
        end

        function rmse = compute_estimates_rmse(obj)
            rmse = sqrt(mean((obj.estimates - obj.true_params).^2, 1));
        end

        function trajectory = get_trajectory(obj, index)
            stream = RandStream(obj.gen_type);
            stream.State = uint32(obj.gen_states(index, :)');
            trajectory = obj.model.generate_trajectory(obj.true_params, obj.length, true, stream);
        end

        function obj = join(obj, other)
            merged_estimates = [obj.estimates; other.estimates];
            merged_cpu_time = [obj.cpu_time; other.cpu_time];
            merged_wall_time = [obj.wall_time; other.wall_time];
            merged_gen_states = [obj.gen_states; other.gen_states];
            obj.estimates = merged_estimates;
            obj.cpu_time = merged_cpu_time;
            obj.wall_time = merged_wall_time;
            obj.gen_states = merged_gen_states;

            obj.current_simulation = obj.current_simulation + other.current_simulation - 1;
        end

        function [] = export(obj, path, output_foldername)
            old_dir = pwd;
            if nargin < 2
                path = pwd;
            end
            if nargin < 3
                output_foldername = obj.simulation_name;
            end
            cd(path)
            if isfolder(output_foldername)
                cd(old_dir);
                error("Output directory exists, remove it if you want to overwrite.")
            end
            mkdir(output_foldername);
            cd(output_foldername);
            
            metadata = struct(...
                "simulation_name", obj.simulation_name, ...
                "model", class(obj.model), ...
                "true_params", obj.true_params, ...
                "param_opt_set", obj.param_opt_set, ...
                "length", obj.length, ...
                "method", class(obj.method), ...
                "solver", class(obj.solver), ...
                "simulation_count", obj.current_simulation - 1, ...
                "generator_type", obj.gen_type ...
            );

            meta_file = fopen('metadata.json', 'w');
            fwrite(meta_file, jsonencode(metadata));
            fclose(meta_file);
            

            data = struct2table(struct( ...
                "estimates", obj.estimates, ...
                "wall_time", obj.wall_time, ...
                "cpu_time", obj.cpu_time, ...
                "gen_states", obj.gen_states ...
            ));
            writetable(data, "data.csv");

            cd(old_dir);
        end
    end

    methods (Static = true)
        function [merged_result] = merge(results)
            merged_result = results(1);
            for i = 2:size(results, 2)
                merged_result = merged_result.join(results(i));
            % sim_counts = [results.current_simulation] - 1;
            % 
            % merged_result = EstimationSimulationResult(sum(sim_counts), results(1).length, results(1).true_params);
            % merged_result.current_simulation = size(merged_result.estimates, 1) + 1;
            % 
            % begin_index = 1;
            % for i = 1:size(results, 2)
            %     sim_count = sim_counts(i);
            %     merged_result.estimates(begin_index:begin_index + sim_count - 1, :) = results(i).estimates;
            %     begin_index = begin_index + sim_count;
            end
        end

        function [summary_table] = aggregate_results(results)
            simulation_count = size(results, 2);
            
            true_params = zeros(simulation_count, size(results(1).true_params, 2));
            mean_estimates = zeros(simulation_count, size(true_params, 2));
            rmses = zeros(simulation_count, size(true_params, 2));
            for i = 1:simulation_count
                true_params(i, :) = results(i).true_params;
                mean_estimates(i, :) = results(i).compute_mean_estimates();
                rmses(i, :) = results(i).compute_estimates_rmse();
            end

            summary_table = table( ...
                [results.length]', true_params, mean_estimates, rmses, ...
                'VariableNames', ["length", "true_params", "mean_estimates", "rmse"], ...
                'RowNames', [results.simulation_name] ...
            );

        end

    end
end

