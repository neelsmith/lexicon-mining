var documenterSearchIndex = {"docs":
[{"location":"api/#API-documentation","page":"Code APIs","title":"API documentation","text":"","category":"section"},{"location":"api/#Organizing-and-formatting-data","page":"Code APIs","title":"Organizing and formatting data","text":"","category":"section"},{"location":"api/","page":"Code APIs","title":"Code APIs","text":"formatentries\ntypelist\npos_itype_counts","category":"page"},{"location":"api/#LexiconMining.formatentries","page":"Code APIs","title":"LexiconMining.formatentries","text":"Read source file f and format content for mainentries.cex\n\nformatentries(f)\n\n\n\n\n\n\n","category":"function"},{"location":"api/#LexiconMining.typelist","page":"Code APIs","title":"LexiconMining.typelist","text":"Read source file f and determine list of unique values for @type attribute on entries.\n\ntypelist(f)\n\n\n\n\n\n\nDetermine list of unique values for @type attribute on entries in lns, a Vector of source data lines.\n\ntypelist(lns, reader)\n\n\n\n\n\n\n","category":"function"},{"location":"api/#LexiconMining.pos_itype_counts","page":"Code APIs","title":"LexiconMining.pos_itype_counts","text":"Compute occurrences of pos*itype in lns, a Vector of morphological data lines.\n\npos_itype_counts(lns, reader)\n\n\n\n\n\n\n","category":"function"},{"location":"api/#Working-with-extracted-morphological-data","page":"Code APIs","title":"Working with extracted morphological data","text":"","category":"section"},{"location":"api/","page":"Code APIs","title":"Code APIs","text":"MorphData\nmorphData","category":"page"},{"location":"buildingsrc/","page":"Building source files","title":"Building source files","text":"repo = pwd() |> dirname |> dirname","category":"page"},{"location":"buildingsrc/#Organizing-and-extracting-source-data","page":"Building source files","title":"Organizing and extracting source data","text":"","category":"section"},{"location":"buildingsrc/#Formatting-a-data-source","page":"Building source files","title":"Formatting a data source","text":"","category":"section"},{"location":"buildingsrc/","page":"Building source files","title":"Building source files","text":"use formatentries to read the source XML, and build a 3-column structure with a unique ID, a labelling lemma, and the full XML text of the entry.","category":"page"},{"location":"buildingsrc/#Extracting-morphological-data","page":"Building source files","title":"Extracting  morphological data","text":"","category":"section"},{"location":"buildingsrc/","page":"Building source files","title":"Building source files","text":"use extractmorph to read a file of 3-column data and extract a set of morphological features with:\nid\nlabel\nlemma\npos\nitype\ngen\nmood","category":"page"},{"location":"buildingsrc/#Working-with-morphological-data","page":"Building source files","title":"Working with morphological data","text":"","category":"section"},{"location":"buildingsrc/","page":"Building source files","title":"Building source files","text":"The morphological data extracted by extractmorph can be read into an object model by applying the morphData function to each entry.","category":"page"},{"location":"buildingsrc/#Worked-example","page":"Building source files","title":"Worked example","text":"","category":"section"},{"location":"buildingsrc/","page":"Building source files","title":"Building source files","text":"The cex/lewis-short directory has a three-column file named mainentries.cex.","category":"page"},{"location":"buildingsrc/","page":"Building source files","title":"Building source files","text":"sourcefile = joinpath(repo, \"cex\", \"lewis-short\", \"mainentries.cex\")","category":"page"},{"location":"buildingsrc/","page":"Building source files","title":"Building source files","text":"Chain extractmorph and morphData to create a Vector of MorphData objects.","category":"page"},{"location":"buildingsrc/","page":"Building source files","title":"Building source files","text":"using LexiconMining\nextractmorph(sourcefile) .|> morphData","category":"page"},{"location":"data/#About-the-data","page":"Data","title":"About the data","text":"","category":"section"},{"location":"data/#Sources","page":"Data","title":"Sources","text":"","category":"section"},{"location":"data/","page":"Data","title":"Data","text":"Lewis-Short Latin Dictionary: https://www.perseus.tufts.edu/hopper/opensource/download\nLiddell-Scott-Jones Greek Lexicon: https://github.com/gcelano/LSJ_GreekUnicode","category":"page"},{"location":"data/","page":"Data","title":"Data","text":"The files in the repository's source-data have extracted from these sources all the entryFree elements, and formatted them one-per line.  Each line is therefore a well-formed XML document.","category":"page"},{"location":"data/#Modifications","page":"Data","title":"Modifications","text":"","category":"section"},{"location":"data/#Lewis-Short","page":"Data","title":"Lewis-Short","text":"","category":"section"},{"location":"data/","page":"Data","title":"Data","text":"Macron and breve are represented by _ and ^ following a vowel; all other HTML entities in the Perseus source have been converted to Unicode codepoints.","category":"page"},{"location":"#Lexicon-mining","page":"Overview","title":"Lexicon mining","text":"","category":"section"},{"location":"","page":"Overview","title":"Overview","text":"Extract morphological data from Perseus XML editions of Lewis-Short and Liddell-Scott-Jones lexica; create delimited-text tables usable with Kanones.jl and Tabulae.jl.","category":"page"},{"location":"morphtables/#Extracting-morphological-data","page":"Extracting morphological data","title":"Extracting morphological data","text":"","category":"section"}]
}
