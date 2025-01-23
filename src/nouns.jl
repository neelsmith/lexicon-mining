"""Morphological information from Lewis-Short for a noun."""
struct LSNoun
    lsid
    nomsg
    gensg
    gender
    declension::Int
end


"""Override Base.show for LSNoun type.
$(SIGNATURES)
"""
function show(io::IO, n::LSNoun)
    msg = [n.lsid, 
            " ", 
            n.nomsg, 
            ", ", 
            n.gensg, 
            " (",
            n.declension,
            "), ", 
            n.gender
    ]
    print(io, join(msg))
end

"""Override Base.== for gerundive rule type.
$(SIGNATURES)
"""
function ==(n1::LSNoun, n2::LSNoun)
    n1.lsid == n2.lsid &&
    n1.nomsg == n2.nomsg &&
    n1.gensg == n2.gensg &&
    n1.gender  == n2.gender && 
    n1.declension == n2.declension
end


"""Standardize string value for gender.
$(SIGNATURES)
"""
function normalizegender(s)
    genderval = Unicode.normalize(strip(s), stripmark = true)

    if genderval in ["m", "masculine", "m."  ]
        "masculine"

    elseif genderval in ["f.", "f", "feminine"]
        "feminine"

    elseif genderval in ["neuter", "n", "n." ]
        "neuter"

    elseif genderval ==   "common"
        "common"

    else
        #@warn("Invalid value for gender: $(s)")
        ""
    end
end


function expand(nom, gen)
    if gen == "ae"
        replace(nom, r"a$" => "") * "ae"
    elseif gen == "arum"
        replace(nom, r"ae$" => "") * "arum"

    elseif gen == "i"
        #if endswith()
        replace(nom, r"[ou][smn]$" => "") * "i"

    elseif gen == "orum"
        replace(nom, r"[ia]$" => "") * "orum"

    else
        ""
    end
end

"""Extract noun entries from list of data tuples, and format 
noun morphology in type-specific structure.
$(SIGNATURES)
"""
function nouns(datatuples; includebad = false)#::Union{Vector{LSNoun}, Tuple{Vector{Any}, Vector{Any}}}
    noundata = filter(tpl -> tpl.pos == "noun", datatuples)
    good = LSNoun[]
    bad = []

    for tpl in noundata
        cols = split(tpl.morphology,",")
        if length(cols) > 2
            nsraw = cols[1]
            gsraw = cols[2]
            genderraw = cols[3]
            ns = Unicode.normalize(nsraw, stripmark = true)
            gs = Unicode.normalize(gsraw, stripmark = true)
            gender = normalizegender(genderraw)
            if isempty(gender)
                @warn("Invalid value for gender $(genderraw) in ($(tpl.lemma), $(tpl.urn))")
            end
            shortid = trimid(tpl.urn)

            bareendings = ["i", "ae", "arum", "orum"]
            if gs in bareendings
                #@warn("RAW ENDING GEN SG: $(gs) in $(shortid) ($(ns))")
                gs = expand(ns, gs)
                #@info("Expanded to $(gs)")
            end
    
            decl = if endswith(gs, "ae")
                1
            elseif endswith(gs, "arum")
                1
            elseif endswith(gs, "orum")
                2
            elseif endswith(gs, "is")
                3
            elseif endswith(gs, "ium")        
                3
            elseif endswith(gs, "um")  &&
                (endswith(ns, "es") || endswith(ns, "a"))
                3
            elseif endswith(gs, "us")
                4
            elseif endswith(gs,"ei") && endswith(ns,"es")
                5
            #elseif endswith(gs,"es") && endswith(ns,"es")

            elseif endswith(gs, "i")
                2

            elseif endswith(gs, "es") && endswith(ns, "e")
               # @info("GREEK 1st: $(ns)")
                1 # Greek
            else
                0
            end
            push!(good, LSNoun(shortid, ns, gs, gender, decl))
        
        else
            @warn("$(tpl.urn): wrong number of columns for noun")
            push!(bad, tpl)
        end
    end    
    if includebad
        (good, bad)
    else
        good
    end
end

function decl1class(nom, gen)
    
    if endswith(gen, "ae") && endswith(nom, "a")
        "a_ae"
    elseif endswith(gen, "ae") && endswith(nom, "as")
        "as_ae"

    elseif endswith(gen, "ae") && endswith(nom, "es")   
        "es_ae"         

    elseif endswith(gen, "es") && endswith(nom, "e")
            "e_es"            

    elseif endswith(gen, "arum")
        "a_ae_pl"

    else
        @warn("Declension 1 conflicts with endings  ($(gen)) for $(nom)")
            ""
    end
end

"""Find Tabulae class for a first declension noun.
$(SIGNATURES)
"""
function decl1class(noun::LSNoun)
    decl1class(noun.nomsg, noun.gensg)
end

"""Find Tabulae class for a second declension noun.
$(SIGNATURES)
"""
function decl2class(noun::LSNoun)
    decl2class(noun.nomsg, noun.gensg)
end

function decl2class(nom, gen)
    if endswith(gen, "i") && 
        (endswith(nom, "us") || endswith(nom, "um"))
            "us_i"

    elseif endswith(gen, "ri") && 
        endswith(nom, "er") 
            "er_ri"

    elseif endswith(gen, "i") && 
        (endswith(nom, "os")  || endswith(nom, "on"))
                "os_i"            

    elseif endswith(gen, "orum")
        "os_i_pl"

    else
        @warn("Declension 2 conflicts with endings in $(gen) for $(nom)")
           ""
    end
end

"""Find Tabulae class for a third declension noun.
$(SIGNATURES)
"""
function decl3class(noun::LSNoun)
    decl3class(noun.nomsg, noun.gensg)
end

function decl3class(nom, gen)
    if endswith(gen, "onis") && endswith(nom, "o")
        "o_onis"
    elseif endswith(gen, "inis") && endswith(nom, "o")
        "o_inis"
    elseif endswith(gen, "inis") && endswith(nom, "en")
        "en_inis"
    
        
    elseif endswith(gen, "dis") && endswith(nom, "s")
        "s_dis"
    elseif endswith(gen, "itis") && endswith(nom, "es")
        "es_itis"
    elseif endswith(gen, "tis") && endswith(nom, "s")
        "s_tis"
    

    elseif endswith(gen, "icis") && endswith(nom, "ex")
        "ex_icis"
    elseif endswith(gen, "cis") && endswith(nom, "x")
        "x_cis"
     elseif endswith(gen, "gis") && endswith(nom, "x")
        "x_gis"
    
    elseif endswith(gen, "eris") && endswith(nom, "us")
        "us_eris"
    elseif endswith(gen, "oris") && endswith(nom, "us")
        "us_oris"
    
    elseif endswith(gen, "is") && endswith(nom, "is")
        "is_is"
    
    elseif endswith(gen, "is")
        "0_is"

    elseif endswith(gen, "ium") &&
        endswith(nom, "a")
        "i_is_is"

    else 
        @warn("Declension 3 conflicts with endings ($(gen)) for  $(nom)")
        ""
    end
end

"""Find Tabulae class for a fourth declension noun.
$(SIGNATURES)
"""
function decl4class(noun::LSNoun)
    decl4class(noun.nomsg, noun.gensg)
end

function decl4class(nom, gen)
    if endswith(gen, "us") && endswith(nom, "us")
        "us_us"
       
    else
        @warn("Declension 4 conflicts with endings in $(gen)")
        ""
    end
end

"""Find Tabulae class for a fifth declension noun.
$(SIGNATURES)
"""
function decl5class(noun::LSNoun)
    decl5class(noun.nomsg, noun.gensg)
end

function decl5class(nom, gen)
    if endswith(gen, "ei") && endswith(nom, "es")
        "es_ei"
       
    else
        @warn("Declension 5 conflicts with endings in $(gen) for $(nom)")
        ""
    end
end

"""Find Tabulae class for a noun. 
Returns empty string if no class found.
$(SIGNATURES)
"""
function tabulaeclass(noun::LSNoun)
    if noun.declension == 1
        decl1class(noun)

    elseif noun.declension == 2
        decl2class(noun)

    elseif noun.declension == 3
        decl3class(noun)

    elseif noun.declension == 4
        decl4class(noun)

    elseif noun.declension == 5
        decl5class(noun)
    else
        ""
    end
end
