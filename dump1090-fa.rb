require "formula"

# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Dump1090Fa < Formula
  homepage "https://github.com/flightaware/dump1090"
  head 'git://github.com/flightaware/dump1090.git'

  env :std

  depends_on "librtlsdr"
  depends_on "libusb"
  depends_on "libbladerf"

  # depends_on "cmake" => :build
  #depends_on :x11 # if your formula requires any X11/XQuartz components

  head do
    # FA fork of dump1090-mutability removes MacOS compatibility options from the Makefile. This restores them.
    patch do
      url "https://raw.githubusercontent.com/budrick/homebrew-dump1090/master/patches/dump1090-compat.patch"
      sha256 "ad9752f153ea47917d136cbbb9c4200f00b3b82d3be3d145f8400d25c99e001e"
    end
  end

  def install
    # Compile
    system "make BLADERF=no"

    # Create a hacky shell script to cd into the working dir, then pass any dump1090 params
    system "echo \"cd #{prefix} && ./dump1090 \\$@\" > #{prefix}/dump1090-fa"
    system "chmod +x #{prefix}/dump1090-fa"

    # Manually install
    system "install -m 755 dump1090 #{prefix}"
    system "cp -r public_html #{prefix}"

    # Manually create the symlink
    # system "ln -fs #{prefix}/dump1090.sh /usr/local/bin/dump1090-fa"
    bin.install ["#{prefix}/dump1090-fa"]
  end
end
