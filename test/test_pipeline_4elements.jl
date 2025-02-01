@testset "Test verb pipeline: compound with omitted prefixes" begin
    
    summary = "725|urn:cite2:hmt:ls.markdown:n724|ad-dīco | verb | 3, ad-dīco, -dīxi, -dictum"
    tpl = LexiconMining.readdataline(summary)

end


@testset "Test verb pipeline: infinitive omitted, distinct principal parts given" begin
    summary = "43095|urn:cite2:hmt:ls.markdown:n43092|scrībo | to write, draw, compose, describe | verb  | 3, scrībo, scrīpsi, scrīptum" 
    
    scribo = summary |> LexiconMining.readdataline |> verb
    @test scribo isa LSVerb
    @test scribo.conjugation == 3
    @test scribo.pp1 == "scribo"
    @test scribo.pp2 == "scribere"
    @test scribo.pp3 == "scripsi"
    @test scribo.pp4 == "scriptum"
    @test_broken tabulaeclass(scribo) == "c3pres"

    # NEED TO IMPLEMENT CEXLINE FOR 3RD CONJ
    cex = cexline(scribo)
    @test_broken length(cex) == 3
end

