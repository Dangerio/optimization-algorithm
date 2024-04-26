import os
import numpy as np
import pandas as pd
from tqdm import tqdm
from pathlib import Path


raw_data_dir = Path("raw_data")
raw_data_files = sorted(os.listdir(raw_data_dir))
grouped_data_files = list(zip(raw_data_files[::2], raw_data_files[1::2]))
assert all(
    first.split("_")[0] == second.split("_")[0]
    for first, second in grouped_data_files
)
assert all(
    first.split("_")[1:] != second.split("_")[1:]
    for first, second in grouped_data_files
)
assert len(raw_data_files) == 48 * 2


df_list = []
for first_part, second_part in tqdm(grouped_data_files):
    first_df = pd \
        .read_csv(raw_data_dir / first_part) \
        .drop(columns=["<PER>", "<TIME>"])
    second_df = pd \
        .read_csv(raw_data_dir / second_part) \
        .drop(columns=["<PER>", "<TIME>"])

    if first_df.shape[0] > 0 and second_df.shape[0] > 0:
        merged_df = pd.concat([first_df, second_df])
    elif first_df.shape[0] > 0:
        merged_df = first_df
    elif second_df.shape[0] > 0:
        merged_df = second_df
    else:
        continue

    merged_df["<CLOSE>"] = (
        np
        .log(merged_df["<CLOSE>"])
        .diff()
    )
    merged_df.rename(columns={
        "<TICKER>": "ticker",
        "<DATE>": "date",
        "<CLOSE>": "log_return"
    }, inplace=True)

    df_list.append(merged_df.drop(0))

result_df = pd.concat(df_list)
result_df.to_csv("merged_data.csv", sep=",", index=False)
