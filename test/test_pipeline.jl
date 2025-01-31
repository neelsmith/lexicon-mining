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

@testset "Test pipeline" begin
    summary = "15|urn:cite2:hmt:ls.markdown:n14|ăb-aestŭo |to hang down richly |verb  |1, ab-aestuo, -āvi, -ātum"
    tpl = LexiconMining.readdataline(summary)
    abaestuo = verb(tpl) 
end

@testset "Test verb pipeline: compound with omitted prefixes" begin
    
    summary = "725|urn:cite2:hmt:ls.markdown:n724|ad-dīco | verb | 3, ad-dīco, -dīxi, -dictum"
    tpl = LexiconMining.readdataline(summary)

end

@testset "Test verb pipeline: distinct principal parts all given" begin
    summary = "43095|urn:cite2:hmt:ls.markdown:n43092|scrībo | to write, draw, compose, describe | verb  | 3, scrībo, scrīpsi, scrīptum"
    tpl = summary |> LexiconMining.readdataline
    scribo = verb(tpl)

    @test scribo isa LSVerb
end

#=
10897|urn:cite2:hmt:ls.markdown:n10896|con-tremo | to tremble greatly, to quake | verb  | 3, con-tremo, -tremui

10880|urn:cite2:hmt:ls.markdown:n10879|contrā-pōno|to place opposite, oppose to|verb |3, contrā-pōno, -ere, -posui, -positum

summary = "10429|urn:cite2:hmt:ls.markdown:n10428|conscio|to be conscious of, to know well|verb |4, con-scīre, -scīvī, -scītum"

15|urn:cite2:hmt:ls.markdown:n14|ăb-aestŭo |to hang down richly |verb  |1, ab-aestuo, -āvi, -ātum


=#