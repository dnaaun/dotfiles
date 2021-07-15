from setuptools import setup # type: ignore

setup(
    name="setupdotfiles",
    version="0.1",
    author="David Assefa Tofu",
    author_email="davidat@bu.edu",
    description="",
    license="Apache",
    packages=["setupdotfiles"],
    install_requires=[
        "typing-extensions>=3.7.4.2,<4",
        "python-daemon",
        "pyinotify"
    ],
    extras_require={
        "dev": [
            "pytest==6.0.1",
            "mypy==0.782",
            "black==19.10b0",
        ]
    },
    python_requires=">=3.6.0",
)
