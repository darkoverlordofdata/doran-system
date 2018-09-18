# system

Vala really needs a robust framework. GLib is ok, but... it should be written in vala.
Gee is a step in the right direction.  I don't have time to write the whole fx, so 
I've ported some chunks of opensource dotnet and open jdk, along with some of Jurg's 
original Gee. It's a mish-mosh of licensing - GPL, BSD, MIT, and Apache:

    types       - java.lang
    io          - java.io
    json        - org.json
    collections - gee 
    core & xna  - dotnet

## todo

For emscripten:

replace System.IO.WinNTFileSystem with System.IO.PosixFileSystem

add conditional compile flags for filesystem, and clock choice (SDL|native)