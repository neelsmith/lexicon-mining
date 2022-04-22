

"""Write a morphological dataset for Tabulae in directory `dest`.
$(SIGNATURES)
"""
function tabulae(mdata::Vector{MorphData}, dest)
    tabulae_nouns(mdata, dest)
    # verbs
    # adjectives
end

const NOUN_HEADER = "StemUrn|LexicalEntity|Stem|Gender|InflClass"