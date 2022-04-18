# if running from root of repository:
f = joinpath(pwd(), "cex", "lewis-short", "entries.cex")
lns = readlines(f)
morphinfo = ["id|label|lemma|itype"]
using EzXML
for (i,ln) in enumerate(lns)
    cols = split(ln, "||")
    try
        doc = parsexml(cols[3])
        t = doc.root["type"]
        quantlemma = doc.root["key"]
        if t == "main"

            # process it...
            # Find element `itype`, get its text contents
            n = findfirst("//itype", doc.root)
            itype = isnothing(n) ? "" : n.content
            push!(morphinfo, "$(cols[1])|$(cols[2])|$(quantlemma)|$(itype)")
    
            # Check for
            # pos, gen, mood tns
        end
    catch e
        println("ERROR ON ENTRY $(i)")
        throw(e)
    end
end


open("morphinfo.cex", "w") do io
    write(io, join(morphinfo,"\n"))
end