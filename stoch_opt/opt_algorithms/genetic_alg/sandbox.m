addpath(genpath(fileparts(pwd)));

options = optimoptions(@ga,'UseVectorized',true);
options.MaxGenerations = 20000;
options.FunctionTolerance = 0;
options.MaxStallGenerations = 20000;


opt_set = repmat([-10, 10], 5, 1);
[x,y] = ga(@square_sin_func, size(opt_set, 1),[],[],[],[],opt_set(:, 1)',opt_set(:, 2)',[],options)