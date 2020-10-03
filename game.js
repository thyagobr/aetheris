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

  const block_movement_if_going_into_path_blocker = function (character, movement) {
    // Big problem here: when we draw partially, even though
    var future_character = { ...character, ...movement }
    tile_x = Math.floor(future_character.x / 50);
    tile_y = Math.floor(future_character.y / 50);
    var future_tile = fetch_tile_for_xy_coord(tile_x, tile_y);
    if (future_tile.path_blocker === true) {
      console.log("Can't go:")
      console.log(future_character)
      console.log(future_tile)
      return true;
    }
    return false;
  }

  const calculate_movement_vector = function (character, movement) {

  }

  let keys_pressed = {
    "KeyL": {
      is_pressed: false,
      perform: function () {
        //if (block_movement_if_going_into_path_blocker(character, { x: character.x + character.speed })) return;
        character.x += character.speed;
        if (!in_middle_of_screen().x) character.local.x += character.speed;
        camera.x += character.speed;
      }
    },
    "KeyI": {
      is_pressed: false,
      perform: function () {
        character.y -= character.speed;
        if (!in_middle_of_screen().y) character.local.y -= character.speed;
        camera.y -= character.speed;
      }
    },
    "KeyK": {
      is_pressed: false,
      perform: function () {
        character.y += character.speed;
        if (!in_middle_of_screen().y) character.local.y += character.speed;
        camera.y += character.speed;
      }
    },
    "KeyJ": {
      is_pressed: false,
      perform: function () {
        //if (block_movement_if_going_into_path_blocker(character, { x: character.x - character.speed })) return;
        character.x -= character.speed;
        if (!in_middle_of_screen().x) character.local.x -= character.speed;
        camera.x -= character.speed;
      }
    },
    "KeyY": {
      is_pressed: false,
      // Detect player tile
      perform: function () {
        const { tile_x, tile_y } = player_tile();
        map_tiles[(tile_y * (map.tile_width)) + tile_x].tile = 'purple'
      }
    },
    "KeyC": {
      is_pressed: false,
      perform: function () {
        // console.log(character)
        // console.log(map)
        // console.log(tile_data)
        console.log("---")
        console.log("camera.x = " + camera.x)
        console.log("offset_left_x = " + (camera.offset_threshold.left.x));
        console.log("offset_right_x = " + (camera.offset_threshold.right.x));
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
      map_tiles.push({
        x: x * 50,
        y: y * 50,
        width: 50,
        height: 50,
        tile: "green",
        path_blocker: ((x == 0) || (y == 0) || (x == map.tile_width - 1) || (y == map.tile_height - 1))
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

  let mid_tile = map_tiles[
    (
      (Math.floor(map.tile_height / 2) * map.tile_width)
      +
      Math.floor(map.tile_width / 2)
    )]

  const fetch_tile_for_xy_coord = function (x, y) {
    return map_tiles[(y * map.tile_width) + x];
  }

  let character = {
    name: "Naztharune",
    image: "black",
    speed: 5,
    x: 0, //mid_tile.x,
    y: 0, //mid_tile.y,
    width: mid_tile.width,
    height: mid_tile.height,
    local: { // local is the actual x,y coord on the screen
      x: 0,
      y: 0
    }
  }

  let camera = {
    x: character.x,
    y: character.y,
    width: map.tile_width,
    height: map.tile_height,
    offset_threshold: {
      left: {
        x: (canvas.width / 2),
        y: (canvas.height / 2)
      },
      right: {
        x: (map.tile_width * tile_data.tile_width) - (canvas.width / 2),
        y: (map.tile_height * tile_data.tile_height) - (canvas.height / 2),
      }
    }
  }

  const is_within_canvas_bounds = function (event, tile) {
    return (
      (event.x > tile.x) &&
      (event.x < tile.x + tile.width) &&
      (event.y > tile.y) &&
      (event.y < tile.y + tile.height));
  }

  let offset_x = 0;
  let offset_y = 0;
  const repaint = function () {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    // Draw map
    map_tiles.forEach(function (tile) {
      if ((tile == undefined) || (tile.tile == null)) {
        ctx.strokeStyle = 'black'
        ctx.strokeRect(tile.x * 50, tile.y * 50, 50, 50);
      }
      else {
        var tile_width = tile.width
        var tile_height = tile.height
        // todo: console log the x-point of camera snapping
        // todo: create condition for freezing offset_* increase
        if (camera.x <= camera.offset_threshold.left.x) {
          offset_x = 0
        } else if (camera.x > camera.offset_threshold.right.x) {
          // use previous offset_x; do not increment
        } else {
          offset_x = camera.x - camera.offset_threshold.left.x
        }
        if ((camera.y >= camera.offset_threshold.left.y) &&
          (camera.y < camera.offset_threshold.right.y)) {
          offset_y = camera.y - camera.offset_threshold.left.y
        }
        if (tile.path_blocker) {
          ctx.drawImage(debug_image, tile.x - offset_x, tile.y - offset_y, tile_width, tile_height)
        }
        else {
          ctx.drawImage(image, tile.x - offset_x, tile.y - offset_y, tile_width, tile_height)
        }
      }
    })

    // Draw character
    ctx.beginPath();
    ctx.fillStyle = character.image;
    // world position
    ctx.fillRect(character.local.x, character.local.y, character.width, character.height);
  }

  const in_middle_of_screen = function () {
    var offset_x = ((camera.x > camera.offset_threshold.left.x) && (camera.x < camera.offset_threshold.right.x))
    var offset_y = ((camera.y > camera.offset_threshold.left.y) && (camera.y < camera.offset_threshold.right.y))
    return { x: offset_x, y: offset_y }
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