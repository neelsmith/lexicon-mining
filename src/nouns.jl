struct LSNoun
    lsid
    nomsg
    gensg
    gender
    declension::Int
end


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
function nouns(datatuples)
    noundata = filter(tpl -> lowercase(strip(tpl.pos)) == "noun", datatuples)
    map(noundata) do tpl
        cols = split(tpl.morphology,",")
        if length(cols) > 2
            nsraw = cols[1]
            gsraw = cols[2]
            genderraw = cols[3]
            ns = Unicode.normalize(strip(nsraw), stripmark = true)
            gs = Unicode.normalize(strip(gsraw), stripmark = true)
            gender = normalizegender(genderraw)
            shortid = replace(tpl.urn, r"[^:]+:" => "")
    
            decl = if endswith(gs, "ae")
                1
            elseif endswith(gs, "is")
                3
            elseif endswith(gs, "us")
                4
            elseif endswith(gs,"ei") && endswith(ns,"es")
                5
            elseif endswith(gs, "i")
                2
            else
                0
            end
            LSNoun(shortid, ns, gs, gender, decl)
        
        else
            @warn("$(tpl.urn): wrong number of columns for noun")
            nothing
        end
    end    
end
