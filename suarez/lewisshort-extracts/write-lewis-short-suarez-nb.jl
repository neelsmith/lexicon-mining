### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ cc5328ce-c118-11ef-3010-7996c1f7cc45
begin
	using Downloads
	using HTTP
	using JSON

	using Markdown
	using PlutoUI
	md"""*Unhide this cell to see the Julia environment.*"""
end

# ╔═╡ e4051862-1807-4d10-bed1-9092c2b97869
TableOfContents()

# ╔═╡ ab38d4c7-83ef-41fa-975e-634c643df4ec
md"""# Write extracted morphological data from Lewis-Short's *Latin Dictionary* to delimited-text files"""

# ╔═╡ dba37041-3d70-4efc-8909-64b78685d921
md"""*Start typing a word*: $(@bind wordchoice TextField(placeholder = "capio"))"""

# ╔═╡ 2f2ba995-dcb5-4466-bd0d-cdeb2094dc2a
outputdir = joinpath(pwd(), "extracted")

# ╔═╡ b8c79c2f-90bc-4418-8464-01240370d675
#lewisshort[616]

# ╔═╡ 37cee672-54b3-4b1f-8bb6-6eb2d147c305
#@isdefined(vocab) && !isempty(vocab) ? vocab : Markdown.parse("*`vocab` not defined or empty*")

# ╔═╡ f3bab1f9-f800-4019-b274-6f761c608d2d
html"""
<br/><br/><br/><br/>
<br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/>
"""

# ╔═╡ ea1c2c72-73e8-4cd4-ba2f-93f6122638ee
md"""# Mechanics"""

# ╔═╡ 1328c305-6fe2-45f3-95a3-a04f111b2094
md"""> ## Configure suarez"""

# ╔═╡ b5014c9e-1ad0-40fa-82fe-9bf1f5e2c9ce
mybearerkey = "sk-ff7e8eb3ed834982b52697c558a4db81"

# ╔═╡ 17381ef5-a315-4ec6-a3c0-43f01b6f9ae9
"""Submit a query to suares and get reply body as a Dict parsed from JSON."""
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

# ╔═╡ bffcca7a-b9d1-41a4-a221-f62d8a056e10
"""Extract message content from ChatGPT reply."""
function messagebody(chatjson)
	
	chatjson["choices"][1]["message"]["content"] 
end

# ╔═╡ 54b395b2-327d-4d79-8ae9-642dfe1d28b3
md"""> ## Query suarez about Latin"""

# ╔═╡ ec76e2c0-e39a-4089-8c37-194dbadb0483
preface = """I have a digital version of Lewis and Short's Latin Dictionary formatted in Markdown. I would like to extract morphological information from articles in the dictionary. Please extract from the article a head word (lemma) and identify the part of speech.  Your reply should be a single line of delimited text.

If the article is only a crossreference to another article, please reply with the head word of the article and the second article it points to.

Otherwise, your reply should have three columns separated by a pipe character: head word, part of speech and information specific to each part of speech. If the part of speech is a verb and the verb is a compound of a simplex form, please append the note "(compound)" to the part of speech.

The third column should be a comma-delimited list of information as follows: for nouns, nominative singular, genitive singular, gender; for verbs, conjugation number and principal parts; for adjectives, nominative singular of masculine, feminine and neuter; for prepositions, cases the preposition can be constructed with; for other parts of speech, the label "uninflected".

"""

# ╔═╡ 12726a3d-3b51-4eba-bd7b-cf784e713ba3


# ╔═╡ cf3625a3-2f96-4a9d-adf0-0adb651598b3
"""Get ChaptGPT to find morphology data in a Lewis-Short article."""
function extractmorph(article)
	query = preface * article
	querysuarez(query) |> messagebody
	
end

# ╔═╡ c0364b7e-2992-4e87-bd3c-81ba796448c3
md"""> ## All the Lewis-Short"""

# ╔═╡ f94bb2af-b68d-493e-bb01-0d688a4fddfb
url = "http://shot.holycross.edu/lexica/ls-articles.cex"

# ╔═╡ c3c7a7d7-1e71-48dc-b85d-270261ff1164
function readurl(u)
	f = Downloads.download(u)
	s = read(f) |> String
	rm(f)
	s
end

# ╔═╡ cdb0cd5d-0c54-494b-9b7c-8ff7754e74ba
lewisshortlines = filter(ln -> ! isempty(ln), split(readurl(url), "\n"))

# ╔═╡ ea6ff7e5-ae46-48cc-9d80-4903437fa85a
lewisshort = map(lewisshortlines[2:end]) do ln
	(seq, urn, key, entry) = split(ln,"|")
	(seq = seq, urn = urn, key = key, entry = entry)
end

# ╔═╡ 86780f93-aa99-4d4f-8ea6-e6ab023c1593
capio = filter(tupl -> startswith(tupl.key, "capio"), lewisshort)[1]

# ╔═╡ 6540976d-2cab-434e-9c96-edad6e23fe1e
lspairs = map(lewisshort) do tupl
	(tupl.urn => tupl.key)
end

# ╔═╡ d8185df1-a2d1-42ba-88b5-c2ec6bde31bc
lsmenu = if length(wordchoice) > 1
	vcat([("" => "")], filter(pr -> startswith(pr[2], wordchoice), lspairs))
else
	[]
end

# ╔═╡ 06315efd-241d-4f44-9927-40daab3f3373
if isempty(lsmenu) 
	nothing
else
	md"""*Select from **$(length(lsmenu) - 1)** matching articles (out of $(length(lewisshort)) total)* $(@bind vocab confirm(Select(lsmenu), label = "Submit to ChatGPT"))"""
end

# ╔═╡ 65513dee-a4da-4f79-a685-120f0ccb25d0
function getarticle(id; ls = lewisshort)
	matchingarticles = filter(tupl -> tupl.urn == id, lewisshort)
	if length(matchingarticles) == 1
		matchingarticles[1]
	else
		nothing
	end
end
		

# ╔═╡ 6b97039b-defa-4c1a-841a-2c46f5a7a999
"""Submit request to suarez and format reply."""
function writeanalysisfile(u; ls = lewisshort, outdir = outputdir)
	
	article = getarticle(u, ls = ls)
	if isempty(article) || isnothing(article)
		"Very bad choice! Too many articles!"
	else
		try
			delimited = string(article.seq, "|", article.urn, "|", extractmorph(article.entry))
	
			idval = replace(article.urn, r"[^:]+:" => "")
			outfile = joinpath(outdir, "$(idval).cex")
			open(outfile, "w") do io
				write(io, delimited)
			end
			"Wrote output to $(idval)"
		catch e
			
		end
		
	end

end

# ╔═╡ 2130012c-9cd4-4d27-a871-73ddbd7c69c7
@isdefined(vocab) && !isempty(vocab) ? writeanalysisfile(vocab) : nothing

# ╔═╡ 8b19ce3a-fd9c-4cbd-a282-bfff79c7a52c
@time for i in 1:1
	writeanalysisfile(lewisshort[i].urn)
end
	

	

# ╔═╡ 129e431d-9984-4a1d-a2d9-606bf9fb6108
"""Format display of Lewis-Short article."""
function showls(id; ls = lewisshort)
	article = getarticle(id, ls = ls)
	if isnothing(article)
	else
		lines = ["## Article to analyze",
			"**$(article.key)** (`$(article.urn)`)",
		"> $(article.entry)"
		]
		


		join(lines, "\n\n")
	end
	
end

# ╔═╡ 6c68c726-7c77-4703-872f-ea11e40241d9
@isdefined(vocab) && !isempty(vocab) ? Markdown.parse(showls(vocab)) : nothing


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HTTP = "~1.10.15"
JSON = "~0.21.4"
PlutoUI = "~0.7.60"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.2"
manifest_format = "2.0"
project_hash = "3a1bf831bab2a37b22bbe84f2e3bb31c63666875"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "bce6804e5e6044c6daab27bb533d1295e4a2e759"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.6"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "f36e5e8fdffcb5646ea5da81495a5a7566005127"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.3"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "c67b33b085f6e2faf8bf79a61962e7339a81129c"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.15"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "be3dc50a92e5a386872a493a10050136d4703f9b"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.6.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f02b56007b064fbfddb4c9cd60161b6dd0f40df3"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.1.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7493f61f55a6cce7325f197443aa80d32554ba10"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.15+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─cc5328ce-c118-11ef-3010-7996c1f7cc45
# ╟─e4051862-1807-4d10-bed1-9092c2b97869
# ╟─ab38d4c7-83ef-41fa-975e-634c643df4ec
# ╟─dba37041-3d70-4efc-8909-64b78685d921
# ╟─2f2ba995-dcb5-4466-bd0d-cdeb2094dc2a
# ╟─06315efd-241d-4f44-9927-40daab3f3373
# ╟─6c68c726-7c77-4703-872f-ea11e40241d9
# ╠═2130012c-9cd4-4d27-a871-73ddbd7c69c7
# ╠═8b19ce3a-fd9c-4cbd-a282-bfff79c7a52c
# ╠═b8c79c2f-90bc-4418-8464-01240370d675
# ╟─37cee672-54b3-4b1f-8bb6-6eb2d147c305
# ╟─f3bab1f9-f800-4019-b274-6f761c608d2d
# ╟─ea1c2c72-73e8-4cd4-ba2f-93f6122638ee
# ╟─1328c305-6fe2-45f3-95a3-a04f111b2094
# ╟─b5014c9e-1ad0-40fa-82fe-9bf1f5e2c9ce
# ╟─17381ef5-a315-4ec6-a3c0-43f01b6f9ae9
# ╟─bffcca7a-b9d1-41a4-a221-f62d8a056e10
# ╟─54b395b2-327d-4d79-8ae9-642dfe1d28b3
# ╠═ec76e2c0-e39a-4089-8c37-194dbadb0483
# ╠═6b97039b-defa-4c1a-841a-2c46f5a7a999
# ╠═12726a3d-3b51-4eba-bd7b-cf784e713ba3
# ╠═cf3625a3-2f96-4a9d-adf0-0adb651598b3
# ╟─86780f93-aa99-4d4f-8ea6-e6ab023c1593
# ╟─c0364b7e-2992-4e87-bd3c-81ba796448c3
# ╟─129e431d-9984-4a1d-a2d9-606bf9fb6108
# ╟─d8185df1-a2d1-42ba-88b5-c2ec6bde31bc
# ╟─6540976d-2cab-434e-9c96-edad6e23fe1e
# ╟─ea6ff7e5-ae46-48cc-9d80-4903437fa85a
# ╟─cdb0cd5d-0c54-494b-9b7c-8ff7754e74ba
# ╟─f94bb2af-b68d-493e-bb01-0d688a4fddfb
# ╟─c3c7a7d7-1e71-48dc-b85d-270261ff1164
# ╟─65513dee-a4da-4f79-a685-120f0ccb25d0
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
