"""Morphological information from Lewis-Short for a noun."""
struct LSConjunction
    lsid
    form
end


"""Override Base.show for LSConjunction type.
$(SIGNATURES)
"""
function show(io::IO, prep::LSConjunction)
    msg = [
        prep.form,
        " (",
        prep.lsid, 
        ") conjunction",
    ]
    print(io, join(msg))
end

"""Override Base.== for LSConjunction type.
$(SIGNATURES)
"""
function ==(c1::LSConjunction, c2::LSConjunction)
    c1.lsid == c2.lsid &&
    c1.form == c2.form
end


function conjunctions(datatuples; includebad = false)::Union{Vector{LSConjunction}, Tuple{Vector{Any}, Vector{Any}}}
    conjdata = filter(tpl -> tpl.pos == "conjunction", datatuples)
    good = LSConjunction[]
    bad = []
    for tpl in conjdata
        shortid = trimid(tpl.urn)
        if isempty(tpl.lemma)
            push!(bad, tpl)
        else
            push!(good, LSConjunction(shortid, tpl.lemma)) 
        end
    end
    if includebad
        (good, bad)
    else
        good
    end
end


"""Compose a delimited-text line defining the
Tabulae stem for a conjunction.
$(SIGNATURES)    
"""
function cexline(conj::LSConjunction; divider = "|")        
   
    if iscommon(conj.form)
        [join(["latcommon.conj$(conj.lsid)","lsx." * conj.lsid, suareznorm(conj.form), "conjunction"], divider)]
    else
        l25 = join(["lat25.conj$(conj.lsid)","lsx." * conj.lsid, suareznorm(conj.form), "conjunction"], divider)
        l24 = join(["lat24.conj$(conj.lsid)","lsx." * conj.lsid, suareznorm(lat24(conj.form)), "conjunction"], divider)
        l23 = join(["lat23.conj$(conj.lsid)","lsx." * conj.lsid, suareznorm(lat23(conj.form)), "conjunction"], divider)
        [l23, l24, l25]
    end

end




"""Create a Tabulae CEX table for a vector of conjunctions.
$(SIGNATURES)
"""
function cextable(conjs::Vector{LSConjunction}, ortho = "latcommon"; divider = "|")
    hdr = join(
        ["StemUrn", "LexicalEntity", "Stem", "InflClass"], 
        divider)

    cexlines = cexline.(conjs; divider = divider) |> Iterators.flatten |> collect
    ortholines = filter(ln -> occursin(ortho, ln), cexlines)
    string(
        hdr,
        "\n",
        join(ortholines, "\n")
    )
end