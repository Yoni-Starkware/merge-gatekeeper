# The action's runtime image: a static Go binary on distroless, which ships CA certificates
# (the gatekeeper talks TLS to api.github.com) and nothing else.
#
# The binary is built OUTSIDE this Dockerfile, by .github/workflows/release-image.yaml with
# actions/setup-go, and copied in. No Go base image is pulled: the previous build pulled
# golang:alpine from public.ecr.aws on every run, and that registry's anonymous data limit
# (429) is exactly what this image exists to get away from. gcr.io/distroless has no such
# limit, and this pull happens once per release, not once per consumer run.
#
# Local build: CGO_ENABLED=0 go build -o merge-gatekeeper . && docker build -t merge-gatekeeper .
# Pinned by digest so a rebuild of the same tag gives the same bytes; bump deliberately.
FROM gcr.io/distroless/static-debian12:nonroot@sha256:afa5c872c891853ca7fcf1f12c3edb23f7eeef36189728842dd51042ff57f7ab

COPY merge-gatekeeper /merge-gatekeeper

ENTRYPOINT ["/merge-gatekeeper"]
