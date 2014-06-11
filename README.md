access-private-class-in-liba
=============================

This is sample code that to access private class in static library.
The static library is like a file libxxx.a which archived by ar command.

Ordinary, private classes in the static library can't be accessed
from a program linking the library,
because valac doesn't export these classes informations to vapi file.

In this sample code, show how to export private classes informations,
how to use and link these, and finally make as one executable program.

This code is licensed under GPL2.

Copyright(c) Yusuke Ishida.

