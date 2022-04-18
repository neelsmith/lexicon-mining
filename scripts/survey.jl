#############
# Read mainentries.cex and extract morphological info.
#
# If NOT running from root of repository,
# adjust paths here:
f = joinpath(pwd(), "cex", "lewis-short", "mainentries.cex")
target = joinpath(pwd(), "cex", "lewis-short", "morphinfo.cex")
repo = pwd()
#############


# main script
using Pkg
Pkg.activate(repo)
Pkg.resolve()
Pkg.instantiate()

using EzXML

lns = readlines(f)

morphinfo = ["id|label|lemma|pos|itype|gen|mood"]#|tns"]
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
            
            pos = findfirst("//pos", doc.root)
            posval = isnothing(pos) ? "" : lowercase(pos.content)

            gen = findfirst("//gen", doc.root)
            genval = isnothing(gen) ? "" : lowercase(gen.content)

            mood = findfirst("//mood", doc.root)
            moodval = isnothing(mood) ? "" : lowercase(mood.content)

            #= Not used in Lewis-Short

            tns = findfirst("//tns", doc.root)
            tnsval = isnothing(tns) ? "" : lowercase(tns.content)
            =#

            push!(morphinfo, "$(cols[1])|$(cols[2])|$(quantlemma)|$(posval)|$(itype)|$(genval)|$(moodval)") #|$(tnsval)")
          
        end
    catch e
        println("ERROR ON ENTRY $(i)")
        throw(e)
    end
end


open(target, "w") do io
    write(io, join(morphinfo,"\n"))
end