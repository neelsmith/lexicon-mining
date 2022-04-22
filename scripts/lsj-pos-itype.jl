repo = pwd()
using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()



basedir = joinpath(pwd(), "cex", "lsj")
v = Vector{MorphData}()
for i in collect(1:27)
    f = joinpath(basedir, "morphdata_$(i).cex")
    append!(v, readlines(f) .|> morphData)
end

f = joinpath(pwd(), "cex", "lsj", "morphdataalpha.cex")
target = joinpath(pwd(), "cex", "lsj", "pos-itype-pairs-bycount.cex")


freqtab = pos_itype_counts(f)
open(target, "w") do io
    write(io,join(freqtab,"\n"))
end