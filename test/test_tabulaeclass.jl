@testset "Test assignment of Tabulae inflectional class to verbs" begin
    abbrevio = LexiconMining.readdataline("40|urn:cite2:hmt:ls.markdown:n39|ab-brevio |to shorten, abridge |verb  |1, ab-brevio, ab-breviare, ab-breviavi, ab-breviatum")   |> verb
    @test tabulaeclass(abbrevio) == "conj1"

    abaestuo = "15|urn:cite2:hmt:ls.markdown:n14|ăb-aestŭo |to hang down richly |verb  |1, ab-aestuo, -āvi, -ātum" |> LexiconMining.readdataline |> verb
    @test tabulaeclass(abaestuo) == "conj1"
     


end