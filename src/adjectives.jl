"""Structure of an adjective read from Lewis-Short."""
struct LSAdjective
    lsid
    mnomsg
    mgensg
    fnomsg
    fgensg
    nnomsg
    ngensg
    tabulaeclass
end



"""Override Base.show for LSAdjective type.
$(SIGNATURES)
"""
function show(io::IO, a::LSAdjective)
    msg = string(a.lsid, " ", label(a))
    print(io, msg)
end

"""Compose a label for an `LSAdjective`.
$(SIGNATURES)
"""
function label(a::LSAdjective)
    if a.tabulaeclass == "us_a_um"
        join([a.mnomsg, a.fnomsg, a.nnomsg], ", ")

    elseif a.tabulaeclass == "is_e"
        join([a.mnomsg, a.nnomsg], ", ")

    elseif a.tabulaeclass == "ns_ntis"
        join([a.mnomsg, a.mgensg], ", ")

    else
        string(a.mnomsg, " of tabulae class ", a.tabulaeclass)
    end
end

"""Override Base.== for LSAdjective type.
$(SIGNATURES)
"""
function ==(a1::LSAdjective, a2::LSAdjective)
    a1.lsid == a2.lsid &&
    a1.mascsg == a2.mascsg &&
    a1.femsg == a2.femsg &&
    a1.neutsg  == a2.neutsg 
end


"""Remove extraneous parenthetic notes from masculine gender strings.
$(SIGNATURES)
"""
function tidymasculine(adjstring)
    normed = Unicode.normalize(adjstring, stripmark = true)
    strip1 = replace(normed, "(m)" => "")
    strip2 = replace(strip1, "(masc)" => "")
    replace(strip2, "(masc.)" => "")
end

"""Remove extraneous parenthetic notes from feminine gender strings.
$(SIGNATURES)
"""
function tidyfeminine(adjstring)
    normed = Unicode.normalize(adjstring, stripmark = true)
    strip1 = replace(normed, "(f)" => "")
    strip2 = replace(strip1, "(fem)" => "")
    replace(strip2, "(fem.)" => "")
end

"""Remove extraneous parenthetic notes from neuter gender strings.
$(SIGNATURES)
"""
function tidyneuter(adjstring)
    normed = Unicode.normalize(adjstring, stripmark = true)
    strip1 = replace(normed, "(n)" => "")
    strip2 = replace(strip1, "(neut)" => "")
    replace(strip2, "(neut.)" => "")
end



"""Extract adjective entries from a list of data tuples, and format 
adjective morphology in type-specific structure.
$(SIGNATURES)
"""
function adjectives(datatuples; includebad=false)#::Vector{LSAdjective}
    adjdata = filter(tpl -> tpl.pos == "adjective", datatuples)
    
    #
    good = LSAdjective[]
    bad = []
    #map(adjdata) do adj
    for adj in adjdata
        shortid = trimid(adj.urn)
        cols = strip.(split(adj.morphology, ","))        
        if length(cols) == 3
            adjform = formadjective(shortid, cols)
            if isnothing(adjform)
                push!(bad, adj)
            else
                push!(good, adjform)
            end        
        end
    end
    if includebad
        (good, bad)
    else
        good
    end
end



"""Find Tabulae class for an adjective.
$(SIGNATURES)
"""
function tabulaeclass(adj::LSAdjective)
    adj.tabulaeclass
end


"""Form an adjective from an ID value and three columns of morphological data.
$(SIGNATURES)
"""
function formadjective(id, cols)::LSAdjective
    col1 = Unicode.normalize(cols[1]; stripmark = true)
    col2 = Unicode.normalize(cols[2]; stripmark = true)
    col3 = Unicode.normalize(cols[3]; stripmark = true)
    if endswith(cols[1],"us") && 
        endswith(cols[2], "a") &&
        endswith(cols[3], "um")
            tabclass = "us_a_um"
            mnomsg = tidymasculine(cols[1])
            mgensg = replace(mnomsg, r"us$" => "i")

            fnomsg = tidyfeminine(cols[2])
            fgensg = replace(fnomsg, r"a$" => "ae")

            nnomsg = replace(mnomsg, r"s$" => "m")
            ngensg = mgensg

            LSAdjective(id,
            mnomsg, mgensg,
            fnomsg, fgensg,
            nnomsg, ngensg,
            tabclass)

    elseif  endswith(col1,"is") && 
            endswith(col2, "is") &&
            endswith(col3, "e")
            tabclass = "is_e"

            mnomsg = tidymasculine(cols[1])
            mgensg = mnomsg

            fnomsg = tidyfeminine(cols[2])
            fgensg = fnomsg

            nnomsg = tidyneuter(cols[3])
            ngensg = mgensg

            LSAdjective(id,
            mnomsg, mgensg,
            fnomsg, fgensg,
            nnomsg, ngensg,
            tabclass)

    elseif  endswith(cols[1],"er") && 
            endswith(cols[2], "era") &&
            endswith(cols[3], "erum")
            tabclass = "er_era_erum"            

            mnomsg = tidymasculine(cols[1])
            mgensg = mnomsg * "i"

            fnomsg = tidyfeminine(cols[2])
            fgensg = fnomsg * "e"

            nnomsg = tidyneuter(cols[3])
            ngensg = mgensg

            LSAdjective(id,
            mnomsg, mgensg,
            fnomsg, fgensg,
            nnomsg, ngensg,
            tabclass)


    elseif  endswith(cols[1],"er") && 
            endswith(cols[2], "ra") &&
            endswith(cols[3], "rum")
            tabclass = "er_ra_rum"            

            mnomsg = tidymasculine(cols[1])
            mgensg = mnomsg * "i"

            fnomsg = tidyfeminine(cols[2])
            fgensg = fnomsg * "e"

            nnomsg = tidyneuter(cols[3])
            ngensg = mgensg

            LSAdjective(id,
            mnomsg, mgensg,
            fnomsg, fgensg,
            nnomsg, ngensg,
            tabclass)  
            
            
    elseif  endswith(cols[1],"er") && 
            endswith(cols[2], "ris") &&
            endswith(cols[3], "re")
            tabclass = "er_ris_re"

            mnomsg = tidymasculine(cols[1])
            mgensg = mnomsg * "is"

            fnomsg = tidyfeminine(cols[2])
            fgensg = mgensg

            nnomsg = tidyneuter(cols[3])
            ngensg = mgensg

            LSAdjective(id,
            mnomsg, mgensg,
            fnomsg, fgensg,
            nnomsg, ngensg,
            tabclass)  


    elseif  endswith(cols[1],"ns") && 
            endswith(cols[2], "ns") &&
            endswith(cols[3], "ns")
            tabclass = "ns_ntis"

            mnomsg = tidymasculine(cols[1])
            mgensg = replace(mnomsg, r"ns" => "ntis")

            fnomsg = tidyfeminine(cols[2])
            fgensg = mgensg

            nnomsg = tidyneuter(cols[3])
            ngensg = mgensg

            LSAdjective(id,
            mnomsg, mgensg,
            fnomsg, fgensg,
            nnomsg, ngensg,
            tabclass)   

    else
        LSAdjective(id, 
        cols[1], nothing,
        nothing, nothing,
        nothing, nothing,
        nothing
        
        )

    end
end


#=
x√ "us_a_um"        => 135
x√  "is_e"           => 27
x √ "ns_ntis"        => 10
 x√ "er_ra_rum"      => 9

x√  "er_era_erum"    => 1
x√  "er_ris_re"      => 1



  "x_cis"          => 6
  "us_a_um_superl" => 3
  "i_0_is"         => 2
  "0_is"           => 1
  

  "or_oris_comp"   => 1
  "er_ris"         => 1
  "s_tis"          => 1
=#




function cexline(adj::LSAdjective; divider = "|") 
    iclass = tabulaeclass(adj)
    @info("LOOK AT ADJ $(adj) class $(iclass)")
    
    if  iclass == "us_a_um"
        us_a_um_cex(adj; divider = divider)

    elseif iclass == "is_e"
        is_e_cex(adj; divider = divider)

        
    else
        ""
    end    
end




function cextable(adjslist::Vector{LSAdjective}, ortho = "latcommon"; divider = "|")
    hdr = join(
        ["StemUrn", "LexicalEntity", "Stem", "InflClass"], 
        divider)
        
    cexlines = cexline.(adjslist; divider = divider) |> Iterators.flatten |> collect
    
    ortholines = filter(ln -> occursin(ortho, ln), cexlines)
    string(
        hdr,
        "\n",
        join(ortholines, "\n")
    )
end