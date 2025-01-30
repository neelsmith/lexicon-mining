using LexiconMining

(lex, badlex) = lexicaldata(; includebad = true)


badids = map(t -> replace(t.urn,r".+:" => "") , badlex)

basedir = joinpath(pwd(), "summaries")
cmds = []
for id in badids
    idint = parse(Int, replace(id, "n" => ""))
    
    #tranchenum = (idint / 1000) |> round |> Int
    tranchenum = (idint / 1000) |> trunc |> Int
    @info(string(idint, " => ", tranchenum) )
    filename = joinpath(basedir, "tranche$(tranchenum)", "$(id).cex")
    #@info(filename)
    if isfile(filename)
        cmd = "git rm $(filename)"
        push!(cmds, cmd)
        @info("FOUND file $(filename)")
    else
        @warn("No file: $(filename) for id $(id)")
    end
end




open("rmbad.sh", "w") do io
    write(io, join(cmds, "\n"))
end
