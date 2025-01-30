using LexiconMining

(lex, badlex) = lexicaldata(; includebad = true)


badids = map(t -> replace(t.urn,r".+:" => "") , badlex)

basedir = joinpath(pwd(), "summaries")
cmds = []
for id in badids[1:10]
    idint = parse(Int, replace(id, "n" => ""))
    
    #tranchenum = (idint / 1000) |> round |> Int
    tranchenum = (idint / 1000) |> trunc |> Int
    #@info(string(idint, " => ", tranchenum) )
    filename = joinpath(basedir, "tranche$(tranchenum)", "$(id).cex")
    #@info(filename)
    if isfile(filename)
        cmd = "git rm $(filename)"
        push!(cmds, cmd)
    else
        tranchenum = tranchenum -1
        filename = joinpath(basedir, "tranche$(tranchenum)", "$(id).cex")
        if isfile(filename)
            cmd = "git rm $(filename)"
            push!(cmds, cmd)
        else
            @warn("No file: $(filename)")
        end
    end
end




open("rmbad.sh", "w") do io
    write(io, join(cmds, "\n"))
end
