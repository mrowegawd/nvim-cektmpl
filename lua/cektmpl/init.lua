local tmpl_file = require("cektmpl.tmpl-file")
local tmpl_projectionist = require("cektmpl.tmpl-projectionist")
local util = require("cektmpl.utils")

local fn = vim.fn

local M = {}

M.toggle = function()

  local ans = fn.input([[
What do you want?
1. Setup test for project?
2. Add template codes?

answer: ]])

  util.clear_prompt()

  if ans == "1" then
    tmpl_projectionist.toggle()

  elseif ans == "2" then
    tmpl_file.toggle()

  else
    util.clear_prompt_with_print()
  end

end

return M
