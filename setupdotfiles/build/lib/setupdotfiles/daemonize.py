import os
from pathlib import Path
import re
import subprocess
import time
from typing import List, Union
from typing_extensions import Protocol

from watchdog.events import (
    DirCreatedEvent,
    DirDeletedEvent,
    DirMovedEvent,
    FileCreatedEvent,
    FileDeletedEvent,
    FileMovedEvent,
    RegexMatchingEventHandler,
)
from watchdog.observers import Observer

from .setup_symlinks import setup_symlink


class EventProtocol(Protocol):
    pathname: str


def Notification(body: str, title: str) -> None:
    """
    It's capitalized to keep the same interface as
    notify.Notification
    """
    print(f"{title}: {body}")
    subprocess.Popen(["notify-send", title, body])


class EventHandler(RegexMatchingEventHandler):
    def __init__(
        self,
        base: Path,
        to: Path,
        dry_run: bool,
        force: bool,
        verbose: bool,
        exclude: List[re.Pattern],
        desktop_notify: bool,
    ):
        self._base = base
        self._to = to
        self._dry_run = dry_run
        self._force = force
        self._verbose = verbose
        self._exclude = exclude
        self._desktop_notify = desktop_notify
        super().__init__(
            ignore_regexes=list(map(str, exclude)),
            ignore_directories=False,
            case_sensitive=False,
        )

    def on_moved(self, event: Union[FileMovedEvent, DirMovedEvent]):
        """Called when a file or a directory is moved or renamed.

        :param event:
            Event representing file/directory movement.
        :type event:
            :class:`DirMovedEvent` or :class:`FileMovedEvent`
        """
        if isinstance(event, DirMovedEvent):
            return

        if (path := Path(event.dest_path).resolve()).is_relative_to(self._to):
            self._handle_delete_file(path)

    def on_created(self, event: Union[DirCreatedEvent, FileCreatedEvent]):
        """Called when a file or directory is created.

        :param event:
            Event representing file/directory creation.
        :type event:
            :class:`DirCreatedEvent` or :class:`FileCreatedEvent`
        """
        if isinstance(event, DirCreatedEvent):
            return

        self._handle_new_file(Path(event.src_path))

    def on_deleted(self, event: Union[DirDeletedEvent, FileDeletedEvent]):
        """Called when a file or directory is deleted.

        :param event:
            Event representing file/directory deletion.
        :type event:
            :class:`DirDeletedEvent` or :class:`FileDeletedEvent`
        """
        if isinstance(event, DirDeletedEvent):
            return
        self._handle_delete_file(Path(event.src_path).resolve())

    def _is_excluded(self, path: Path) -> bool:
        return any(ptrn.match(str(path)) for ptrn in self._exclude)

    def _handle_delete_file(self, path: Path) -> None:
        to_resolved = self._to / path.relative_to(self._base)
        if (
            self._is_excluded(path)
            or to_resolved.is_dir()
            or not to_resolved.is_symlink()
        ):
            return
        if self._dry_run:
            print(f"DELETE {to_resolved}")
        else:
            os.unlink(to_resolved)

        if self._desktop_notify:
            Notification(f"Deleted {to_resolved}", "Dotfiles watcher")

    def _handle_new_file(self, path: Path) -> None:
        if self._is_excluded(path) or path.is_dir():
            return
        from_ = path.relative_to(self._base)
        to_resolved = setup_symlink(
            self._base,
            from_=from_,
            to=self._to,
            dry_run=self._dry_run,
            force=self._force,
            verbose=self._verbose,
        )
        if to_resolved and self._desktop_notify:
            Notification(f"Setup {to_resolved}", "Dotfiles watcher")


def daemonize(
    base: Path,
    to: Path,
    dry_run: bool,
    force: bool,
    exclude: List[re.Pattern],
    verbose: bool,
    desktop_notify: bool,
) -> None:
    _daemonize(base, to, dry_run, force, exclude, verbose, desktop_notify)
    # with daemon.DaemonContext(pidfile="/tmp/setupdotfiles.pid", detach_process=False):


def _daemonize(
    base: Path,
    to: Path,
    dry_run: bool,
    force: bool,
    exclude: List[re.Pattern],
    verbose: bool,
    desktop_notify: bool,
) -> None:

    observer = Observer()
    event_handler = EventHandler(
        base=base,
        to=to,
        dry_run=dry_run,
        force=force,
        verbose=verbose,
        exclude=exclude,
        desktop_notify=desktop_notify,
    )
    observer.schedule(event_handler, str(base), recursive=True)
    observer.start()

    try:
        while True:
            time.sleep(1)
    finally:
        observer.stop()
        observer.join()


if __name__ == "__main__":
    daemonize(
        base=Path("/Users/elemental/git/dotfiles"),
        to=Path("/Users/elemental"),
        dry_run=False,
        exclude=[
            re.compile(pat)
            for pat in [
                r".*\.gitmodules",
                r".*\.git/.*",
                r".*README\.md",
                r".*index.lock",
                r".*setupdotfiles.*",
                r".*\.Session\.vim",
                r".*submodules.*",
                r".*\.mypy_cache/.*",
                r".*__pycache__/.*",
                r".*.tmuxp.yaml",
                # Saving in neovim creates these temporary files
                r".*[0-9]{3,}",
                r".*~" r".*\.st",  # axel temporary file
            ]
        ],
        force=False,
        verbose=True,
        desktop_notify=False,
    )
