classdef (Abstract) LinearDynamicModel 
    %LINEARDYNAMICMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Abstract)
        baseline
    end

    methods
        function obj = LinearDynamicModel()
        end
        
        function log_likelihood = compute_log_likelihood( ...
                obj, trajectory, params ...
            )
            trajectory = obj.transform_data_to_ldm(trajectory);
            log_likelihood = 0;
            state_expectation = obj.get_initial_state_expectation(params);
            state_variance = obj.get_initial_state_variance(params);
            for time = 1:trajectory.get_length()
                exog_observation = trajectory.get_exog_observation(time);
                endog_observation = trajectory.get_endog_observation(time);

                state_transformation = obj.compute_state_transformation(...
                    exog_observation, params ...
                );
                endog_transformation = obj.compute_endog_transformation( ...
                    exog_observation, params ...
                );
                endog_shift = obj.compute_endog_shift(exog_observation, params);
                endog_variance = endog_transformation * state_variance ...
                    * endog_transformation';
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % endog_variance = nearestSPD(endog_variance);
                % if endog_variance < 1e7
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

             
                residuals_variance = obj.compute_residuals_variance(...
                    exog_observation, params ...
                );

                prediction_error = endog_observation - endog_shift - ...
                    endog_transformation * state_expectation;
                log_likelihood = log_likelihood + prediction_error' * ...
                    (endog_variance \ prediction_error);
                log_likelihood = log_likelihood + log(det(endog_variance));

                [state_expectation, state_variance] = obj.update_state_distribution(...
                    state_expectation, state_variance, state_transformation, ...
                    endog_observation, endog_transformation, endog_shift, ...
                    endog_variance, residuals_variance ...
                );
            end

            log_likelihood = -(0.5) * log_likelihood;
        end

        function [posteriori_state_expectations, posteriori_state_variances] = ...
                get_predictions(obj, trajectory, params)
            trajectory = obj.transform_data_to_ldm(trajectory);
            state_expectation = obj.get_initial_state_expectation(params);
            state_variance = obj.get_initial_state_variance(params);
            
            state_size = size(state_expectation, 1);
            posteriori_state_expectations = zeros(trajectory.get_length(), state_size);
            posteriori_state_variances = zeros(trajectory.get_length(), state_size, state_size);
            for time = 1:trajectory.get_length()
                exog_observation = trajectory.get_exog_observation(time);
                endog_observation = trajectory.get_endog_observation(time);

                state_transformation = obj.compute_state_transformation(...
                    exog_observation, params ...
                );
                endog_transformation = obj.compute_endog_transformation( ...
                    exog_observation, params ...
                );
                endog_shift = obj.compute_endog_shift(exog_observation, params);
                endog_variance = endog_transformation * state_variance ...
                    * endog_transformation';
                residuals_variance = obj.compute_residuals_variance(...
                    exog_observation, params ...
                );
                [state_expectation, state_variance, state_posteriori_expectation, state_posteriori_variance] = obj.update_state_distribution(...
                    state_expectation, state_variance, state_transformation, ...
                    endog_observation, endog_transformation, endog_shift, ...
                    endog_variance, residuals_variance ...
                );
                posteriori_state_expectations(time, :) = state_posteriori_expectation;
                posteriori_state_variances(time, :, :) = state_posteriori_variance;
            end

        end
    end

    methods (Abstract = true)
        generate_trajectory(obj, params, length, is_initial_value_random, stream);
    end

    methods (Access = protected, Static = true)
        function [state_posteriori_expectation, state_posteriori_variance] = ... 
            compute_posteriori_state_distribution( ...
                state_priori_expectation, state_priori_variance, ...
                endog_observation, endog_transformation, endog_shift, ...
                endog_posteriori_variance ...
            )
            second_sum_multiplier = state_priori_variance * endog_transformation' / ...
                endog_posteriori_variance;

            state_posteriori_expectation = state_priori_expectation + ...
                second_sum_multiplier * (endog_observation - ...
                endog_shift - endog_transformation * state_priori_expectation);
            
            state_posteriori_variance = state_priori_variance - ...
                second_sum_multiplier * endog_transformation * state_priori_variance;
        end

        function [state_priori_expectation, state_priori_variance] = ...
            compute_priori_state_distribution(...
                state_posteriori_expectation, state_posteriori_variance, ...
                state_transformation, residuals_variance ...
            )
            state_priori_expectation = state_transformation * ...
                state_posteriori_expectation;
            state_priori_variance = state_transformation *  ...
                state_posteriori_variance * state_transformation' + ...
                residuals_variance;
        end

        function [new_state_expectation, new_state_variance, ...
                state_posteriori_expectation, state_posteriori_variance] = ...
            update_state_distribution( ...
                state_expectation, state_variance, state_transformation, ...
                endog_observation, endog_transformation, endog_shift, ...
                endog_posteriori_variance, residuals_variance ...
            )
            [state_posteriori_expectation, state_posteriori_variance] = ...
                LinearDynamicModel.compute_posteriori_state_distribution( ...
                    state_expectation, state_variance, ...
                    endog_observation, endog_transformation, endog_shift, ...
                    endog_posteriori_variance ...
            );
            [new_state_expectation, new_state_variance] = ...
                LinearDynamicModel.compute_priori_state_distribution(...
                    state_posteriori_expectation, state_posteriori_variance, ...
                    state_transformation, residuals_variance ...
            );
        end
    end

    methods (Access = protected, Abstract = true)
        transform_data_to_ldm(obj, trajectory);
        compute_state_transformation(obj, exog, params);
        compute_endog_transformation(obj, exog, params);
        compute_endog_shift(obj, exog, params);
        compute_residuals_variance(obj, exog, params);
        get_initial_state_expectation(obj, params);
        get_initial_state_variance(obj, params);
    end
end

