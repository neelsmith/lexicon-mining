# Read src.cex, and format mainentries.cex
#
#
# if running from root of repository:
#=
f = joinpath(pwd(), "cex", "lewis-short", "src.cex")
target = joinpath(pwd(),"cex", "lewis-short", "mainentries.cex")
=#

"""Read source file `f` and format contebnt for `mainentries.cex`
$(SIGNATURES)
"""
function formatentries(f)
    lns = readlines(f)
    
    metadata = []
    for (i,ln) in enumerate(lns)
        try 
            doc = parsexml(ln)
            id = doc.root["id"]
            k = doc.root["key"]
            cleaner = replace(k, r"[_^]" => "")
            push!(metadata, join([id,cleaner], "||"))
        catch e
            println("ERROR AT LINE $(i)")
            println(e)
            throw(e)
        end
    end

    prs = zip(metadata, lns)
    cexlines = map(pr -> pr[1] * "||" * pr[2], prs)
end


#=
open(target, "w") do io
    write(io, join(cexlines,"\n"))
end
=#
