from __future__ import annotations
import re
import os
from pathlib import Path
from typing import Generator, List, Optional


def walk_with_exclude(
    base: Path, exclude: List[re.Pattern], to_walk: Path = Path("")
) -> Generator[Path, None, List[os.DirEntry]]:
    """ "We assume `base` is .resolve()ed"""
    skipped = []
    base = base if isinstance(base, Path) else Path(base.path)
    for child in os.scandir(base / to_walk):
        child_rel_path = to_walk / child.name
        if any(ptrn.match(child.path) for ptrn in exclude):
            skipped.append(child_rel_path)
            continue
        if child.is_dir():
            walk_with_child = walk_with_exclude(base, exclude, child_rel_path)
            try:
                while True:
                    yield next(walk_with_child)
            except StopIteration as e:
                skipped.extend(e.value)
        else:
            yield child_rel_path
    return skipped


def setup_all_symlinks(
        base: Path, to: Path, dry_run: bool, force: bool, exclude: List[re.Pattern[str]], verbose: bool
) -> None:
    to_symlink = walk_with_exclude(base, exclude)
    try:
        while fp := next(to_symlink):
            setup_symlink(base, fp, to, dry_run, force, verbose)
    except StopIteration as e:
        if verbose:
            print({"skipped": list(map(str, e.value))})


def setup_symlink(
        base: Path, from_: Path, to: Path, dry_run: bool, force: bool, verbose: bool
) -> Optional[Path]:
    resolved_from = base / from_
    resolved_to = to / from_
    if resolved_to.exists():
        if force:
            os.unlink(resolved_to)
        else:
            if verbose:
                print(f"Warning: not setting up {resolved_to} because target exists.")
            return None
    print(f"{resolved_from} => {resolved_to}")
    if not dry_run:
        if not resolved_to.parent.exists():
            os.makedirs(resolved_to.parent)
        os.symlink(resolved_from, resolved_to)
    return resolved_to
