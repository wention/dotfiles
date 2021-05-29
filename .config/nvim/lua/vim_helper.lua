function has_feature(feature)
    if vim.fn.has(feature) == 1 then
        return true
    end

    return false
end

function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end
