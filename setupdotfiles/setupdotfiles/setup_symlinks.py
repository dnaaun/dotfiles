from __future__ import annotations
import re
import os
import shutil
from pathlib import Path
from typing import Generator, List, Optional


def walk_with_exclude(
        base: Path, exclude: List[re.Pattern], to_walk: Path = Path(""), dirs_only: bool=False
) -> Generator[Path, None, List[os.DirEntry]]:
    """ 

    Args:
        base: We assume it's `.resolve()`ed
        exclude: We'll 
        to_walk:
    """
    skipped = []
    base = base if isinstance(base, Path) else Path(base.path)
    for child in os.scandir(base / to_walk):
        child_rel_path = to_walk / child.name
        if any(ptrn.match(child.path) for ptrn in exclude):
            skipped.append(child_rel_path)
            continue
        if child.is_dir():
            if dirs_only:
                yield Path(child)
            walk_with_child = walk_with_exclude(base, exclude, child_rel_path, dirs_only)
            try:
                while True:
                    yield next(walk_with_child)
            except StopIteration as e:
                skipped.extend(e.value)
        else:
            if not dirs_only:
                yield child_rel_path
    return skipped


def setup_all_symlinks(
    base: Path,
    to: Path,
    dry_run: bool,
    force: bool,
    exclude: List[re.Pattern[str]],
    verbose: bool,
) -> None:
    to_symlink = walk_with_exclude(base, exclude)
    try:
        while fp := next(to_symlink):
            setup_symlink(base, fp, to, dry_run, force, verbose)
    except StopIteration as e:
        if verbose:
            print({"skipped": list(map(str, e.value))})

    to_remove_invalid_symlinks = walk_with_exclude(base, exclude, dirs_only=True)
    for dir_ in to_remove_invalid_symlinks:
        dir_ = to / dir_.relative_to(base)
        if not dir_.exists():
            continue
        for fp in dir_.iterdir():
	    # this hasattr() check is a workaround for a bug I don't understand yet. On the SCC,
	    # pathlib.PosixPath doesnt' have a .readlink() method????
            if fp.is_symlink() and hasattr(fp, 'readlink') and not fp.readlink().exists():
                print(f"Removed {str(fp)} because it's a stale symlink.")
                fp.unlink()


def setup_symlink(
        base: Path, from_: Path, to: Path, dry_run: bool, force: bool, verbose: bool
) -> Optional[Path]:
    resolved_from = base / from_
    resolved_to = to / from_
    should_copy = from_.parts[:2] == (".codex", "skills")
    replacing_skill_symlink = should_copy and resolved_to.is_symlink()
    if replacing_skill_symlink:
        if verbose:
            print(f"Replacing skill symlink {resolved_to} with a copy.")
        if not dry_run:
            resolved_to.unlink()
    if resolved_to.exists() and not replacing_skill_symlink:
        if force:
            os.unlink(resolved_to)
            if verbose:
                print(f"Deleted {resolved_to}.")
        else:
            if verbose:
                print(f"Warning: not setting up {resolved_to} because target exists.")
            return None
    operation = "copy" if should_copy else "symlink"
    print(f"{resolved_from} => {resolved_to} ({operation})")
    if not dry_run:
        if not resolved_to.parent.exists():
            os.makedirs(resolved_to.parent)
        if should_copy:
            shutil.copy2(resolved_from, resolved_to)
        else:
            os.symlink(resolved_from, resolved_to)
    return resolved_to

if __name__ == "__main__":
    walk_with_exclude(Path('.'), [re.compile('.*venv.*')])
