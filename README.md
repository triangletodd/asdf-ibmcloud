<div align="center">

# asdf-ibmcloud [![Build](https://github.com/triangletodd/asdf-ibmcloud/actions/workflows/build.yml/badge.svg)](https://github.com/triangletodd/asdf-ibmcloud/actions/workflows/build.yml) [![Lint](https://github.com/triangletodd/asdf-ibmcloud/actions/workflows/lint.yml/badge.svg)](https://github.com/triangletodd/asdf-ibmcloud/actions/workflows/lint.yml)


[IBM Cloud](https://www.ibm.com/cloud) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Disclaimer](#disclaimer)
- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Disclaimer

This software is an independent, community-driven project and is not affiliated with, endorsed by, or maintained by IBM. IBM does not contribute to, sponsor, or support this project, and assumes no responsibility or liability for its use.

# Dependencies

- `bash`, `curl`, `tar`, `tr`, `td`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add ibmcloud
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

