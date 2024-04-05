classdef StringHasher
    %STRINGHASHER Object computing hash of strings
    
    methods
       
        function hash = compute_hash(~, string)
            hash = mod(keyHash(string), 2^32);
        end
    end
end

