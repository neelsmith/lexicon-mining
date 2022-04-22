#freader::Type{FileReader}
function extractmorph(lns, reader::Type{StringReader}; header = true)
    morphinfo = header ? ["id|label|lemma|pos|itype|gen|mood"] : [] #tns
    for (i,ln) in enumerate(lns)
        @info("$(i) / $(length(lns))")
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

                #=
                # Not used in Lewis-Short

                tns = findfirst("//tns", doc.root)
                tnsval = isnothing(tns) ? "" : lowercase(tns.content)
                
                gramGrp cotaining gram type="voice"
                =#

                push!(morphinfo, "$(cols[1])|$(cols[2])|$(quantlemma)|$(posval)|$(itype)|$(genval)|$(moodval)") #|$(tnsval)")
            
            end
        catch e
            println("ERROR ON ENTRY $(i)")
            throw(e)
        end
    end
    morphinfo
end

"""Read source file `f` and compile table of relevant morphological data.
$(SIGNATURES)
"""
function extractmorph(f; header = true)
    lns = readlines(f)
    @info("Analyzing  $(f)...")
    extractmorph(lns, StringReader)
end
#=
   
    morphinfo = header ? ["id|label|lemma|pos|itype|gen|mood"] : [] #tns
    for (i,ln) in enumerate(lns)
        @info("$(i) / $(length(lns))")
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
    morphinfo
end
=#

struct MorphData
    # id|label|lemma|pos|itype|gen|mood
    id
    label
    lemma
    pos
    itype
    gen
    mood
end

function morphData(s)
    cols = split(s, "|")
    MorphData(
        cols[1],
        cols[2],
        cols[3],
        cols[4],
        cols[5],
        cols[6],
        cols[7]
    )
end