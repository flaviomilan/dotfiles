# 🚀 Dotfiles for a Terminal-Centric Life

Welcome to my dotfiles! This is where the magic happens for all the terminal lovers out there. If you live in the terminal and want to make it even more awesome, you've come to the right place! These dotfiles are packed with tools and keymaps to make your command-line life smoother, faster, and, dare I say, cooler.

## 🛠️ Terminal Utilities

Here's the squad of tools that'll supercharge your terminal:

- **mise**: Dev tools, environment variables, task runner — it's like your terminal's personal assistant.
- **fzf**: 🌸 A fuzzy finder that lets you find stuff faster than you can say "I love my terminal."
- **fd**: A snappy alternative to `find`. It’s like `find`, but faster and cooler.
- **bat**: A `cat` clone with wings! Display your files with style.
- **tldr**: 📚 Collaborative cheatsheets for your terminal commands. Because who doesn’t forget `grep` options sometimes?
- **zoxide**: A smarter `cd` command that actually knows where you’re going. No more hunting for directories!
- **eza**: `ls` on steroids. A modern twist on listing files.
- **git-fzf**: Git + fzf = pure joy. Navigate your Git history like a boss.
- **lazygit**: A Git UI that’s so simple, you’ll wonder why you ever used Git the old way.

## 🎮 Keymap

Here’s where the real fun begins: key bindings and shortcuts to make you feel like a terminal ninja. These keymaps are optimized to work perfectly with the tools listed above. Get ready for some serious terminal speedrunning!

### fzf

- <kbd>CTRL-T</kbd>: Trigger fuzzy file search (using `fd` for file navigation)
- <kbd>ALT-C</kbd>: Trigger fuzzy directory search (using `fd` for directories)
- <kbd>CTRL-R</kbd>: Trigger reverse search (history search)

### fzf-git

* <kbd>CTRL-G</kbd><kbd>CTRL-F</kbd> for **F**iles
* <kbd>CTRL-G</kbd><kbd>CTRL-B</kbd> for **B**ranches
* <kbd>CTRL-G</kbd><kbd>CTRL-T</kbd> for **T**ags
* <kbd>CTRL-G</kbd><kbd>CTRL-R</kbd> for **R**emotes
* <kbd>CTRL-G</kbd><kbd>CTRL-H</kbd> for commit **H**ashes
* <kbd>CTRL-G</kbd><kbd>CTRL-S</kbd> for **S**tashes
* <kbd>CTRL-G</kbd><kbd>CTRL-L</kbd> for ref**l**ogs
* <kbd>CTRL-G</kbd><kbd>CTRL-W</kbd> for **W**orktrees
* <kbd>CTRL-G</kbd><kbd>CTRL-E</kbd> for **E**ach ref (`git for-each-ref`)

## 🛠️ Aliases
These aliases are designed to save you time and make your terminal experience even smoother:

- `tree` → View your directories like a pro
- `dtree` → For directories only, no files!
- `lg` → Because who doesn’t want a simple Git UI?

### git
- `ga` → git add . (Add all the things)
- `gs` → git status -s (Quick status, because you’re efficient)
- `gc` → git commit -m (Commit messages made easy)
- `gp` → git pull origin main --rebase (Keep your branch fresh)
- `glog` → See all your commits with style

## 🛠️ Setup

## 📜 License

These dotfiles are open-source and licensed under the MIT License. Feel free to use, modify, and enjoy! See the LICENSE file for more details.
