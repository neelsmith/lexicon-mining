"""Morphological information from Lewis-Short for a noun."""
struct LSVerb
    lsid 
    conjugation
    pp1
    pp2
    pp3
    pp4
end

"""Override Base.show for LSNoun type.
$(SIGNATURES)
"""
function show(io::IO, v::LSVerb)
    msg = [v.lsid, 
            " ", 

           v.pp1, 
           " (",
           
            v.conjugation,
            ") ",


            
            v.pp2,  
            ", ", 
            
            v.pp3,  
            ", ", 

            v.pp4,  
            
    ]
    print(io, join(msg))
end

"""Override Base.== for LSVerb.
$(SIGNATURES)
"""
function ==(v1::LSVerb, v2::LSVerb)
    v1.lsid == v2.lsid &&
    v1.conjugation == v2.conjugation &&
    v1.pp1 == v2.pp1 &&
    v1.pp2  == v2.pp2 && 
    v1.pp3 == v2.pp3
    v1.pp4 == v2.pp4
end


"""Form present active infinitive for regular verbs.
$(SIGNATURES)
"""
function activeinfinitive(lemma, conj)
    if conj == 1
        replace(lemma, r"o$" => "are")
    
    elseif conj == 2 || conj == 4
        replace(lemma, r"o$" => "re")

    elseif conj == 3
        replace(lemma, r"o$" => "ere")
    end

end

"""Form present passive infinitive for regular verbs.
$(SIGNATURES)
"""
function passiveinfinitive(lemma, conj)
    if conj == 1
        replace(lemma, r"or$" => "ari")
    
    elseif conj == 2 || conj == 4
        replace(lemma, r"or$" => "ri")

    elseif conj == 3
        replace(lemma, r"or$" => "i")
    end

end


"""Try to infer a present infinitive from a lemma.
$(SIGNATURES)
"""
function guessinfinitive(lemma, conj::Int)
    #@info("Guess infinitive for $(lemma)")
    if endswith(lemma, "o")
        activeinfinitive(lemma, conj)
    elseif endswith(lemma,"or")
        passiveinfinitive(lemma, conj)
    else
        @warn("Didn't recognize lemma form in $(lemma)")
        ""
    end
end


"""Interpret verb entry with only 4 columns.
$(SIGNATURES)
"""
function structure4(cols)
    @info("Figure out 4 cols $(cols)")
    conjugation = 0
    try 
        conjugation = parse(Int, strip(cols[1]))
    catch e
        @warn("Couldn't parse conjugation value $(cols[1])")
    end
    pp1 = ""
    pp2 = ""
    pp3 = "" 
    pp4 = ""

    if endswith(cols[end], "um")
        pp4 = cols[end]
    end

    if endswith(cols[end - 1], "i")
        pp3 = cols[end - 1]
    end
    if endswith(cols[2], "o") || endswith(cols[2], "or")
        pp1 = cols[2]

    elseif endswith(cols[2], "re")
        pp2 = cols[2]
        pp1 = replace(pp2, r"re$" => "o")
    end

    if isempty(pp1)
        @warn("NO first pp in $(cols)")
    elseif isempty(pp2)
        #@warn("NO second pp")
       # @warn("Guess at infin for $(pp1) of conjugation $(conjugation)")   
        pp2 = guessinfinitive(pp1, conjugation)
    elseif isempty(pp3)
        @warn("No third pp in in $(cols)")
    elseif isempty(pp4)
        @warn("No fourth pp in $(cols)")
        
    end

    #@info("So far: $([conjugation, pp1, pp2, pp3, pp4])")
    

    expand_elisions(conjugation, pp1, pp2, pp3, pp4)
end

function joinpair(prefix, glossform)
    if startswith(glossform, "-")
        string(prefix, glossform[2:end])
    else
        string(prefix, glossform)
    end
end


function expand_elisions(conj::Int, pp1, pp2, pp3, pp4)
    newpp2 = newpp3 = newpp4 = ""
    prefix = ""
    if occursin("-", pp1)
        (prefix,body) = split(pp1, "-")
    end
    stem = presentstem(conj, pp1)
    @info("1. Stem: $(stem) Prefix? $(prefix)")


<<<<<<< HEAD
    @info("Check out $(pp2)")
    pp2bare = Unicode.normalize(pp2; stripmark = true)
    pp2elided = r"\-?[aei]r[ei]"
    if ! isnothing(match(pp2elided, pp2bare)) || 
        pp2bare == "-i"
        newpp2 = joinpair(stem, pp2)
        @info("2. Expand $(pp2) to $(newpp2)")
=======
    #@info("Expand stems as needed based on $(stem)- ")
    newp2 = joinpair( stem, pp2)
    newp3 = joinpair( stem, pp3)
    newp4 = joinpair( stem, pp4)
>>>>>>> e205c9991d029197464c40fa86f5a8c5e911c9da

    elseif startswith( pp2,"-")
        
        newpp2 = joinpair(prefix, pp2)
        @info("2. Expand $(pp2) to $(newpp2)")
    else
        newpp2 = pp2
    end


    pp3bare = Unicode.normalize(pp3; stripmark = true)
    pp3elided = r"\-?[aei][uv]i"
    if ! isnothing(match(pp3elided, pp3bare)) || 
        pp3bare == "-i"
        
        newpp3 = joinpair(stem, pp3)
        @info("3. Expand $(pp3) to $(newpp3)")
    elseif startswith( pp3,"-")
        
        newpp3 = joinpair(prefix, pp3)
        #@info("2. Expand $(pp2) to $(newpp2)")
    else
        newpp3 = pp3
    end


    pp4bare = Unicode.normalize(pp4; stripmark = true)
    pp4elided = r"\-?[aei]tum"
    if ! isnothing(match(pp4elided, pp4bare)) || 
        pp4bare == "-um"
        
        newpp4 = joinpair(stem, pp4)
        @info("4. Expand $(pp4) to $(newpp4)")
    elseif startswith( pp4,"-")
        
        newpp4 = joinpair(prefix, pp4)
        #@info("2. Expand $(pp2) to $(newpp2)")
    else
        newpp4 = pp4
    end

    (pp1, newpp2, newpp3, newpp4)
    
end




"""Interpret verb entry with only 3 columns.
$(SIGNATURES)
"""
function structure3(cols)
    #@info("Look at 3-column structure for $(cols)")
    conjugation = 0
    try 
        conjugation = parse(Int, strip(cols[1]))
    catch e
        @warn("Couldn't parse conjugation value $(cols[1])")
    end
    pp1 = ""
    pp2 = ""
    pp3 = "" 
    pp4 = ""

    if endswith(cols[2], "o") || endswith(cols[2], "or")
        pp1 = cols[2]
    end


    if endswith(cols[3], "re") || endswith(cols[3], "ri")
        pp2 = cols[2]
    end

    if endswith(cols[3], "us") || endswith(cols[3], "um")
        pp4 = cols[3]
    end

    if isempty(pp1)
        @warn("NO first pp in $(cols)")
    elseif isempty(pp2)
        #@warn("NO second pp")
       # @warn("Guess at infin for $(pp1) of conjugation $(conjugation)")   
        pp2 = guessinfinitive(pp1, conjugation)
    elseif isempty(pp3)
        @warn("No third pp in in $(cols)")
    elseif isempty(pp4)
        @warn("No fourth pp in $(cols)")
        
    end

    #@info("Sending back $([conjugation, pp1, pp2, pp3, pp4])")

    [conjugation, pp1, pp2, pp3, pp4]
end


function verb(tpl)
    shortid = trimid(tpl.urn)
    cols = strip.(split(tpl.morphology,","))
    cleaner = Unicode.normalize.(cols, stripmark = true)

    #@info("Examine data from raw morphology $(tpl.morphology)")
    #@info("Columns: $(length(cols))")
    if length(cols) == 5    
        (conjugationraw, pp1, pp2, pp3, pp4 ) = cleaner 
        conjugation = 0
        try 
            conjugation = parse(Int, strip(conjugationraw))
        catch e
            @warn("Couldn't parse conjugation value $(conjugationraw)")
        end
    
        (pp1, pp2, pp3, pp4) = expand_elisions(conjugation, pp1, pp2, pp3, pp4)
        LSVerb(shortid, conjugation, pp1, pp2,  pp3,  pp4 )

    elseif length(cols) == 4

       # @info("4 columns for verb $(shortid): $(cleaner)")
        (conjugation, pp1, pp2, pp3, pp4 ) = structure4(cleaner)
        if typeof(conjugation) <: Int
            #ok
        else
            @warn("Got $(typeof(conjugation)) for $(conjugation)")
        end
        (conjugation, pp1, pp2, pp3, pp4) = expand_elisions(conjugation, pp1, pp2, pp3, pp4)
        LSVerb(shortid, conjugation, pp1, pp2,  pp3,  pp4 )

    elseif length(cols) == 3
        (conjugation, pp1, pp2, pp3, pp4 ) = structure3(cleaner)
        if typeof(conjugation) <: Int
            #ok
        else
            @warn("Got $(typeof(conjugation)) for $(conjugation)")
        end
        LSVerb(shortid, conjugation, pp1, pp2,  pp3,  pp4 )
    else
        @info("Very short verb entry : $(cols)")
        tpl
    end
end

"""Parse LSVerbs out of datatuples.
$(SIGNATURES)
"""
function verbs(datatuples; includebad = false)

    verbdata = filter(tpl -> occursin("verb", tpl.pos) && ! occursin("dverb", tpl.pos), datatuples)

    goodverbs = LSVerb[]
    badverbs = []
    
    for tpl in verbdata
        vrb = verb(tpl)
        if vrb isa LSVerb
            push!(goodverbs, vrb)
        else
            push!(badverbs, tpl)
        end
    end
    if includebad
        (goodverbs, badverbs)
    else
        goodverbs
    end
end

"""Find tabulae class for present system.
$(SIGNATURES)
"""
function presentconj(verb::LSVerb)
    if endswith(verb.pp1, "or")
        "c$(verb.conjugation)presdep"
    elseif endswith(verb.pp1, "o")
        "c$(verb.conjugation)pres"
    else
        ""
    end
end

"""Compose CEX content for a verb. Despite the function name,
this produces a vector of lines, not a single line.
$(SIGNATURES)
"""
function cexline(verb::LSVerb; divider = "|")    
    #@info("Start from tabulaeclass for $(verb):")
    #iclass = tabulaeclass(verb)
    #@info("$(iclass)")

    # Change this check to look at iclass:
    if missingpart(verb)
        principalparts_cex(verb)
    elseif verb.conjugation == 1
        conj1_cex(verb; divider = divider)
    elseif verb.conjugation == 2
        conj2_cex(verb; divider = divider)
    elseif verb.conjugation == 3
        conj3_cex(verb; divider = divider)        
    elseif verb.conjugation == 4
        conj4_cex(verb; divider = divider)        
    else
        []
    end
end



function cextable(verblist::Vector{LSVerb}, ortho = "latcommon"; divider = "|")
    hdr = join(
        ["StemUrn", "LexicalEntity", "Stem", "InflClass", "Notes"], 
        divider)
        
    cexlines = cexline.(verblist; divider = divider) |> Iterators.flatten |> collect
    
    ortholines = filter(ln -> occursin(ortho, ln), cexlines)
    string(
        hdr,
        "\n",
        join(ortholines, "\n")
    )
end

"""True if any value for principal part is missing.
$(SIGNATURES)
"""
function incomplete(v::LSVerb)
    isempty(v.pp1) ||
    isempty(v.pp2) ||
    isempty(v.pp3) ||
    isempty(v.pp4)
end

function conj4deponentclass(verb::LSVerb)
    stem = replace(verb.pp1, r"ior$" => "")
    if verb.pp2 == string(stem, "iri") &&
        (verb.pp4 == string(stem,"itus") ||  verb.pp4 == string(stem,"itum"))
        "conj4dep"
    else
        "c4presdep"
    end
end

function conj4class(verb::LSVerb)
    if ismissing(verb)
        "c4pres"
    else
        stem = replace(verb.pp1, r"io$" => "")
        if verb.pp2 == string(stem,"ire") &&
            verb.pp3 == string(stem,"ivi") &&
            (verb.pp4 == string(stem,"itus") ||  verb.pp4 == string(stem,"itum"))
            "conj4"
        else
            "c4pres"
        end
    end
end


function conj1deponentclass(verb::LSVerb)
    stem = replace(verb.pp1, r"or$" => "")
    if verb.pp2 == string(stem, "ari") &&
        (verb.pp4 == string(stem,"atus") ||  verb.pp4 == string(stem,"atum"))
        "conj1dep"
    else
        "c1presdep"
    end
end

function conj1class(verb::LSVerb)
    if ismissing(verb)
        "c1pres"
    else
        stem = replace(verb.pp1, r"o$" => "")
        if verb.pp2 == string(stem,"are") &&
            verb.pp3 == string(stem,"avi") &&
            (verb.pp4 == string(stem,"atus") ||  verb.pp4 == string(stem,"atum"))
            "conj1"
        else
            "c1pres"
        end
    end
end

function conj2deponentclass(verb::LSVerb)
    stem = replace(verb.pp1, r"eor$" => "")
    if verb.pp2 == string(stem, "eri") &&
        (verb.pp4 == string(stem,"itus") ||  verb.pp4 == string(stem,"itum"))
        "conj2dep"
    else
        "c2presdep"
    end
end

function conj2class(verb::LSVerb)
    if ismissing(verb)
        "c2pres"
    else
        stem = replace(verb.pp1, r"eo$" => "")
        if verb.pp2 == string(stem,"ere") &&
            verb.pp3 == string(stem,"ui") &&
            (verb.pp4 == string(stem,"itus") ||  verb.pp4 == string(stem,"itum"))
            "conj2"
        else
            "c2pres"
        end
    end
end



"""Find Tabulae class for a noun. 
Returns empty string if no class found.
$(SIGNATURES)
"""
function tabulaeclass(verb::LSVerb)
    if isempty(verb.pp1)
        nothing
   
    elseif verb.conjugation == 1
        if endswith(verb.pp1, "or")
            conj1deponentclass(verb)
        else
            conj1class(verb)
        end
        
    elseif verb.conjugation == 2
        if endswith(verb.pp1, "or")
            conj1deponentclass(verb)
        else
            conj1class(verb)
        end
        
    elseif verb.conjugation == 3
        ""

    elseif verb.conjugation == 4
       #@info("Analyze conj 4 verb class")
        if endswith(verb.pp1, "or")
            conj4deponentclass(verb)
        else
            conj4class(verb)
        end
        

    end
end

