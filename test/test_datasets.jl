
@testset "Test inferring orthographic requirements from string values" begin
    
    
    @test LexiconMining.latindataset("jussi") == "lat25"
    @test LexiconMining.latindataset("amavi") == "lat24"
    # This test is wrong.
    #@test LexiconMining.latindataset("amaui") == "lat23"
    @test LexiconMining.latindataset("amo") == "latcommon"
end