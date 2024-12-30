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


    
    
    

    #@info("4 $(cols)")
    
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
    #@info("Guess at: $(pp1)/$(pp2)/$(pp3)/$(pp4)")
    [conjugation, pp1, pp2, pp3, pp4]
end

function verbs(datatuples)

    verbdata = filter(tpl -> occursin("verb", tpl.pos), datatuples)

    goodverbs = []
    badverbs = []
    
    for tpl in verbdata
        shortid = trimid(tpl.urn)
        cols = strip.(split(tpl.morphology,","))
        cleaner = Unicode.normalize.(cols, stripmark = true)

        if length(cols) == 5    
            (conjugation, pp1, pp2, pp3, pp4 ) = cleaner # Unicode.normalize.(cols, stripmark = true)
            push!(goodverbs, (id = shortid, conjugation = conjugation, pp1 = pp1,pp2 = pp2, pp3 = pp3, pp4 = pp4))


        elseif length(cols) == 4
            @info("4 for $(shortid): $(cleaner)")
            (conjugation, pp1, pp2, pp3, pp4 ) = structure4(cleaner)
            push!(goodverbs, (id = shortid, conjugation = conjugation, pp1 = pp1,pp2 = pp2, pp3 = pp3, pp4 = pp4 ))



        else
            push!(badverbs, tpl)
        end
    end
    


    #filter(verbdata) do tpl
    #    cols = 
    #    length(cols) != 5
    #end

#=
    fivepieces = filter(verbdata) do tpl
        cols = split(tpl.morphology,",")
        length(cols) == 5
    end
     = 
    end
=#
    (goodverbs, badverbs)
end

