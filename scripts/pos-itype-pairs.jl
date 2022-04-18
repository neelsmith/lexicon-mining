f = joinpath(pwd(), "cex", "lewis-short", "morphinfo.cex")
target = joinpath(pwd(), "cex", 
"lewis-short", "pos-itype-pairs.cex")
target2 = joinpath(pwd(), "cex", "lewis-short", "pos-itype-pairs-bycount.cex")
repo = pwd()


using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()

using SplitApplyCombine

lns = readlines(f)

pairlist = []
for ln in lns
    cols = split(ln,"|")
    push!(pairlist,cols[4] * "|" * cols[5])
end

grouped = group(pairlist)
counts = []
for k in keys(grouped)
    push!(counts, (k, length(grouped[k])))
end
sorted = sort(counts, by = pr -> pr[1])

tab = map(pr -> string(pr[1], "|", pr[2]), sorted)
open(target, "w") do io
    write(io,join(tab,"\n"))
end


byfreq = sort(counts, by = pr -> pr[2], rev = true)
freqtab = map(pr -> string(pr[1], "|", pr[2]), byfreq)
open(target2, "w") do io
    write(io,join(freqtab,"\n"))
end