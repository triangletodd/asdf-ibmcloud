<div align="center">

# asdf-ibmcloud [![Build](https://github.com/triangletodd/asdf-ibmcloud/actions/workflows/build.yml/badge.svg)](https://github.com/triangletodd/asdf-ibmcloud/actions/workflows/build.yml) [![Lint](https://github.com/triangletodd/asdf-ibmcloud/actions/workflows/lint.yml/badge.svg)](https://github.com/triangletodd/asdf-ibmcloud/actions/workflows/lint.yml)


[IBM Cloud](https://www.ibm.com/cloud) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Work in Progress
 - [x] Fetch Versions `bin/list-all`
 - [x] Fetch Latest Version `bin/latest-stable`
 - [x] Download Script `bin/download`
 - [ ] Installer `bin/install`

# Dependencies

- `bash`, `curl`, `tar`, `tr`, `td`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add ibmcloud
# or
asdf plugin add ibmcloud https://github.com/triangletodd/asdf-ibmcloud.git
```

ibmcloud:

```shell
# Show all installable versions
asdf list-all ibmcloud

# Install specific version
asdf install ibmcloud latest

# Set a version globally (on your ~/.tool-versions file)
asdf global ibmcloud latest

# Now ibmcloud commands are available
ibmcloud version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/triangletodd/asdf-ibmcloud/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Todd Edwards](https://github.com/triangletodd/)

