"""Create named tuples structuring CGPT output written to files in a list of directories. Return two vectors, one with structured tuples, one with list of data that couldn't be parsed.
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
                    seqnum = parse(Int, tidyvalue(cols[1]))
                    entry = (seq = seqnum, urn = tidyvalue(cols[2]), lemma =  tidyvalue(cols[3]), pos = tidyvalue(cols[4]), morphology = tidyvalue(cols[5]))
                    push!(data,entry)
                else
                    @warn("$(length(cols)) columns in $(src)")
                
                end
            end
        end
    end

    (sort(data, by = x -> x.seq), badlist)
end


"""Normalize the string value for a data cell.
$(SIGNATURES)
"""
function tidyvalue(s)
    lowercase(strip(s))
end

"""Trim a URN down to its object identifier.
$(SIGNATURES)
"""
function trimid(urnstring)
    replace(urnstring, r"[^:]+:" => "")
end


"""Find dataset for the orthography of a given string.
$(SIGNATURES)
"""
function latindataset(s)
    if occursin("j", s) 
        "lat25"
    elseif occursin("v", s) 
        "lat24"
    elseif occursin("i", s) || occursin("u", s)  
        "lat23"
    else
        "latcommon"
    end
end 