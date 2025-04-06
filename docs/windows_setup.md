# Configurando Windows + WSL2 + ArchLinux

## 🎨 Como adicionar um tema no Windows Terminal

### ✅ 1. Abra as configurações do Windows Terminal

- Atalho: `Ctrl + ,`  
- Ou clique na setinha ↓ no topo da aba > **Settings**

> Isso vai abrir a interface gráfica de configurações.  
> **Mas a parte de adicionar temas você precisa fazer no JSON manualmente.**

---

### ✅ 2. Abra o `settings.json`

Na parte inferior da tela de configurações, clique em:

> **"Open JSON file"**

Isso vai abrir o arquivo `settings.json` (geralmente no seu VS Code ou outro editor).

---

### ✅ 3. Adicione seu tema (esquema de cores) na chave `schemes`

Procure (ou adicione) a seção `"schemes": [ ... ]` e insira seu tema.  
Exemplo com **Tokyonight**:

```json
"schemes": [
  {
    "name": "Tokyo Night",
    "black": "#1a1b26",
    "red": "#f7768e",
    "green": "#9ece6a",
    "yellow": "#e0af68",
    "blue": "#7aa2f7",
    "purple": "#bb9af7",
    "cyan": "#7dcfff",
    "white": "#a9b1d6",
    "brightBlack": "#414868",
    "brightRed": "#f7768e",
    "brightGreen": "#9ece6a",
    "brightYellow": "#e0af68",
    "brightBlue": "#7aa2f7",
    "brightPurple": "#bb9af7",
    "brightCyan": "#7dcfff",
    "brightWhite": "#c0caf5",
    "background": "#1a1b26",
    "foreground": "#c0caf5"
  }
],
```

> Se não tiver `"schemes": []`, pode adicionar essa chave perto do final do JSON.

---

### ✅ 4. Aplique o tema ao seu perfil do WSL

Na seção `"profiles" > "list"`, ache o perfil do seu WSL (ex: Ubuntu) e adicione:

```json
"colorScheme": "Tokyo Night"
```

Exemplo completo:

```json
{
  "guid": "{algum-guid}",
  "name": "Ubuntu",
  "source": "Windows.Terminal.Wsl",
  "colorScheme": "Tokyo Night",
  "commandline": "wsl.exe",
  "hidden": false
}
```

---

### ✅ 5. Salve o arquivo e veja a mágica acontecer ✨

Assim que você salvar o `settings.json`, o tema já entra em ação!
