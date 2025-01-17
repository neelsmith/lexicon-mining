#=
repo = pwd()
trancheroot = joinpath(repo, "suarez", "lewisshort-extracts", "extracts-cycle2")
dirlist = map(i -> joinpath(trancheroot, string("tranche", i)), collect(11:33))



    good = 0
    badlist = []
    
    for d in dirlist
=#

function readtranche(dir)        
    data = []
    badlist = []
    for f in readdir(dir)
        src = joinpath(dir, f)
        lns = readlines(src)
        if isempty(lns)
            @warn("Empty line from file $(f)")
        elseif length(lns) > 1
            @info("Multiple lines in $(src)")
            push!(badlist, f)
        else
    
            cols = split(lns[1], "|") 
            if length(cols) == 6
                #good = good + 1
                (seq, urn, lemma, definition, pos, morphology) = cols
                entry = (seq = seq, urn = urn, lemma =  lemma, definition = definition, pos = pos, morphology = morphology)
                push!(data,entry)
            else
                @warn("$(length(cols)) columns in $(src): ignoring line.")
            end
        end
    end
    (data, badlist)
end




#=

println("Total good records: $(good)")
println("Total entries in data set: $(length(data))")

using StatsBase
using OrderedCollections

posvals =  map(tpl ->  lowercase(strip(tpl.pos)), data)
poscounts = posvals |> countmap |> OrderedDict
sort!(poscounts, byvalue = true, rev = true)


xref = filter(tpl ->  lowercase(strip(tpl.pos)) == "crossreference", data)
sort!(poscounts, byvalue = true, rev = true)


using Unicode
noundata = filter(tpl -> tpl.pos == "noun", data)
nouns = map(noundata) do tpl
    (nsraw,gsraw,genderraw) = split(tpl.morphology,",")
    ns = Unicode.normalize(strip(nsraw), stripmark = true)
    gs = Unicode.normalize(strip(gsraw), stripmark = true)
    gender = Unicode.normalize(strip(genderraw), stripmark = true)

    decl = if endswith(gs, "ae")
        1
    elseif endswith(gs, "is")
        3
    elseif endswith(gs, "us")
        4
    elseif endswith(gs,"ei") && endswith(ns,"es")
        5
    elseif endswith(gs, "i")
        2
    else
        0
    end
    (ns = ns, gs = gs, gender = gender, declension = decl)
end


# These results are really good!
noundecls = map(n -> n.declension, nouns) |> countmap



verbdata = filter(tpl -> occursin("verb", tpl.pos), data)

badverbs = []
fivepieces = filter(verbdata) do tpl
   cols = split(tpl.morphology,",")
    length(cols) == 5
end

goodpps = map(fivepieces) do tpl
    pieces = strip.(split(tpl.morphology, ","))
    (conjugation, pp1, pp2, pp3, pp4 ) = Unicode.normalize.(pieces, stripmark = true)

    (conjugation = conjugation, pp1 = pp1,pp2 = pp2, pp3 = pp3, pp4 = pp4)
end


conjugations = map(v -> v.conjugation, goodpps) |> countmap |> OrderedDict
sort!(conjugations, byvalue = true, rev = true)


preps = filter(tpl -> tpl.pos == "preposition", data)

adjs = filter(tpl -> tpl.pos == "adjective", data)


=#