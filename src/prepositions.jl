"""Morphological information from Lewis-Short for a noun."""
struct LSPreposition
    lsid
    form
    cases::Vector{AbstractString}
end

"""Override Base.show for LSPreposition type.
$(SIGNATURES)
"""
function show(io::IO, prep::LSPreposition)
    msg = [
        prep.form,
        " (", 
        prep.lsid, 
        "; takes ",
        join(prep.cases, ", "),
        ")", 
    ]
    print(io, join(msg))
end

"""Override Base.== for LSPreposition type.
$(SIGNATURES)
"""
function ==(p1::LSPreposition, p2::LSPreposition)
    p1.lsid == p2.lsid &&
    p1.cases == p2.cases
end

"""
"""
function prepositions(datatuples; includebad = false)::Union{Vector{LSPreposition}, Tuple{Vector{Any}, Vector{Any}}}
    prepdata = filter(tpl -> tpl.pos == "preposition", datatuples)
    good = LSPreposition[]
    bad = []
    for tpl in prepdata
        shortid = trimid(tpl.urn)
        cases = split(tpl.morphology,",")
        if isempty(cases) 
            push!(bad, tpl)
            @warn("Failed for preposition record $(tpl)")
        else
            push!(good, LSPreposition(shortid, tpl.lemma, cases)) 
        end

    end
    if includebad
        (good, bad)
    else
        good
    end
end


"""Compose a delimited-text line defining the
Tabulae stem for a noun.
$(SIGNATURES)    
"""
function tabulaecex(prep::LSPreposition; divider = "|")        
   
    if iscommon(prep.form)
        [join(["latcommonprep.$(prep.lsid)","ls." * prep.lsid, suareznorm(prep.form), "preposition"], divider)]
    else
        l25 = join(["lat25prep.$(prep.lsid)","ls." * prep.lsid, suareznorm(prep.form), "preposition"], divider)
        l24 = join(["lat24prep.$(prep.lsid)","ls." * prep.lsid, suareznorm(lat24(prep.form)), "preposition"], divider)
        l23 = join(["lat23prep.$(prep.lsid)","ls." * prep.lsid, suareznorm(lat23(prep.form)), "preposition"], divider)
        [l23, l24, l25]
    end

end


"""Create a Tabulae CEX table for a vector of prepositions.
$(SIGNATURES)
"""
function cextable(preps::Vector{LSPreposition}, ortho = "latcommon"; divider = "|")
    hdr = join(
        ["StemUrn", "LexicalEntity", "Stem", "InflClass"], 
        divider)

    cexlines = tabulaecex.(preps; divider = divider) |> Iterators.flatten |> collect
    ortholines = filter(ln -> occursin(ortho, ln), cexlines)
    string(
        hdr,
        "\n",
        join(ortholines, "\n")
    )
end