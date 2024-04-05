function [number] = ranstream_pass(stream)
    %RANSTREAM_PASS Summary of this function goes here
    %   Detailed explanation goes here
    RandStream.setGlobalStream(stream);
    number = normrnd(0, 1);
end

