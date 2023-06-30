-- I'm not sure why sometimes, rust-analyzer doesn't run cargo check with the `extraArgs` below.
return {
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "check",
				allTargets = false,
				extraArgs = {
					"--profile",
					"rust-analyzer",
				},
			},
		},
	},
}
