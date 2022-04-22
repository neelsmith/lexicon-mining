# About the data




## Sources

- Lewis-Short *Latin Dictionary*: https://www.perseus.tufts.edu/hopper/opensource/download
- Liddell-Scott-Jones *Greek Lexicon*: https://github.com/gcelano/LSJ_GreekUnicode


The files in the repository's `source-data` have extracted from these sources all the `entryFree` elements, and formatted them one-per line.  Each line is therefore a well-formed XML document.

## Modifications

### Lewis-Short

Macron and breve are represented by `_` and `^` following a vowel; all other HTML entities in the Perseus source have been converted to Unicode codepoints.
