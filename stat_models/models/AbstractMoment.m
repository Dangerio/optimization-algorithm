classdef (Abstract) AbstractMoment 
    % properties 
    %     counter = 0
    %     prev_weight_matrix = 0
    % end

    methods
        function obj = AbstractMoment()
        end

        function [mse, weight_matrix]  = compute_smm_mse(obj, time_series, params)


            time_series_real = time_series.endog.';
            real_moments_matrix = obj.compute_moments(time_series_real);
            real_moments = obj.compute_mean_moments(real_moments_matrix);

            simulational_length = obj.simulational_length_size * size(time_series_real, 2);
            time_series_simulated = obj.generate_trajectory(params, simulational_length, 0).endog.';

            simulated_moments_matrix = obj.compute_moments(time_series_simulated);
            simulated_moments = obj.compute_mean_moments(simulated_moments_matrix);
            moment_closeness = real_moments - simulated_moments;

            % disp(last_weight_matrix)

            weight_matrix = obj.calculate_weight_matrix(params, simulated_moments_matrix);

            d = eig(weight_matrix);
            isposdef = all(d > 0);

            if isposdef == false
                mse = 1000000;
                weight_matrix = zeros(size(moment_closeness,2));
            else
                mse = moment_closeness * weight_matrix * moment_closeness.';
            end
            % disp([mse, params])
            % disp(weight_matrix)

        end

        function weight_matrix = calculate_weight_matrix(obj, params, simulated_moments_matrix)
        
            simulated_series_for_weight = obj.generate_trajectory(params, obj.length_sim_for_weight, 100).endog.';
            simulated_moments_for_weight_matrix = obj.compute_moments(simulated_series_for_weight);
            simulated_moments_for_weight = obj.compute_mean_moments(simulated_moments_for_weight_matrix);
        
            clossenes_for_weight_matrix = simulated_moments_matrix - simulated_moments_for_weight;
            B_matrix = obj.calculate_Q_matrix(clossenes_for_weight_matrix, 0);
            
            for k = 1:obj.length_cycle_weight
                Q_j = obj.calculate_Q_matrix(clossenes_for_weight_matrix, k);
                weight_inside = (obj.length_cycle_weight + 1 - k)/ (obj.length_cycle_weight + 1);
                B_matrix = B_matrix + weight_inside * (Q_j + Q_j.');
            end
            weight_matrix = pinv(B_matrix + eps * eye(size(B_matrix,2)));
        end
            


        function Q = calculate_Q_matrix(obj, clossenes_for_weight_matrix, j)
            Q = zeros(size(clossenes_for_weight_matrix,2));
            size_of_series = size(clossenes_for_weight_matrix,1);
            for s = j+1:size_of_series
                Q = Q + clossenes_for_weight_matrix(s-j,:).' * clossenes_for_weight_matrix(s,:);
            end
            Q = Q./(size_of_series);
        end


        function moments = compute_moments(obj, time_series)
            power_first = obj.initial_first_power_vectors().';
            power_second = obj.initial_second_power_vectors().';
            lags_between_series = obj.initial_lags_over_ts();

            max_lag =  max(lags_between_series) + 1;
            length_timeseries = size(time_series, 2);
            time_series_lagged = lagmatrix(time_series, lags_between_series).';

            time_series_power_lagged = abs(bsxfun( @power, time_series_lagged, power_first));
            time_series_power_nolagged = abs(time_series.^power_second);
            

            moments = (time_series_power_lagged .* time_series_power_nolagged);
            moments = moments(:, max_lag:length_timeseries);
            moments = moments.';
        end

        function mean_moments = compute_mean_moments(obj, moments_vector)
            mean_moments = mean(moments_vector, 1);
        
        end

    end


    methods (Abstract = true)
        generate_trajectory(obj, params, length);
    end

    methods (Access = protected, Abstract = true)
    
        initial_first_power_vectors(obj);
        initial_second_power_vectors(obj);
        initial_lags_over_ts(obj);
        simulational_length_size(obj);
        weight_bool(obj);
        length_sim_for_weight(obj);
        length_cycle_weight(obj);
    end
end