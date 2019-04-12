require "formula"

# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Dump1090Mutability < Formula
  homepage "https://github.com/mutability/dump1090"
  head 'git://github.com/mutability/dump1090.git'

  env :std

  depends_on "librtlsdr"
  depends_on "libusb"

  # depends_on "cmake" => :build
  #depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # Compile
    system "make"

    # Create a hacky shell script to cd into the working dir, then pass any dump1090 params
    system "echo \"cd #{prefix} && ./dump1090 \\$@\" > #{prefix}/dump1090-mutability"
    system "chmod +x #{prefix}/dump1090-mutability"

    # Manually install
    system "install -m 755 dump1090 #{prefix}"
    system "cp -r public_html #{prefix}"

    # Manually create the symlink
    # system "ln -fs #{prefix}/dump1090-mutability /usr/local/bin/dump1090-mutability"
    bin.install ["#{prefix}/dump1090-mutability"]

  end
end
