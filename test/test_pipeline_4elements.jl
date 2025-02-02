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

@testset "Test verb pipeline: infinitive omitted, regular third conjugation" begin
    summary = "9135|urn:cite2:hmt:ls.markdown:n9134|cŏlo|to cultivate, inhabit, worship|verb |3,cŏlo,colŭi,cultum"

    colo = summary |> LexiconMining.readdataline |> verb
    @test colo isa LSVerb
    @test colo.conjugation == 3
    @test colo.pp1 == "colo"
    @test colo.pp2 == "colere"
    @test colo.pp3 == "colui"
    @test colo.pp4 == "cultum"
    @test_broken tabulaeclass(scribo) == "conj3"

    # NEED TO IMPLEMENT CEXLINE FOR 3RD CONJ
    cex = cexline(colo)
    #@test_broken length(cex) == 3
end

#51435|urn:cite2:hmt:ls.markdown:n51432|vulpīnor|to play the fox, be sly|verb |1, vulpīnōr, vulpīnārī, vulpīnātus
#15|urn:cite2:hmt:ls.markdown:n14|ăb-aestŭo |to hang down richly |verb  |1, ab-aestuo, -āvi, -ātum
#summary = "10429|urn:cite2:hmt:ls.markdown:n10428|conscio|to be conscious of, to know well|verb |4, con-scīre, -scīvī, -scītum"
# 