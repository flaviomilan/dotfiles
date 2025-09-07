# 🚀 Dotfiles for a Terminal-Centric Life

Welcome to my dotfiles! This is where the magic happens for all the terminal lovers out there. These dotfiles are packed with tools and keymaps to make your command-line life smoother, faster, and, dare I say, cooler.

This setup is managed by `stow` for symlinking, uses `mise` for runtime version management, and is built around `zsh`, `tmux`, and `neovim`.

## ✨ Features

Here's the squad of tools that'll supercharge your terminal:

- **Shell & Multiplexer**: `zsh`, `tmux`, and `starship` for a powerful and beautiful prompt.
- **Editor**: `Neovim` configured with `lazy.nvim` for a fast and extensible IDE experience.
- **Version Management**: `mise` to manage versions for Node, Python, Java, Go, and more without cluttering your system.
- **Fuzzy Finding**: `fzf` and `fd` for finding files and history faster than you can type.
- **Git**: `lazygit` for a simple and effective terminal UI, enhanced with `fzf-git` scripts.
- **Utilities**: `eza` (a modern `ls`), `bat` (a `cat` with wings), `tldr` (community-driven man pages), and `zoxide` (a smarter `cd`).

## ⚙️ Installation

This repository is designed to be set up with a single script.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2.  **Run the installer:**
    ```bash
    ./install.sh
    ```
    The script will use `gum` to present an interactive prompt, allowing you to select your OS and which applications to install.

## 🔌 Post-Installation

After the script finishes, a few manual steps are required to complete the setup.

### 1. Configure Git with 1Password

This setup uses the `1Password` CLI (`op`) to securely fetch your Git credentials.

1.  Ensure you have created a "Login" item in your 1Password vault containing your Git `name` (in the username field) and `email` (in the password field).
2.  Edit the `.gitconfig` file located at `~/dotfiles/configs/git/.gitconfig`.
3.  Replace the placeholder URIs with the correct secret reference links from 1Password for your name and email:
    ```ini
    [user]
      # Replace with your actual 1Password secret URIs
      name = !op read "op://<your_vault>/<item_name>/username" --no-newline
      email = !op read "op://<your_vault>/<item_name>/password" --no-newline
    ```

### 2. Setup Neovim

The first time you launch Neovim, `lazy.nvim` will automatically install all the configured plugins.

```bash
nvim
```
You may need to restart Neovim after the installation is complete.

## 💡 Usage Highlights & Keymaps

Here are some of the keybindings that make this environment efficient. Note that `<leader>` is mapped to the `Space` key.

### Neovim

-   **LSP (Language Server Protocol)**:
    -   `K`: Show documentation for the symbol under the cursor.
    -   `gd`: Go to definition.
    -   `gr`: Find references.
    -   `<leader>ca`: Show code actions.
    -   `<leader>lr`: Rename symbol.
-   **Telescope (Fuzzy Finder)**:
    -   `<leader>sf`: Find files.
    -   `<leader>sg`: Live grep for text in your project.
    -   `<leader>sd`: Search diagnostics (errors, warnings).
    -   `<leader><leader>`: Find open buffers.
-   **Java Development**:
    -   `<leader>lU`: Update project configuration (downloads dependencies).
    -   `<leader>lo`: Organize imports.

### Tmux

-   **Prefix**: `Ctrl + a`
-   **Panes**:
    -   `|`: Split pane horizontally.
    -   `-`: Split pane vertically.
    -   `Ctrl + h/j/k/l`: Navigate between panes (and Neovim splits).

## 🔧 Extending Your Dotfiles

This project is structured to be easily extensible. Here is the general workflow for adding a new application (e.g., `my-new-app`):

1.  **Add to `mise` (Optional)**: If the tool's version is managed by `mise`, add it to the `[tools]` section in `mise.toml`.
2.  **Add to Installer**: Add the application's package name to the appropriate package list in the `setup/` directory (e.g., `packages_arch_cli.txt`).
3.  **Add Configuration Files**:
    -   Create a new directory for the app: `configs/my-new-app/`.
    -   Place the configuration files inside, maintaining the directory structure you want them to have in your home directory (e.g., `configs/my-new-app/.config/my-new-app/config.toml`).
4.  **Run the Installer**: The `install.sh` script will automatically detect the new application, install it via the package manager, and use `stow` to symlink the configuration files from `configs/my-new-app/` to the correct location.

## 📂 Project Structure

-   `configs/`: Contains the configuration directories for each application (e.g., `nvim`, `tmux`). These are managed by `stow`.
-   `setup/`: Contains the installation scripts and package lists for different operating systems.
-   `install.sh`: The main installation script that orchestrates the setup.
-   `mise.toml`: Defines the tool versions (Node, Python, etc.) managed by `mise`.

## 📜 License

These dotfiles are open-source and licensed under the MIT License. Feel free to use, modify, and enjoy!
