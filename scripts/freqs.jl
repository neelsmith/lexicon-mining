function freqs(v)
    grouped = group(v)
    counts = []
    for k in keys(grouped)
        push!(counts, (k, length(grouped[k])))
    end
    sort(counts, by = pr -> pr[2], rev = true)
end