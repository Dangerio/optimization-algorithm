parfor i = 1:4
    stream = RandStream("mt19937ar", "Seed", StringHasher().compute_hash(i));
    s1 = stream.State;
    disp(ranstream_pass(stream))
    s2 = stream.State;
    if s1 == s2
        disp("states are equal")
    else 
        disp("no equal")
    end
end