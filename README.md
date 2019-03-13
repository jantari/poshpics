# poshpics

Inspired by [reddit-powershell-drawing](https://github.com/natemrice/reddit-powershell-drawing),
this is yet another script to display image files in the terminal.

It features two ways of fitting the image, either filling the console distorting the image
or finding the best fit without distorting it - leaving blank space around it if needed.

![Example screenshot](Header.png?raw=true "example screenshot")

### Syntax:

```powershell
.\draw.ps1 "C:\Path\To\Image.png"
.\draw.ps1 "C:\Path\To\Image.png" -Fit "FillTerminal"
```
