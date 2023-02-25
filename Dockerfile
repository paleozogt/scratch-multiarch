FROM busybox as upstream
RUN mkdir /empty

FROM scratch

# the image needs *something*, even if its just an empty dir
COPY --from=upstream /empty /tmp
