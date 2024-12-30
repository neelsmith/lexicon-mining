module LexiconMining

import Base: show
import Base: ==

using EzXML
using SplitApplyCombine
using CitableBase


using Unicode

using Documenter
using DocStringExtensions

include("suarez.jl")
include("nouns.jl")
include("adjectives.jl")
include("verbs.jl")

export readdata
export LSNoun, nouns
export LSVerb, verbs

export LSAdjective, adjectives


end # module
