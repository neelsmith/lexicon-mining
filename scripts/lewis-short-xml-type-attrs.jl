# Read src.cex, and find unique list of type attributes
# for Lewis-Short entries.
#
# Run from root of repository:
f = joinpath(pwd(), "cex", "lewis-short", "mainentries.cex")
target = joinpath(pwd(), "cex", "lewis-short", "entrytypes.txt")

repo = pwd()
using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()
using LexiconMining

types = typelist(f)
open(target, "w") do io
    write(io, join(types,"\n"))
end
