function has_feature(feature)
    if vim.fn.has(feature) == 1 then
        return true
    end

    return false
end
