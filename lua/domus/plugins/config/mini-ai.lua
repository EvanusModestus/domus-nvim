-- mini.ai configuration
-- Enhanced text objects with custom delimiters
-- Supports AsciiDoc code blocks (----), comment blocks (////), and more

local M = {}

function M.setup()
    local status_ok, ai = pcall(require, "mini.ai")
    if not status_ok then
        return
    end

    -- Custom text object specs
    -- Use: yi- (yank inner ---- block), va- (visual around), ci- (change inner), etc.
    local custom_textobjects = {
        -- AsciiDoc code/listing block: ---- delimited
        -- Works with: yi-, ya-, ci-, di-, vi-
        ['-'] = function(ai_type, _, _)
            local current_line = vim.fn.line('.')
            local from_line, to_line

            -- First, check if we're ON a ---- line
            local current_text = vim.fn.getline(current_line)
            local on_delimiter = current_text:match('^%-%-%-%-+%s*$')

            if on_delimiter then
                -- Check if this is opening or closing by looking for another ---- above
                local found_above = false
                for line = current_line - 1, math.max(1, current_line - 500), -1 do
                    local text = vim.fn.getline(line)
                    if text:match('^%-%-%-%-+%s*$') then
                        -- This is a closing delimiter, use the one above as opening
                        from_line = line
                        to_line = current_line
                        found_above = true
                        break
                    end
                end
                if not found_above then
                    -- This is an opening delimiter, search forward for closing
                    from_line = current_line
                    for line = current_line + 1, math.min(vim.fn.line('$'), current_line + 500) do
                        local text = vim.fn.getline(line)
                        if text:match('^%-%-%-%-+%s*$') then
                            to_line = line
                            break
                        end
                    end
                end
            else
                -- Search backward for opening ----
                for line = current_line, math.max(1, current_line - 500), -1 do
                    local text = vim.fn.getline(line)
                    if text:match('^%-%-%-%-+%s*$') then
                        from_line = line
                        break
                    end
                end

                if not from_line then return nil end

                -- Search forward for closing ----
                for line = from_line + 1, math.min(vim.fn.line('$'), from_line + 500) do
                    local text = vim.fn.getline(line)
                    if text:match('^%-%-%-%-+%s*$') then
                        to_line = line
                        break
                    end
                end
            end

            if not from_line or not to_line then return nil end
            if to_line <= from_line then return nil end

            -- For 'i' (inner): exclude delimiters
            -- For 'a' (around): include delimiters
            if ai_type == 'i' then
                if to_line - from_line <= 1 then return nil end  -- Empty block
                local last_content_line = to_line - 1
                local last_line_len = vim.fn.getline(last_content_line):len()
                return {
                    from = { line = from_line + 1, col = 1 },
                    to = { line = last_content_line, col = math.max(last_line_len, 1) }
                }
            else
                -- 'a' (around) - include delimiters
                local last_line_len = vim.fn.getline(to_line):len()
                return {
                    from = { line = from_line, col = 1 },
                    to = { line = to_line, col = math.max(last_line_len, 1) }
                }
            end
        end,

        -- AsciiDoc comment block: //// delimited
        -- Works with: yi/, ya/, ci/, di/, vi/
        ['/'] = function(ai_type, _, _)
            local current_line = vim.fn.line('.')
            local from_line, to_line
            local pattern = '^////+%s*$'

            local current_text = vim.fn.getline(current_line)
            local on_delimiter = current_text:match(pattern)

            if on_delimiter then
                local found_above = false
                for line = current_line - 1, math.max(1, current_line - 500), -1 do
                    if vim.fn.getline(line):match(pattern) then
                        from_line = line
                        to_line = current_line
                        found_above = true
                        break
                    end
                end
                if not found_above then
                    from_line = current_line
                    for line = current_line + 1, math.min(vim.fn.line('$'), current_line + 500) do
                        if vim.fn.getline(line):match(pattern) then
                            to_line = line
                            break
                        end
                    end
                end
            else
                for line = current_line, math.max(1, current_line - 500), -1 do
                    if vim.fn.getline(line):match(pattern) then
                        from_line = line
                        break
                    end
                end
                if not from_line then return nil end
                for line = from_line + 1, math.min(vim.fn.line('$'), from_line + 500) do
                    if vim.fn.getline(line):match(pattern) then
                        to_line = line
                        break
                    end
                end
            end

            if not from_line or not to_line or to_line <= from_line then return nil end

            if ai_type == 'i' then
                if to_line - from_line <= 1 then return nil end
                local last_line_len = vim.fn.getline(to_line - 1):len()
                return {
                    from = { line = from_line + 1, col = 1 },
                    to = { line = to_line - 1, col = math.max(last_line_len, 1) }
                }
            else
                local last_line_len = vim.fn.getline(to_line):len()
                return {
                    from = { line = from_line, col = 1 },
                    to = { line = to_line, col = math.max(last_line_len, 1) }
                }
            end
        end,

        -- AsciiDoc sidebar/example block: ==== or **** delimited
        -- Works with: yi=, ya=, ci=, di=, vi=
        ['='] = function(ai_type, _, _)
            local current_line = vim.fn.line('.')
            local from_line, to_line
            local pattern_eq = '^====+%s*$'
            local pattern_star = '^%*%*%*%*+%s*$'

            local function matches_delimiter(text)
                return text:match(pattern_eq) or text:match(pattern_star)
            end

            local current_text = vim.fn.getline(current_line)
            local on_delimiter = matches_delimiter(current_text)
            local delimiter_pattern

            if on_delimiter then
                delimiter_pattern = current_text:match(pattern_eq) and pattern_eq or pattern_star
                local found_above = false
                for line = current_line - 1, math.max(1, current_line - 500), -1 do
                    if vim.fn.getline(line):match(delimiter_pattern) then
                        from_line = line
                        to_line = current_line
                        found_above = true
                        break
                    end
                end
                if not found_above then
                    from_line = current_line
                    for line = current_line + 1, math.min(vim.fn.line('$'), current_line + 500) do
                        if vim.fn.getline(line):match(delimiter_pattern) then
                            to_line = line
                            break
                        end
                    end
                end
            else
                for line = current_line, math.max(1, current_line - 500), -1 do
                    local text = vim.fn.getline(line)
                    if matches_delimiter(text) then
                        from_line = line
                        delimiter_pattern = text:match(pattern_eq) and pattern_eq or pattern_star
                        break
                    end
                end
                if not from_line then return nil end
                for line = from_line + 1, math.min(vim.fn.line('$'), from_line + 500) do
                    if vim.fn.getline(line):match(delimiter_pattern) then
                        to_line = line
                        break
                    end
                end
            end

            if not from_line or not to_line or to_line <= from_line then return nil end

            if ai_type == 'i' then
                if to_line - from_line <= 1 then return nil end
                local last_line_len = vim.fn.getline(to_line - 1):len()
                return {
                    from = { line = from_line + 1, col = 1 },
                    to = { line = to_line - 1, col = math.max(last_line_len, 1) }
                }
            else
                local last_line_len = vim.fn.getline(to_line):len()
                return {
                    from = { line = from_line, col = 1 },
                    to = { line = to_line, col = math.max(last_line_len, 1) }
                }
            end
        end,

        -- Markdown fenced code block: ``` delimited
        ['`'] = {
            { '```%w*\n().-()```' },                 -- inner
            { '()```%w*\n.-```()' },                 -- around
        },

        -- AsciiDoc inline formatting
        -- Underscore for italic: _text_
        ['_'] = { "%f[%w_]_[^_]+_%f[^%w_]", "_%f[%w]().-()%f[%W]_" },
        -- Bold with double asterisk for inline (single * conflicts with block delimiter)
        ['*'] = { "%*%*[^%*]+%*%*", "%*%*()[^%*]+()%*%*" },
        -- Passthrough: +text+
        ['+'] = { "%+[^%+]+%+", "%+()[^%+]+()`+" },

        -- XML/HTML tags (enhanced)
        ['t'] = ai.gen_spec.treesitter({ a = '@tag.outer', i = '@tag.inner' }),

        -- Function (treesitter)
        ['f'] = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),

        -- Class (treesitter)
        ['c'] = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),

        -- Comment (treesitter)
        ['C'] = ai.gen_spec.treesitter({ a = '@comment.outer', i = '@comment.inner' }),

        -- Entire buffer
        ['g'] = function()
            local from = { line = 1, col = 1 }
            local to = {
                line = vim.fn.line('$'),
                col = math.max(vim.fn.getline('$'):len(), 1)
            }
            return { from = from, to = to }
        end,
    }

    ai.setup({
        -- Number of lines within which textobject is searched
        n_lines = 500,

        -- Custom textobjects
        custom_textobjects = custom_textobjects,

        -- Module mappings (use defaults)
        mappings = {
            -- Main textobject prefixes
            around = 'a',
            inside = 'i',

            -- Next/previous textobject
            around_next = 'an',
            inside_next = 'in',
            around_last = 'al',
            inside_last = 'il',

            -- Move cursor to corresponding edge of `a` textobject
            goto_left = 'g[',
            goto_right = 'g]',
        },

        -- Search method (cover, cover_or_next, cover_or_prev, cover_or_nearest, next, prev, nearest)
        search_method = 'cover_or_next',

        -- Silent when textobject not found
        silent = false,
    })
end

-- Keymaps reference (automatic with mini.ai):
--
-- AsciiDoc block text objects:
-- yi-  : yank inside ---- block (code/listing)
-- ya-  : yank around ---- block (includes delimiters)
-- ci-  : change inside ---- block
-- di-  : delete inside ---- block
-- vi-  : visual select inside ---- block
--
-- yi/  : yank inside //// block (comment block)
-- ya/  : yank around //// block (includes delimiters)
-- ci/  : change inside //// block
-- vi/  : visual select inside //// block
--
-- yi=  : yank inside ==== or **** block (sidebar/example)
-- ya=  : yank around ==== or **** block
-- ci=  : change inside ==== or **** block
-- vi=  : visual select inside ==== or **** block
--
-- Markdown:
-- yi`  : yank inside ``` block (markdown fence)
-- ya`  : yank around ``` block
--
-- AsciiDoc inline formatting:
-- yi_  : yank inside _italic_
-- yi*  : yank inside **bold**
-- yi+  : yank inside +passthrough+
--
-- Code navigation (treesitter):
-- yif  : yank inside function
-- yic  : yank inside class
-- yiC  : yank inside comment
-- yit  : yank inside tag (HTML/XML)
--
-- Utility:
-- yig  : yank entire buffer
--
-- All text objects work with operators: y (yank), d (delete), c (change),
-- v (visual), > (indent), < (dedent), = (format), etc.

return M
