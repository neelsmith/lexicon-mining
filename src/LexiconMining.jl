module LexiconMining
using EzXML
using SplitApplyCombine
using PolytonicGreek

using Documenter
using DocStringExtensions


include("src.jl")

export formatentries
export typelist
export pos_itype_counts

end # module
