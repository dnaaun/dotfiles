if not pcall(function() require("coq_3p") end) then
  print("coq.thirdparty not installed. Not configuring.")
  return {}
end

require("coq_3p") {
  { src = "vimtex", short_name = "vTEX" },
  { src = "dap", short_name = "vDAP" },
  { src = "orgmode", short_name = "vORGMODE" },
}
