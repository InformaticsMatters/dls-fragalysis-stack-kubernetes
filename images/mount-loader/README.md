# Fragalysis Mounted Volume Data Loader Image
An extension of the `xchem/fragalysis-loader` image that first
copies files from a volume mounted at `/mounted-media` before calling
the loader's `run_loader.sh` script.

## Building
Build and push with: -

    $ docker build . -t informaticsmatters/fragalysis-mounted-loader:latest \
        --build-arg from_image=informaticsmatters/fragalysis-loader
    $ docker push informaticsmatters/fragalysis-mounted-loader:latest
