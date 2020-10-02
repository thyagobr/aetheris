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
      tile: "green"
    },
    {
      tile: "brown"
    },
    {
      tile: "blue"
    },
    {
      tile: "white"
    },
    {
      tile: "gray"
    }
  ]
  map_tiles = []

  ctx.beginPath();
  for (var y = 0; y < Math.floor(canvas.height / 50) - 2; y++) {
    for (var x = 0; x < 2; x++) {
      fill = tiles[(y * 2) + x]
      if (fill != undefined) {
        ctx.strokeStyle = 'black'
        ctx.strokeRect(x * 50, 50 + y * 50, 50, 50);
        ctx.fillStyle = fill.tile
        ctx.fillRect(x * 50, 50 + y * 50, 50, 50);
        fill.x = x * 50;
        fill.y = 50 + y * 50;
        fill.width = 50;
        fill.height = 50;
      }
    }
  }

  // Load
  ctx.strokeStyle = 'black';
  ctx.strokeRect(5, canvas.height - 160, 100, 40);
  ctx.font = '24px serif';
  ctx.fillText('Load', 15, canvas.height - 130);
  // Save
  ctx.strokeStyle = 'black';
  ctx.strokeRect(5, canvas.height - 110, 100, 40);
  ctx.font = '24px serif';
  ctx.fillText('Save', 15, canvas.height - 80);
  // Export
  ctx.strokeStyle = 'black';
  ctx.strokeRect(5, canvas.height - 60, 100, 40);
  ctx.font = '24px serif';
  ctx.fillText('Export', 15, canvas.height - 30);

  ctx.beginPath();
  for (var y = 0; y < tiles_y; y++) {
    for (var x = 0; x < tiles_x; x++) {
      map_tiles[(y * tiles_x) + x] = {
        tile: null,
        x: 110 + x * 50,
        y: 50 + y * 50,
        width: 50,
        height: 50
      }
      ctx.strokeStyle = 'black';
      ctx.strokeRect(110 + x * 50, 50 + y * 50, 50, 50);
    }
  }

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

  const detect_mouse_click = function (event) {
    // Panel side
    let tile = tiles.find(function (tile) {
      return is_within_canvas_bounds(event, tile);
    })
    if (tile) current_tile = tile.tile;
    // Drawing board side
    else {
      const drawing_board_dimensions = { x: 110, width: canvas.width - 110, y: 50, height: canvas.height - 50 }
      if (is_within_canvas_bounds(event, drawing_board_dimensions)) {
        tile = map_tiles.find(function (tile) {
          return is_within_canvas_bounds(event, tile);
        })
        if (tile) {
          console.log(tile)
          tile.tile = current_tile;
          repaint();
        }
      }
    }
  }

  const repaint = function () {
    map_tiles.forEach(function (tile) {
      if ((tile == undefined) || (tile.tile == null)) {
        ctx.strokeStyle = 'black';
        ctx.strokeRect(110 + x * 50, 50 + y * 50, 50, 50);
      } else {
        ctx.strokeStyle = 'black';
        ctx.lineWidth = 2;
        ctx.strokeRect(110 + x * 50, 50 + y * 50, 50, 50);
        ctx.fillStyle = tile.tile
        ctx.fillRect(tile.x, tile.y, tile.width, tile.height);
      }
    })
  }
})();