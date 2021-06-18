local fn = vim.fn
local api = vim.api

local clear_prompt = function()
  api.nvim_command("normal :esc<CR>")
end

local clear_prompt_with_print = function()
  clear_prompt()
  print("aborting..")
  return
end

local check_filereadble = function(filepath)
  return fn.filereadable(filepath) ~= 0 and true or false
end

local convert_str_toTbl = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

local create_filename = function()
  -- local cwd = fn.resolve(fn.getcwd())
  -- cwd = fn.substitute(cwd, "^" .. os.getenv("HOME") .. "/", "", "")
  -- cwd = fn.fnamemodify(cwd, ":p:gs?/?_?")
  -- cwd = fn.substitute(cwd, "^\\.", "", "")
  local cwd = fn.fnamemodify(fn.getcwd(), ":t")
  return cwd
end

return {

  check_filereadble = check_filereadble,
  convert_str_toTbl = convert_str_toTbl,
  create_filename = create_filename,
  clear_prompt = clear_prompt,
  clear_prompt_with_print = clear_prompt_with_print,
}
