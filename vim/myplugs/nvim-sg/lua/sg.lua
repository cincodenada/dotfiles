local sh = require('sh')

unpack = unpack or table.unpack

local function parse_args(argstr)
    local args = {}
    for arg in string.gmatch(argstr, '"[^"]+"') do
        local escaped = arg:gsub("%$", "\\$")
        table.insert(args, escaped)
    end
    return unpack(args)
end

local function make_quickfix(line)
    --print(line)
    local fname, lineno, match = unpack(vim.split(line, ":"))
    local bufno = vim.fn.bufnr()
    --print(fname, lineno, match)
    return {
        bufnr = bufno,
        lnum = lineno,
        text = match
    }
end

local function call_sg(opts)
    local line_start = opts.range > 0 and opts.line1 or 0
    local line_end = opts.range > 1 and opts.line2 or -1
    --print(vim.inspect(opts))
    local input = vim.api.nvim_buf_get_lines(0, line_start, line_end, true)

    local search, replace = parse_args(opts.args)
    --print(vim.inspect(opts), search, replace, vim.fn.expand("%"))
    local sgargs = {
        "--stdin",
        "--lang", vim.bo.filetype,
        "--pattern", search,
    }
    if replace then
        sgargs = vim.fn.extend(sgargs, {
            "--rewrite", replace,
            "--update-all",
        })
    end
    local result = tostring(sg({__input=vim.fn.join(input, "\n")}, unpack(sgargs)))
    local lines = vim.split(result, "\n", { trimempty = true })
    if replace then
        vim.api.nvim_buf_set_lines(0, line_start, line_end, true, lines)
    else
        --print(vim.inspect(lines))
        file_list=vim.tbl_map(make_quickfix, lines)
        --print(vim.inspect(file_list))
        vim.fn.setqflist(file_list, 'r')
        vim.cmd.cw()
    end
end

vim.api.nvim_create_user_command('Sg', call_sg, {})
