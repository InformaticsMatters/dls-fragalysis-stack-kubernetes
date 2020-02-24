ARG from_image='xchem/fragalysis-loader'
ARG from_tag='latest'
FROM $from_image:$from_tag

COPY docker-entrypoint.sh ./
COPY loader-requirements.txt ./
RUN pip install -r loader-requirements.txt && \
    chmod -R 755 *.sh && \
    chmod -R 755 *.py

CMD ["./docker-entrypoint.sh"]
