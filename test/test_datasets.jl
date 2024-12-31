
@testset "Test inferring orthographic requirements from string values" begin
    
    
    @test LexiconMining.latindataset("jussi") == "lat25"
    @test LexiconMining.latindataset("amavi") == "lat24"
    @test LexiconMining.latindataset("amaui") == "lat23"
    @test LexiconMining.latindataset("amo") == "latcommon"
end