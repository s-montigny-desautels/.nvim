local embedded_sql = vim.treesitter.parse_query(
    "go",
    [[
(expression_list
    (raw_string_literal) @sql
    (#match? @sql "^`--sql")
    (#offset! @sql 0 1 0 -1))
]]
)

local get_root = function(buff)
    local parser = vim.treesitter.get_parser(buff, "go", {})
    local tree = parser:parse()[1]
    return tree:root()
end

local format_sql = function(buff)
    buff = buff or vim.api.nvim_get_current_buff()

    if vim.bo[buff].filetype ~= "go" then
        vim.notify("can only be used in go file")
        return
    end

    local root = get_root(buff)

    local changes = {}
    for id, node in embedded_sql:oter_captures(root, buff, 0, -1) do
        local name = embedded_sql.captures[id]
        if name == "sql" then
            local range = { node:range() }
            local indentation = string.rep(" ", range[2])

            print(vim.treesitter.get_node_text(node, buff))
        end
    end
end
