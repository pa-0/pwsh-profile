# 🎨 PowerShell Profile (Pretty PowerShell)

A stylish and functional PowerShell profile that looks and feels almost as good as a Linux terminal.

## ⚡ One Line Install (Elevated PowerShell Recommended)

Execute the following command in an elevated PowerShell window to install the PowerShell profile...

<ins>for `pwsh.exe` (PowerShell Core's standalone shell)</ins>:

```bash
irm "https://github.com/poa00/powershell-profile/raw/poa00.profile/setup.ps1" | iex
```

>[`pwsh` profile - direct link)](https://github.com/poa00/powershell.profile/raw/poa00.profile/setup.ps1)

<ins>for `code.exe` (Visual Studio Code's integrated terminal)</ins>:

```bash
irm "https://github.com/poa00/powershell.profile/raw/poa00.profile/setupVSC.ps1" | iex
```

>[`code` profile - direct link](https://github.com/poa00/powershell.profile/raw/poa00.profile/setupVSC.ps1)

## 🛠️ Fix the Missing Font

After running the script, you'll have two options for installing a font patched to support icons in PowerShell:

### 1) You will find a downloaded `cove.zip` file in the folder you executed the script from. Follow these steps to install the patched `Caskaydia Cove` nerd font family:

1. Extract the `cove.zip` file.
2. Locate and install the nerd fonts.

### 2) With `oh-my-posh` (loaded automatically through the PowerShell profile script hosted on this repo):
1. Run the command `oh-my-posh font install`
2. A list of Nerd Fonts will appear like so:
<pre>
PS> oh-my-posh font install

   Select font

  > 0xProto
    3270
    Agave
    AnonymousPro
    Arimo
    AurulentSansMono
    BigBlueTerminal
    BitstreamVeraSansMono

    •••••••••
    ↑/k up • ↓/j down • q quit • ? more</pre>
3. With the up/down arrow keys, select the font you would like to install and press <kbd>ENTER</kbd>
4. DONE!
   
Now, enjoy your enhanced and stylish PowerShell experience! 🚀
