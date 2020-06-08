#!/usr/bin/env bash

# Does the container look intact?
# We need numerous environment variables.

: "${DATA_ORIGIN?Need to set DATA_ORIGIN}"

SRC=/mounted-media

if [ ! -d "/code/media" ]; then
    echo "ERROR - the destination directory (/code/media) does not exist"
    exit 0
fi
if [ ! -d "$SRC" ]; then
    echo "ERROR - the source directory ($SRC) does not exist"
    exit 0
fi

# OK if we get here...
#
# We expect data to be available in /mounted-media
# using the sub-path specified in DATA_ORIGIN.
# We copy data to the mount point '/code/media',
# i.e. data in '/mounted-media/${DATA_ORIGIN}'
# is written to '/code/media/NEW_DATA'.
#
# - Wipe the (temporary) destination directory
# - Copy new content
# - Run the loader
DST=/code/media/NEW_DATA
echo "+> Removing ${DST}"
rm -rf ${DST}
mkdir ${DST}
echo "+> Copying ${SRC}/${DATA_ORIGIN} to ${DST}..."
cp -R "${SRC}/${DATA_ORIGIN}/"* /code/media/NEW_DATA
echo "+> Running loader..."
./run_loader.sh
echo "+> Done."
