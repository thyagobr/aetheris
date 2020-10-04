(function () {
  console.log("Engine started");
  const canvas = document.getElementById("canvas");
  const ctx = canvas.getContext('2d');

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
  let tiles_x = Math.floor(canvas.width / 50) - 2;
  let tiles_y = Math.floor(canvas.height / 50) - 1;
  let tiles_x_offest = 50 * 2;
  let tiles_y_offest = 50 * 1;

  current_tile = null;
  tiles = [
    {
      file: new Image(),
      src: "grass.jpeg"
    },
    {
      file: new Image(),
      src: "checkers_texture.png"
    }
  ]
  // Let's prepare the source file here (otherwise it might not load on the loop)
  tiles.forEach(function (tile) {
    tile.file.src = tile.src;
  })

  var map_tiles = []

  buttons = [
    {
      label: "Load",
      rect: { x: 5, y: canvas.height - 160, width: 100, height: 40 }
    },
    {
      label: "Save",
      rect: { x: 5, y: canvas.height - 110, width: 100, height: 40 },
      perform: function () {
        var data = map_tiles.slice();
        filename = "map.json";

        if (!data) {
          console.error('No data')
          return;
        }

        if (!filename) filename = 'console.json'

        if (typeof data === "object") {
          data = JSON.stringify(data, undefined, 4)
        }

        var blob = new Blob([data], { type: 'text/json' }),
          e = document.createEvent('MouseEvents'),
          a = document.createElement('a')

        a.download = filename
        a.href = window.URL.createObjectURL(blob)
        a.dataset.downloadurl = ['text/json', a.download, a.href].join(':')
        e.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null)
        a.dispatchEvent(e)
      }
    },
    {
      label: "Open",
      rect: { x: 5, y: canvas.height - 60, width: 100, height: 40 }
    }
  ]

  ctx.beginPath();

  for (var y = 0; y < tiles_y; y++) {
    for (var x = 0; x < tiles_x; x++) {
      map_tiles[(y * tiles_x) + x] = {
        file: null,
        src: null,
        x: x * 50,
        y: y * 50,
        width: 50,
        height: 50
      }
      ctx.strokeStyle = 'black';
      ctx.strokeRect(110 + x * 50, 50 + y * 50, 50, 50);
    }
  }
  console.log(map_tiles)

  window.addEventListener('mousedown', function (event) {
    detect_mouse_click(event);
  });

  window.addEventListener('mousemove', function (event) {
    if (event.buttons == 1) {
      detect_mouse_click(event);
    }
  });

  const is_within_canvas_bounds = function (event, tile) {
    return (
      (event.x > tile.x) &&
      (event.x < tile.x + tile.width) &&
      (event.y > tile.y) &&
      (event.y < tile.y + tile.height));
  }

  const apply_board_offset = function (tile) {
    return {
      width: tile.width,
      height: tile.height,
      x: tile.x + 110,
      y: tile.y + 50
    }
  }

  const detect_mouse_click = function (event) {
    // Panel side
    let tile = tiles.find(function (tile) {
      return is_within_canvas_bounds(event, tile);
    })
    if (tile) {
      current_tile = tile;
      // set somewhere which color is chosen
      return;
    }
    const button_clicked = buttons.find(function (button) {
      return is_within_canvas_bounds(event, button.rect);
    });
    if (button_clicked) {
      console.log(button_clicked.label)
      button_clicked.perform();
    }
    // Drawing board side
    else {
      const drawing_board_dimensions = { x: 0, width: canvas.width, y: 0, height: canvas.height }
      if (is_within_canvas_bounds(event, apply_board_offset(drawing_board_dimensions))) {
        tile = map_tiles.find(function (tile) {
          return is_within_canvas_bounds(event, apply_board_offset(tile));
        })
        if (tile) {
          // If we point to the actual tile, we'll change it
          // (unless we copy it)
          // If we copy it, we don't want to overwrite X and Y
          // For now, let's just pick the file.
          tile.file = current_tile.file;
        }
      }
    }
  }

  const repaint = function () {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    // Left-side panel
    ctx.beginPath();
    for (y = 0; y < Math.floor(canvas.height / 50) - 2; y++) {
      for (x = 0; x < 2; x++) {
        fill = tiles[(y * 2) + x]
        if (fill != undefined) {
          ctx.drawImage(fill.file, x * 50, 50 + y * 50, 50, 50)
          ctx.strokeStyle = 'black'
          ctx.strokeRect(x * 50, 50 + y * 50, 50, 50);
          fill.x = x * 50;
          fill.y = 50 + y * 50;
          fill.width = 50;
          fill.height = 50;
        }
      }
    }

    // Drawing padd
    map_tiles.forEach(function (tile) {
      if ((tile == undefined) || (tile.file == null)) {
        ctx.strokeStyle = 'black';
        ctx.strokeRect(110 + tile.x, 50 + tile.y, tile.width, tile.height);
      } else {
        ctx.strokeStyle = 'black';
        ctx.lineWidth = 2;
        ctx.strokeRect(110 + tile.x, 50 + tile.y, tile.width, tile.height);
        if (tile.file) {
          ctx.drawImage(tile.file, 110 + tile.x, 50 + tile.y, tile.width, tile.height);
        }
        else {
          ctx.fillStyle = tile.tile
          ctx.fillRect(110 + tile.x, 50 + tile.y, tile.width, tile.height);
        }
      }
    })

    // Panel buttons 
    buttons.forEach(function (button) {
      ctx.strokeStyle = 'black';
      ctx.strokeRect(button.rect.x, button.rect.y, button.rect.width, button.rect.height);
      ctx.font = '24px serif';
      var text_width = ctx.measureText(button.label).width;
      var font_size = 24;
      var placement_x = (button.rect.x + (button.rect.width / 2) - (text_width / 2));
      var placement_y = (button.rect.y + (button.rect.height / 2) + (font_size / 3));
      ctx.fillText(button.label, placement_x, placement_y);
    });

  }

  window.requestAnimationFrame(game_loop)
  function game_loop() {
    repaint()
    window.requestAnimationFrame(game_loop)
  }
})();