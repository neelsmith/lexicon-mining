"""Morphological information from Lewis-Short for an adverb."""
struct LSAdverb
    lsid
    form
end


"""Override Base.show for LSAdverb type.
$(SIGNATURES)
"""
function show(io::IO, adv::LSAdverb)
    msg = [
        adv.form,
        " (",
        adv.lsid, 
        ") adverb",
    ]
    print(io, join(msg))
end

"""Override Base.== for LSAdverb type.
$(SIGNATURES)
"""
function ==(a1::LSAdverb, a2::LSAdverb)
    a1.lsid == a2.lsid &&
    a1.form == a2.form
end

"""

"""
function adverbs(datatuples; includebad = false)::Union{Vector{LSAdverb}, Tuple{Vector{Any}, Vector{Any}}}
    # These are all uninflected/irregular.
    conjdata = filter(tpl -> tpl.pos == "adverb", datatuples)
    good = LSAdverb[]
    bad = []
    for tpl in conjdata
        shortid = trimid(tpl.urn)
        if isempty(tpl.lemma)
            push!(bad, tpl)
        else
            push!(good, LSAdverb(shortid, tpl.lemma)) 
        end
    end
    if includebad
        (good, bad)
    else
        good
    end
end


"""Compose a delimited-text line defining the
Tabulae stem for an adverb.
$(SIGNATURES)    
"""
function cexline(adv::LSAdverb; divider = "|")        

    if iscommon(adv.form)
        [join([
            "latcommon.adverb$(adv.lsid)",
            "lsx." * adv.lsid, 
            suareznorm(adv.form), "positive","irregularadverb"], divider)]
    else
        l25 = join(["lat25.adverb$(adv.lsid)","lsx." * adv.lsid, suareznorm(adv.form), "positive","irregularadverb"], divider)
        l24 = join(["lat24.adverb$(adv.lsid)","lsx." * adv.lsid, suareznorm(lat24(adv.form)), "positive","irregularadverb"], divider)
        l23 = join(["lat23.adverb$(adv.lsid)","lsx." * adv.lsid, suareznorm(lat23(adv.form)), "positive", "irregularadverb"], divider)
        [l23, l24, l25]
    end

end

"""Create a Tabulae CEX table for a vector of conjunctions.
$(SIGNATURES)
"""
function cextable(conjs::Vector{LSAdverb}, ortho = "latcommon"; divider = "|")
    hdr = join(
        ["StemUrn", "LexicalEntity", "Stem", "Degree", "InflClass"], 
        divider)

    cexlines = cexline.(conjs; divider = divider) |> Iterators.flatten |> collect
    ortholines = filter(ln -> occursin(ortho, ln), cexlines)
    string(
        hdr,
        "\n",
        join(ortholines, "\n")
    )
end
