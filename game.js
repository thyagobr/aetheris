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

  let keys_pressed = {
    "KeyL": {
      is_pressed: false,
      perform: function () {
        character.x += character.speed;
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
    }
  };

  const handle_keydown = function () {
    Object.keys(keys_pressed).forEach(function (key_code) {
      if (keys_pressed[key_code].is_pressed == true) {
        keys_pressed[key_code].perform();
      }
    })
  }

  window.addEventListener('keydown', function (event) {
    if (keys_pressed[event.code] == undefined) {
      keys_pressed[event.code] = {
        is_pressed: false,
        perform: function () { console.log(event.code + " not implemented") } }
    }
    keys_pressed[event.code].is_pressed = true;
  });

  window.addEventListener('keyup', function (event) {
    if (keys_pressed[event.code] == undefined) {
      keys_pressed[event.code] = {
        is_pressed: false,
        perform: function () { console.log(event.code + " not implemented") } }
    }
    keys_pressed[event.code].is_pressed = false;
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

  const is_within_canvas_bounds = function (event, tile) {
    return (
      (event.x > tile.x) &&
      (event.x < tile.x + tile.width) &&
      (event.y > tile.y) &&
      (event.y < tile.y + tile.height));
  }

  const repaint = function () {
    map_tiles.forEach(function (tile) {
      if ((tile == undefined) || (tile.tile == null)) {
        ctx.strokeStyle = 'black';
        ctx.strokeRect(tile.x * 50, tile.y * 50, 50, 50);
      } else {
        ctx.strokeStyle = 'black';
        ctx.fillStyle = tile.tile
        ctx.fillRect(tile.x, tile.y, tile.width, tile.height);
      }
    })

    ctx.beginPath();
    ctx.fillStyle = character.image;
    ctx.fillRect(character.x, character.y, character.width, character.height);
  }

  setInterval(function () {
    handle_keydown();
    repaint();
  }, 33);
})();