return {
	settings = {
		gopls = {
			buildFlags = { "-tags=tools" },
			usePlaceholders = false,
			completeFunctionCalls = false,
			analyses = {
				fieldalignment = false,
			},
		},
	},
}
