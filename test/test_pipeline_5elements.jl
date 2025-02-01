#=Five elements to morphology:

 n18 abalieno (1) abalienare, abalienavi, abalienatum
 √ n39 ab-brevio (1) ab-breviare, ab-breviavi, ab-breviatum
 n100 ab-jungo (3) -jungere, -junxi, -junctum
=#
@testset "Test pipeline for verb: regular first conjugation with 5 elements given in morphology property" begin
    summary = "40|urn:cite2:hmt:ls.markdown:n39|ab-brevio |to shorten, abridge |verb  |1, ab-brevio, ab-breviare, ab-breviavi, ab-breviatum"
    tpl = LexiconMining.readdataline(summary)
    abbrevio = verb(tpl)

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




@testset "Test pipeline: regular first conjugation with 5 elements given in morphology property, guyt some elements abbreviated" begin
    summary = "15|urn:cite2:hmt:ls.markdown:n14|ăb-aestŭo |to hang down richly |verb  |1, ab-aestuo, -āvi, -ātum"
    tpl = LexiconMining.readdataline(summary)
    abaestuo = verb(tpl) 
end



@testset "Test verb pipeline: distinct principal parts all given" begin
    summary = "43095|urn:cite2:hmt:ls.markdown:n43092|scrībo | to write, draw, compose, describe | verb  | 3, scrībo, scrīpsi, scrīptum"
    tpl = summary |> LexiconMining.readdataline
    scribo = verb(tpl)

    @test scribo isa LSVerb
end
 #88|urn:cite2:hmt:ls.markdown:n87|abigo |to drive away |verb  |3, abigo, abigere, abegi, abactum
#=
10897|urn:cite2:hmt:ls.markdown:n10896|con-tremo | to tremble greatly, to quake | verb  | 3, con-tremo, -tremui

10880|urn:cite2:hmt:ls.markdown:n10879|contrā-pōno|to place opposite, oppose to|verb |3, contrā-pōno, -ere, -posui, -positum

summary = "10429|urn:cite2:hmt:ls.markdown:n10428|conscio|to be conscious of, to know well|verb |4, con-scīre, -scīvī, -scītum"

15|urn:cite2:hmt:ls.markdown:n14|ăb-aestŭo |to hang down richly |verb  |1, ab-aestuo, -āvi, -ātum

51435|urn:cite2:hmt:ls.markdown:n51432|vulpīnor|to play the fox, be sly|verb |1, vulpīnōr, vulpīnārī, vulpīnātus

=#




@testset "Test pipeline: deponent verb with first and fourth parts given" begin
    summary = "28950|urn:cite2:hmt:ls.markdown:n28947|mētĭor|to measure, mete out or distribute|verb |4 ,mētĭor, mensus"
    tpl = LexiconMining.readdataline(summary)
    @test tpl.pos == "verb"
    @test tpl.urn == "urn:cite2:hmt:ls.markdown:n28947"
    @test tpl.lemma == "mētĭor"
    @test tpl.seq == 28950
    @test tpl.definition == "to measure, mete out or distribute"
    @test tpl.morphology == "4 ,mētĭor, mensus"


    metior = verb(tpl)
    @test metior isa LSVerb
    @test metior.conjugation == 4
    @test metior.pp1 == "metior"
    @test metior.pp2 == "metiri"
    @test isempty(metior.pp3)
    @test metior.pp4 == "mensus"
    @test tabulaeclass(metior) == "c4presdep"
    
end

