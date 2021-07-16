import os
import daemon
import subprocess
from typing import List
from typing_extensions import Protocol
import pyinotify
from pathlib import Path
import re

from .setup_symlinks import setup_symlink


class EventProtocol(Protocol):
    pathname: str

def Notification(body: str, title: str) -> None:
    """
    It's capitalized to keep the same interface as
    notify.Notification
    """
    subprocess.Popen(['notify-send', title, body])

class EventHandler(pyinotify.ProcessEvent):
    def my_init(self, base: Path, to: Path, dry_run: bool, force: bool):
        self._base = base
        self._to = to
        self._dry_run = dry_run
        self._force = force

    def process_IN_DELETE(self, event: EventProtocol) -> None:
        self._handle_delete_file(event)

    def process_IN_MOVE_FROM(self, event: EventProtocol) -> None:
        self._handle_delete_file(event)

    def process_IN_CREATE(self, event: EventProtocol) -> None:
        self._handle_new_file(event)

    def process_IN_MOVE_TO(self, event: EventProtocol) -> None:
        self._handle_new_file(event)

    def _handle_delete_file(self, event: EventProtocol) -> None:
        path = Path(event.pathname)
        
        to_resolved = self._to / path.relative_to(self._base)
        if path.is_dir() or not path.exists():
            return
        if self._dry_run:
            print(f"DELETE {to_resolved}")
        else:
            os.unlink(to_resolved)
        Notification(f"Deleted {to_resolved}", "Dotfiles watcher")

    def _handle_new_file(self, event: EventProtocol) -> None:
        path = Path(event.pathname)
        if path.is_dir():
            return
        from_ = path.relative_to(self._base)
        to_resolved = setup_symlink(
            self._base,
            from_=from_,
            to=self._to,
            dry_run=self._dry_run,
            force=self._force,
        )
        if to_resolved:
            Notification(f"Setup {to_resolved}", "Dotfiles watcher")
        else:
            Notification(f"Failed to setup {to_resolved}.", "Dotfiles watcher")

def daemonize(
    base: Path, to: Path, dry_run: bool, force: bool, exclude: List[re.Pattern]
) -> None:
    _daemonize(base, to, dry_run, force, exclude)
    # with daemon.DaemonContext(pidfile="/tmp/setupdotfiles.pid", detach_process=False):

def _daemonize(
    base: Path, to: Path, dry_run: bool, force: bool, exclude: List[re.Pattern]
) -> None:

    mask = (
        pyinotify.IN_CREATE  # type: ignore
        | pyinotify.IN_DELETE  # type: ignore
        | pyinotify.IN_MOVED_FROM  # type: ignore
        | pyinotify.IN_MOVED_TO  # type: ignore
    )

    event_handler = EventHandler(base=base, to=to, dry_run=dry_run, force=force)
    wm = pyinotify.WatchManager()

    def exclude_func(path: str):
        return any(ptrn.search(path) for ptrn in exclude)

    wm.add_watch([str(base)], mask, rec=True, exclude_filter=exclude_func)
    notifier = pyinotify.Notifier(wm, event_handler)
    notifier.loop()
