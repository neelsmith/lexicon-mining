## StemUrn|LexicalEntity|Stem|Gender|InflClass
"""Write Tabulae stem files for nouns in dataset in `dsdir`.
$(SIGNATURES)
"""
function tabulae_nouns(mdata::Vector{MorphData}, dsdir)
    stemsdir  = joinpath(dsdir, "stems-tables")
    if !isdir(stemsdir)
        mkdir(stemsdir)
    end
    nounsdir  = joinpath(stemsdir, "nouns")
    if !isdir(nounsdir)
        mkdir(nounsdir)
    end

    
    # write second declension types to file:
    decl2_itype = filter(m -> m.itype == "i" && ! isempty(m.gen), mdata)
    @info("Formatting $(length(decl2_itype)) entries for second-declension nouns.")
    decl2_file = joinpath(nounsdir, "decl2.cex")
    itype_i(decl2_itype, decl2_file)

    # write

end

