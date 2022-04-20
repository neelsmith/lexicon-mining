# Read mainentries.cex and extract morphological info.
#
# Run from root of repository:
f = joinpath(pwd(), "cex", "lewis-short", "mainentries.cex")
target = joinpath(pwd(), "cex", "lewis-short", "morphinfo.cex")

repo = pwd()
using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()

morphinfo = survey(f)
open(target, "w") do io
    write(io, join(morphinfo,"\n"))
end