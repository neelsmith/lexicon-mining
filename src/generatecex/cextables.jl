
"""Create a Tabulae CEX table for a vector of nouns.
$(SIGNATURES)
"""
function cextable(nouns::Vector{LSNoun}; divider = "|")
    cexlines = tabulaecex.(nouns; divider = divider)
    hdr = join(
        ["StemUrn", "LexicalEntity", "Stem", "Gender", "InflClass"], 
        divider)
    string(
        hdr,
        "\n",
        join(cexlines, "\n")
    )
end