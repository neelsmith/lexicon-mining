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
        @warn("Invalid value for gender: $(s)")
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
            shortid = trimid(tpl.urn)
    
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
                (endswith(ns, "es") || endswith(ns, "um"))
                3
            elseif endswith(gs, "us")
                4
            elseif endswith(gs,"ei") && endswith(ns,"es")
                5
            #elseif endswith(gs,"es") && endswith(ns,"es")

            elseif endswith(gs, "i")
                2

            elseif endswith(gs, "es") && endswith(ns, "e")
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


"""Find Tabulae class for a first declension noun.
$(SIGNATURES)
"""
function decl1class(noun::LSNoun)
    if endswith(noun.gensg, "ae") && endswith(noun.nomsg, "a")
            "a_ae"
    elseif endswith(noun.gensg, "ae") && endswith(noun.nomsg, "as")
            "as_ae"
    elseif endswith(noun.gensg, "es") && endswith(noun.nomsg, "e")
            "e_es"            
    else
            @warn("Declension $(noun.declension) conflicts with endings in $(noun)")
            ""
    end
end

"""Find Tabulae class for a second declension noun.
$(SIGNATURES)
"""
function decl2class(noun::LSNoun)
    if endswith(noun.gensg, "i") && 
        (endswith(noun.nomsg, "us") || endswith(noun.nomsg, "um"))
            "us_i"

    elseif endswith(noun.gensg, "ri") && 
        endswith(noun.nomsg, "er") 
            "er_ri"

    elseif endswith(noun.gensg, "i") && 
        (endswith(noun.nomsg, "os")  || endswith(noun.nomsg, "on"))
                "os_i"            

    else
        @warn("Declension $(noun.declension) conflicts with endings in $(noun)")
           ""
    end
end

"""Find Tabulae class for a third declension noun.
$(SIGNATURES)
"""
function decl3class(noun::LSNoun)
    
    if endswith(noun.gensg, "onis") && endswith(noun.nomsg, "o")
        "o_onis"
    elseif endswith(noun.gensg, "inis") && endswith(noun.nomsg, "o")
        "o_inis"
    elseif endswith(noun.gensg, "inis") && endswith(noun.nomsg, "en")
        "en_inis"
    
        
    elseif endswith(noun.gensg, "dis") && endswith(noun.nomsg, "s")
        "s_dis"
    elseif endswith(noun.gensg, "itis") && endswith(noun.nomsg, "es")
        "es_itis"
    elseif endswith(noun.gensg, "tis") && endswith(noun.nomsg, "s")
        "s_tis"
    

    elseif endswith(noun.gensg, "icis") && endswith(noun.nomsg, "ex")
        "ex_icis"
    elseif endswith(noun.gensg, "cis") && endswith(noun.nomsg, "x")
        "x_cis"
     elseif endswith(noun.gensg, "gis") && endswith(noun.nomsg, "x")
        "x_gis"
    
    elseif endswith(noun.gensg, "eris") && endswith(noun.nomsg, "us")
        "us_eris"
    elseif endswith(noun.gensg, "oris") && endswith(noun.nomsg, "us")
        "us_oris"
    
    elseif endswith(noun.gensg, "is") && endswith(noun.nomsg, "is")
        "is_is"
    
    elseif endswith(noun.gensg, "is")
        "0_is"
    else 
        @warn("Declension $(noun.declension) conflicts with endings in $(noun)")
        ""
    end
end

"""Find Tabulae class for a fourth declension noun.
$(SIGNATURES)
"""
function decl4class(noun::LSNoun)
    if endswith(noun.gensg, "us") && endswith(noun.nomsg, "us")
        "us_us"
       
    else
        @warn("Declension $(noun.declension) conflicts with endings in $(noun)")
        ""
    end
end

"""Find Tabulae class for a fifth declension noun.
$(SIGNATURES)
"""
function decl5class(noun::LSNoun)
    if endswith(noun.gensg, "ei") && endswith(noun.nomsg, "es")
        "es_ei"
       
    else
        @warn("Declension $(noun.declension) conflicts with endings in $(noun)")
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

#=
    √√ "us_i"     => 175
    √√  "a_ae"     => 127
    √  "o_onis"   => 49

    √  "s_tis"    => 42
    √  "us_us"    => 40
    √  "is_is"    => 19
    √  "o_inis"   => 13
    √  "en_inis"  => 13
      "us_oris"  => 9
    √  "x_cis"    => 9
    √  "er_ri"    => 8
    √   "es_itis"  => 8
    √  "es_ei"    => 7
      "us_eris"  => 7
    √  "s_dis"    => 5
      "er_ris"   => 5
      "i_is_is"  => 5
      "s_is"     => 5
      "i_s_tis"  => 4
     √ "x_gis"    => 4
      "es_is"    => 4
      "s_ris"    => 4
      "i_es_is"  => 2
      "0_i"      => 2
      "eps_ipis" => 1
      "0_tis"    => 1
      "0_dis"    => 1
      "e_es"     => 1
      "i_0_is"   => 1
      "i_er_ris" => 1
      "x_ctis"   => 1
      "ut_itis"  => 1
      "s_nis"    => 1
      √ "ex_icis"  => 1
      ""         => 1
      "os_i"     => 1
      "0_is"     => 43   
=#
    






