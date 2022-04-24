module LexiconMining
using EzXML
using SplitApplyCombine
using CitableBase

using Documenter
using DocStringExtensions


include("morphology.jl")
include("src.jl")

include("tabulae/tabulae.jl")
include("tabulae/nouns.jl")
include("tabulae/nouns/decl1.jl")
include("tabulae/nouns/decl2.jl")

export formatentries
export typelist
export pos_itype_counts

export extractmorph

export MorphData, morphData

export tabulae
# export kanones

end # module
