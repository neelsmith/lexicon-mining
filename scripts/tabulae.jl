# Read morphdata and compose tabulae data set.
#
# Run from root of repository:
f = joinpath(pwd(), "cex", "lewis-short", "morphinfo.cex")
destdir = joinpath(pwd(),"datasets", "lewis-short")

repo = pwd()
using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()
using LexiconMining

mdata = readlines(f) .|> morphData
tabulae(mdata, destdir)