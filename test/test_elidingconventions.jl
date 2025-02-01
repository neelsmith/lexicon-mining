@testset "Form present stem correctly depending on conjugation" begin
    @test LexiconMining.presentstem(1, "ab-brevio") == "abbrevi"
    @test LexiconMining.presentstem(2, "abolĕo") == "abol"
    @test LexiconMining.presentstem(3, "ab-ŏlesco") == "abolesc"
    @test LexiconMining.presentstem(3, "abripio") == "abrip"
    @test LexiconMining.presentstem(4, "abortio") == "abort"
end


@testset "Expand various forms of elision in glossary entries" begin

    abaestuo = ("ab-aestuo", "abaestuare", "abaestuāvi", "abaestuatum")
    @test LexiconMining.expand_elisions(1, "ab-aestuo", "-are", "-āvi", "-ātum")  == abaestuo
    

    abolesco = ("ab-ŏlesco", "abŏlescere", "abŏlēvī", "—")
    @test LexiconMining.expand_elisions(1,"ab-ŏlesco", "-ŏlescere", "-ŏlēvī", "—") == abolesco
    
    abjungo = ("ab-jungo", "abjungere","abjunxi", "abjunctum")
    @test LexiconMining.expand_elisions(3, "ab-jungo", "-jungere", "-junxi", "-junctum") == abjungo

    contrapono = ("contrā-pōno", "contraponere", "contrāposui", "contrāpositum")
    @test LexiconMining.expand_elisions(3, "contrā-pōno", "-ere", "-posui", "-positum") == contrapono

    abomino = ("ăbōmĭno", "abomināre", "abomināvī", "abominatum")
    @test LexiconMining.expand_elisions(1, "ăbōmĭno", "āre", "āvī", "ātum") == abomino


    abigo = ("abigo", "abigere", "abegi", "abactum")
    @test LexiconMining.expand_elisions(3, "abigo", "abigere", "abegi", "abactum") == abigo


# 1,vōcĭfĕro,vōcĭfĕrāre,-,-
#4, con-scīre, -scīvī, -scītum


end