return {
	settings = {
		vue = {
			suggest = {
				propNameCasing = "alwaysCamelCase",
				componentNameCasing = "alwaysPascalCase",
			},
		},
	},
	on_attach = function(client)
		client.server_capabilities.semanticTokensProvider.full = true
	end,
}
