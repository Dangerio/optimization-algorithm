from dataclasses import dataclass
from typing import Union
from pathlib import Path
import json
import pandas as pd


@dataclass
class EstimationSimulationResult:
    metadata: dict[str, Union[int, str, list[float], list[list[float]]]]
    data: pd.DataFrame


def read_esr(path: str | Path) -> EstimationSimulationResult:
    if isinstance(path, str):
        path = Path(path)
    elif not isinstance(path, Path):
        raise RuntimeError("Path should be string or pathlib.Path.")

    with open(path / "metadata.json", "r", encoding="utf8") as file:
        metadata = json.load(file)
    data = pd.read_csv(path / "data.csv")
    return EstimationSimulationResult(metadata, data)
