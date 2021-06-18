local is_install, telescope = pcall(require, "telescope.builtin")

if not is_install then
  print("warn: so sorry, you need to install telescope plugin!!")
  return
end

local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local config = require("tmpl.config")
local utils = require("tmpl.utils")

local fn = vim.fn
local g = vim.g

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

  local new_table = utils.convert_str_toTbl(newfrom, " ")

  for i = 1, #new_table do
    table.insert(custom_vimgrep_arguments, new_table[i])
  end

  -- print(table.concat(custom_vimgrep_arguments, " "))
  return custom_vimgrep_arguments
end

local M = {}

M.insert_content = function(filenames)
  local path = g.nvimcektest_path
    or os.getenv("HOME") .. "/Dropbox/vimwiki/nvimcektest"

  -- If path table filenames cannot be found, make script stop immediately!
  -- i dont care..
  if type(filenames) == "table" then
    for i = 1, #filenames do
      if not utils.check_filereadble(path .. "/" .. filenames[i]) then
        print("file not found, aborting..", filenames[i])
        return
      end
    end
  else
    if not utils.check_filereadble(path .. "/" .. filenames) then
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

        -- prompt_bufnr harus di close (telescope popup) terlebih dahulu,
        -- kalau tidak, script hanya akan berefek pada prompt_bufnr,
        -- bukan pada buffer yang kita tujukan, to avoid that better close it.
        actions.close(prompt_bufnr)

        local curr_content = fn.systemlist("cat " .. fn.expand("%"))

        if #curr_content == 0 then
          vim.cmd(":silent! 0r " .. content.value)
          return
        end

        local ans = fn.input("Update the contents? y/n ")

        if ans == "y" or ans == "yes" then
          vim.cmd(":silent! 0r " .. content.value)
        end

        utils.clear_prompt_with_print()
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

M.toggle = function()
  M.insert_content(config.file_templates())
end

return M
