# if running from root of repository:
f = joinpath(pwd(), "cex", "lewis-short", "entries.cex")
lns = readlines(f)
typelist = []
using EzXML
for (i,ln) in enumerate(lns)
    cols = split(ln, "||")
    try
        doc = parsexml(cols[3])
        t = doc.root["type"]
        if ! (t in typelist)
            push!(typelist, t)
        end
    catch e
        println("ERROR ON ENTRY $(i)")
        throw(e)
    end
end