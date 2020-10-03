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

var map_tiles = [];
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
  var future_character = { ...character, ...movement }
  // todo: if path_blockers break, it could be that we're using the world space instead of local
  tile_x = Math.floor(future_character.x / 50);
  tile_y = Math.floor(future_character.y / 50);
  // todo: we're verifyingg top and left, but not the collision from bottom and right
  // ****: must check collision as a square, not as a point
  //var collision_detected = detect_surrounding_collisions(tile_x, tile_y);
  var collision_detected = detect_surrounding_collisions(tile_x, tile_y);
  // todo: We have to let the user go until they actually hit the border
  // ****: Maybe the function returns the number of pixels we'll actually move
  if (collision_detected) {
    console.log("Can't go:")
    return true;
  }
  return false;
}

let keys_pressed = {
  "KeyL": {
    is_pressed: false,
    perform: function () {
      if (block_movement_if_going_into_path_blocker(character, { x: character.x + character.speed })) return;
      character.x += character.speed;
      if (!in_middle_of_screen().x) character.local.x += character.speed;
      camera.x += character.speed;
    }
  },
  "KeyI": {
    is_pressed: false,
    perform: function () {
      if (block_movement_if_going_into_path_blocker(character, { y: character.y - character.speed })) return;
      character.y -= character.speed;
      if (!in_middle_of_screen().y) character.local.y -= character.speed;
      camera.y -= character.speed;
    }
  },
  "KeyK": {
    is_pressed: false,
    perform: function () {
      if (block_movement_if_going_into_path_blocker(character, { y: character.y + character.speed })) return;
      character.y += character.speed;
      if (!in_middle_of_screen().y) character.local.y += character.speed;
      camera.y += character.speed;
    }
  },
  "KeyJ": {
    is_pressed: false,
    perform: function () {
      if (block_movement_if_going_into_path_blocker(character, { x: character.x - character.speed })) return;
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
      console.log(character)
      console.log(map)
      console.log(tile_data)
    }
  },
  "KeyT": {
    is_pressed: false,
    perform: function () {
      console.log("highlithg called")
      let surrounding_boxes = []
      surrounding_boxes.push(map_tiles[(Math.floor(character.y / 50) * map.tile_width) + Math.floor(character.x / 50)])
      surrounding_boxes.push(map_tiles[(Math.floor(character.y / 50) * map.tile_width) + Math.floor((character.x + tile_data.tile_width) / 50)])
      surrounding_boxes.push(map_tiles[(Math.floor((character.y + tile_data.tile_height) / 50) * map.tile_width) + Math.floor(character.x / 50)])
      surrounding_boxes.push(map_tiles[(Math.floor((character.y + tile_data.tile_height) / 50) * map.tile_width) + Math.floor((character.x + tile_data.tile_width) / 50)])
      surrounding_boxes.forEach(function (box) {
        if (box) {
          console.log("highliting: " + box.x + ", " + box.y)
          box.highlight = true;
        }
      })
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

const detect_surrounding_collisions = function (x, y) {
  let surrounding_boxes = []
  // top-left
  surrounding_boxes.push(map_tiles[(y * map.tile_width) + x])
  // top-right
  // todo: INVESTIGATE: why the off_by_one problem on width?
  surrounding_boxes.push(map_tiles[(y * map.tile_width) + (x + tile_data.tile_width + 1)])
  // bottom-left
  surrounding_boxes.push(map_tiles[((y + tile_data.tile_height) * map.tile_width) + x])
  // bottom-right
  surrounding_boxes.push(map_tiles[((y + tile_data.tile_height) * map.tile_width) + (x + tile_data.tile_width)])
  var should_block_movement = surrounding_boxes.some((box) => box && box.path_blocker === true)
  return should_block_movement;
}

let character = {
  name: "Naztharune",
  image: "black",
  speed: 5,
  x: 50, //mid_tile.x,
  y: 50, //mid_tile.y,
  width: mid_tile.width,
  height: mid_tile.height,
  local: { // local is the actual x,y coord on the screen
    x: 50,
    y: 50
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
      if (tile.highlight) {
        ctx.strokeStyle = 'black'
        ctx.strokeRect(tile.x - offset_x, tile.y - offset_y, 50, 50);
      }
    }
  })

  // Draw character
  ctx.beginPath();
  ctx.fillStyle = character.image;
  // world position
  ctx.fillRect(character.local.x, character.local.y, character.width, character.height);
}

// returns whether or not the player should be frozen and the camera move
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

window.requestAnimationFrame(game_loop)
function game_loop() {
  handle_keydown()
  repaint()
  window.requestAnimationFrame(game_loop)
}