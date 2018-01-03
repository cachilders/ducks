--lights out (ducks shall fall)
--by @cachilders

function _init()
 count = 0
 light = false
 FLOOR = 120
end

function _update()
 if light then
  speed = 150
  spr_light_mod = 0
 else
  speed = 5
  spr_light_mod = 16
 end
 if count == 0 then
  display = "up or down to play"
 else
  display = count
 end
 if btn(2) and count == 0 then
  make_ducks()
 elseif btn(2) and not light then
  light = true
 end
 if btn(3) and count == 0 then
  make_ducks()
 elseif btn(3) and light then
  light = false
 end
end

function _draw()
 cls()
 draw_room()
 draw_ducks()
end

function randomize_counter()
 return rnd(5 * 100) / 100
end

function make_ducks()
 ducks = {}
 for i = 1, 5 do
  count = count + 1
  ducks[i] = {}
  ducks[i].x = (rnd(76 * 100) / 100) + 23
  ducks[i].y = 96
  ducks[i].counter = randomize_counter()
  ducks[i].direction = get_duck_direction()
  ducks[i].spr = 1
  ducks[i].jump = 0
  ducks[i].down = false
  get_duck_spr_x_mod(ducks[i])
  get_duck_spr_y_mod(ducks[i])
 end
end

function draw_ducks()
 for duck in all(ducks) do
  if duck.down != true then
   move_duck(duck)
  else
   drop_duck(duck)
  end
  spr(duck.spr, duck.x, duck.y, 1, 1, duck.spr_x_mod, duck.spr_y_mod)
 end
end

function draw_room()
 if light then
  print(display, get_cursor_position(display), 60, 8)
  map(0, 0, 0, 96, 16, 4)
  spr(46, 56, 40, 2, 2)
 else
  print(display, get_cursor_position(display), 60, 2)
  map(0, 4, 0, 96, 16, 4)
  spr(14, 56, 40, 2, 2)
 end
end

function jump_duck(duck)
 duck.counter = duck.counter + 1
 if duck.counter > speed and not light then
  if duck.jump == 0 then
   sfx(1)
   duck.jump = 1
   duck.spr = 2 + spr_light_mod
   get_duck_spr_x_mod(duck)
  elseif duck.jump == 1 then
   duck.jump = 2
   duck.spr = 3 + spr_light_mod
   get_duck_spr_x_mod(duck)
   duck.x = duck.x + 8
  else
   duck.jump = 0
   duck.spr = 1 + spr_light_mod
   get_duck_spr_x_mod(duck)
  end
 elseif light then
  drop_duck(duck)
  duck.jump = 0
  duck.spr = 1 + spr_light_mod
  get_duck_spr_x_mod(duck)
 end
end

function move_duck(duck)
 jump_duck(duck)
 if duck.counter > speed then
  if duck.counter > 6 then
   duck.counter = randomize_counter()
  else
   duck.counter = 0
  end
  if duck.jump == 0 then
   duck.counter = 0
   duck.direction = get_duck_direction()
   duck.spr_x_mod = get_duck_spr_x_mod(duck)
   drop_duck(duck)
   if duck.direction == "r" then
    duck.x = duck.x + 8
   else
    duck.x = duck.x - 8
   end
  end
 end
end

function get_duck_direction()
 direction = rnd()
 if direction <= 0.5 then
  return "r"
 else
  return "l"
 end
end

function get_duck_spr_x_mod(duck)
 if duck.direction == "r" then
  duck.spr_x_mod = nil
 else
  duck.spr_x_mod = flip_x
 end
end

function get_duck_spr_y_mod(duck)

 if duck.drop or duck.y == FLOOR then
  duck.spr_y_mod = nil
 else
  duck.spr_y_mod = flip_y
 end
end

function drop_duck(duck)
 if duck.x > 96 then
  if duck.y == 96 then
   duck.down = true
   duck.x = duck.x + 2
   duck.y = 104
   duck.spr = 9 + spr_light_mod
   get_duck_spr_x_mod(duck)
   get_duck_spr_y_mod(duck)
   duck.counter = 0
  elseif duck.y == 104 then
   if duck.counter > 2 then
    sfx(2)
    duck.x = duck.x + 2
    duck.y = 112
    duck.spr = 10 + spr_light_mod
    get_duck_spr_x_mod(duck)
    get_duck_spr_y_mod(duck)
    duck.counter = 0
   else
    duck.counter = duck.counter + 1
   end
  elseif duck.y == 112 then
   if duck.counter > 2 then
    count = count - 1
    light = true
    duck.x = duck.x + 2
    duck.y = FLOOR
    duck.spr = 12 + spr_light_mod
    get_duck_spr_x_mod(duck)
    get_duck_spr_y_mod(duck)
   else
    duck.counter = duck.counter + 1
   end
  else
   if light and duck.spr > 12 then
    duck.spr = duck.spr - 16
   elseif not light and duck.spr < 27 then
    duck.spr = duck.spr + 16
   end
  end
 else
  duck.down = false
 end
end

function get_cursor_position(val)
 local str = ""..val
 return 64 - (#str * 2) 
end
