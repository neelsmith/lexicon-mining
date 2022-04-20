module LexiconMining
using EzXML
using SplitApplyCombine
using PolytonicGreek

using Documenter
using DocStringExtensions


include("src.jl")
include("morphology.jl")

export formatentries
export typelist
export pos_itype_counts

export survey

end # module
