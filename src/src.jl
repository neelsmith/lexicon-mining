"""Read source file `f` and format content for `mainentries.cex`
$(SIGNATURES)
"""
function formatentries(f)
    lns = readlines(f)
    
    metadata = []
    for (i,ln) in enumerate(lns)
        try 
            doc = parsexml(ln)
            id = doc.root["id"]
            k = doc.root["key"]
            cleaner = replace(k, r"[_^]" => "")
            push!(metadata, join([id,cleaner], "||"))
        catch e
            println("ERROR AT LINE $(i)")
            println(e)
            throw(e)
        end
    end

    prs = zip(metadata, lns)
    cexlines = map(pr -> pr[1] * "||" * pr[2], prs)
end


"""Read source file `f` and determine list of unique values for `@type` attribute on entries.
$(SIGNATURES)
"""
function typelist(f)
    lns = readlines(f)

    typelist = []
    for (i,ln) in enumerate(lns)
        cols = split(ln, "||")
        try
            doc = parsexml(cols[3])
            t = doc.root["type"]
            if ! (t in typelist)
                push!(typelist, t)
            end
        catch e
            println("ERROR ON ENTRY $(i)")
            throw(e)
        end
    end
    typelist
end





"""Read source file `f` and compute occurrences of pos*itype.
$(SIGNATURES)
"""
function pos_itype_counts(f)
    lns = readlines(f)

    pairlist = []
    for ln in lns
        cols = split(ln,"|")
        push!(pairlist,cols[4] * "|" * cols[5])
    end

    grouped = group(pairlist)
    counts = []
    for k in keys(grouped)
        push!(counts, (k, length(grouped[k])))
    end
    sorted = sort(counts, by = pr -> pr[1])

    tab = map(pr -> string(pr[1], "|", pr[2]), sorted)
    byfreq = sort(counts, by = pr -> pr[2], rev = true)
    freqtab = map(pr -> string(pr[1], "|", pr[2]), byfreq)
end

#=
open(target, "w") do io
        write(io,join(tab,"\n"))
    end


    
=#