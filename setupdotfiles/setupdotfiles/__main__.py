from __future__ import annotations
from argparse import ArgumentParser
import os
from typing import cast
from .setup_symlinks import setup_all_symlinks
import re
from pathlib import Path
import sys


def main() -> int:
    parser = ArgumentParser()
    parser.add_argument("-d", "--dry-run", action="store_true")
    parser.add_argument("-f", "--force", action="store_true")
    parser.add_argument("-b", "--daemonize", action="store_true")
    parser.add_argument("-t", "--dotfiles-dir", default=None)
    parser.add_argument(
        "-e",
        "--exclude",
        nargs="*",
        default=[
            r".*\.git.*",
            r".*README\.md",
            r".*setupdotfiles.*",
            r".*\.Session\.vim.*",
            r".*submodules.*",
            r".*\.mypy_cache.*",
            r".*__pycache__.*",
            # Saving in neovim creates these temporary files
            r".*[0-9]{3,}",
            r".*\~" 
        ],
    )
    args = parser.parse_args()

    base = Path(args.dotfiles_dir) if args.dotfiles_dir is not None else None
    if base is None:
        if home_dir := os.getenv("HOME"):
            base=Path(home_dir) / "git"/ "dotfiles"
        else:
            print("No $HOME env var, and no explicitly passed dotfiles dir")
            return 1

    to_str = os.getenv("HOME")
    if to_str == None:
        print(f"$HOME env var not set. Are you not on Unix?")
        return 1
    to = Path(to_str).resolve()
    if not to.exists():
        print("$HOME from_ env vars doesn't exist as a directory.")
        return 1
    exclude = [ re.compile(cast(str, ptrn)) for ptrn in args.exclude ]
    setup_all_symlinks(
        base,
        to,
        dry_run=args.dry_run,
        exclude=exclude,
        force=args.force,
    )
    if args.daemonize:
        from .daemonize import daemonize
        daemonize(base, to, dry_run=args.dry_run, force=args.force, exclude=exclude)

    return 0


if __name__ == "__main__":
    sys.exit(main())
