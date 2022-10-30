# LnzLive guide

## Quickstart

Load a pet by double-clicking one of the Examples.

Edit the LNZ in the right-hand window.

Hit Ctrl+S to save and refresh the pet view. Your file will be saved in local storage.

Once a pet is loaded, you can paste in external LNZ. If using in a browser, your browser must have permission to access the clipboard.

## Help! It crashes when I do this!

LnzLive is definitely a work in progress!  

f you're using the web version, it should be fairly resilient. If you make a mistake in your LNZ (e.g. missing a space between two numbers) and the pet view goes all weird, you should be able to correct it and continue.

If you're using the Windows exe, run the debug version rather than the release version.

Raise an issue if you have a bug to point out. There's also a LnzLive channel on the Discord server "Hexers HQ". Check in there if you want to ask, chat or complain :)

## Basic navigation

Click and hold the left mouse button in the pet view (centre) to rotate the pet.

Click and hold the right mouse button to pan.

Use the mouse wheel to zoom in and out.

The pet view currently has a maximum size of 1000x1000px. If part of your pet is cut off when zoomed in, don't worry about it.

## File tools

Once you have a file saved in Local Storage (i.e. you have loaded an Example pet and hit Ctrl+S at least once), you can right click it to see some options.

While a file is loaded, you can hit Back Up to save a copy of the file named "yourfilename_backup.lnz". Note: this will overwrite any existing file of that name.

You can also rename or delete files in local storage.

## Advanced navigation

Turn on ball selection using the "Select" checkbox at the top of the screen.

Hover over balls to show their ball number.

Double-click a ball/addball to go directly to the LNZ line defining the ball/addball.

While hovering over a ball/addball, you can use the following keys:

- Z or B: go directly to the LNZ line defining the ball/addball
- X or M: cycle through Move lines that affect this ball. If none are found, goes to the Move header.
- C or P: cycle through Project Ball lines that affect this ball. If none are found, goes to the Project Ball header.
- V or L: cycle through Linez that include this ball. If none are found, goes to the Linez header.

## Drag and drop

Change the "Select" dropdown to "Move" and ensure the tickbox is ticked.

Click a ball to select it and show a 3D gizmo.

Use the gizmo arrows to drag in a given axis.

Projected balls will automatically update if the base ball is dragged.

Change the dropdown to "Project" to update projections.

Click to select the ball to project. Click another ball to select it as the base ball. The projected ball will show a gizmo to move forward or backward along the projection line.

Save to update the actual lnz file. Move/project changes will not be automatically saved.

## Tools menu

Warning: make sure you do not have empty lines or comments in your LNZ before using any Tools.

Press Ctrl+Space in the pet view to open the tools menu.

### Add ball

While a ball/addball is selected, use "Add ball" to create a new addball and line. If an addball is selected, the new addball will be parented to the same ball as the selected addball. The line will connect the selected addball and the new addball.

### Color

The Color menu can be used to recolor the pet. When you select a part to recolor, two text entry boxes will appear at your cursor. The first is for the ball colour, the second is for outline color. Type a color number (e.g. 25) and hit Enter to apply. Leave a box blank if you don't want to affect the color/outline.

### Color swap

The Color Swap tool under the Color menu can be used to quickly create a recolor. Enter the color mappings you want to apply (e.g. 35 -> 15). Use the checkboxes to select what to apply the color swap to.

### Copy L to R

The Copy L to R tool will apply all changes on the left side of the pet (i.e. the side with ball number 0 - in LnzLive this is currently the left side when looking at the pet head-on, NOT the pet's left side) to the right side. This includes balls, addballs, paintballs, lines, etc.

### Move head

LNZ has no such thing as a 'neck extension', so this is a small util to move all head balls at once. The three text boxes are for x, y, z coordinates to move by. Hit Enter to apply. You can keep hitting Enter to continue moving.

### Copy ball colors to clipboard

Useful for making Color Info Override sections in breeds. Not supported in all browsers.

## Backups

Color Swap and Copy L to R can be destructive! LnzLive takes a backup of your file before applying them, and saves it as "yourfilename_backup.lnz". The backup will overwrite any existing backup file.

## Custom textures

Custom bmp files can be loaded from local storage. There's no way to add these via the interface at the moment, but you can do it manually if you're using the Windows exe.

Go to %APPDATA%/Godot/app_userdata/PetzRendering/resources/textures (you may have to create this folder). Copy your textures directly into this folder, without subfolders. Relaunch LnzLive. If your textures have been loaded correctly, you will see them if you expand the Local Textures part of the filetree in the left panel.

Apply textures as normal in the LNZ data. LnzLive doesn't care about the full filepath, only the filename.

## Other features

While editing the LNZ:

- Place the editing cursor on any line in Ballz Info. You don't need to select the entire line, just place the cursor within it. Hit Ctrl+Q to make that ball flash in the pet view so you can locate it.
- Similarly, place the cursor on any line in the Add Ball section and hit Ctrl+Q to make the addball flash.