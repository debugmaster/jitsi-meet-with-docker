### **Status:** Under development 🚧

This project aims to help you customize and deploy environments with Jitsi Meet components.

It has **only one requirement**: to have Docker installed; in case you don't know what Docker is, I recommend you to learn about it before digging into the code. You may also need to learn about Saltstack; this is one in charge of handling and delivering configurations to Docker containers.

### How to use it?

There is a file named `project.env` in the main folder of this project. This file contains several environment variables that are used while building and running Jitsi components or Prosody. Some of these configurations are repetitive and present in most of the builds, so let us go through them.

If you are not familiar with the `: ${variable:=value}`, it sets the `variable` to `value` if `variable` is not yet set or empty (null). You can read about parameter expansion [here](https://www.gnu.org/software/bash/manual/html\_node/Shell-Parameter-Expansion.html).

**RUN\_PROJECT**: If this is set to `true` to a project, it means that this project will run when `run.sh` is invoked. Notice that some components may not behave well if other components are not running. For example, Jicofo and Jitsi Videobridge needs at least one instance of Prosody to work.

**BUILD\_PROJECT\_IMAGE**: If this is set to `true` to a project, it means that this project's Docker image will be built locally. If it is set to anything else and RUN\_PROJECT is set to `true`, it will try to fetch the image from Docker Hub.

**BUILD\_PROJECT\_FROM\_SCRATCH**: By default, an image installs packages from [Ubuntu's Advanced Packaging Tool](https://help.ubuntu.com/lts/serverguide/apt.html), which is also known as `apt`. If this is set to `true` to a project, it means that this project's Docker image will be created by installing its dependencies and building the package from scratch. It has no effect if CREATE\_PROJECT\_IMAGE is not set to `true`.

The following configurations are used only if the last two configurations are `true`.

**PROJECT\_REPOSITORY**: This is the remote URL of the repository to be downloaded and built. It works with GIT versioning and can be cloned with HTTPS or SSH. At the moment, it handles only public repositories.

**PROJECT\_RELEASE**: This is the branch or tag of the project's repository that will be used while building the project.

**PROJECT\_RELEASE\_VERSION**: This is an identifier that will be attached to the build. It can be the same as PROJECTRELEASE although it is desirable to be or start with a number.
