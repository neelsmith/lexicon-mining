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
   #StemUrn|LexicalEntity|String|Degree
    @info("Write cex for $(adv)")

    if iscommon(adv.form)
        [join([
            "latcommonadv.$(adv.lsid)",
            "lsx." * adv.lsid, 
            suareznorm(adv.form), "positive"], divider)]
    else
        l25 = join(["lat25adv.$(adv.lsid)","lsx." * adv.lsid, suareznorm(adv.form), "positive"], divider)
        l24 = join(["lat24advp.$(adv.lsid)","lsx." * adv.lsid, suareznorm(lat24(adv.form)), "positive"], divider)
        l23 = join(["lat23adv.$(adv.lsid)","lsx." * adv.lsid, suareznorm(lat23(adv.form)), "positive"], divider)
        [l23, l24, l25]
    end

end


#=

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
=#