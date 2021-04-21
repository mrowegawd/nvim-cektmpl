local config = require("cektmpl.config")

local fn = vim.fn

local check_filereadble = function(filepath)

  return fn.filereadable(filepath) ~= 0 and true or false

end

local function validate_filesystem(tbl_folder, tbl_filenames)

  for i = 1, #tbl_folder do
    fn.systemlist(string.format("mkdir -p %s", tbl_folder[i]))
  end

  for i = 1, #tbl_filenames do
    if not check_filereadble(tbl_filenames[i]) then
      fn.systemlist(string.format("touch %s", tbl_filenames[i]))
    end
  end

end

local M = {
  file_ext = nil,
}

M.setup_test_project = function()

  local cwd = fn.fnamemodify(fn.getcwd(), ":p:h")

  local tbl_folder = {}
  local tbl_filenames = {}

  for k, v in pairs(config.file_hirarky) do
    if k == M.file_ext then
      for j, s in pairs(v) do

        table.insert(tbl_folder, cwd .. "/" .. j)

        for i = 1, #s do

          table.insert(tbl_filenames, cwd .. "/" .. j .. "/" .. s[i])

        end
      end
    else
      print("[!] file tests with ext: [" .. M.file_ext .. "] not found!")
      return
    end
  end

  validate_filesystem(tbl_folder, tbl_filenames)

  print("[+] Setup test project done..")

end

M.toggle = function()

  M.file_ext = config.file_ext()
  M.setup_test_project()

end

return M
