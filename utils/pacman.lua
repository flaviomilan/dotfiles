local Pacman = {}

function Pacman.execute_command(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return result
end

-- Function to install packages using Pacman
function Pacman.install_packages(packages)
    local package_list = table.concat(packages, " ")
    local pacman_command = "sudo pacman -S --noconfirm " .. package_list
    print("Installing packages: " .. package_list)
    local output = Pacman.execute_command(pacman_command)
    print(output)
    print("Packages installed successfully.")
end

return Pacman