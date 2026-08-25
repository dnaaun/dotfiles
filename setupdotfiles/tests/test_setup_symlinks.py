import tempfile
import unittest
from pathlib import Path

from setupdotfiles.setup_symlinks import setup_symlink


class SetupSymlinkTests(unittest.TestCase):
    def test_copies_codex_skills(self) -> None:
        with tempfile.TemporaryDirectory() as base_dir, tempfile.TemporaryDirectory() as home_dir:
            base = Path(base_dir)
            home = Path(home_dir)
            relative_path = Path(".codex/skills/example/SKILL.md")
            source = base / relative_path
            source.parent.mkdir(parents=True)
            source.write_text("skill contents")

            result = setup_symlink(base, relative_path, home, False, False, False)

            destination = home / relative_path
            self.assertEqual(result, destination)
            self.assertFalse(destination.is_symlink())
            self.assertEqual(destination.read_text(), "skill contents")

    def test_symlinks_other_dotfiles(self) -> None:
        with tempfile.TemporaryDirectory() as base_dir, tempfile.TemporaryDirectory() as home_dir:
            base = Path(base_dir)
            home = Path(home_dir)
            relative_path = Path(".config/example/config")
            source = base / relative_path
            source.parent.mkdir(parents=True)
            source.write_text("config contents")

            setup_symlink(base, relative_path, home, False, False, False)

            destination = home / relative_path
            self.assertTrue(destination.is_symlink())
            self.assertEqual(destination.resolve(), source.resolve())

    def test_replaces_existing_codex_skill_symlink_without_force(self) -> None:
        with tempfile.TemporaryDirectory() as base_dir, tempfile.TemporaryDirectory() as home_dir:
            base = Path(base_dir)
            home = Path(home_dir)
            relative_path = Path(".codex/skills/example/SKILL.md")
            source = base / relative_path
            source.parent.mkdir(parents=True)
            source.write_text("skill contents")
            destination = home / relative_path
            destination.parent.mkdir(parents=True)
            destination.symlink_to(source)

            setup_symlink(base, relative_path, home, False, False, False)

            self.assertFalse(destination.is_symlink())
            self.assertEqual(destination.read_text(), "skill contents")


if __name__ == "__main__":
    unittest.main()
