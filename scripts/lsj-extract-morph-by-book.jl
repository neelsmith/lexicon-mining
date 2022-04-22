# Read mainentries.cex and extract morphological info.
#
# Run from root of repository:

repo = pwd()
using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()
using LexiconMining

function extractbook(n)
    f = joinpath(pwd(), "cex", "lsj", "mainentries", "lsj_main_$(n).cex")
    target = joinpath(pwd(), "cex", "lsj", "morphdata_$(n).cex")

    morphinfo = extractmorph(f)
    open(target, "w") do io
        write(io, join(morphinfo,"\n"))
    end
end

for arg in ARGS
    println("Extracting for file $(arg):")
    extractbook(arg)
end