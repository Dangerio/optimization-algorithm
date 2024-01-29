function x = cauchyrnd(location_parameter, scale_parameter, cnt_rows, cnt_cols)
    if nargin == 2
        cnt_rows = 1;
        cnt_cols = 1;
    end
    
    p_cdf = unifrnd(0, 1, cnt_rows, cnt_cols); %uniform random from 0->1, since cdf by definition 0->1
    x = location_parameter + scale_parameter*tan(pi*(p_cdf-0.5)); %solve cdf eqn for x