(function () {
  console.log("Game started");
  const canvas = document.getElementById("canvas");
  const ctx = canvas.getContext('2d');

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
  let tiles_x = Math.floor(canvas.width / 50);
  let tiles_y = Math.floor(canvas.height / 50);

  let map_tiles = window.map.slice();
  ctx.beginPath();

  // Draws the map
  window.addEventListener('mousedown', function (event) {
    detect_mouse_click(event);
  });

  window.addEventListener('mousemove', function (event) {
    if (event.buttons == 1) {
      detect_mouse_click(event);
    }
  });

  let character = {
    name: "Naztharune",
    image: "black",
    x: 10,
    y: 10,
    width: 50,
    height: 50
  }

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
    if (tile) {
      current_tile = tile.tile;
      // set somewhere which color is chosen
      return;
    }
    const button_clicked = buttons.find(function(button) {
      return is_within_canvas_bounds(event, button.rect);
    });
    if (button_clicked)
    {
      console.log(button_clicked.label)
      button_clicked.perform();
    }
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
        ctx.strokeRect(110 + tile.x * 50, 50 + tile.y * 50, 50, 50);
      } else {
        ctx.strokeStyle = 'black';
        ctx.lineWidth = 2;
        ctx.strokeRect(110 + tile.x * 50, 50 + tile.y * 50, 50, 50);
        ctx.fillStyle = tile.tile
        ctx.fillRect(tile.x, tile.y, tile.width, tile.height);
      }
    })
  }

  repaint();
})();