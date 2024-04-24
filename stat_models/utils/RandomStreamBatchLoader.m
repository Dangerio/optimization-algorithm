classdef RandomStreamBatchLoader < handle
    %RANDOMSTREAMBATCH Loader for batches of mutually independent RandomStreams
    
    properties 
        pool
    end

    properties (Access = private)
        current_batch_begin
        current_batch = 1;
    end
    
    methods
        function obj = RandomStreamBatchLoader(pool, loader_index)
            obj.pool = pool;
            obj.current_batch_begin = obj.pool.first + obj.pool.batch_size * (loader_index - 1);
        end
        
        function stream = get_random_stream(obj, index_in_batch)
            obj.pool.stream.Substream = obj.current_batch_begin + index_in_batch - 1;
            stream = obj.pool.stream;
        end

        function next(obj)
            obj.current_batch_begin = mod(obj.current_batch_begin + obj.pool.batch_size * obj.pool.loaders_count - 1, obj.pool.size) + 1;
        end

        function batch_begin = get_batch_begin(obj)
            batch_begin = obj.current_batch_begin;
        end
    end
end

