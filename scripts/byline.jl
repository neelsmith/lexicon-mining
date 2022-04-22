f = joinpath(pwd(), "cex", "lsj", "alpha.cex")


repo = pwd()
using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()
using LexiconMining
using EzXML

lines = readlines(f)
for (i, ln) in enumerate(lines[5925:end])
    cols = split(ln, "||")
    doc = parsexml(cols[3]).root
    println("Parsed $(i)")
end