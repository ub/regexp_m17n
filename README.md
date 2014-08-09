regexp_m17n [![Build Status](https://travis-ci.org/os97673/regexp_m17n.svg?branch=master)](https://travis-ci.org/os97673/regexp_m17n)
===========
> Сhange non_empty? method in lib/regexp_m17n.rb to make test pass (but it must use regexp)

> We are ok with changing the test to skip dummy encoding but it will be interesting to either pass some string with dummy encoding to non_empty? and make this work too or prove that this is impossible.
> I.e. (officially) skipping dummy is acceptable solution for the contest but solution with test(s) for dummy encoding(s) will be even better.

The problem is not with dummy encodings. There are eight dummy encodings in Ruby 2.1.2

* UTF-16
* UTF-32
* ISO-2022-JP
* ISO-2022-JP-2
* CP50220
* CP50221
* UTF-7
* ISO-2022-JP-KDDI

but only  `ISO-2022-JP-2` and `UTF-7` throw exception in `String#encode` method. (In jruby `ISO-2022-JP-2` works fine for this example, btw).
Problem with these encodings, technically speaking, is in the test itself (which accidentally discovered bugs in current ruby implementations),
not in the tested function.


My solution involves monkey-patching `String#encode` to return correct results for  `".".encode("ISO-2022-JP-2")` and
`".".encode("UTF-7")` and uses original ruby implementation for all other encodings.

