
@testset "Test inferring orthographic requirements from string values" begin
    
    
    @test LexiconMining.latindataset("jussi") == "lat25"
    @test LexiconMining.iscommon("jussi") == false
    @test LexiconMining.lat24("jussi") == "iussi"
    @test LexiconMining.lat23("jussi") == "iussi"

    @test LexiconMining.latindataset("amavi") == "lat24"
    @test LexiconMining.iscommon("amavi") == false
    @test LexiconMining.lat23("amavi") == "amaui"

    # This test is wrong: LS is in Latin, so you'll never see
    # this string in Lewis-Short:
    #@test LexiconMining.latindataset("amaui") == "lat23"

    
    @test LexiconMining.latindataset("amo") == "latcommon"
    @test LexiconMining.iscommon("amo")

    
end

@testset "Test tidying string values" begin
    @test LexiconMining.suareznorm("sēd") ==  "sed"
    @test LexiconMining.suareznorm(" ăb-usque") ==  "abusque"

end