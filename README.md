# docker-build-pve

**This repository is not maintained as I don't use Proxmox VE anymore.**

Dockerfile and helper scripts to build most of the Proxmox VE packages and upload the built packages to S3. Some are downloaded from the Proxmox VE repository, however. It should be able to build the packages for both AMD64 and ARM64.

Note that there are probably a number of issues at this point. Specifically with building the kernel on ARM64.

## S3 configuration

Place your configuration in `s3/config` and your credentials in `s3/credentials`. 

For reference, see: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html.

## Usage

Build:

```
./build.sh
```

Debug:

```
./debug.sh
```

## Notes

There are some hacks in the Dockerfile to make it build on Docker on macOS. They are probably not needed on other platforms or when not building the packages using Docker.
