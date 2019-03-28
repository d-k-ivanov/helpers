FROM python:3.7-slim

# ENV DB_URL=
# ENV DB_NAME=
# ENV DB_USER=
# ENV DB_PASSWORD=
# ENV EMAIL_FROM=
# ENV EMAIL_TO=
# ENV EMAIL_SMTP_SERVER=
# ENV EMAIL_SMTP_PORT=
# ENV EMAIL_USER=
# ENV EMAIL_PASS=
# ENV EMAIL_ERROR=

COPY  [".", "/app/"]

WORKDIR  /app

RUN set +x                                          \
    && find . -type f -print -exec chmod 644 {} \;  \
    && find . -type d -print -exec chmod 755 {} \;  \
    && pip install .

ENTRYPOINT ["sql-reports"]
