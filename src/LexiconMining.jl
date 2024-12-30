module LexiconMining

import Base: show
import Base: ==

using EzXML
using SplitApplyCombine
using CitableBase


using Unicode

using Documenter
using DocStringExtensions


#include("morphology.jl")
#include("src.jl")

#include("tabulae/tabulae.jl")
#include("tabulae/nouns.jl")
#include("tabulae/nouns/decl1.jl")
#include("tabulae/nouns/decl2.jl")

#include("tabulae/verbs.jl")


#=
export formatentries
export typelist
export pos_itype_counts

export extractmorph

export MorphData, morphData

export tabulae
=#


include("suarez.jl")
include("nouns.jl")
export readdata
export LSNoun, nouns
export verbs


end # module
