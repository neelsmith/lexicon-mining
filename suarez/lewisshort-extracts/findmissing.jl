extractroot = joinpath(pwd(), "suarez", "lewisshort-extracts", "extracts-cycle2")


function gaps(dir)
    cex = filter(f -> endswith(f, ".cex"), readdir(dir))
    mia = []

    if length(cex) == 1000
        # All good!
        []
    else
        re = r"n([0-9]+).cex"
        nummatches = match(re, cex[1])
        
        currentcount = parse(Int, nummatches.captures[1])
        for f in cex[2:end]
            newmatches = match(re, f)
            newcount = parse(Int, newmatches.captures[1])
            #@debug("Compare $(currentcount) : $(newcount)")
            if newcount == currentcount + 1
                # All good!
            else
                push!(mia, f)
            end
            currentcount = newcount
        end
    end

    mia
end

