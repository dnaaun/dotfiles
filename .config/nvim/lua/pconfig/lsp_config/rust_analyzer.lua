return {
	settings = {
		["rust-analyzer"] = {
			-- This is actually only because of crushedgarlic/ingredient_tagger_2
			-- server = {
			-- 	extraEnv = {
			-- 		RUSTFLAGS = {
			-- 			"-C",
			-- 			"link-args=-Wl,-rpath,/Users/davidat/git/onnxruntime-rs/target/onnxruntime/lib",
			-- 		},
			-- 	},
			-- },
			-- diagnostics = {
			-- 	enable = true,
			-- 	disabled = { "unresolved-proc-macro" },
			-- 	-- enableExperimental = true,
			-- },
			-- cargo = {
			-- 	-- target = "wasm32-unknown-unknown",
			-- },

			-- https://github.com/rust-lang/rust-analyzer/issues/6007#issuecomment-1379342831
			checkOnSave = {
				extraArgs = { "--profile", "rust-analyzer" },
			},
			check = {
				extraArgs = { "--profile", "rust-analyzer" },
			},
		},
	},
}
