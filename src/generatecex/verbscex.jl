function principalparts_cex(verb; divider = "|")
    ""
end


function conj4ok(verb)
    true
end

function conj3ok(verb)
    false
end

function conj2ok(verb)
    true
end

function conj1ok(verb)
    true
end

function conj3_cex(verb; divider = "|")
    if conj3ok(verb)
        ""
    else
        principalparts_cex(verb)
    end
end

function conj4_cex(verb; divider = "|")
    if conj4ok(verb)
        lexentity = string("lsx.", verb.lsid)
        stem = replace(verb.pp1, r"or?$" => "") |> suareznorm
        conj = endswith(stem, "or") ? "conj4dep" : "conj4"
        note = "Automatically generated"
        if iscommon(stem)
            
            [join(["latcommon.verb$(verb.lsid)", lexentity, stem, conj, note], divider)]
        else
            l23 = join(["lat23.verb$(verb.lsid)", lexentity, stem, conj, note], divider)
            l24 = join(["lat24.verb$(verb.lsid)", lexentity, stem,  conj, note], divider)
            l25 = join(["lat25.verb$(verb.lsid)", lexentity, stem,  conj, note], divider)
            [l23, l24, l25]
        end
    else
        principalparts_cex(verb)
    end
end


function conj2_cex(verb; divider = "|")
    if conj2ok(verb)
        #StemUrn|LexicalEntity|StemString|MorphologicalClass|Notes
        lexentity = string("lsx.", verb.lsid)
        stem = replace(verb.pp1, r"or?$" => "") |> suareznorm
        conj = endswith(stem, "or") ? "conj2dep" : "conj2"
        note = "Automatically generated"
        if iscommon(stem)
            
            [join(["latcommon.verb$(verb.lsid)", lexentity, stem, conj, note], divider)]
        else
            l23 = join(["lat23.verb$(verb.lsid)", lexentity, stem, conj, note], divider)
            l24 = join(["lat24.verb$(verb.lsid)", lexentity, stem,  conj, note], divider)
            l25 = join(["lat25.verb$(verb.lsid)", lexentity, stem,  conj, note], divider)
            [l23, l24, l25]
        end
    else
        principalparts_cex(verb)
    end
end


"""Create CEX for a regular 1st-conjugation verb.
$(SIGNATURES)
"""
function conj1_cex(verb; divider = "|")
    if conj1ok(verb)
        #StemUrn|LexicalEntity|StemString|MorphologicalClass|Notes
        lexentity = string("lsx.", verb.lsid)
        stem = replace(verb.pp1, r"or?$" => "") |> suareznorm
        conj = endswith(stem, "or") ? "conj1dep" : "conj1"
        note = "Automatically generated"
        if iscommon(stem)
            
            [join(["latcommon.verb$(verb.lsid)", lexentity, stem, conj, note], divider)]
        else
            l23 = join(["lat23.verb$(verb.lsid)", lexentity, stem, conj, note], divider)
            l24 = join(["lat24.verb$(verb.lsid)", lexentity, stem,  conj, note], divider)
            l25 = join(["lat25.verb$(verb.lsid)", lexentity, stem,  conj, note], divider)
            [l23, l24, l25]
        end
    else
        principalparts_cex(verb, divider = divider)
    end
end