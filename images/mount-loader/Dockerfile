ARG from_image='xchem/fragalysis-loader'
ARG from_tag='latest'
FROM $from_image:$from_tag

COPY docker-entrypoint.sh ./

CMD ["./docker-entrypoint.sh"]
