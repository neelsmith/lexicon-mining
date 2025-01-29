using LexiconMining

f = "top200.txt"
ids = readlines(f)

data = datatuples()

function gloss(id, data)
    try
        tpl = filter(t -> endswith(t.urn, string(":", id)),  data)[1]
        string("**", tpl.lemma, "**, *", tpl.definition, "*, ", tpl.pos, ": **", tpl.morphology, "**.")
    catch e
        @warn("Died on $(id)")
        @warn(e)
        nothing
    end
end

mdgloss = map(ln -> gloss(ln, data), ids)

ids[1]
gloss("n43291", data)

prepped = filter(g -> !isnothing(g), mdgloss) |> sort

hdg = "# Top 200 vocabulary items in Augustine, *Confessions*\n\n"
open("glossary.md", "w") do io
    write(io, hdg * join(prepped,"\n\n"))
end