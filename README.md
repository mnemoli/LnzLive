# LnzLive

![screenshot](screenshot.png)

[Edit and preview LNZ files in your browser!](https://mnemoli.github.io/LnzLive/export/index.html)

**Currently limited to desktop browsers.**

## Instructions

Load a sample pet by double-clicking it in the left-hand menu.

Click and drag in the centre screen to rotate the pet. Use the mouse wheel to zoom.

Edit the LNZ file in the right-hand text box. Hit Ctrl+S to save your changes and refresh the pet render.

When you save, the edited LNZ will be stored in your browser's local storage.

If you want to load your own pet, extract the LNZ using LNZ Pro, paste into the text box and save. Only pet files are fully supported; breed files may not display correctly. Pasting requires browser permission to access your clipboard. No data is sent anywhere; all files and data are processed client-side in your browser.

To view animations, type an animation number in the box at the top and hit enter. There are roughly 500 animations per species.

Use the Select checkbox to turn on ball selection. Hide addballs/paintballs if you don't want to select them.

While a ball/paintball is selected:
- Double-click or press Z or B to go to the ball in the Ball Info/Add Ball section.
- Press X or M to go to the ball in the Move section. If the ball doesn't exist there, you'll be taken to the start of the section. Press again to cycle through Moves for that ball.
- Press C or P to go to the ball in the Project section.  If the ball doesn't exist there, you'll be taken to the start of the section. Press again to cycle through Projections for that ball.

## Limitations

This app is in development. Expect crashes and visual bugs.

- Most textures are not supported. You will be able to upload custom textures in the future.
- Lines may disappear or glitch at certain view angles.
- Paintballs may not layer correctly.
- Addball positions may not be correct in some animations.

If you would like to help with development, raise [an issue](https://github.com/mnemoli/LnzLive/issues) (as long as it's not covered above) or a pull request.
