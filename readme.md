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

Replace interface with abstract class. GObject's implementation of interface results in a unpromotable recast error, likely due to type puning. This only really affects ICloneable.

https://www.cocoawithlove.com/2008/04/using-pointers-to-recast-in-c-is-bad.html :

"Most of the time, type punning won't cause any problems. It is considered undefined behavior by the C standard but will usually do the work you expect."
...
"To be clear, these bugs can only occur if you dereference both pointers (or otherwise access their shared data) within a single scope or function. Just creating a pointer should be safe." 

In this case it's not possible bugs but undefined behavior that is the issue, causing a crash in wasm.

