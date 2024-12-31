### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ f3933da0-c108-11ef-3660-23236cbeb9bf
begin
	using HTTP
	using JSON
	using Markdown
end

# ╔═╡ 30ed2886-3594-4835-b951-6397cbd40723
md"""## Julia environment"""

# ╔═╡ d3a177b5-a729-4d6a-a41a-7ee7590b8a6e
md"""## API docs

[https://suarezai.holycross.edu/api/v1/docs](https://suarezai.holycross.edu/api/v1/docs)
"""

# ╔═╡ 9b977309-b973-4c6d-a09f-6c27224f153e
md"""## Configuration"""

# ╔═╡ a816c3cc-e13a-4acf-977b-b8b80ef6a4a2
bearerkey = "sk-ff7e8eb3ed834982b52697c558a4db81"


# ╔═╡ a9b7d07a-5bab-4fd6-9bb9-3ebcfe21da29
hdrs = ["accept" => "application/json",
    "Authorization" =>  "Bearer sk-ff7e8eb3ed834982b52697c558a4db81"
]

# ╔═╡ ddb3e9e1-7df1-4a52-8212-f85ac2ba5f63
md"""## Step 1: GET request with no parameters"""

# ╔═╡ 78058604-82f3-48e7-ad80-9db298ad5f81
md"""### In `curl`"""

# ╔═╡ d202fefe-9a20-43f5-8c84-9b86a87b0e80
md"""
This curl command works:


    curl -X 'GET' 'https://suarezai.holycross.edu/api/v1/auths/' -H 'accept: application/json' -H 'Authorization: Bearer sk-ff7e8eb3ed834982b52697c558a4db81'

"""

# ╔═╡ 67e3691f-d172-43fb-9245-64b7d9850486
md"""### In Julia"""

# ╔═╡ 220a90a5-1bd9-4567-9910-49a37ebf1464
requesturl = "https://suarezai.holycross.edu/api/v1/auths/" # baseurl * "/models/1"

# ╔═╡ b790b4bc-7b70-4b1f-b704-355c1fb93a18
reply1 = HTTP.request("GET", requesturl, hdrs)

# ╔═╡ 38894d24-b08a-4e8c-ae49-20d3487afbcd
reply1string = reply1.body  |> String

# ╔═╡ 3840cddd-d5bd-4cd8-85a8-6a0fd5898fcb
reply1string |> JSON.parse

# ╔═╡ 29da0861-0f77-4ca6-a8d1-86abf3639ee2
md"""## Step 2: add HTTP parameters"""

# ╔═╡ e8503f8e-bc05-479b-aa4c-dcbc99bdf66e
md"""### In `curl`"""

# ╔═╡ be083c70-9101-493c-9291-d848dfee855c
md"""This works:

    curl -X 'GET' 'https://suarezai.holycross.edu/api/v1/chats/list?page=1' -H 'accept: application/json' -H 'Authorization: Bearer sk-ff7e8eb3ed834982b52697c558a4db81'
"""

# ╔═╡ cfc698c9-f96b-4307-a4ff-d80b5e57042f
md"""### In Julia"""

# ╔═╡ 156296b1-aea7-457d-bb00-50e2a2a247b8
step2url = HTTP.URI("https://suarezai.holycross.edu/api/v1/chats/list"; query = "page=1")

# ╔═╡ 3fd55c28-ed6b-4955-983a-b6035f8881a3
step2repl = HTTP.get(step2url, hdrs)

# ╔═╡ b0c424fb-0f31-413d-b706-2234c7f38be7
step2replstring = step2repl.body |> String

# ╔═╡ d05d50a0-727a-40a6-8086-4562396d7b52
step2replstring |> JSON.parse

# ╔═╡ e369696b-42a9-43ad-845a-ac722c8a3ee4
md"""## Chat completions"""

# ╔═╡ 0905eca4-8569-4731-a4c5-ae40e8a753bf
md"""### In curl



    curl -X 'POST' 'https://suarezai.holycross.edu/openai/chat/completions?bypass_filter=false' -H 'accept: application/json' -H 'Authorization: Bearer sk-ff7e8eb3ed834982b52697c558a4db81' -H 'Content-Type: application/json' -d '{
      "model": "chatgpt-4o-latest",
      "messages": [
        {
          "role": "user",
          "content": "Why is the sky blue?"
        }
      ]
    }'
"""

# ╔═╡ 2f8e0423-0bfa-4a1b-9724-be06ae47262b
md"""### In Julia"""

# ╔═╡ cfd61be2-6d3d-4020-8730-6f02074af5ed
chatcompleteurl = HTTP.URI("https://suarezai.holycross.edu/openai/chat/completions"; query = "bypass_filter=false")

# ╔═╡ 8fc213e2-4da6-4cb4-9d5f-c65ff32af647
json_data = Dict(
    "model" => "chatgpt-4o-latest",
    "messages" => [
        Dict(
            "role" => "user",
            "content" => "Why is the sky blue?"
        )
    ]
)

# ╔═╡ 9461e513-f41a-41da-8dda-13111e4ee90d
# Convert the dictionary to a JSON string
json_payload = JSON.json(json_data)

# ╔═╡ ac0d6d4b-60fc-45a7-af6e-1f9672362c1a
chatresponds = HTTP.post(chatcompleteurl, hdrs, json_payload)


# ╔═╡ 33f965d4-c1cf-463a-9dd5-61c16ba65160
chatreplystring = chatresponds.body |> String

# ╔═╡ cb94e15a-4681-46cd-afe7-1101151dcbf4
chatreplyjson = chatreplystring |> JSON.parse

# ╔═╡ 3936fbc1-3451-42fb-8ba5-ba42faa68513
chatreplyjson["choices"][1]["message"]["content"] |> Markdown.parse

# ╔═╡ 4add2f8d-5d09-4394-9520-7b63ed8efcbf
open("reply.txt","w") do io
	write(io, chatreplystring)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"

[compat]
HTTP = "~1.10.8"
JSON = "~0.21.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.2"
manifest_format = "2.0"
project_hash = "d1ed90b61a377dcda04c840ac93c9c4ea3e3f031"

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

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "ea32b83ca4fefa1768dc84e504cc0a94fb1ab8d1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.2"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

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

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

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

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

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
"""

# ╔═╡ Cell order:
# ╟─30ed2886-3594-4835-b951-6397cbd40723
# ╠═f3933da0-c108-11ef-3660-23236cbeb9bf
# ╟─d3a177b5-a729-4d6a-a41a-7ee7590b8a6e
# ╟─9b977309-b973-4c6d-a09f-6c27224f153e
# ╠═a816c3cc-e13a-4acf-977b-b8b80ef6a4a2
# ╠═a9b7d07a-5bab-4fd6-9bb9-3ebcfe21da29
# ╟─ddb3e9e1-7df1-4a52-8212-f85ac2ba5f63
# ╟─78058604-82f3-48e7-ad80-9db298ad5f81
# ╟─d202fefe-9a20-43f5-8c84-9b86a87b0e80
# ╟─67e3691f-d172-43fb-9245-64b7d9850486
# ╟─220a90a5-1bd9-4567-9910-49a37ebf1464
# ╠═b790b4bc-7b70-4b1f-b704-355c1fb93a18
# ╠═38894d24-b08a-4e8c-ae49-20d3487afbcd
# ╠═3840cddd-d5bd-4cd8-85a8-6a0fd5898fcb
# ╟─29da0861-0f77-4ca6-a8d1-86abf3639ee2
# ╟─e8503f8e-bc05-479b-aa4c-dcbc99bdf66e
# ╟─be083c70-9101-493c-9291-d848dfee855c
# ╟─cfc698c9-f96b-4307-a4ff-d80b5e57042f
# ╠═156296b1-aea7-457d-bb00-50e2a2a247b8
# ╠═3fd55c28-ed6b-4955-983a-b6035f8881a3
# ╠═b0c424fb-0f31-413d-b706-2234c7f38be7
# ╠═d05d50a0-727a-40a6-8086-4562396d7b52
# ╟─e369696b-42a9-43ad-845a-ac722c8a3ee4
# ╟─0905eca4-8569-4731-a4c5-ae40e8a753bf
# ╟─2f8e0423-0bfa-4a1b-9724-be06ae47262b
# ╠═cfd61be2-6d3d-4020-8730-6f02074af5ed
# ╠═8fc213e2-4da6-4cb4-9d5f-c65ff32af647
# ╠═9461e513-f41a-41da-8dda-13111e4ee90d
# ╠═ac0d6d4b-60fc-45a7-af6e-1f9672362c1a
# ╠═33f965d4-c1cf-463a-9dd5-61c16ba65160
# ╠═cb94e15a-4681-46cd-afe7-1101151dcbf4
# ╠═3936fbc1-3451-42fb-8ba5-ba42faa68513
# ╠═4add2f8d-5d09-4394-9520-7b63ed8efcbf
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
