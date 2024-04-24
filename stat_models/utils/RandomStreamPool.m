classdef RandomStreamPool < handle
    %RANDOMSTREAMPOOL Pool of mutually independent RandomStreams 
    
    properties
        stream;
        batch_size
        loaders_count
        first = 1
        size = 2^128
        
    end
    
    methods
        function obj = RandomStreamPool(batch_size, loaders_count, first, size, gen_type)
            obj.batch_size = batch_size;
            obj.loaders_count = loaders_count;

            if nargin >= 3
                obj.first = first;
            end
            if nargin >= 4
                obj.size = size;
            end

            if nargin >= 5
                obj.stream = RandStream(gen_type);
            else
                obj.stream = RandStream("threefry4x64_20");
            end 
        end
        
        function loader = get_loader(obj, index)
            % This function should be called not more than once for a given
            % idx
            loader = RandomStreamBatchLoader(obj, index);
        end

        function reset(obj)
            obj.stream.reset();
        end
    end
end

