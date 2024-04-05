classdef Trajectory
    %TRAJECTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        endog
        exog
    end
    
    methods
        function obj = Trajectory(endog, exog)
            if nargin <= 1
                obj.endog = endog;
            end
            if nargin == 2
                obj.exog = exog;
            end
        end

        function len = get_length(obj)
            len = size(obj.endog, 1);
        end

        function dim = get_endog_dim(obj)
            dim = size(obj.endog, 2);
        end

        function dim = get_exog_dim(obj)
            dim = size(obj.exog, 2);
        end

        function exog = get_exog_observation(obj, time)
            if size(obj.exog, 1) == 0
                exog = [];
            else 
                exog = obj.exog(time, :);
            end
        end

        function endog = get_endog_observation(obj, time)
            endog = obj.endog(time, :);
        end
    end
end

