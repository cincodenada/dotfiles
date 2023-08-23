local sh = require('sh')

unpack = unpack or table.unpack

-- TODO: Handle quoted whitespace??
local function parse_args(opts)
    local args = {}
    for _, arg in pairs(opts.fargs) do
        table.insert(args, vim.fn.shellescape(arg))
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

local function get_range(opts)
    local s = opts.line1 - 1
    local e = opts.line2

    if opts.range == 0 then
        return 0, -1
    elseif opts.range == 1 then
        return s, s
    else
        return s, e
    end
end

local function call_sg(opts)
    local line_start, line_end = get_range(opts)
    local inputlines = vim.api.nvim_buf_get_lines(0, line_start, line_end, true)
    --print(vim.inspect(inputlines), line_start, line_end)

    local search, replace = parse_args(opts)
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
    local input = vim.fn.join(inputlines, "\n")
    local result = sg({__input=input}, unpack(sgargs))
    -- print(vim.inspect(result), input, vim.inspect(sgargs))
    if result then
        local lines = vim.split(tostring(result), "\n", { trimempty = true })
        --print(vim.inspect(lines))
        if replace then
            -- TODO: Handle error conditions?
            if vim.tbl_count(lines) > 0 then
                vim.api.nvim_buf_set_lines(0, line_start, line_end, true, lines)
            end
        else
            file_list=vim.tbl_map(make_quickfix, lines)
            --print(vim.inspect(file_list))
            vim.fn.setqflist(file_list, 'r')
            vim.cmd.cw()
        end
    end
end

vim.api.nvim_create_user_command('Sg', call_sg, {
    range=true,
    nargs='+',
})
