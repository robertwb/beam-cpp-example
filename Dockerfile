FROM apache/beam_python3.8_sdk:2.34.0

# Install a C++ library.
RUN apt-get update
RUN apt-get install -y libgmp3-dev

# Install Python dependencies.
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Install the code and some python bindings.
COPY pipeline.py pipeline.py
COPY collatz.pyx collatz.pyx
COPY setup.py setup.py
RUN python setup.py install
