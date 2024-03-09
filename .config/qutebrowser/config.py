# type: ignore

# Load autoconfig.yml
config.load_autoconfig()

# Custom "hint-ables" for kotlinlang.org.
with config.pattern("*://kotlinlang.org/"):
    c.hints.selectors.update(
        {
            "toc": ["li[data-toc-scroll]"],  # Table of content sidebar items
            "scrollable": ["div.layout--scroll-container"],  # Focus on one of the scrollable divs.
        }
    )

import os
from urllib.request import urlopen

if not os.path.exists(config.configdir / "theme.py"):
    theme = "https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py"
    with urlopen(theme) as themehtml:
        with open(config.configdir / "theme.py", "a") as file:
            file.writelines(themehtml.read().decode("utf-8"))

if os.path.exists(config.configdir / "theme.py"):
    import theme
    theme.setup(c, 'latte', True)
