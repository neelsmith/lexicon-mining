
function us_a_um_cex(adj::LSAdjective; divider = "|")
    #StemUrn|LexicalEntity|Stem|InflClass
    lexentity = string("lsx.", adj.lsid)


    stem = replace(adj.mnomsg, r"us$" => "") |> suareznorm
    
    if iscommon(stem)
        [join(["latcommon.adj$(adj.lsid)", lexentity, stem, "us_a_um"], divider)]
    else
        l23 = join(["lat23.adj$(adj.lsid)", lexentity, stem, "us_a_um"], divider)
        l24 = join(["lat24.adj$(adj.lsid)", lexentity, stem,  "us_a_um"], divider)
        l25 = join(["lat25.adj$(adj.lsid)", lexentity, stem,  "us_a_um"], divider)
        [l23, l24, l25]
    end
end