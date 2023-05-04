# jsonnet
A repo for my "generic" Jsonnet code, in particular a TSV parser, and "int" support.

WARNING: This is currently a v0.1 *protoype*. Don't use this for anything, unless you want to fix the bugs yourself!

The TSV part is now working, and the "int" support ist almost done, except for a bug in "euclide" (div/mod).

The idea is to load up a TSV file in Jsonnet, and turn it into an array of objects.
But I want to support "big integers" (signed/unsigned 64-bit ints), and there is currently no support for
that in the standard Jsonnet library, so I started working on this as well.

The main downside of saving the data in a TSV file, is that it's pure data;
I currently cannot "generate" data using expressions, like in pure Jsonnet.

The "motivation" for the TSV parser is that my "users" will be just that, "users",
not coders, so that I cannot expect them to be able to edit Jsonnet, JSON or XML.
Editing a TSV file as a spreadsheet, is about as much as I can expect from them.

run:

jsonnet test.jsonnet

to check the functionality of the code.
