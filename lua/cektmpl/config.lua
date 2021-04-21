local fn = vim.fn

local M = {}

M = {

  default_ext = {
    ["py"] = "python",
    ["sh"] = "shellscript",
    ["kt"] = "kotlin",

  },

  file_tmpl_opts = {
    ["python"] = "python-test.py",
    ["shellscript"] = "sh-test.sh",
    ["vim"] = {
      "vim-plugin.vim", -- TODO: duplicate code di index vim dan index lua!!
    },
    ["lua"] = {
      "vim-lua-plugin.lua",
    },
  },

  file_ext = function()

    local get_ext = fn.fnamemodify(fn.expand("%:t"), ":e") or ""
    get_ext = M.default_ext[get_ext] or get_ext
    return get_ext

  end,

  file_templates = function()

    local get_ext = M.file_ext()
    local filenames = M.file_tmpl_opts[get_ext]
    return filenames

  end,

  file_hirarky = {

    ["python"] = {         -- extension of files
      ["test"] = {         -- folder test
        "__init__.py",          -- nama2 test yang harus di buat di folder `test`
        "yourmodule_test.py",
      },
    },
  },

}

return M
