
"""Create a Tabulae CEX table for a vector of nouns.
$(SIGNATURES)
"""
function cextable(nounslist::Vector{LSNoun}, ortho = "latcommon"; divider = "|")
    hdr = join(
        ["StemUrn", "LexicalEntity", "Stem", "Gender", "InflClass"], 
        divider)
        
    cexlines = tabulaecex.(nounslist; divider = divider) |> Iterators.flatten |> collect
    
    ortholines = filter(ln -> occursin(ortho, ln), cexlines)
    string(
        hdr,
        "\n",
        join(ortholines, "\n")
    )
end