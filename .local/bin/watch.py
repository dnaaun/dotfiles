#!/usr/bin/env python
from pathlib import Path
from typing import TextIO
import time
import datetime
import typer


NEWLINE = '\n'
def count_lines(f_: TextIO, chunksize=2 ** 12) -> int:
    count = 0
    f_.seek(0)
    chunk = f_.read(chunksize)
    while chunk:
        count += chunk.count(NEWLINE)
        chunk = f_.read(chunksize)
    return count

def main(
    total: int = 8537, dir_: Path = Path("."), glob: str = "*.jsonl", file_: Path=None, period: float = 2
) -> None:
    
    first_time = time.time()

    in_file = 0
    if file_:
        open_file =  file_.open()
        in_file = count_lines(open_file)

    in_dir = len(list(dir_.glob(glob)))


    first_count = in_dir + in_file

    time.sleep(period)
    while True:
            new_time = time.time()
            in_dir = len(list(dir_.glob(glob)))

            if file_: in_file = count_lines(open_file)

            new_count =  in_dir+ in_file

            speed = (new_count - first_count) / (new_time - first_time)

            eta = float('inf') if speed == 0. else datetime.timedelta(seconds=(total -new_count) / speed)

            print(
                f"Currently have: {in_dir} in dir and {in_file} in file. Speed {speed:.2f} /sec, eta: {eta}"
            )
            time.sleep(period)


if __name__ == "__main__":
    typer.run(main)
