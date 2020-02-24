ARG from_image='xchem/fragalysis-loader'
ARG from_tag='latest'
FROM $from_image:$from_tag

COPY docker-entrypoint.sh ./
COPY loader-requirements.txt ./
RUN pip install -r loader-requirements.txt && \
    chmod 755 docker-entrypoint.sh

CMD ["./docker-entrypoint.sh"]
