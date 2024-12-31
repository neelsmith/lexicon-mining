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

"""Override Base.== for gerundive rule type.
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




function activeinfinitive(lemma, conj)
    if conj == 1
        replace(lemma, r"o$" => "are")
    
    elseif conj == 2 || conj == 3
        replace(lemma, r"o$" => "ere")

    elseif conj == 4
        replace(lemma, r"o$" => "ire")
    end

end


function passiveinfinitive(lemma, conj)
    if conj == 1
        replace(lemma, r"or$" => "ari")
    
    elseif conj == 2 
        replace(lemma, r"or$" => "eri")

    elseif conj == 3
        replace(lemma, r"or$" => "i")


    elseif conj == 4
        replace(lemma, r"or$" => "iri")
    end

end


function guessinfinitive(lemma, conj::Int)
    if endswith(lemma, "o")
        activeinfinitive(lemma, conj)
    elseif endswith(lemma,"or")
        passiveinfinitive(lemma, conj)
    else
        @warn("Didn't recognize lemma form in $(lemma)")
        ""
    end
end

function structure4(cols)
    conjugation = 0
    try 
        conjugation = parse(Int, cols[1])
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
        @warn("NO first pp")
    elseif isempty(pp2)
        #@warn("NO second pp")
       # @warn("Guess at infin for $(pp1) of conjugation $(conjugation)")   
        pp2 = guessinfinitive(pp1, conjugation)
    elseif isempty(pp3)
        @warn("No third pp")
    elseif isempty(pp4)
        @warn("No fourth pp")
        
    end

    [conjugation, pp1, pp2, pp3, pp4]
end

"""Parse LSVerbs out of datatuples.
$(SIGNATURES)
"""
function verbs(datatuples)

    verbdata = filter(tpl -> occursin("verb", tpl.pos) && ! occursin("dverb", tpl.pos), datatuples)

    goodverbs = LSVerb[]
    badverbs = []
    
    for tpl in verbdata
        shortid = trimid(tpl.urn)
        cols = strip.(split(tpl.morphology,","))
        cleaner = Unicode.normalize.(cols, stripmark = true)

        if length(cols) == 5    
            (conjugation, pp1, pp2, pp3, pp4 ) = cleaner 
            push!(goodverbs, LSVerb(shortid, conjugation, pp1, pp2,  pp3,  pp4 ))

        elseif length(cols) == 4
            @info("4 columns for verb $(shortid): $(cleaner)")
            (conjugation, pp1, pp2, pp3, pp4 ) = structure4(cleaner)
            push!(goodverbs, LSVerb(shortid, conjugation, pp1, pp2,  pp3,  pp4 ))

        else
            push!(badverbs, tpl)
        end
    end

    (goodverbs, badverbs)
end

