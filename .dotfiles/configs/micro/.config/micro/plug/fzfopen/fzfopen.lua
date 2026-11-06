VERSION = "1.0.0"

-- Open a file picked with fzf (uses FZF_DEFAULT_COMMAND, so fd and its ignore list).
-- Opens in the current pane if it is an empty, unsaved buffer, otherwise in a new tab.
local config = import("micro/config")
local shell = import("micro/shell")

function fzfopen(bp)
    local output, err = shell.RunInteractiveShell("fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'", false, true)
    if err ~= nil then
        return
    end
    local path = output:gsub("[\r\n]+$", "")
    if path == "" then
        return
    end
    local quoted = "\"" .. path:gsub("\\", "\\\\"):gsub("\"", "\\\"") .. "\""
    if bp.Buf.Path == "" and not bp.Buf:Modified() then
        bp:HandleCommand("open " .. quoted)
    else
        bp:HandleCommand("tab " .. quoted)
    end
end

function init()
    config.MakeCommand("fzf", fzfopen, config.NoComplete)
end
