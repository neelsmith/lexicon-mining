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
#include("tranchereader.jl")


include("nouns.jl")
include("adjectives.jl")
include("verbs.jl")
include("prepositions.jl")
include("conjunctions.jl")
include("adverbs.jl")


include("generatecex/nounscex.jl")
include("generatecex/verbscex.jl")
include("generatecex/cextables.jl")

include("tabulae.jl")

export datatuples, lexicaldata
export summarydirs, readdata
export LSNoun, nouns
export LSVerb, verbs
export LSAdjective, adjectives
export LSPreposition, prepositions # These are OK
export LSConjunction, conjunctions # These are OK
export LSAdverb, adverbs


export cexline
export cextable
export tabulae

end # module
