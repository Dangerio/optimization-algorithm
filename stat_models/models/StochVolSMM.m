classdef StochVolSMM < AbstractMoment 
    %STOCHVOLSMM Summary of this class goes here
    %   Detailed explanation goes here
    properties (Constant = true)
        exp_log_sq_stdnorm = -double((eulergamma + log(2)));
        var_log_sq_stdnorm = double(eulergamma^2 + eulergamma * log(4)) + log(2)^2 + pi^2 / 2 - double((eulergamma + log(2))^2);

    end

    methods
        function trajectory = generate_trajectory(obj, params, length, seed)
            if nargin == 3
                seed = randi(100000);
            end
            stream1 = RandStream('swb2712','Seed', seed);
            stream2 = RandStream('swb2712','Seed', seed + 1);
            stream3 = RandStream('swb2712','Seed', seed + 2);
            trajectory = Trajectory(zeros(length, 1));
            % hidden_ar_values = obj.generate_hidden_ar_one_process(params, length, seed);
            hidden_ar_values = zeros(length, 1);
            hidden_ar_values(1) = randn(stream1) * sqrt(params(3)^2 / (1 - params(2)^2));
            noise_values = randn(stream2, length - 1, 1) * params(3);
            for time = 2:length
                hidden_ar_values(time) = params(2) * hidden_ar_values(time - 1) + noise_values(time - 1);
            end
            
            noise = log(randn(stream3, length, 1).^2) - obj.exp_log_sq_stdnorm;
            drift = params(1) / (1 - params(2)) - double(eulergamma) - log(2);
            trajectory.endog = drift + hidden_ar_values + noise;
        end
    end

    % methods (Access = private)
    %     function ar_values = generate_hidden_ar_one_process(~, params, length, seed)
    %         stream = RandStream('mcg16807','Seed', seed + 1);
    %         ar_values = zeros(length, 1);
    %         ar_values(1) = randn(stream) * params(3)^2 / (1 - params(2)^2);
    %         noise_values = randn(stream, length - 1, 1) * params(3)^2;
    %         for time = 2:length
    %             ar_values(time) = params(2) * ar_values(time - 1) + noise_values(time - 1);
    %         end
    %     end

        % function noise_values = generate_noise_for_observed_variable(obj, length)
        % 
        %     noise_values = log(randn(obj.stream, length, 1).^2) - obj.exp_log_sq_stdnorm;
        % end
    % end


    methods (Access = protected)
        % params = [theta_1, theta_2, theta_3]
        function power_first = initial_first_power_vectors(~)
            power_first = [0 0 0 0 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2];
            % power_first = [1 2 1 1];

        end

        function power_second =  initial_second_power_vectors(~)
            power_second = [1 2 3 4 1 1 1 1 1 2 2 2 2 2 1 1 1 1 1];
            % power_second = [0 0 1 2];
        end

        function lags =  initial_lags_over_ts(~)
            lags = [0 0 0 0 3 6 9 12 15 2 5 8 11 14 1 4 7 10 13];
            % lags = [0 0 1 2];

        end

        function k =  simulational_length_size(~)
            k = 10;
        end
        %r^{power_second}_t * r^{power_first}_{t-lags}

    end
end

