repo = pwd()
using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()
using LexiconMining

basedir = joinpath(pwd(), "cex", "lsj")
v = Vector{MorphData}()
for i in collect(1:27)
    f = joinpath(basedir, "morphdata_$(i).cex")
    append!(v, readlines(f) .|> morphData)
end

