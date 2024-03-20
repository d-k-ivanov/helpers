FROM python:3.7-alpine

# ENV GIT_PROVIDER=bitbucket.org
# ENV GIT_USER=keepbot
# ENV GIT_REPO_NAME=py-git-cleaner
# ENV EMAIL_FROM=git-cleaner@example.com
# ENV EMAIL_SMTP_SERVER=smtp.example.com
# ENV EMAIL_SMTP_PORT=587
# ENV EMAIL_USER=git-cleaner@example.com
# ENV EMAIL_PASS=git-cleaner-password
# ENV EMAIL_ERROR=git-cleaner-error@example.com
# ENV OAUTH_CLIENT_ID=bitbucket-client-id
# ENV OAUTH_CLIENT_Secret=bitbucket-sercret-id
# ENV OAUTH_URI_ACCESS_TOKEN=https://bitbucket.org/site/oauth2/access_token
# ENV OAUTH_URI_AUTHORIZATION=https://bitbucket.org/site/oauth2/authorize

COPY  [".", "/app/"]

WORKDIR  /app

RUN set +x                                          \
    && apk add git                                  \
    && find . -type f -print -exec chmod 644 {} \;  \
    && find . -type d -print -exec chmod 755 {} \;  \
    && pip install .

ENTRYPOINT ["git-cleaner"]
