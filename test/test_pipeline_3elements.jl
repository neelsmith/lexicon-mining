@testset "Test verb pipeline: 3 elements" begin
    
    summary = "10897|urn:cite2:hmt:ls.markdown:n10896|con-tremo | to tremble greatly, to quake | verb  | 3, con-tremo, -tremui"

    contremo = summary |>  LexiconMining.readdataline  |> verb
    @test contremo isa LSVerb
    @test contremo.conjugation == 3
    @test contremo.pp1 == "con-tremo"
    @test contremo.pp2 == "con-tremere"
    @test contremo.pp3 == "contremui"
    @test isempty(contremo.pp4)
    @test tabulaeclass(contremo) == "c3pres"
    


    cex = cexline(contremo)
    @test_broken length(cex) == 3
end

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
    

    cex = cexline(metior)
    expected = [
     "latcommon.verbn28947|lsx.n28947|met|c4presdep|Automatically generated",
    "latcommon.verbn28947|lsx.n28947|mensus|pftpass|Automatically generated"
    ]
    @test cex == expected
end

@testset "Test pipeline: deponent verb with in present system only" begin
    summary = "4148|urn:cite2:hmt:ls.markdown:n4147|a-stipulor|to agree with one|verb |1,a-stipulor,a-stipulari"

    astipulor = summary |> LexiconMining.readdataline |> verb
    @test astipulor isa LSVerb
    @test astipulor.conjugation == 1
    @test astipulor.pp1 == "a-stipulor"
    @test astipulor.pp2 == "a-stipulari"
    @test isempty(astipulor.pp3)
    @test isempty(astipulor.pp4)
    @test tabulaeclass(astipulor) == "c1presdep"
end