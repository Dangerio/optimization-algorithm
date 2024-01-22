function [best_y, best_x] = particle_swarm_multistart(f, opt_set, alpha, beta, gamma, M, L, tolerance, multistart_count)
best_y = Inf; 
for i = 1:multistart_count
    [y, x] = particle_swarm(f, opt_set, alpha, beta, gamma, M, L, tolerance);
    if y < best_y
        best_y = y;
        best_x = x;
    end
end
end