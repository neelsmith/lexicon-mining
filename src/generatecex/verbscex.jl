
"""True if a principal part is explicitly marked as missing.
$(SIGNATURES)
"""
function missingpart(verb::LSVerb)
    verb.pp1 == "–" || verb.pp1 == "-" ||
    verb.pp2 == "–" || verb.pp2 == "-" ||
    verb.pp3 == "–" || verb.pp3 == "-" ||
    verb.pp4 == "–" || verb.pp4 == "-" 

end


"""Compose CEX lines for a verb stem.
$(SIGNATURES)
"""
function verb_cexlines(id, lexentity, stem, conj, note; divider = "|")        
    if iscommon(stem)
        [join(["latcommon.verb$(id)", lexentity, stem, conj, note], divider)]
    else
        l23 = join(["lat23.verb$(id)", lexentity, stem, conj, note], divider)
        l24 = join(["lat24.verb$(id)", lexentity, stem,  conj, note], divider)
        l25 = join(["lat25.verb$(id)", lexentity, stem,  conj, note], divider)
        [l23, l24, l25]
    end
end


function principalparts_cex(verb; divider = "|")
    
    presstem_cex(verb; divider = divider)
    pftactstem_cex(verb; divider = divider)
    pftpassstem_cex(verb; divider = divider)
    
end

function presstem_cex(verb; divider = "|")
    if verb.pp1 == "–" || verb.pp1 == "-" 
        []
    else
        lexentity = string("lsx.", verb.lsid)
        stem = replace(verb.pp1, r"or?$" => "") |> suareznorm
        conj = presentconj(verb)
        note = "Automatically generated"
        verb_cexlines(verb.lsid, lexentity, stem, conj, note; 
        divider = divider)
    end
end

function pftactstem_cex(verb; divider = "|")
    if verb.pp3 == "–" || verb.pp3 == "-" 
        []
    else
        lexentity = string("lsx.", verb.lsid)
        stem = replace(verb.pp3, r"i$" => "") |> suareznorm
        note = "Automatically generated"
        verb_cexlines(verb.lsid, lexentity, stem, "pftact", note; 
        divider = divider)
    end
end
function pftpassstem_cex(verb; divider = "|")
    if verb.pp4 == "–" || verb.pp4 == "-"
        []
    else
        lexentity = string("lsx.", verb.lsid)
        stem = replace(verb.pp4, r"tu[ms]$" => "t") |> suareznorm
        note = "Automatically generated"
        verb_cexlines(verb.lsid, lexentity, stem, "pftpass", note; 
        divider = divider)
    end
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
    lexentity = string("lsx.", verb.lsid)
    stem = replace(verb.pp1, r"or?$" => "") |> suareznorm
    note = "Automatically generated"

    if conj4ok(verb) 
        conj = endswith(stem, "or") ? "conj4dep" : "conj4"
        verb_cexlines(verb.lsid, lexentity, stem, conj, note; 
        divider = divider)

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
        verb_cexlines(verb.lsid, lexentity, stem, conj, note; 
        divider = divider)

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
        verb_cexlines(verb.lsid, lexentity, stem, conj, note; 
        divider = divider)

    else
        principalparts_cex(verb; divider = divider)
    end
end