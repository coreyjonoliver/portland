# Portland [![Build Status](https://travis-ci.org/coreyjonoliver/portland.png)](https://travis-ci.org/coreyjonoliver/portland)

Portland is a tool for discovering unbound networking ports.

## Installation

If you are using Linux or Mac OS X, the easiest way to install Portland is to run the following command:

```
$ curl https://raw.githubusercontent.com/coreyjonoliver/portland/master/install.sh | sh
```

This will perform a installation of Portland into either `$HOME/bin` or `/usr/local/bin`. If `$HOME/bin` exists, it will be given priority over `/usr/local/bin`.

You can uninstall Portland simply by running:

```
$ rm $HOME/bin/portland
```

or

```
$ rm /usr/local/bin
```

depending on where it was originally installed.

## Quick Start

To view an available networking port simply run:

```
$ portland 127.0.0.1
```