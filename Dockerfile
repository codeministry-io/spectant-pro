# The site is built in CI (bun run verify); the image only ships the static output.
# The official image moved from nginxinc/ to nginx/ with 1.31.7; nginxinc/ gets no new releases.
FROM nginx/nginx-unprivileged:1.31.9-alpine@sha256:60214a103e6f38e953ff957f34b1f2e97a9db801ab2df3821da955d0fe6cadd6
# CVE-2026-86144: the 1.31.9 image still ships libxml2 2.13.9-r2, Alpine 3.24 has the fix in r3.
# Drop these three lines once the base image already contains it.
USER root
RUN apk upgrade --no-cache libxml2
USER 101
COPY dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
