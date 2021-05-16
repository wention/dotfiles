local M = {}

local opts_info = vim.api.nvim_get_all_options_info()

M.opt = setmetatable({}, {
    __newindex = function(_, key, value)
        vim.o[key] = value
        local scope = opts_info[key].scope
        if scope == 'win' then
            vim.wo[key] = value
        elseif scope == 'buf' then
            vim.bo[key] = value
        end
    end
})

function M.add(value, str, sep)
    sep = sep or ','
    str = str or ''
    value = type(value) == 'table' and table.concat(value, sep) or value
    return str ~= '' and table.concat({value, str}, sep) or value
end

return M
