# jsonnet
A repo for my "generic" Jsonnet code, in particular a TSV parser, and "big int" support.

WARNING: This is currently a v0.1 *prototype*. Don't use this for anything, unless you want to fix the
bugs yourself!

The idea is to load up a TSV file in Jsonnet, parse the strings, and turn it into an array of objects.
But I also wanted to support "big integers" (signed/unsigned 64-bit ints), enums, and maps/dicts and
there is currently no support for those in the standard Jsonnet library, so I started working on them
as well.

The main downside of saving the data in a TSV file, is that it's pure data; I cannot currently
"generate" data using expressions, like in Jsonnet. Eventually, I'll solve that too.

The "motivation" for the TSV parser is that my "users" will be just that, "users",
not techies, so that I cannot expect them to be able to edit Jsonnet, JSON or XML.
Editing a TSV file as a spreadsheet, is about as much as I can expect from them.

Currently, the following modules have working "unit tests", but some features are missing:
(I decided to stick to the 3-letters module name convention of "std".)

utl: The "utility" module
log: The "logging" module. I try to collect all info/warn/errors and give them ALL at the END.
int: The "big integer" module. Note: No work was done on optimizing for speed.
spr: The "safe parser" module. "Safe" as in "does not crash with an error". Also supports TSV files.

spr needs a lot more testing.

Support of "enums" and "maps/dicts" is still missing to achieve v0.1 "feature completeness".

run:

jsonnet test.jsonnet

to check the functionality of the code.
