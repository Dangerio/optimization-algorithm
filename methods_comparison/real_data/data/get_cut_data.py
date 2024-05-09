import pandas as pd
from datetime import datetime
data = pd.read_csv("merged_data.csv")
data["date"] = pd.to_datetime(data.date, format="%Y%m%d")
data = data.loc[data.date < datetime(2022, 1, 1), :]
gpb = data.groupby(by="ticker").count()
tickers = gpb.loc[gpb.date >= 250, "date"].index
data = data.set_index("ticker").loc[tickers, :].reset_index()
data.date = data.date.apply(lambda date: date.strftime(format="%Y%m%d"))
data.to_csv("cut_data.csv", sep=",", index=False)
