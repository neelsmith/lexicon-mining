
```@setup building
repo = pwd() |> dirname |> dirname
```


# Organizing and extracting source data


## Formatting a data source

- use `formatentries` to read the source XML, and build a 3-column structure with a unique ID, a labelling lemma, and the full XML text of the entry.


## Extracting  morphological data

- use `extractmorph` to read a file of 3-column data and extract a set of morphological features with:

    - id
    - label
    - lemma
    - pos
    - itype
    - gen
    - mood


## Working with morphological data

The morphological data extracted by `extractmorph` can be read into an object model by applying the `morphData` function to each entry.

## Worked example


The `cex/lewis-short` directory has a three-column file named `mainentries.cex`.

```@example building
sourcefile = joinpath(repo, "cex", "lewis-short", "mainentries.cex")
```

Chain `extractmorph` and `morphData` to create a Vector of `MorphData` objects.

```@example building
using LexiconMining
extractmorph(sourcefile) .|> morphData
```