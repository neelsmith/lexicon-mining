dirlist = map(i -> joinpath(pwd(), "suarez", "lewisshort-extracts", "extracted", string("tranche", i)), collect(0:10))

using LexiconMining

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
nounslist = nouns(data)

# These results are really good!
noundecls = map(n -> n.declension, nounslist) |> countmap

decl3 = filter(n -> n.declension == 3, nounslist)


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

decl2 = filter(n -> n.declension == 2, nounslist)
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



conjugations = map(v -> v.conjugation, goodpps) |> countmap |> OrderedDict
sort!(conjugations, byvalue = true, rev = true)


preps = filter(tpl -> tpl.pos == "preposition", data)

adjs = filter(tpl -> tpl.pos == "adjective", data)

