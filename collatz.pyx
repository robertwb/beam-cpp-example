# distutils: langauge = c++
# distutils: libraries = gmp gmpxx
# cython: language_level = 3

"""
Uses the gmp library to determine the collatz total stopping time of an integer.

Might be overkill to use gmp, but this is mostly for a demonstration of binding
C++ libraries into Beam.

After changing this file, run

  python setup.py build_ext --inplace

to rebuild.
"""


from libcpp.string cimport string

# These have not yet been ported to mpz_class.
cdef extern from "gmp.h":
  cdef struct mpz_t:
    pass

  cdef bint mpz_odd_p(mpz_t)

# Mostly use the C++ API.
cdef extern from "<gmpxx.h>":
  cdef cppclass mpz_class:
    # Declare some constructors.
    mpz_class()
    mpz_class(string s, int base)

    # Declare some of the arithmetic operators with ints.
    mpz_class operator+(int)
    mpz_class operator-(int)
    mpz_class operator*(int)
    mpz_class operator/(int)

    bint operator!=(int)
    bint operator==(int)

    # For use with mpz_odd_p.
    mpz_t get_mpz_t()


def total_stopping_time(py_n):
  """
  Returns the number of steps taken to get to 1 for the given input.
  """
  cdef int steps = 0
  # Use base-16 strings to convert arbitrarily large numbers.
  cdef mpz_class n = mpz_class(hex(py_n)[2:].encode('ascii'), 16)
  while n != 1:
    steps += 1
    if mpz_odd_p(n.get_mpz_t()):
      n = n * 3 + 1
    else:
      n = n / 2
  return steps
