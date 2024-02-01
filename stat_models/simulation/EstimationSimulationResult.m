classdef EstimationSimulationResult < handle
    %ESTIMATIONSIMULATIONRESULT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        estimates % Mat[sim_count, param_count]
        current_simulation = 1
    end
    
    methods
        function obj = EstimationSimulationResult(sim_count, param_count)
            obj.estimates = zeros(sim_count, param_count);
        end

        function add_new_estimate(obj, estimate)
            obj.estimates(obj.current_simulation, :) = estimate;
            obj.current_simulation = obj.current_simulation + 1;
        end
        
        function mean_estimates = compute_mean_estimates(obj)
            mean_estimates = mean(obj.estimates, 1);
        end

        function rmse = compute_estimates_rmse(obj, true_params)
            rmse = sqrt(mean((obj.estimates - true_params).^2, 1));
        end
    end

    methods (Static = true)
        function [merged_result] = merge(results)
            param_count = size(results(1).estimates, 2);
            sim_counts = [results.current_simulation] - 1;

            merged_result = EstimationSimulationResult(sum(sim_counts), param_count);
            merged_result.current_simulation = size(merged_result.estimates, 1) + 1;
            
            begin_index = 1;
            for i = 1:size(results, 2)
                sim_count = sim_counts(i);
                merged_result.estimates(begin_index:begin_index + sim_count - 1, :) = results(i).estimates;
                begin_index = begin_index + sim_count;
            end
        end

    end
end

