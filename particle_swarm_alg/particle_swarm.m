function [argvalue_global, argmin_global] = particle_swarm(f, opt_set, alpha, beta, gamma, M, L, tolerance)
dim = size(opt_set, 1);

X = zeros(M, dim);
V = zeros(M, dim);
for i = 1:dim
    x_lower = opt_set(i, 1);
    x_upper = opt_set(i, 2);
    X(:, i) = unifrnd(x_lower, x_upper, M, 1);
    V(:, i) = unifrnd(x_lower - x_upper, x_upper - x_lower, M, 1);
end

X = X + V;
y = f(X);
argvalue_local = y;
argmin_local = X;

[argvalue_global, idxmin_global] = min(argvalue_local);
argmin_global = argmin_local(idxmin_global, :);

iter = 1;
func_value_diff = Inf;
while iter <= L && func_value_diff > tolerance
    if mod(iter, 1000) == 1
        old_argvalue = argvalue_global;
    end
    
   
    xi_1 = repmat(unifrnd(0, 1, M, 1), 1, dim);
    xi_2 = repmat(unifrnd(0, 1, M, 1), 1, dim);
    V = alpha * V + beta * xi_1 .* (argmin_local - X) +  gamma * xi_2 .* (argmin_global - X);
    X = X + V;
    y = f(X);

    [argvalue_local, idxmin_local] = min([argvalue_local, y], [], 2);
    mask_idx = find(idxmin_local == 2);
    argmin_local(mask_idx, :) = X(mask_idx, :);
    [argvalue_global, idxmin_global] = min(argvalue_local);
    argmin_global = argmin_local(idxmin_global, :);

    if mod(iter, 1000) == 999
        func_value_diff = abs(old_argvalue - argvalue_global);
    end
    iter = iter + 1;
end

if iter > L
    disp("WARNING")
    disp("Max limit on iterations has reached, probably the algorithm fails to converge.")
end
