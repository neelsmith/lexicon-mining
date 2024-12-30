
struct LSAdjective
    lsid
    mascsg
    femsg
    neutsg
end



"""Override Base.show for LSAdjective type.
$(SIGNATURES)
"""
function show(io::IO, a::LSAdjective)
    msg = [a.lsid, 
            " ", 
            a.mascsg, 
            #", ", 
            #n.gensg, 
            #" (",
            #n.declension,
            #"), ", 
            #n.gender
    ]
    print(io, join(msg))
end

"""Override Base.== for gerundive rule type.
$(SIGNATURES)
"""
function ==(a1::LSAdjective, a2::LSAdjective)
    a1.lsid == a2.lsid &&
    a1.mascsg == a2.mascsg &&
    a1.femsg == a2.femsg &&
    a1.neutsg  == a2.neutsg 
end



"""Extract adjective entries from list of data tuples, and format 
adjective morphology in type-specific structure.
$(SIGNATURES)
"""
function adjectives(datatuples)::Vector{LSAdjective}
    adjdata = filter(tpl -> tpl.pos == "adjective", datatuples)

    goodadjs = []

    #for adj in adjdata
    good = map(adjdata) do adj
        shortid = trimid(adj.urn)

        cols = strip.(split(adj.morphology, ","))
        if length(cols) == 3
            (m,f,n) = Unicode.normalize.(cols, stripmark = true)
            LSAdjective(shortid, m, f, n)
        end
    end
    filter(adj -> ! isnothing(adj), good)
end


function tabulaeclass(adj::LSAdjective)
    if endswith(adj.mascsg,"us") && 
    endswith(adj.femsg, "a") &&
    endswith(adj.neutsg, "um")
        "us_a_um"

    elseif  endswith(adj.mascsg,"is") && 
        endswith(adj.femsg, "is") &&
        endswith(adj.neutsg, "e")
        "is_e"

    elseif  endswith(adj.mascsg,"er") && 
        endswith(adj.femsg, "era") &&
        endswith(adj.neutsg, "erum")
        "er_ra_rum"

    elseif  endswith(adj.mascsg,"er") && 
        endswith(adj.femsg, "ris") &&
        endswith(adj.neutsg, "re")
        "er_ris_re"

    elseif  endswith(adj.mascsg,"ns") && 
        endswith(adj.femsg, "ns") &&
        endswith(adj.neutsg, "ns")
        "ns_ntis"

    else
        ""
    end
end

#=
√ "us_a_um"        => 135
√  "is_e"           => 27
 √ "ns_ntis"        => 10
 √ "er_ra_rum"      => 9
  "x_cis"          => 6
  "us_a_um_superl" => 3
  "i_0_is"         => 2
  "0_is"           => 1
  
  "er_era_erum"    => 1
  "er_ris_re"      => 1
  "or_oris_comp"   => 1
  "er_ris"         => 1
  "s_tis"          => 1
=#