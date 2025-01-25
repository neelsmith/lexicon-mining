
function adj_cexlines(id, lexentity, stem,  inflclass; divider = "|")
    if iscommon(stem)
        [join(["latcommon.adj$(id)", lexentity, stem, inflclass], divider)]
    else
        l23 = join(["lat23.adj$(id)", lexentity, stem, inflclass], divider)
        l24 = join(["lat24.adj$(id)", lexentity, stem,  inflclass], divider)
        l25 = join(["lat25.adj$(id)", lexentity, stem,  inflclass], divider)
        [l23, l24, l25]
    end
end


function us_a_um_cex(adj::LSAdjective; divider = "|")
    #StemUrn|LexicalEntity|Stem|InflClass
    lexentity = string("lsx.", adj.lsid)
    stem = replace(adj.mnomsg, r"us$" => "") |> suareznorm
    adj_cexlines(adj.lsid, lexentity, stem,  "us_a_um")
end




function is_e_cex(adj::LSAdjective; divider = "|")
    #StemUrn|LexicalEntity|Stem|InflClass
    lexentity = string("lsx.", adj.lsid)
    stem = replace(adj.mnomsg, r"is$" => "") |> suareznorm
    adj_cexlines(adj.lsid, lexentity, stem,  "is_e")
end






function er_ra_rum_cex(adj::LSAdjective; divider = "|")
    #StemUrn|LexicalEntity|Stem|InflClass
    lexentity = string("lsx.", adj.lsid)
    stem = replace(adj.fnomsg, r"a$" => "") |> suareznorm
    adj_cexlines(adj.lsid, lexentity, stem,  "er_ra_rum")
end


function er_era_erum_cex(adj::LSAdjective; divider = "|")
    #StemUrn|LexicalEntity|Stem|InflClass
    lexentity = string("lsx.", adj.lsid)
    stem = replace(adj.fnomsg, r"a$" => "") |> suareznorm
    adj_cexlines(adj.lsid, lexentity, stem,  "er_era_erum")
end