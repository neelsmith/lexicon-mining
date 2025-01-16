#=
Simple-minded examination of file names to see if they are in numeric sequence.

This will fail on tranche0 (and any directory where the numeric component of the file names does not have a consistent number of digits) since the alphabetic sort this script works through will result in sequences like 1, 10.., 2, 20..

=#
extractroot = joinpath(pwd(), "suarez", "lewisshort-extracts", "extracts-cycle2")


function gaps(dir)
    cex = filter(f -> endswith(f, ".cex"), readdir(dir))
    mia = []

    if length(cex) == 1000
        # All good!
        []
    else
        re = r"n([0-9]+)([a-z]*).cex"
        nummatches = match(re, cex[1])
        #@info("Matching $(cex[1]): $(nummatches)")
        currentcount = parse(Int, nummatches.captures[1])
        for f in cex[2:end]
            newmatches = match(re, f)
            #@info("Matching $(f): $(newmatches)")
            newcount = parse(Int, newmatches.captures[1])
            #@debug("Compare $(currentcount) : $(newcount)")
            if newcount == currentcount ||
                newcount == currentcount + 1
                # All good!
            else
                push!(mia, f)
            end
            currentcount = newcount
        end
    end

    mia
end

