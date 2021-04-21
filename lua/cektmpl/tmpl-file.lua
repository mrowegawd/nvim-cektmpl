local is_install, telescope = pcall(require, "telescope.builtin")

if not is_install then

  print("warn: so sorry, you need to install telescope plugin!!")
  return

end

local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local config = require("cektmpl.config")

local fn = vim.fn
local api = vim.api
local g = vim.g

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

local function convert_str_totable(inputstr, sep)

  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t

end

local function custom_cmd_grep(path, filenames)

  local custom_vimgrep_arguments = {
    "find",
    path,
    "-type",
    "f",
  }

  local newfrom = ""

  if type(filenames) == "table" then

    -- Tiap element path harus di tandai dengan aksterik contoh `*<filename>*`
    -- karena butuh glob nya (find cmd),
    -- jadi membuat table baru dari "penambahan aksterik pada tiap element
    -- table filenames"
    local new_table_file = {}
    for i = 1, #filenames do
      table.insert(new_table_file, string.format("*%s*", filenames[i]))
    end

    -- local custom_vimgrep_arguments = {
    --   "find",
    --   path,
    --   "-type",
    --   "f",
    --   -- "( -name " .. "\"*" .. filename .. "*\"" .. " )",
    --   "(",
    --   "-name",
    --   "*vim-plugin*",
    --   "-o",
    --   "-name",
    --   "*terserah*",
    --   ")",
    -- }

    newfrom = string.format(
      "( -name %s )",
      table.concat(new_table_file, " -o -name ")
    )
  else
    newfrom = string.format("( -name %s )", filenames)
  end

  local new_table = convert_str_totable(newfrom, " ")

  for i = 1, #new_table do
    table.insert(custom_vimgrep_arguments, new_table[i])
  end

  -- print(table.concat(custom_vimgrep_arguments, " "))
  return custom_vimgrep_arguments

end

local function telescope_popup(filenames)

  local path = g.nvimcektest_path
    or os.getenv("HOME")
    .. "/Dropbox/vimwiki/nvimcektest"

  -- If path table filenames cannot be found, make script stop immediately!
  -- i dont care..
  if type(filenames) == "table" then
    for i = 1, #filenames do
      if not check_filereadble(path .. "/" .. filenames[i]) then
        print("file not found, aborting..", filenames[i])
        return
      end
    end
  else
    if not check_filereadble(path .. "/" .. filenames) then
      print("file not found, aborting..", filenames)
      return
    end
  end

  local custom_command = custom_cmd_grep(path, filenames)

  telescope.find_files({
    file_ignore_patterns = { "%.png", "%.jpg", "%.webp" },
    find_command = custom_command,
    prompt_title = "Nvim Cektest",
    hidden = true,
    follow = true,
    shorten_path = true,

    -- Taken from idea ThePrimeagen:
    -- https://www.youtube.com/watch?v=2tO2sT7xX2k
    attach_mappings = function(prompt_bufnr, map)
      local function callme()

        local content = action_state.get_selected_entry()
        -- content adalah type table,
        -- content.value adalah path selected_entry

        -- NOTE: harus diclose prompt_bufnr nya (telescope popup) terlebih dahulu..
        -- kalau tidak, script akan berefek pada prompt_bufnr dan bukan
        -- pada buffer yang kita tuju..so to avoid that, need close it first
        actions.close(prompt_bufnr)

        -- TODO: harus di cek dahulu apakah buffer yang kita buka sekarang itu
        -- telah berisi content atau tidak, kalau iya get user input!!
        local ans = fn.input("Update the contents? y/n ")
        if ans == "y" or ans == "yes" then
          vim.cmd(":silent! 0r " .. content.value)
          return
        end

        clear_prompt_with_print()
      end

      map("n", "<CR>", function()
        callme()
      end)

      map("i", "<CR>", function()
        callme()
      end)
      return true
    end,
  })

end

local M = {}

M.toggle = function()

  telescope_popup(config.file_templates())

end

return M
