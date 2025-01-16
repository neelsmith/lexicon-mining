repo = pwd()
summarydir = joinpath(repo, "summaries")
tranches = filter(readdir(summarydir)) do f
    startswith(f, "tranch")
end


longies = []
for tranche in tranches
    tranchepath = joinpath(summarydir, tranche)
    cexfiles = filter(readdir(tranchepath)) do f
        endswith(f, ".cex")
    end
    for cexfile in cexfiles
        full = joinpath(tranchepath, cexfile)
        lines = readlines(full)
        if length(lines) != 1
            push!(longies, cexfile)
        end
    end
end