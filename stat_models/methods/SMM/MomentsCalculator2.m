classdef MomentsCalculator2
    %MOMENTSCALCULATOR Class calculating moments of a time series
    
    properties
        %shvedov
        first_power_vectors = [0 0 0 0 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2];
        second_power_vectors = [1 2 3 4 1 1 1 1 1 2 2 2 2 2 1 1 1 1 1];
        lags_over_ts = [0 0 0 0 3 6 9 12 15 2 5 8 11 14 1 4 7 10 13];

        % Andersen Sorsen 24 moments
        %first_power_vectors = [0 0 0 0 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2];
        %second_power_vectors = [1 2 3 4 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2];
        %lags_over_ts = [0 0 0 0 1 2 3 4 5 6 7 8 9 10 1 2 3 4 5 6 7 8 9 10];
        
        %3 Andersen Sorsen 14 baseline
        %first_power_vectors =  [0 0 0 0 1 1 1 1 1 2 2 2 2 2];
        %second_power_vectors = [1 2 3 4 1 1 1 1 1 2 2 2 2 2];
        %lags_over_ts =         [0 0 0 0 2 4 6 8 10 1 3 5 7 9];




    end 
    
    methods
        function obj = MomentsCalculator(first_power_vectors, second_power_vectors, lags_over_ts)
            if nargin > 0
                obj.first_power_vectors = first_power_vectors;
                obj.second_power_vectors = second_power_vectors;
                obj.lags_over_ts = lags_over_ts;
            end
        end
        
        function moments = compute_moments(obj, time_series)
            max_lag =  max(obj.lags_over_ts);
            length_timeseries = size(time_series, 2);

            time_series = abs(time_series);
            time_series_lagged = lagmatrix(time_series, - obj.lags_over_ts).';

            time_series_power_lagged = bsxfun( @power, time_series_lagged, obj.first_power_vectors.');
            time_series_power_nolagged = time_series.^(obj.second_power_vectors.');

            moments = (time_series_power_lagged .* time_series_power_nolagged);
            moments = moments(:, 1: length_timeseries - max_lag);
            moments = moments.';

        end

        function mean_moments = compute_mean_moments(~, moments_vector)
            mean_moments = mean(moments_vector, 1);
        end

        function moments_count = get_moments_count(obj)
            moments_count = size(obj.first_power_vectors, 2);
        end
    end
end

