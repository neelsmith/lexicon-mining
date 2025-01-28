using LexiconMining
dirs = summarydirs()

gitlines = []

for d in dirs
    #@info("Reading dir $(d)")
    for f in readdir(d)
        src = joinpath(d, f)
        #@info("Reading file $(src)")
        lns = readlines(src)
        if isempty(lns)
            @error("Empty line from file $(f)")
        end
    
        for ln in lns
            cols = split(ln, "|") 
            if length(cols) == 6
                (seq, urn, lemma, definition, pos, morphology) = cols
                if pos == "crossreference" ||
                    pos == "participle" ||
                    occursin("false reading", definition)
                    cmd = "git rm $(src)"
                    push!(gitlines, cmd)
                    @info(cmd)
                end
            end
        
        end
        
    end
end

open("rmfile.sh", "w") do io 
    write(io, join(gitlines,"\n"))
end
