# Read 3-column source, and compose a Tabulae data set.
#
# Run from root of repository:
f = joinpath(pwd(), "source-data", "lewis-short", "src.cex")
destdir = joinpath(pwd(),"datasets", "lewis-short")

repo = pwd()
using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()
using LexiconMining

tabulae(f, destdir)