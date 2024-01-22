function [y, x] = golden_ratio_search(func, lb, ub, max_iter, tolerance)
    golden_ratio = (1 + sqrt(5)) / 2;
    
    iter = 1;
    func_diff = Inf;
    y = Inf;
    while iter <= max_iter && func_diff > tolerance
        if mod(iter, 100) == 1
            y_old = y;
        end
  
        x_left = ub - (ub - lb) / golden_ratio;
        x_right = lb + (ub - lb) / golden_ratio;
        y_left = func(x_left);
        y_right = func(x_right);

        if y_left > y_right
            y = y_right;
            x = x_right;

            lb = x_left;
        else
            y = y_left;
            x = x_left;

            ub = x_right;
        end

        if mod(iter, 100) == 99
            func_diff = abs(y - y_old);
        end
        iter = iter + 1;
    end

end