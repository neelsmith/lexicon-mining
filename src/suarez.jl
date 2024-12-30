"""Read CGPT output from a list of directories, and create
named tuples. Return two vectors, one with good data, one with list of failures.
"""
function readdata(dirs)
    good = 0
    badlist = []
    data = []
    for d in dirs
        for f in readdir(d)
            src = joinpath(d, f)
            lns = readlines(src)
            if isempty(lns)
                @warn("Empty line from file $(f)")
            elseif length(lns) > 1
                @info("Multiple lines in $(src)")
                push!(badlist, src)
            else
            
                cols = split(lns[1], "|") 
                if length(cols) == 5
                    good = good + 1
                    entry = (seq = cols[1], urn = cols[2], lemma =  cols[3], pos = cols[4], morphology = cols[5])
                    push!(data,entry)
                else
                    @warn("$(length(cols)) columns in $(src)")
                
                end
            end
        end
    end
    (data, badlist)
end


"""Trim a URN down to its object identifier.
$(SIGNATURES)
"""
function trimid(urnstring)
    replace(urnstring, r"[^:]+:" => "")
end


