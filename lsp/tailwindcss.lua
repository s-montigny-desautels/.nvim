return {
	settings = {
		tailwindCSS = {
			classAttributes = {
				"class",
				"className",
				"ngClass",
				"activeClass",
				"exactActiveClass",
				"enterActiveClass",
				"enterFromClass",
				"enterToClass",
				"leaveActiveClass",
				"leaveFromClass",
				"leaveToClass",
				"innerClass",
				"inner-class",
			},
			experimental = {
				classRegex = {
					"tw`([^`]*)`",
					{ "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					{
						"cva\\(((?:[^()]|\\([^()]*\\))*)\\)",
						"[\"'`]([^\"'`]*).*?[\"'`]",
					},
					{
						"cx\\(((?:[^()]|\\([^()]*\\))*)\\)",
						"(?:'|\"|`)([^']*)(?:'|\"|`)",
					},
				},
			},
		},
	},
}
