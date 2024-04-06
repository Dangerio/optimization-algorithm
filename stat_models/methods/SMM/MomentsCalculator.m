classdef MomentsCalculator
    %MOMENTSCALCULATOR Class calculating moments of a time series
    
    properties
        first_power_vectors = [0 0 0 0 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2];
        second_power_vectors = [1 2 3 4 1 1 1 1 1 2 2 2 2 2 1 1 1 1 1];
        lags_over_ts = [0 0 0 0 3 6 9 12 15 2 5 8 11 14 1 4 7 10 13];
    end
    
    methods
        function obj = MomentsCalculator(first_powers, second_powers, lags)
            if nargin > 0
                obj.first_power_vectors = first_powers;
                obj.second_power_vectors = second_powers;
                obj.lags_over_ts = lags;
            end
        end
        
        function moments = compute_moments(obj, time_series)
            max_lag =  max(obj.lags_over_ts) + 1;
            length_timeseries = size(time_series, 2);
            time_series_lagged = lagmatrix(time_series, obj.lags_over_ts).';

            time_series_power_lagged = abs(bsxfun( @power, time_series_lagged, obj.first_power_vectors.'));
            time_series_power_nolagged = abs(time_series.^(obj.second_power_vectors.'));
            

            moments = (time_series_power_lagged .* time_series_power_nolagged);
            moments = moments(:, max_lag:length_timeseries);
            moments = moments.';
        end

        function mean_moments = compute_mean_moments(~, moments_vector)
            mean_moments = mean(moments_vector, 1);
        end

        function moments_count = get_moments_count(obj)
            moments_count = size(obj.first_power_vectors, 1);
        end
    end
end

