# PSBanner

Banner written in PowerShell.

It's inspired by [mattn/gobanner](https://github.com/mattn/gobanner) .

## How to Install

## Usage

### Write-Banner (psbanner)

```ps1
# default
Write-Banner "Hello!"

# change font name, size
Write-Banner "Hello!" -FontName "Consolas" -FontSize 14

# use pipeline
"Hello!" | Write-Banner

# use emoji
Write-Banner "😊" -FontName "Segoe UI Emoji" -FontSize 20

# vertical writing :)
"日本" -as [char[]] | Write-Banner
```

### Get-FontFamilies

```ps1
# no parameters
Get-FontFamilies
```

## License

MIT
