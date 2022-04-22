## StemUrn|LexicalEntity|Stem|Gender|InflClass
"""Write Tabulae tables for `us_i` inflectional type to file `f`.
$(SIGNATURES)
"""
function itype_i(mdata::Vector{MorphData}, f)
    formatted = map(d -> format_itype_i(d), mdata)
    nonempty = filter(d -> !isempty(d), formatted)
    @info("Writing $(length(nonempty)) second-declension nouns to $(f).")
    open(f, "w") do io
        write(io, NOUN_HEADER * "\n" * join(nonempty, "\n"))
    end
end

"""Format `datum` as a noun of inflectional type `us_i`
$(SIGNATURES)
"""
function format_itype_i(datum::MorphData)
    if datum.gen == "m."
        gndr = "masculine"
        # "os", "us" are acceptable 2nd-declension masculine endings:
        if endswith(datum.label, "us")
            stemurn = "lsnouns.$(datum.id)"
            lexurn = "ls.$(datum.id)"
            stem = replace(datum.label, r"us$" => "")
            inflclass = "us_i"
            join([stemurn, lexurn, stem, gndr, inflclass], "|")
        elseif endswith(datum.label, "os")
            stemurn = "lsnouns.$(datum.id)"
            lexurn = "ls.$(datum.id)"
            stem = replace(datum.label, r"os$" => "")
            inflclass = "os_i"
            join([stemurn, lexurn, stem, gndr, inflclass], "|")
        else
            ""
        end


    elseif datum.gen == "f."
        gndr = "feminine"
        # "os", "us" are acceptable 2nd-declension feminine endings:
        if endswith(datum.label, "us")
            stemurn = "lsnouns.$(datum.id)"
            lexurn = "ls.$(datum.id)"
            stem = replace(datum.label, r"us$" => "")
            inflclass = "us_i"
            join([stemurn, lexurn, stem, gndr, inflclass], "|")
        elseif endswith(datum.label, "os")
            stemurn = "lsnouns.$(datum.id)"
            lexurn = "ls.$(datum.id)"
            stem = replace(datum.label, r"os$" => "")
            inflclass = "os_i"
            join([stemurn, lexurn, stem, gndr, inflclass], "|")
        else
            ""
        end


    elseif datum.gen == "n."
        gndr = "neuter"
        # "um", "on" are acceptable 2nd-declension neuter endings:
        if endswith(datum.label, "um")
            stemurn = "lsnouns.$(datum.id)"
            lexurn = "ls.$(datum.id)"
            stem = replace(datum.label, r"um$" => "")
            inflclass = "us_i"
            join([stemurn, lexurn, stem, gndr, inflclass], "|")

        elseif endswith(datum.label, "on")
            stemurn = "lsnouns.$(datum.id)"
            lexurn = "ls.$(datum.id)"
            stem = replace(datum.label, r"on$" => "")
            inflclass = "on_i"
            join([stemurn, lexurn, stem, gndr, inflclass], "|")
        else
            ""
        end
    else
        ""
    end
end