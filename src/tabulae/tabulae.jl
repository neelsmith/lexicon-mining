

"""Write a morphological dataset for Tabulae in directory `dest`.
$(SIGNATURES)
"""
function tabulae(mdata::Vector{MorphData}, dest)
    tabulae_nouns(mdata, dest)
    tabulae_verbs(mdata, dest)
    # verbs
    # adjectives
end

function tabulae(f, dest)
    tabulae(readlines(f) .|> morphData, dest)
end


const NOUN_HEADER = "StemUrn|LexicalEntity|Stem|Gender|InflClass"

const VERB_HEADER = "StemUrn|LexicalEntity|StemString|MorphologicalClass"