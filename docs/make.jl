# Run this from repository root, e.g. with
# 
#    julia --project=docs/ docs/make.jl
#
# Run this from repository root to serve:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'julia -e 'using LiveServer; serve(dir="docs/build")' 
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Documenter, DocStringExtensions
using LexiconMining


makedocs(
    sitename="LexiconMining.jl",
    pages = [
        "User's guide" => Any[
            "Overview" => "index.md",
            "Data" => "data.md",
            "Building source files" => "buildingsrc.md",
            "Extracting morphological data" => "morphtables.md",
            
        ],
        "Code APIs" => Any[
            "Code APIs" => "api.md"
        ]
    ],
    )

deploydocs(
    repo = "github.com/neelsmith/LexiconMining.jl.git",
)
