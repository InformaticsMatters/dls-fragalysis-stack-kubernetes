#!/usr/bin/env bash

# Does the container look intact?
# We need numerous environment variables.

: "${AWS_ACCESS_KEY_ID?Need to set AWS_ACCESS_KEY_ID}"
: "${AWS_SECRET_ACCESS_KEY?Need to set AWS_SECRET_ACCESS_KEY}"
: "${BUCKET_NAME?Need to set BUCKET_NAME}"
: "${DATA_ORIGIN?Need to set DATA_ORIGIN}"

if [ ! -d "/code/media" ]; then
    echo "ERROR - the destination directory (/code/media) does not exist"
    exit 0
fi

# OK if we get here...
#
# We expect data to be available on S3 in the BUCKET_NAME provided in the
# 'django-data' sub-directory using the path specified in DATA_ORIGIN.
# The bucket data is copied to the mount point '/code/media',
# i.e. data in s3://${BUCKET_NAME)/django-data/${DATAT_ORIGIN}
# is written to '/code/media/NEW_DATA'.
#
# - Wipe the (temporary) destination directory
# - Copy new content
# - Run the loader
DST=/code/media/NEW_DATA
echo "+> Removing ${DST}"
rm -rf ${DST}
mkdir ${DST}
echo "+> Syncrhonising ${DATA_ORIGIN} to ${DST}..."
aws s3 sync "s3://${BUCKET_NAME}/django-data/${DATA_ORIGIN}" /code/media/NEW_DATA
echo "+> Running loader..."
./run_loader.sh
echo "+> Done."
