-- DAP Configuration

local M = {}

function M.setup()
    local dap_ok, dap = pcall(require, "dap")
    if not dap_ok then return end

    local dapui_ok, dapui = pcall(require, "dapui")
    if dapui_ok then
        dapui.setup()

        -- Auto open/close UI
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
    end

    -- Virtual text
    pcall(function()
        require("nvim-dap-virtual-text").setup()
    end)

    -- Mason DAP integration
    pcall(function()
        require("mason-nvim-dap").setup({
            ensure_installed = { "python", "codelldb" },
            automatic_installation = true,
        })
    end)

    -- Python adapter
    dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
    }

    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            pythonPath = function()
                local venv = os.getenv("VIRTUAL_ENV")
                if venv then
                    return venv .. "/bin/python"
                end
                return "python3"
            end,
        },
    }

    -- Rust/C/C++ adapter (codelldb)
    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
            args = { "--port", "${port}" },
        },
    }

    dap.configurations.rust = {
        {
            name = "Launch",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
    }

    dap.configurations.c = dap.configurations.rust
    dap.configurations.cpp = dap.configurations.rust

    -- Signs
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped" })
end

return M
