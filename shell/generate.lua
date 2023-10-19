local ShellFiles = {}
local FileUtils = require("utils.files")

local parts = {
    "shell/parts/env",
    "shell/parts/aliases", 
    "shell/parts/functions",
    "shell/parts/shelloptions",
    "shell/parts/misc"
}

function ShellFiles.bash()
    local content = FileUtils.aggregate_files(parts)
    FileUtils.write_file(ShellFiles.root_path .. "/.bashrc", content)
end

function ShellFiles.zsh()
    local content = FileUtils.aggregate_files(parts)
    FileUtils.write_file(ShellFiles.root_path .. "/.zshrc", content)
end

function ShellFiles.fish()
    local content = FileUtils.aggregate_files(parts)
    FileUtils.write_file(ShellFiles.root_path .. "/.config/fish/config", content)
end

return ShellFiles