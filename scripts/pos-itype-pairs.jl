f = joinpath(pwd(), "cex", "lewis-short", "morphinfo.cex")
target = joinpath(pwd(), "cex", "lewis-short", "pos-itype-pairs.cex")


lns = readlines(f)

pairlist = []
for ln in lns
    cols = split(ln,"|")
    push!(pairlist,cols[4] * "|" * cols[5])
end


open(target, "w") do io
    write(io, join(sort(unique(pairlist)),"\n"))
end