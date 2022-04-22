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
            cleaner = replace(k, r"[_^0-9]" => "")
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
    typelist(lns, StringReader)
end

"""Determine list of unique values for `@type` attribute on entries in lns, a Vector of source data lines.
$(SIGNATURES)
"""
function typelist(lns, reader::Type{StringReader})
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

function pos_itype_counts(v::Vector{MorphData})
    @info("Woohoo! Found it!")

    strs = map(md -> md.pos * "|" * md.itype,  v)
    grouped = group(strs)
    counts = []
    for k in keys(grouped)
        push!(counts, (k, length(grouped[k])))
    end
    byfreq = sort(counts, by = pr -> pr[2], rev = true)
    map(pr -> string(pr[1], "|", pr[2]), byfreq)
end

function pos_itype_counts(f, reader::Type{FileReader})
    pos_itype_ocunts(readlines(f), StringReader)
end

"""Compute occurrences of pos*itype in `lns`,
a Vector of morphological data lines.
$(SIGNATURES)
"""
function pos_itype_counts(lns, reader::Type{StringReader})
    mdata = lns .|> morphData
    pos_itype_counts(mdata)
    #=
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

    #tab = map(pr -> string(pr[1], "|", pr[2]), sorted)
    byfreq = sort(counts, by = pr -> pr[2], rev = true)
    freqtab = map(pr -> string(pr[1], "|", pr[2]), byfreq)
    =#
end
