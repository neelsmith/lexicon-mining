"""Compose a delimited-text line defining the
Tabulae stem for a noun.
$(SIGNATURES)    
"""
function cexline(n::LSNoun; divider = "|")  
    lexentity = string("lsx.", n.lsid)
    gender = n.gender
    iclass = tabulaeclass(n)

    
    stem = ""
    
    if n.declension == 1
        if endswith(n.gensg, "ae")
            stem = replace(n.gensg, r"ae$" => "") |> suareznorm
        elseif endswith(n.gensg, "es")
            stem = replace(n.gensg, r"es$" => "") |> suareznorm
        end

    elseif n.declension == 2
        if endswith(n.gensg, "i")
            #@info("DECL: $(n.declension) ends with -i in gensg $(n.gensg)")
            stem = replace(n.gensg, r"i$" => "") |> suareznorm
            #@info("SET STEM TO $(stem)")
        end

    elseif n.declension == 3
        if endswith(n.gensg, "is")
            stem = replace(n.gensg, r"is$" => "") |> suareznorm

        elseif endswith(n.gensg, "ium")
            stem = replace(n.gensg, r"ium$" => "") |> suareznorm
        end

    elseif n.declension == 4
        if endswith(n.gensg, "us")
            stem = replace(n.gensg, r"us$" => "") |> suareznorm
        end

    elseif n.declension == 5
        if endswith(n.gensg, "i")
            stem = replace(n.gensg, r"i$" => "") |> suareznorm
        end
    end                        
   
    if isempty(stem)
        @warn("No stem for noun $(n) of declension $(n.declension)")
        []
    else
        noun_cexlines(n.lsid, lexentity, stem, gender, iclass; divider = divider)
    end
end

function noun_cexlines(id, lexentity, stem, gender, inflclass; divider = "|")
    if iscommon(stem)
        [join(["latcommon.noun$(id)", lexentity, stem, gender, inflclass], divider)]
    else
        l23 = join(["lat23.noun$(id)", lexentity, stem, gender, inflclass], divider)
        l24 = join(["lat24.noun$(id)", lexentity, stem, gender, inflclass], divider)
        l25 = join(["lat25.noun$(id)", lexentity, stem, gender, inflclass], divider)
        [l23, l24, l25]
    end
end


