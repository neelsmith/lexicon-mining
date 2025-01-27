function lexicaldata(dir; includebad = false)
    #@info("lexicaldata: use datatuples to get info for $(dir)")
    data = datatuples(dir)
    #@info("Got data with $(length(data)) tuples.")
    #@info(data)


    sheep = filter(data) do tpl
        tpl.pos != "crossreference" &&
        tpl.pos != "participle" && 
        ! occursin("false reading", tpl.definition)
    end
    if includebad
        goats = filter(data) do tpl
            tpl.pos == "crossreference" ||
            tpl.pos == "participle" ||
            occursin("false reading", tpl.definition)
        end
        (sheep, goats)
    else
        sheep
    end
end

function lexicaldata(; includebad = false)
    lexicaldata(pwd(); includebad = includebad)
end
function datatuples(; includebad = false)
    datatuples(pwd(); includebad = includebad)
end

function datatuples(dir; includebad = false)
    #@info("datatuples function: using readdata to collect data for $(dir)")
    data = readdata(summarydirs(dir); includebad = includebad)
    #@info("datatuples function: returning $(length(data)) records")
    data
end

function summarydirs()
    summarydirs(pwd())
end

"""Find file names in local file system for all files with ChatGPT summaries of Lewis-Short articles.
$(SIGNATURES)
"""
function summarydirs(repo)
    summariesdir = joinpath(repo, "summaries")
    tranchenames = filter(readdir(summariesdir)) do dir
        startswith(dir, "tranche")
    end
    map(name -> joinpath(summariesdir, name), tranchenames)
end


function tabulaenouns(data, datasetdir; divider = "|")
    nounlist = filter(nouns(data)) do noun
        ! isnothing(noun.gender) &&
        ! isempty(noun.gender)
    end

    nounscommon = cextable(nounlist, "latcommon")     
    commonfile = joinpath(datasetdir, "common", "stems-tables", "nouns", "nouns.cex")
    open(commonfile,"w") do io
        write(io, nounscommon)
    end

    nouns23 = cextable(nounlist, "lat23")
    lat23file = joinpath(datasetdir, "lat23", "stems-tables", "nouns", "nouns.cex")
    open(lat23file,"w") do io
        write(io, nouns23)
    end

    nouns24 = cextable(nounlist, "lat24")
    lat24file = joinpath(datasetdir, "lat24", "stems-tables", "nouns", "nouns.cex")
    open(lat24file,"w") do io
        write(io, nouns24)
    end

    nouns25 = cextable(nounlist, "lat25")
    lat25file = joinpath(datasetdir, "lat25", "stems-tables", "nouns", "nouns.cex")
    open(lat25file,"w") do io
        write(io, nouns25)
    end
end

function tabulaeprepositions(data, datasetdir; divider = "|")
    preplist = prepositions(data)
    prepscommon = cextable(preplist, "latcommon")     
    commonfile = joinpath(datasetdir, "common", "stems-tables", "uninflected", "prepositions.cex")
    open(commonfile,"w") do io
        write(io, prepscommon)
    end

    preps23 = cextable(preplist, "lat23")
    lat23file = joinpath(datasetdir, "lat23", "stems-tables", "uninflected", "prepositions.cex")
    open(lat23file,"w") do io
        write(io, preps23)
    end

    preps24 = cextable(preplist, "lat24")
    lat24file = joinpath(datasetdir, "lat24", "stems-tables", "uninflected", "prepositions.cex")
    open(lat24file,"w") do io
        write(io, preps24)
    end

    preps25 = cextable(preplist, "lat25")
    lat25file = joinpath(datasetdir, "lat25", "stems-tables", "uninflected", "prepositions.cex")
    open(lat25file,"w") do io
        write(io, preps25)
    end
end


function tabulaeconjunctions(data, datasetdir; divider = "|")
    conjlist = conjunctions(data)
    common = cextable(conjlist, "latcommon")     
    commonfile = joinpath(datasetdir, "common", "stems-tables", "uninflected", "conjunctions.cex")
    open(commonfile,"w") do io
        write(io, common)
    end

    conj23 = cextable(conjlist, "lat23")
    lat23file = joinpath(datasetdir, "lat23", "stems-tables", "uninflected", "conjunctions.cex")
    open(lat23file,"w") do io
        write(io, conj23)
    end

    conj24 = cextable(conjlist, "lat24")
    lat24file = joinpath(datasetdir, "lat24", "stems-tables", "uninflected", "conjunctions.cex")
    open(lat24file,"w") do io
        write(io, conj24)
    end

    conj25 = cextable(conjlist, "lat25")
    lat25file = joinpath(datasetdir, "lat25", "stems-tables", "uninflected", "conjunctions.cex")
    open(lat25file,"w") do io
        write(io, conj25)
    end
end




function tabulaeadjectives(data, datasetdir; divider = "|")
    adjlist = adjectives(data)
    common = cextable(adjlist, "latcommon")     
    commonfile = joinpath(datasetdir, "common", "stems-tables", "adjectives", "adjectives.cex")
    open(commonfile,"w") do io
        write(io, common)
    end

    conj23 = cextable(adjlist, "lat23")
    lat23file = joinpath(datasetdir, "lat23", "stems-tables", "adjectives", "adjectives.cex")
    open(lat23file,"w") do io
        write(io, conj23)
    end

    conj24 = cextable(adjlist, "lat24")
    lat24file = joinpath(datasetdir, "lat24", "stems-tables", "adjectives", "adjectives.cex")
    open(lat24file,"w") do io
        write(io, conj24)
    end

    conj25 = cextable(adjlist, "lat25")
    lat25file = joinpath(datasetdir, "lat25", "stems-tables", "adjectives", "adjectives.cex")
    open(lat25file,"w") do io
        write(io, conj25)
    end
end





function tabulaeverbs(data, datasetdir; divider = "|")
    verblist = verbs(data)
    common = cextable(verblist, "latcommon")     
    commonfile = joinpath(datasetdir, "common", "stems-tables", "verbs-simplex", "verbs.cex")
    open(commonfile,"w") do io
        write(io, common)
    end

    conj23 = cextable(verblist, "lat23")
    lat23file = joinpath(datasetdir, "lat23", "stems-tables", "verbs-simplex", "verbs.cex")
    open(lat23file,"w") do io
        write(io, conj23)
    end

    conj24 = cextable(verblist, "lat24")
    lat24file = joinpath(datasetdir, "lat24", "stems-tables", "verbs-simplex", "verbs.cex")
    open(lat24file,"w") do io
        write(io, conj24)
    end

    conj25 = cextable(verblist, "lat25")
    lat25file = joinpath(datasetdir, "lat25", "stems-tables", "verbs-simplex", "verbs.cex")
    open(lat25file,"w") do io
        write(io, conj25)
    end
end

function tabulaeadverbs(data, datasetdir; divider = "|")
    advs = adverbs(data)

    common = cextable(advs, "latcommon")     
    commonfile = joinpath(datasetdir, "common", "irregular-stems", "adverbs", "adverbs.cex")
    open(commonfile,"w") do io
        write(io, common)
    end

    conj23 = cextable(advs, "lat23")
    lat23file = joinpath(datasetdir, "lat23",  "irregular-stems", "adverbs", "adverbs.cex")
    open(lat23file,"w") do io
        write(io, conj23)
    end

    conj24 = cextable(advs, "lat24")
    lat24file = joinpath(datasetdir, "lat24",  "irregular-stems", "adverbs", "adverbs.cex")
    open(lat24file,"w") do io
        write(io, conj24)
    end

    conj25 = cextable(advs, "lat25")
    lat25file = joinpath(datasetdir, "lat25",  "irregular-stems", "adverbs", "adverbs.cex")
    open(lat25file,"w") do io
        write(io, conj25)
    end


end

function tabulae(;divider = "|")
    tabulae(pwd(); divider = divider)
end

function tabulae(repo::AbstractString; divider = "|")
    data = lexicaldata(repo)
    datasetbase = joinpath(repo, "tabulae-datasets", "lewis-short")
    # Nouns:
    tabulaenouns(data, datasetbase; divider = divider)
    # Uninflected: prepositions
    tabulaeprepositions(data, datasetbase; divider = divider)
    # Uninflected: conjunctions
    tabulaeconjunctions(data, datasetbase; divider = divider)
    # Adjectives
    tabulaeadjectives(data, datasetbase; divider = divider)
    # Verbs
    tabulaeverbs(data, datasetbase; divider = divider)
    # Adverbs
    tabulaeadverbs(data, datasetbase; divider = divider)
end


"""True if a string from Lewis-Short can be used in the "latcommon" dataset.
$(SIGNATURES)
"""
function iscommon(s)
    latindataset(s) == "latcommon"
end

"""Find dataset for the orthography of a given string in Lewis-Short.
If a word belongs to lat25, then we can generate lat24 for it by changing j -> i,
and lat23 by changing j -> i, and v -> u.
If a word belongs to lat24, then we can generate lat 23 by changing v -> u.
$(SIGNATURES)
"""
function latindataset(s::AbstractString)
    if occursin("j", s) 
        "lat25"
    elseif occursin("v", s) 
        "lat24"
    else
        "latcommon"
    end
end


"""Convert a string in Latin 25 orthography to Latin 24.
$(SIGNATURES)
"""
function lat24(s)
    replace(s, "j" => "i")
end


"""Convert a string in Latin 25 or Latin 24 orthography to Latin 23.
$(SIGNATURES)
"""
function lat23(s)
    replace(lat24(s), "v" => "u")    
end

"""Normalize a string generated by Suares.
$(SIGNATURES)
"""
function suareznorm(s)
    nohyphens = replace(s, "-" => "")
    Unicode.normalize(nohyphens; stripmark = true) |> strip
end