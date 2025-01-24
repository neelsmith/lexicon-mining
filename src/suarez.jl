"""Create named tuples structuring CGPT output written to files in a list of directories. Return two vectors, one with structured tuples, one with list of data that couldn't be parsed.
"""
function readdata(dirs; includebad = false)
    good = 0
    badlist = []
    data = []
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
                    good = good + 1

                    (seq, urn, lemma, definition, pos, morphology) = cols
                    seqnum = parse(Int, tidyvalue(seq))
                 
                    entry = (seq = seqnum, urn = tidyvalue(urn), lemma =  tidyvalue(lemma), definition = tidyvalue(definition), pos = tidyvalue(pos), morphology = tidyvalue(morphology))
                    push!(data,entry)
                
                else
                    # RESTORE THIS?
                    #@warn("$(length(cols)) columns in $(src)")
                    push!(badlist, f)
                end
            
            end
            
        end
    end
    sorteddata = sort(data, by = x -> x.seq)
    #@info("readdata: GOT $(length(sorteddata)) RECORDS")
    if includebad
        (sorteddata, badlist)
    else
        sorteddata
    end
end

"""Normalize the string value for a data cell.
$(SIGNATURES)
"""
function tidyvalue(s)
   # @info("TIDY $(s) $(typeof(s))")
    lowercase(strip(s))
end

"""Trim a URN down to its object identifier.
$(SIGNATURES)
"""
function trimid(urnstring)
    replace(urnstring, r"[^:]+:" => "")
end
