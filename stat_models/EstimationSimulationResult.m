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
end

