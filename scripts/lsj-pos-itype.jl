f = joinpath(pwd(), "cex", "lsj", "morphdataalpha.cex")
target = joinpath(pwd(), "cex", "lsj", "pos-itype-pairs-bycount.cex")

repo = pwd()
using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()

freqtab = pos_itype_counts(f)
open(target, "w") do io
    write(io,join(freqtab,"\n"))
end