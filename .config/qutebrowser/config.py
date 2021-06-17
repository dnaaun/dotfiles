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


