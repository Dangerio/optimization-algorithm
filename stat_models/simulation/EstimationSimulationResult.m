classdef EstimationSimulationResult < handle
    %ESTIMATIONSIMULATIONRESULT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        true_params
        estimates % Mat[sim_count, param_count]
        current_simulation = 1
        simulation_name
        length
    end
    
    methods
        function obj = EstimationSimulationResult(sim_count, length, true_params, simulation_name)
            obj.true_params = true_params;
            obj.length = length;
            obj.estimates = zeros(sim_count, size(true_params, 2));
            if nargin == 4
                obj.simulation_name = simulation_name;
            end
        end

        function add_new_estimate(obj, estimate)
            obj.estimates(obj.current_simulation, :) = estimate;
            obj.current_simulation = obj.current_simulation + 1;
        end
        
        function mean_estimates = compute_mean_estimates(obj)
            mean_estimates = mean(obj.estimates, 1);
        end

        function rmse = compute_estimates_rmse(obj)
            rmse = sqrt(mean((obj.estimates - obj.true_params).^2, 1));
        end
    end

    methods (Static = true)
        function [merged_result] = merge(results)
            sim_counts = [results.current_simulation] - 1;

            merged_result = EstimationSimulationResult(sum(sim_counts), results(1).length, results(1).true_params);
            merged_result.current_simulation = size(merged_result.estimates, 1) + 1;
            
            begin_index = 1;
            for i = 1:size(results, 2)
                sim_count = sim_counts(i);
                merged_result.estimates(begin_index:begin_index + sim_count - 1, :) = results(i).estimates;
                begin_index = begin_index + sim_count;
            end
        end

        function [summary_table] = aggregate_results(results)
            true_params = results(1).true_params;
            simulation_count = size(results, 2);

            mean_estimates = zeros(simulation_count, size(true_params, 2));
            rmses = zeros(simulation_count, size(true_params, 2));
            for i = 1:simulation_count
                mean_estimates(i, :) = results(i).compute_mean_estimates();
                rmses(i, :) = results(i).compute_estimates_rmse();
            end

            summary_table = table( ...
                [results.length]', mean_estimates, rmses, ...
                'VariableNames', ["length", "mean_estimates", "rmse"], ...
                'RowNames', [results.simulation_name] ...
            );

        end

    end
end

