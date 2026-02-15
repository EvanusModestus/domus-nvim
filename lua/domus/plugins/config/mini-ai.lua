-- Mini.ai Configuration (text objects)

local M = {}

function M.setup()
    local ok, ai = pcall(require, "mini.ai")
    if not ok then return end

    ai.setup({
        n_lines = 500,
        custom_textobjects = {
            -- AsciiDoc inline formatting (standard syntax)
            -- Use underscore for italic: _text_
            ["_"] = { "%f[%w_]_[^_]+_%f[^%w_]", "_%f[%w]().-()%f[%W]_" },
            -- Bold uses single asterisk in AsciiDoc: *text*
            -- Note: Overrides default mini.ai * (arguments) - use 'a' for arguments instead
            ["*"] = { "%f[%w%*]%*[^%*]+%*%f[^%w%*]", "%*%f[%w]().-()%f[%W]%*" },
            -- Monospace: `text`
            ["`"] = { "`[^`]+`", "`()[^`]+()`" },
            -- Passthrough: +text+
            ["+"] = { "%+[^%+]+%+", "%+()[^%+]+()`+" },
            -- AsciiDoc delimited blocks using mini.ai's gen_spec
            -- For code/listing blocks (----), use mini.ai's indent-based approach
            -- or rely on visual mode for complex multiline selections
        },
        mappings = {
            around = "a",
            inside = "i",
            around_next = "an",
            inside_next = "in",
            around_last = "al",
            inside_last = "il",
            goto_left = "g[",
            goto_right = "g]",
        },
    })
end

return M
