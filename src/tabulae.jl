function summaryfiles()
    summaryfiles(pwd())
end

"""Find file names in local file system for all files with ChatGPT summaries of Lewis-Short articles.
$(SIGNATURES)
"""
function summaryfiles(repo)
    summariesdir = joinpath(repo, "summaries")
    tranchenames = filter(readdir(summariesdir)) do dir
        startswith(dir, "tranche")
    end
    map(name -> joinpath(summariesdir, name), tranchenames)
end

function tabulae(;divider = "|")
    tabulae(pwd(), divider = divider)
end

function tabulae(repo; divider = "|")
    (data, errs) = summaryfiles(repo) |> readdata
    datasetbase = joinpath(repo, "tabulae-datasets", "lewis-short")

    # Nouns:
    nounscexlines = nouns(data) .|> tabulaecex
    nounscommon = filter(ln -> occursin("latcommon", ln), nounscexlines)
    nouns23 = filter(ln -> occursin("lat23", ln), nounscexlines)
    nouns24 = filter(ln -> occursin("lat24", ln), nounscexlines)
    nouns25 = filter(ln -> occursin("lat25", ln), nounscexlines)

    nounheader = join(["StemUrn", "LexicalEntity","Stem","Gender","InflClass"], divider)

    commonfile = joinpath(datasetbase, "common", "stems-tables", "nouns", "nouns.cex")
    open(commonfile,"w") do io
        write(io, nounheader * "\n" * join(nounscommon,"\n"))
    end
    lat23file = joinpath(datasetbase, "lat23", "stems-tables", "nouns", "nouns.cex")
    open(lat23file,"w") do io
        write(io, nounheader * "\n" * join(nouns23,"\n"))
    end
    lat24file = joinpath(datasetbase, "lat24", "stems-tables", "nouns", "nouns.cex")
    open(lat24file,"w") do io
        write(io, nounheader * "\n" * join(nouns24,"\n"))
    end
    lat25file = joinpath(datasetbase, "lat25", "stems-tables", "nouns", "nouns.cex")
    open(lat25file,"w") do io
        write(io, nounheader * "\n" * join(nouns25,"\n"))
    end


    # Uninflected:

end