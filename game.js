(function () {
  console.log("Game started");
  const canvas = document.getElementById("canvas");
  const ctx = canvas.getContext('2d');

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  let tile_data = {
    tile_width: 50,
    tile_height: 50,
    tiles_x: Math.floor(canvas.width / 50),
    tiles_y: Math.floor(canvas.height / 50)
  }
  // let pixels_after_tile_x = 0;
  let pixels_after_tile_y = 0;


  let map_tiles = [];
  let map = {
    tile_width: 2 * tile_data.tiles_x,
    tile_height: 2 * tile_data.tiles_y,
    tiles: map_tiles
  }

  let debug_image = new Image();
  let image = new Image();
  image.src = "grass.jpeg";
  debug_image.src = "checkers_texture.png";

  ctx.beginPath();

  let keys_pressed = {
    "KeyL": {
      is_pressed: false,
      perform: function () {
        character.x += character.speed;
        camera.x += character.speed;
      }
    },
    "KeyI": {
      is_pressed: false,
      perform: function () {
        character.y -= character.speed;
      }
    },
    "KeyK": {
      is_pressed: false,
      perform: function () {
        character.y += character.speed;
      }
    },
    "KeyJ": {
      is_pressed: false,
      perform: function () {
        character.x -= character.speed;
      }
    },
    "KeyY": {
      is_pressed: false,
      // Detect player tile
      perform: function () {
        const { tile_x, tile_y } = player_tile();
        console.log(tile_x)
        map_tiles[(player_tile_y * (map.tile_width)) + player_tile_x].tile = 'purple'
      }
    }
  };

  const handle_keydown = function () {
    Object.keys(keys_pressed).forEach(function (key_code) {
      if (keys_pressed[key_code].is_pressed == true) {
        keys_pressed[key_code].perform();
      }
    })
  }

  const loop_canvas = function (callback) {
    for (y = 0; y < map.tile_height; y++) {
      for (x = 0; x < map.tile_width; x++) {
        callback(x, y);
      }
    }
  }
  const build_map = function () {
    loop_canvas(function (x, y) {
      var tile_index = Math.floor(Math.random() * 10);
      var tile = null;
      switch (tile_index) {
        case 0:
          tile = "brown"
          break;
        case 1:
          tile = "yellow"
          break;
        default:
          tile = "green"
          break;
      }
      map_tiles.push({
        x: x * 50,
        y: y * 50,
        width: 50,
        height: 50,
        tile: tile
      })
    })
  }
  build_map();

  // todo: this method doesn't register the keydown if no longer on
  // ***** the canvas. Gotta find another way...
  window.addEventListener('keydown', function (event) {
    if (keys_pressed[event.code] != undefined) {
      keys_pressed[event.code].is_pressed = true;
    }
  });

  // todo: this method doesn't register the keydown if no longer on
  // ***** the canvas. Gotta find another way...
  window.addEventListener('keyup', function (event) {
    if (keys_pressed[event.code] != undefined) {
      keys_pressed[event.code].is_pressed = false;
    }
  });

  window.addEventListener('mousedown', function (event) {
    //detect_mouse_click(event);
  });

  window.addEventListener('mousemove', function (event) {
    if (event.buttons == 1) {
      //detect_mouse_click(event);
    }
  });

  let character = {
    name: "Naztharune",
    image: "black",
    speed: 5,
    x: map_tiles[0].x,
    y: map_tiles[0].y,
    width: map_tiles[0].width,
    height: map_tiles[0].height
  }

  let camera = {
    x: character.x,
    y: character.y,
    width: map.tile_width,
    height: map.tile_height
  }

  const is_within_canvas_bounds = function (event, tile) {
    return (
      (event.x > tile.x) &&
      (event.x < tile.x + tile.width) &&
      (event.y > tile.y) &&
      (event.y < tile.y + tile.height));
  }
  
  const repaint = function () {
    // Draw map
    map_tiles.forEach(function (tile) {
      if ((tile == undefined) || (tile.tile == null)) {
        ctx.strokeStyle = 'black';
        ctx.strokeRect(tile.x * 50, tile.y * 50, 50, 50);
      } else {
        if (tile.x == 0) {
          pixels_after_tile_x = character.x;
          ctx.drawImage(debug_image, // source image
            pixels_after_tile_x, // source-x
            0, // source-y
            debug_image.width - pixels_after_tile_x, // source-width
            debug_image.height, // source-height
            tile.x, // destination-x
            tile.y, // destination-y
            debug_image.width - pixels_after_tile_x, // destination-width
            50) // destination-height
        }
        else {
          tile_width = tile.width;
          tile_height = tile.height;
          ctx.drawImage(image, tile.x - pixels_after_tile_x, tile.y, tile_width, tile_height)
        }
        //ctx.strokeStyle = 'black';
        //ctx.fillStyle = tile.tile
        //ctx.fillRect(tile.x, tile.y, tile.width, tile.height);
      }
    })

    // Draw character
    ctx.beginPath();
    ctx.fillStyle = character.image;
    ctx.fillRect(character.x, character.y, character.width, character.height);
  }

  const player_tile = function () {
    var tile_x = Math.floor(character.x / 50);
    var tile_y = Math.floor(character.y / 50);
    return { tile_x, tile_y };
  }

  setInterval(function () {
    handle_keydown();
    repaint();
  }, 33);
})();