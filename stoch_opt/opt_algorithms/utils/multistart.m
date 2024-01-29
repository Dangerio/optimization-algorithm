function [best_y, best_x] = multistart(solver, func, opt_set, count, has_to_minimize)
    if nargin == 4
        has_to_minimize = true;
    end
  
    best_y = (-1)^(~has_to_minimize) * Inf;
    for i = 1:count
        if has_to_minimize
            [y, x] = solver.minimize(func, opt_set);
        else
            [y, x] = solver.maximize(func, opt_set);
        end
 
        if (y < best_y && has_to_minimize) || (y > best_y && ~has_to_minimize)
            best_y = y;
            best_x = x;
        end
    end
end