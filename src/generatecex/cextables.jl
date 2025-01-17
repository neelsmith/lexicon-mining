
function cextable(nouns::Vector{LSNoun}; divider = "|")
    cexlines = tabulaecex.(nouns; divider = divider)
    string(
     "HEADER\n",
     join(cexlines, "\n")
    )
end