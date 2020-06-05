# Fragalysis S3 Data Loader Image
An extension of the `xchem/fragalysis-loader` image that first
copies files form an S3 bucket before calling the loader's
`run_loader.sh` script.

## Building
Build and push with: -

    $ docker build . -t informaticsmatters/fragalysis-s3-loader:latest \
        --build-arg from_image=informaticsmatters/fragalysis-loader \
        --build-arg from_tag=im-travis
    $ docker push informaticsmatters/fragalysis-s3-loader:latest
