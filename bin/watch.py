#!/usr/bin/env python
from pathlib import Path
import time
import datetime
import typer


def main(
    total: int = 8537, dir_: Path = Path("."), glob: str = "*.jsonl", period: float = 2
) -> None:
    old_len = len(list(dir_.glob(glob)))
    old_time = time.time()

    time.sleep(period)
    while True:
        new_time = time.time()
        new_len = len(list(dir_.glob(glob)))
        speed = (new_len - old_len) / (new_time - old_time)
        eta = float('inf') if speed == 0. else datetime.timedelta(seconds=(total -new_len) / speed)
        print(
            f"Currently have: {new_len} with speed of {speed:.2f} author/sec, should finish in: {eta}"
        )
        time.sleep(period)


if __name__ == "__main__":
    typer.run(main)
