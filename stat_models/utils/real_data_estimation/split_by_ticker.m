function [ts_list] = split_by_ticker(data_path)
    table = readtable(data_path);
    table.date = datetime(string(table.date),'InputFormat','yyyyMMdd');
    table.ticker = string(table.ticker);
    tickers = unique(table.ticker);
    ts_list = [];
    for i = 1:size(tickers, 1)
        ts.ticker = tickers(i);
        ts.data = sortrows(table(table.ticker == tickers(i), :), {'date'});
        ts_list = [ts_list, ts];
    end
end


