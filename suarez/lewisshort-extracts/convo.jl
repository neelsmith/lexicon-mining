using Downloads
using HTTP
using JSON


## 1. Configure suarez
mybearerkey = "sk-ff7e8eb3ed834982b52697c558a4db81"

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