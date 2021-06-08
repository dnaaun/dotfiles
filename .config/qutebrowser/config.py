# type: ignore

# Load autoconfig.yml
config.load_autoconfig()

# Hint table of contnent links on Kotlin's docs
with config.pattern('*://kotlinlang.org/'):
    c.hints.selectors['toc'] = [ 'li[data-toc-scroll]']
