dirlist = map(i -> joinpath(pwd(), "suarez", "lewisshort-extracts", "extracted", string("tranche", i)), collect(0:10))


"""Read CGPT output from a list of directories, and create
named tuples. Return two vectors, one with good data, one with list of failures.
"""
function readdata(dirs)
    good = 0
    badlist = []
    data = []
    for d in dirs
        for f in readdir(d)
            src = joinpath(d, f)
            lns = readlines(src)
            if isempty(lns)
                @warn("Empty line from file $(f)")
            elseif length(lns) > 1
                @info("Multiple lines in $(src)")
                push!(badlist, src)
            else
            
                cols = split(lns[1], "|") 
                if length(cols) == 5
                    good = good + 1
                    entry = (seq = cols[1], urn = cols[2], lemma =  cols[3], pos = cols[4], morphology = cols[5])
                    push!(data,entry)
                else
                    @warn("$(length(cols)) columns in $(src)")
                
                end
            end
        end
    end
    (data, badlist)
end

(data, fails) = readdata(dirlist)

println("Total good records: $(length(data))")
println("Total failed: $(length(fails))")

using StatsBase
using OrderedCollections

posvals =  map(tpl ->  lowercase(strip(tpl.pos)), data)
poscounts = posvals |> countmap |> OrderedDict
sort!(poscounts, byvalue = true, rev = true)


xref = filter(tpl ->  lowercase(strip(tpl.pos)) == "crossreference", data)
sort!(poscounts, byvalue = true, rev = true)


using Unicode
noundata = filter(tpl -> lowercase(strip(tpl.pos)) == "noun", data)
nouns = map(noundata) do tpl
    cols = split(tpl.morphology,",")
    if length(cols) > 2
        nsraw = cols[1]
        gsraw = cols[2]
        genderraw = cols[3]
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
        (urn = tpl.urn, ns = ns, gs = gs, gender = gender, declension = decl)
    else
        @warn("$(tpl.morphology): wrong number of columns for noun")
        nothing
    end
end


# These results are really good!
noundecls = map(n -> n.declension, nouns) |> countmap

decl3 = filter(n -> n.declension == 3, nouns)


decl3patterns = map(decl3) do n
    if length(n.gs) < 4
        @warn("gen.s. too short! $(n.gs) for nom.s. $(n.ns) $(n.urn)")
        ""
    else
        string("-", n.ns[end-1:end]," -", n.gs[end-3:end])
    end
end

decl3counts = decl3patterns |> countmap |> OrderedDict
sort!(decl3counts, rev = true, byvalue = true)

decl2 = filter(n -> n.declension == 2, nouns)
decl2patterns = map(decl2) do n
    if length(n.ns) < 3
        @warn("nom.s. too short! nom.s. $(n.ns), $(n.gs)  for $(n.urn)")
        ""
    else
        string("-", n.ns[end-1:end]," -", n.gs[end])
    end
end
decl2counts = decl2patterns |> countmap |> OrderedDict
sort!(decl2counts, rev = true, byvalue = true)

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

