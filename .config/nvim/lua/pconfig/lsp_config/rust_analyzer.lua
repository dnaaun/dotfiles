return {
	-- cmd = { "/Users/davidat/.rustup_m1/toolchains/nightly-aarch64-apple-darwin/bin/rust-analyzer" },

	settings = {
		-- cmd = { "/Users/davidat/.rustup_m1/toolchains/nightly-aarch64-apple-darwin/bin/rust-analyzer" },
		["rust-analyzer"] = {
			-- https://www.reddit.com/r/rust/comments/vj2ghz/comment/idhpunt/?utm_source=share&utm_medium=web2x&context=3
			diagnostics = { disabled = { "unresolved-proc-macro" } },
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
