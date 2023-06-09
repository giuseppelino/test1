# Build the API
FROM mcr.microsoft.com/dotnet/nightly/sdk AS api-build
ARG COMMIT_SHA
ENV COMMIT_SHA=${COMMIT_SHA:-v1.0.0}
WORKDIR /src
COPY /api .
RUN dotnet publish \
    --version-suffix $COMMIT_SHA \
    -r linux-musl-x64 --self-contained true -p:PublishSingleFile=true \
    -c Release -o /publish

# Build the static web site
FROM node:lts AS web-build
WORKDIR /src
COPY /web .
RUN npm install -g react-scripts && npm install
RUN BUILD_PATH='/wwwroot' \
    REACT_APP_VERSION=$(npm -s run env echo '$npm_package_version') \
    react-scripts build

# Combine both into the final container
FROM mcr.microsoft.com/dotnet/nightly/runtime-deps:7.0-alpine AS runtime
ENV \
    # Use the default port for Cloud Run
    ASPNETCORE_URLS=http://+:8080
WORKDIR /app
COPY --from=api-build /publish .
COPY --from=web-build /wwwroot ./wwwroot/

ENTRYPOINT ["./EventsSample"]
