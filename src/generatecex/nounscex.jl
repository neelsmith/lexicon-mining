"""Compose a delimited-text line defining the
Tabulae stem for a noun.
$(SIGNATURES)    
"""
function tabulaecex(n::LSNoun; divider = "|")        
    if tabulaeclass(n) == "a_ae"
        noun_a_ae_cex(n; divider = divider)
    elseif tabulaeclass(n) == "us_i"
    noun_us_i_cex(n; divider = divider)        
    else
        ""
    end
end


function noun_a_ae_cex(n::LSNoun; divider = "|")
    ds = latindataset(n)
    stemurn = string(ds, ".noun", n.lsid)
    lexentity = string("ls.", n.lsid)
    stem = replace(n.gensg, r"ae$" => "")
    gender = n.gender
    join([stemurn, lexentity, stem, gender], divider)
end



function noun_us_i_cex(n::LSNoun; divider = "|")
    ds = latindataset(n)
    stemurn = string(ds, ".noun", n.lsid)
    lexentity = string("ls.", n.lsid)
    stem = replace(n.gensg, r"i$" => "")
    gender = n.gender
    join([stemurn, lexentity, stem, gender], divider)
end