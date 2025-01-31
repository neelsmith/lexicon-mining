@testset "Expand various forms of elision in glossary entries" begin
    elision = joinpair("ab-aestuo")
    #=
    function joinpair(prefix, glossform)
        if startswith(glossform, "-")
            string(prefix, glossform[2:end])
        else
            glossform
        end
    end
   =# 
end