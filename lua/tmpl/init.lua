local tfile = require("tmpl.tfile")
local tprojecionist = require("tmpl.tprojectionist")
local util = require("tmpl.utils")

local fn = vim.fn

local M = {}

M.toggle = function()
  local ans = fn.input([[
What do you want?
1. Setup file tests for project?
2. Insert template code?

answer: ]])

  util.clear_prompt()

  if ans == "1" then
    tprojecionist.toggle()
  elseif ans == "2" then
    tfile.toggle()
  else
    util.clear_prompt_with_print()
  end
end

return M
