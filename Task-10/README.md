# Artist Grid App

This is a Flutter app I made called **Artist Grid Tool**. It's for artists who use the "grid method" to copy or scale up a reference image while drawing — basically you overlay a grid on top of a photo, then draw the same grid (bigger) on your paper, and copy the image square by square. A lot of traditional artists actually do this by hand with rulers, so I thought it'd be a fun project to make a small tool for it.

## What it does

- You can **import a reference image** from your gallery.
- The app draws a **grid on top of the image** so you can see how it'll be divided into squares.
- There are two ways to set up the grid:
  - **Manual mode** — just pick how many rows and columns you want using sliders (1 to 20 each).
  - **By paper size** — pick a real paper size (A4, A3, A5, US Letter, or a Square), then choose how big you want each grid square to be in cm, and the app calculates how many rows/columns will fit on that paper for you. This way, whatever grid you draw on your actual paper will match up correctly.
- You can customize how the grid looks:
  - **Line thickness** (0.5 to 8)
  - **Line opacity** (10% to 100%) so the grid doesn't overpower the image if you want it more subtle
  - **Line color** — there's a set of preset colors (yellow, red, blue, green, black, white, orange) you can just tap to select

Basically the goal was to let someone upload a photo, get a proper grid overlay on it based on either their own preference or actual paper dimensions, and then just look at their screen while replicating that grid square by square on real paper.

## Why I made this

I made this mainly as a **practice project** to get better at Flutter, specifically:
- Working with **`StatefulWidget`** and `setState` to manage a lot of different variables changing at once (grid mode, rows, columns, paper size, line color, etc.)
- Using **`CustomPainter`** to actually draw the grid lines on top of the image, which was new to me — I had to learn how `Canvas` and `Paint` work in Flutter to draw lines at calculated positions.
- Using the **`image_picker`** package to let the user pick an image from their gallery and load it as bytes (`Uint8List`) instead of a file path, which was a bit different from what I expected.
- Doing some basic **math/logic** to calculate how many grid squares fit into a paper size based on cm measurements (`(paper.width / squareSizeCm).round()`), and clamping it so it doesn't create some ridiculous number of tiny squares by accident.

It's not a "finished" polished app, still a work in progress, but the core grid + image overlay logic works.

## How it works (a quick look under the hood)

- `_pickImage()` opens the gallery, and once an image is picked, it's read as bytes and stored in `_imageBytes`, which triggers the UI to rebuild and show the image.
- `_calculateGrid()` checks which mode is active:
  - If **paper size mode** is on, it calculates columns and rows based on the paper's actual width/height in cm divided by the chosen square size.
  - If **manual mode** is on, it just uses whatever rows/columns the user picked with the sliders.
- The `GridPainter` class (a `CustomPainter`) is what actually draws the grid — it loops through the number of columns and rows and draws vertical/horizontal lines at evenly spaced positions using `canvas.drawLine()`.
- All the sliders and color options just update state variables, which causes the grid to redraw instantly with the new settings.

## How to run

1. Open the project in Android Studio or VS Code.
2. Get the packages:
   ```
   flutter pub get
   ```
3. Run the app:
   ```
   flutter run
   ```

## Things I'd like to improve later

- Right now the grid is only for viewing on screen — it'd be cool to let users **export the gridded image** as a file so they can print it directly instead of just looking at their screen while drawing.
- Add an option to **flip or rotate** the reference image.
- Maybe let users **save their favorite grid settings** so they don't have to set it up every time.
