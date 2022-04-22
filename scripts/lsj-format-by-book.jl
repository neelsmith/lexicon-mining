# Read source, and format morphological data file
# for LSJ data for α in this repository
#
# Run from root of repository:
repo = pwd()
using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()
using LexiconMining


function formatbook(n)
    f = joinpath(pwd(), "source-data", "lsj", "lsj_$(n).cex")
    target = joinpath(pwd(),"cex", "lsj", "lsj_main_$(n).cex")

    mainentries = formatentries(f)
    open(target, "w") do io
        write(io, join(mainentries,"\n"))
    end
end

for i in 1:27
    formatbook(i)
end