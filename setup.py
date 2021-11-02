from setuptools import setup
from setuptools import Extension
from Cython.Build import cythonize

setup(
    name='beam-collatz',
    ext_modules=cythonize([
        Extension(
            '*',
            ['collatz.pyx'],
            libraries=['gmp', 'gmpxx'],
            language='c++',
        )
    ]),
)
