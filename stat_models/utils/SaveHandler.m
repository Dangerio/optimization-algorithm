classdef SaveHandler
    %SAVEHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filename
    end
    
    methods
        function obj = SaveHandler(filename)
            obj.filename = filename;
        end
        
        function [] = handle(obj, result_object)
            save(obj.filename, "result_object");
            if ~isempty(getCurrentFileStore)
                copyFileToStore(getCurrentFileStore, obj.filename + ".mat", obj.filename);
            end
        end
    end
end

