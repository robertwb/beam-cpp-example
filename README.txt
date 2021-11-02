This is an example of using custom containers with C++ libraries in a
Beam Python pipeline.  This example uses some functions from the gmp
library with cython bindings, though the principles should be the same
no matter the library or binding tool of choice.

After installing the requirements

  apt-get install libgmp3
  pip install -r requirements.txt

the Python bindings can be built by running

  python setup.py build_ext --inplace

One can then run the pipeline locally via

  python pipeline.py

which will produce an image out.png.


To run this in a distributed environment, we package the code and dependencies
into a docker container. This can be created via

  docker build . -t cpp_beam_container

Which can be tested locally with

  python pipeline.py --runner=PortableRunner --job_endpoint=embed --environment_type=DOCKER --environment_config="docker.io/library/cpp_beam_container"

Note that with this run the output will be written inside the docker image; pass --output=gs://... to be able to view it.

To run on Dataflow, the docker image must be pushed somewhere accessible, e.g.

  docker tag cpp_beam_container gcr.io/[your project]/cpp_beam_container
  docker push gcr.io/[your project]/cpp_beam_container

And run with

  export GCS_PATH="gs://my-gcs-bucket"
  export GCS_PROJECT="my project"
  python pipeline.py                 \
      --runner=DataflowRunner        \
      --project=$GCS_PROJECT         \
      --region=us-central1           \
      --temp_location=$GCS_PATH/tmp  \
      --sdk_container_image="gcr.io/$GCS_PROJECT/cpp_beam_container"  \
      --experiment=use_runner_v2     \
      --output=$GCS_PATH/out.png


See also docs at https://beam.apache.org/documentation/runtime/environments/

