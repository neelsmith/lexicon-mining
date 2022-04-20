# Read src.cex, and format mainentries.cex
# for Lewis-Short data in this repository
#
# Run from root of repository:
f = joinpath(pwd(), "cex", "lewis-short", "src.cex")
target = joinpath(pwd(),"cex", "lewis-short", "mainentries.cex")

repo = pwd()
using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()


using LexiconMining
mainentries = formatentries(f)
open(target, "w") do io
    write(io, join(mainentries,"\n"))
end