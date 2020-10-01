(function() {
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
      tile: "purple"
    }
  ]
  map_tiles = []

  ctx.beginPath();
  for (var y = 0; y < Math.floor(canvas.height / 50) - 2; y++)
  {
    for (var x = 0; x < 2; x++)
    {
      ctx.strokeStyle = 'purple';
      ctx.strokeRect(x * 50, 50 + y * 50, 50, 50);
      fill = tiles[(y * tiles_x) + x]
      if (fill != undefined) {
        ctx.fillStyle = fill.tile
        ctx.fillRect(x * 50, 50 + y * 50, 50, 50);
        fill.x = x * 50;
        fill.y = 50 + y * 50;
        fill.width = 50;
        fill.height = 50;
      }
    }
  }

  ctx.beginPath();
  for (var y = 0; y < tiles_y; y++)
  {
    for (var x = 0; x < tiles_x; x++)
    {
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

  window.addEventListener('click', function(event) {
    let tile = tiles.find(function(tile) {
      return (
        (event.x > tile.x) &&
        (event.x < tile.x + tile.width) &&
        (event.y > tile.y) &&
        (event.y < tile.y + tile.height))
    })

    if (tile) current_tile = tile.tile;
    else {
      if ((event.x > 110) &&
        (event.x < canvas.width) &&
        (event.y > 50) &&
        (event.y < canvas.height)) {
        tile = map_tiles.find(function (tile) {
          return ((event.x > tile.x) &&
            (event.x < tile.x + tile.width) &&
            (event.y > tile.y) &&
            (event.y < tile.y + tile.height))
        })
        if (tile) {
          console.log(tile)
          tile.tile = current_tile;
          repaint();
        }
      }
    }
    // Snap nearest divisor of the tile size
    //let x = event.x - (event.x % 50)
    //let y = event.y - (event.y % 50)

    //ctx.beginPath();
    //ctx.fillStyle = 'black';
    //ctx.fillRect(x, y, 50, 50);
  })

  const repaint = function() {
    map_tiles.forEach(function(tile) {
      if ((tile == undefined) || (tile.tile == null)) {
        ctx.strokeStyle = 'black';
        ctx.strokeRect(110 + x * 50, 50 + y * 50, 50, 50);
      } else {
        ctx.fillStyle = tile.tile
        ctx.fillRect(tile.x, tile.y, tile.width, tile.height);
      }
    })
  }

})();
