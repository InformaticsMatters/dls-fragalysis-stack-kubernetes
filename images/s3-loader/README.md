# Fragalysis S3 Data Loader Image
Build and push with: -

    $ docker build . -t informaticsmatters/fragalysis-s3-loader:latest \
        --build-arg from_image=informaticsmatters/fragalysis-loader \
        --build-arg from_tag=im-travis
    $ docker push informaticsmatters/fragalysis-s3-loader:latest