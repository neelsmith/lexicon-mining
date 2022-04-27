"""True if `m` represents a first-conjugation verb.
$(SIGNATURES)
No deponents yet.
"""
function firstconj(m::MorphData)
    (m.itype ==  "a_vi, a_tum, 1" ||
    m.itype == "a_re" ||
    m.itype == "a_re, 1") &&
    endswith(m.label, "o")
end

## StemUrn|LexicalEntity|Stem|Gender|InflClass
"""Write Tabulae stem files for nouns in dataset in `dsdir`.
$(SIGNATURES)
"""
function tabulae_verbs(mdata::Vector{MorphData}, dsdir)
    stemsdir  = joinpath(dsdir, "stems-tables")
    if !isdir(stemsdir)
        mkdir(stemsdir)
    end
    verbsdir  = joinpath(stemsdir, "verb-simplex")
    if !isdir(verbsdir)
        mkdir(verbsdir)
    end

    
    # write first-conjugation to file:
    conj1_itype = filter(m -> firstconj(m), mdata)
    @info("Formatting $(length(conj1_itype)) entries for first-conjugation verbs.")
    conj1_file = joinpath(verbsdir, "conj1.cex")

    # write to file
    conj1(conj1_itype, conj1_file)


end



function format_conj1(m::MorphData)
    id = m.id
    "latcommon.verb$(id)|ls.$(id)|$(m.label[1:end-1])|conj1"
end
#|Notes
#latcommon.verbn2280|ls.n2280|am|conj1

function conj1(v::Vector{MorphData}, f)
    strs = map(m -> format_conj1(m), v)
    open(f, "w") do io
        write(io, VERB_HEADER * "\n" * join(strs, "\n"))
    end
end