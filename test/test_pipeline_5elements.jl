
@testset "Test pipeline for verb: regular first conjugation with 5 elements given in morphology property" begin
    summary = "40|urn:cite2:hmt:ls.markdown:n39|ab-brevio |to shorten, abridge |verb  |1, ab-brevio, ab-breviare, ab-breviavi, ab-breviatum"


    abbrevio = LexiconMining.readdataline(summary) |> verb
    @test abbrevio isa LSVerb
    @test abbrevio.conjugation == 1
    @test abbrevio.pp1 == "ab-brevio"
    @test abbrevio.pp2 == "ab-breviare"
    @test abbrevio.pp3 == "ab-breviavi"
    @test abbrevio.pp4 == "ab-breviatum"
    @test tabulaeclass(abbrevio) == "conj1"

    cex = cexline(abbrevio)
    # -v in stem requires orthography-specific entries:
    @test length(cex) == 3
end

@testset "Test pipeline: regular first conjugation with 5 elements given in morphology property, but some elements abbreviated" begin

    summary = "15|urn:cite2:hmt:ls.markdown:n14|ăb-aestŭo |to hang down richly |verb  |1, ab-aestuo, -āvi, -ātum"

    abaestuo = LexiconMining.readdataline(summary) |> verb
    @test abaestuo isa LSVerb
    @test abaestuo.conjugation == 1
    @test abaestuo.pp1 == "ab-aestuo"
    @test abaestuo.pp2 == "ab-aestuare"
    @test abaestuo.pp3 == "abaestuavi"
    @test abaestuo.pp4 == "abaestuatum"
    @test tabulaeclass(abaestuo) == "conj1"
    
    cex = cexline(abaestuo)
    @test cex == ["latcommon.verbn14|lsx.n14|abaestu|conj1|Automatically generated"]
end


@testset "Test pipeline: verb with distinct principal parts explicitly given" begin

    summary = "88|urn:cite2:hmt:ls.markdown:n87|abigo |to drive away |verb  |3, abigo, abigere, abegi, abactum"

    abigo = LexiconMining.readdataline(summary) |> verb
    @test abigo isa LSVerb
    @test abigo.conjugation == 3
    @test abigo.pp1 == "abigo"
    @test abigo.pp2 == "abigere"
    @test abigo.pp3 == "abegi"
    @test abigo.pp4 == "abactum"
    @test tabulaeclass(abigo) == "c3pres"
    
    cex = cexline(abigo)
    @test_broken length(cex) == 3
end



 @testset "Test pipeline for verb: regular third conjugation with 5 elements given in morphology property" begin
    summary = "35825|urn:cite2:hmt:ls.markdown:n35822|peto|to attack, seek, or request|verb |3,peto, petere, petivi, petitum"

    peto = LexiconMining.readdataline(summary) |> verb
    @test peto isa LSVerb
    @test peto.conjugation == 3
    @test peto.pp1 == "peto"
    @test peto.pp2 == "petere"
    @test peto.pp3 == "petivi"
    @test peto.pp4 == "petitum"
    @test tabulaeclass(peto) == "conj3"
 end

#10880|urn:cite2:hmt:ls.markdown:n10879|contrā-pōno|to place opposite, oppose to|verb |3, contrā-pōno, -ere, -posui, -positum
# "51263|urn:cite2:hmt:ls.markdown:n51260|vōcĭfĕro|rare form of vociferor|verb |1,vōcĭfĕro,vōcĭfĕrāre,-,-"






