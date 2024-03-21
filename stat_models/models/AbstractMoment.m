classdef (Abstract) AbstractMoment 
    methods

        function obj = AbstractMoment()
        end

        function mse = compute_smm_mse(obj, time_series, params)
            time_series_real = time_series.endog.';
            % time_series_real = time_series;

            simulational_length = obj.simulational_length_size * size(time_series_real, 2);

            stream = RandStream('dsfmt19937','Seed',3);
            rng(stream)
            time_series_simulated = obj.generate_trajectory(params, simulational_length).endog.';
            reset(stream);

            simulated_moments = obj.compute_moments(time_series_simulated);

            real_moments = obj.compute_moments(time_series_real);
            
            moment_closeness = real_moments - simulated_moments;
            mse = moment_closeness * moment_closeness.';
            
        end

        function moments = compute_moments(obj, time_series)
            
            power_first = obj.initial_first_power_vectors().';
            power_second = obj.initial_second_power_vectors().';
            lags_between_series = obj.initial_lags_over_ts();

            % assert(size(powers_first) == size(powers_second) & ...
            %        size(powers_first) == size(lags_between_series)), ...
            %        'Second, Third and Fourth variables should have same size')


            max_lag =  max(lags_between_series) + 1;
            length_timeseries = size(time_series, 2);

            time_series_lagged = lagmatrix(time_series, lags_between_series).';

            time_series_power_lagged = abs(bsxfun( @power, time_series_lagged, power_first ));
            time_series_power_nolagged = abs(time_series.^power_second);

            moments = (time_series_power_lagged .* time_series_power_nolagged);
            moments = mean(moments(:, max_lag:length_timeseries), 2);
            moments = moments.';
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
    end
end