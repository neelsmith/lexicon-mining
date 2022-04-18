
# if running from root of repository:
f = joinpath(pwd(), "cex", "lewis-short", "src.cex")
lns = readlines(f)

using EzXML

metadata = []
for (i,ln) in enumerate(lns)
    try 
        doc = parsexml(ln)
        id = doc.root["id"]
        k = doc.root["key"]
        push!(metadata, join([id,k], "|"))
    catch e
        println("ERROR AT LINE $(i)")
        println(e)
        throw(e)
    end
end

prs = zip(metdata, lns)
cexlines = map(pr -> pr[1] * "|" * pr[2], prs)

open("entries.cex", "w") do io
    write(io, join(cexlines,"\n"))
end