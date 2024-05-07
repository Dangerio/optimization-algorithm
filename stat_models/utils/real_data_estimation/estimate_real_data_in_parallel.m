function [estimates_table] = estimate_real_data_in_parallel(...
    data_path, output_path, num_workers, assumed_model, ...
    params_opt_set, estimation_method, solver ...
    )
    pool = gcp("nocreate");
    if isempty(pool)
        pool = parpool('Processes', num_workers);
    end
    
    splitted_data = split_by_ticker(data_path);
    estimation_methods = repmat(estimation_method, size(splitted_data, 2), 1);
    result_esimates = repmat(struct('ticker',"0", 'estimates', [0, 0, 0]), size(splitted_data, 2), 1 );

    parfor ticker_idx = 1:size(splitted_data, 2)
        data = splitted_data(ticker_idx);
        estimates = estimation_methods(ticker_idx).compute_estimates(Trajectory(data.data.log_return), assumed_model, ...
            params_opt_set, solver ...
        );
        result_esimates(ticker_idx).ticker = data.ticker;
        result_esimates(ticker_idx).estimates = estimates;
    end

    estimates_table = struct2table(result_esimates);
    writetable(estimates_table, output_path,'Delimiter',',');

    delete(pool);
end

