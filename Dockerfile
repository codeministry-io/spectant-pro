# The site is built in CI (bun run verify); the image only ships the static output.
# The official image moved from nginxinc/ to nginx/ with 1.31.7; nginxinc/ gets no new releases.
FROM nginx/nginx-unprivileged:1.31.10-alpine@sha256:86628f2c9eaa5e84e3b98d25e26563c4a4f9b0ead9cf5656da4731d86e0621de
# CVE-2026-86144: the 1.31.9 image still ships libxml2 2.13.9-r2, Alpine 3.24 has the fix in r3.
# Drop these three lines once the base image already contains it.
USER root
RUN apk upgrade --no-cache libxml2
USER 101
COPY dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
# /version.txt names this build as <package version>+<commit>. The deploy screenshots
# (codeministry-io/.github, cm-k8s-cluster spec 017) wait until it shows the new commit.
ARG APP_VERSION=0.0.0
ARG GIT_SHA=unknown
USER root
RUN printf '%s+%s\n' "$APP_VERSION" "$GIT_SHA" > /usr/share/nginx/html/version.txt
USER 101

EXPOSE 8080
