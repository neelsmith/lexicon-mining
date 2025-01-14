#=

Use API to Holy Cross suarez AI to extract morphological data and short definitions from Lewis-Short.

Three sections:

1. configure suarez
2. get Lewis-Short data
3. query a range of Lewis-Short and write results to files
=#

# Uncomment this section if you're not running in a preconfigured environment:
#=
using Pkg
Pkg.add("HTTP")
Pkg.add("JSON")
=#
using Downloads
using HTTP
using JSON

## 1. Preonfigure suarez or supply when submitting query
mybearerkey = ""

"""Submit a query to suarez and get reply body as a Dict parsed from JSON."""
function querysuarez(s, bearerkey = mybearerkey)
	chatcompleteurl = HTTP.URI("https://suarezai.holycross.edu/openai/chat/completions"; query = "bypass_filter=false")

	hdrs = ["accept" => "application/json",
    "Authorization" =>  "Bearer $(bearerkey)"
    ]
	json_data = Dict(
	    "model" => "chatgpt-4o-latest",
	    "messages" => [
	        Dict(
	            "role" => "user",
	            "content" => "$(s)"
	        )
	    ]
	)
	json_payload = JSON.json(json_data)
	try
		chatresponds = HTTP.post(chatcompleteurl, hdrs, json_payload)
		chatreplystring = chatresponds.body |> String
		chatreplystring |> JSON.parse
	catch e
		msg = """Query to suarez failed.

		Error was $(e)
		"""

	end
end

"""Extract message content from ChatGPT reply."""
function messagebody(chatjson)	
	chatjson["choices"][1]["message"]["content"] 
end


### 2. Get Lewis-Short into Julia structure:
"""Read Lewis-Short data into named tuples."""
function getls()
    url = "http://shot.holycross.edu/lexica/ls-articles.cex"
    f = Downloads.download(url)
	lslines = split(read(f, String), "\n")
	rm(f)

    data = filter(ln -> ! isempty(ln), lslines)
    map(data[2:end]) do ln
        (seq, urn, key, entry) = split(ln,"|")
        (seq = seq, urn = urn, key = key, entry = entry)
    end
end


"""Extract article from Lewis-Short tuples with a given id."""
function getarticle(id; ls = lewisshort)
	matchingarticles = filter(tupl -> tupl.urn == id, ls)
	if length(matchingarticles) == 1
		matchingarticles[1]
	else
        @warn("Did not match unique article for $(id).")
		nothing
	end
end



# 3. Ask chatgpt about Lewis-Short articles
preface = """I have a digital version of Lewis and Short's Latin Dictionary formatted in Markdown. I would like to extract morphological information and brief definitions from articles in the dictionary. Please extract from the article a head word (lemma), a short definition (only a few words or phrases please), and identify the part of speech.  Your reply should be a single line of delimited text without any Markdown formatting.

If the article is only a crossreference to another article, please reply with the head word of the article and the second article it points to.

Otherwise, your reply should have four columns separated by a pipe character: head word, summary definition, part of speech and information specific to each part of speech. If the part of speech is a verb and the verb is a compound of a simplex form, please append the note "(compound)" to the part of speech.

The fourth column should be a comma-delimited list of information as follows: for nouns, nominative singular, genitive singular, gender; for verbs, conjugation number and principal parts; for adjectives, nominative singular of masculine, feminine and neuter; for prepositions, cases the preposition can be constructed with; for other parts of speech, the label "uninflected".

"""

"""Ask ChaptGPT to find morphology data in a Lewis-Short article."""
function extractmorph(article, bearerkey)
	query = preface * article
	querysuarez(query, bearerkey) |> messagebody
end

"""Submit request to suarez and format reply."""
function writeanalysisfile(u, ls, outdir, bearerkey)	
	article = getarticle(u, ls = ls)
	if isempty(article) || isnothing(article)
		"Very bad choice! Too many articles!"
	else
		try
			delimited = string(article.seq, "|", article.urn, "|", extractmorph(article.entry, bearerkey))
	
			idval = replace(article.urn, r"[^:]+:" => "")
			outfile = joinpath(outdir, "$(idval).cex")
			open(outfile, "w") do io
				write(io, delimited)
			end
			@info("For $(u), wrote output to $(idval)")
		catch e
			@warn("Failed on $(u)\n\n")
            @warn("Error was $(e)")
		end
		
	end
end

"""Extract morphjological data from a given range of Lewis-Short articles
and write to delimited file."""
function extractrange(starti, endi, lexicon; outputroot = "extracted", bearerkey = bearerkey)
    for idx in starti:endi
        diridx::Int = floor(Int, idx / 1000)
        outputdir = mkpath(joinpath(outputroot, "tranche$(diridx)"))
	    writeanalysisfile(lexicon[idx].urn, lexicon, outputdir, bearerkey)
    end
end

ls  = getls()

## Extract data!
outputdir = joinpath(pwd(), "suarez", "lewisshort-extracts", "extracts-cycle2")
extractrange(11000, 11999, ls; outputroot = outputdir, bearerkey = "")

