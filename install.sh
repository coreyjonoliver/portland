#!/bin/sh

# This script installs the Portland on your system by
# downloading a binary distribution and running its installer script
# (which in turn creates and populates /nix).

{ # Prevent execution if this script was only partially downloaded

unpack=$(mktemp -d 2>/dev/null || mktemp -d -t 'portland-binary-tarball-unpack')
trap 'rm -rf $unpack' EXIT

require_util() {
    type "$1" > /dev/null 2>&1 || which "$1" > /dev/null 2>&1 ||
        oops "\`$1' is not available on the system, which is required to $2"
}

oops() {
    echo "$0: $@" >&2
    exit 1
}

case "$(uname -s).$(uname -m)" in
    Linux.x86_64) system=linux-amd64;;
    Linux.i386) system=linux-386;;
    Linux.armv6l) platform=linux-arm;;
    Linux.armv7l) platform=linux-arm;;
    FreeBSD.amd64) platform=freebsd-amd64;;
    FreeBSD.i386) platform=freebsd-386;;
    FreeBSD.arm) platform=freebsd-arm;;
    Darwin.x86_64) system=darwin-amd64;;
    Darwin.i386) system=darwin-386;;
    *) oops "sorry, there is no binary distribution of Portland for your platform";;
esac

url="https://dl.bintray.com/coreyoliver/portland/portland-0.2.0-$system.tar.bz2"

require_util curl "download the binary tarball"
require_util tar "unpack the binary tarball"
require_util bash "run the installation script from the binary tarball"

echo "unpacking Portland binary tarball for $system from \`$url'..."
curl -L "$url" | tar xz -C "$unpack" || oops "failed to unpack \`$url'"


if [ -d "$HOME/bin" ]; then
    if echo ":$PATH:" | grep -q ":~/bin:" || echo ":$PATH:" | grep -q ":$HOME/bin:"; then
        target="$HOME/bin/$bin_name"
    fi
elif [ -d "/usr/local/bin" ]; then
    if echo ":$PATH:" | grep -q ":/usr/local/bin:"; then
        target="/usr/local/bin/$bin_name"
        if [ ! -w /usr/local/bin ]; then
            sudo=sudo
            echo "Warning: you may be asked for administrator password to save the file in /usr/local/bin directory"
        fi
    fi
fi

if [ -z "$target" ]; then
    target="$PWD/$bin_name"
    echo "Warning: couldn't find ~/bin or /usr/local/bin in your \$PATH"
fi

echo "Installing to $target..."
if $sudo cp "$unpack/portland" $target; then
    $sudo chmod a+x $target
    echo "Success."
else
    echo "Error: couldn't copy $bin_name to $target"
fi

} # End of wrapping