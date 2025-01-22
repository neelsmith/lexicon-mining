"""Compose a delimited-text line defining the
Tabulae stem for a noun.
$(SIGNATURES)    
"""
function cexline(n::LSNoun; divider = "|")        
    if tabulaeclass(n) == "a_ae"
        noun_a_ae_cex(n; divider = divider)
    elseif tabulaeclass(n) == "us_i"
    noun_us_i_cex(n; divider = divider)        
    else
        ""
    end
end


function noun_a_ae_cex(n::LSNoun; divider = "|")
    lexentity = string("lsx.", n.lsid)
    gender = n.gender

    stem1 = replace(n.gensg, r"ae$" => "")
    stem = suareznorm(stem1)
    

    if iscommon(stem)
        [join(["latcommon.noun$(n.lsid)", lexentity, stem, gender, "a_ae"], divider)]
    else
        l23 = join(["lat23.noun$(n.lsid)", lexentity, stem, gender, "a_ae"], divider)
        l24 = join(["lat24.noun$(n.lsid)", lexentity, stem, gender, "a_ae"], divider)
        l25 = join(["lat25.noun$(n.lsid)", lexentity, stem, gender, "a_ae"], divider)
        [l23, l24, l25]
    end
end


function noun_us_i_cex(n::LSNoun; divider = "|")
    lexentity = string("lsx.", n.lsid)
    gender = n.gender

    stem1 = replace(n.gensg, r"i$" => "")
    stem = suareznorm(stem1)

    if iscommon(stem)
        [join(["latcommon.noun$(n.lsid)", lexentity, stem, gender, "us_i"], divider)]
    else
        l23 = join(["lat23.noun$(n.lsid)", lexentity, stem, gender, "us_i"], divider)
        l24 = join(["lat24.noun$(n.lsid)", lexentity, stem, gender, "us_i"], divider)
        l25 = join(["lat25.noun$(n.lsid)", lexentity, stem, gender, "us_i"], divider)
        [l23, l24, l25]
    end
end