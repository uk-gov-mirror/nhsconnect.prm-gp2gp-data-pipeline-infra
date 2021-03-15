from setuptools import find_packages, setup

setup(
    name="wordcount",
    version="1.0.0",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    install_requires=[
        "boto3~=1.14",
    ],
)