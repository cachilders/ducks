--lights out (ducks shall fall)
--by @cachilders

function _init()
 count = 0
 light = false
 floor = 120
end

function _update()
 if light then
  speed = 150
  spr_light_mod = 0
 else
  speed = 5
  spr_light_mod = 4
 end
 if count == 0 then
  display = 'up or down to play'
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

function increment_counter(count)
 return count + 1
end

function make_ducks()
 ducks = {}
 for i = 1, 5 do
  count = count + 1
  ducks[i] = {}
  ducks[i].x = (rnd(79 * 100) / 100) + 22
  ducks[i].y = 96
  ducks[i].counter = randomize_counter()
  ducks[i].direction = get_duck_direction()
  ducks[i].spr_x_mod = get_duck_spr_x_mod(ducks[i])
  ducks[i].spr_y_mod = get_duck_spr_y_mod(ducks[i])
  ducks[i].spr = 1
  ducks[i].jump = 0
  ducks[i].down = false
 end
end

function draw_ducks()
 for duck in all(ducks) do
  if not duck.down then
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
 duck.counter = increment_counter(duck.counter)
 if duck.counter > speed and not light then
  if duck.jump == 0 then
   sfx(1)
   duck.jump = 1
   duck.spr = 2 + spr_light_mod
   duck.spr_x_mod = get_duck_spr_x_mod(duck)
  elseif duck.jump == 1 then
   duck.jump = 2
   duck.spr = 3 + spr_light_mod
   duck.spr_x_mod = get_duck_spr_x_mod(duck)
   duck.x = get_duck_x_pos(duck, 8)
  else
   duck.jump = 0
   duck.spr = 1 + spr_light_mod
   duck.spr_x_mod = get_duck_spr_x_mod(duck)
  end
 elseif light then
  drop_duck(duck)
  duck.jump = 0
  duck.spr = 1 + spr_light_mod
  duck.spr_x_mod = get_duck_spr_x_mod(duck)
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
   duck.x = get_duck_x_pos(duck, 8)
   drop_duck(duck)
   if not duck.down then
    duck.direction = get_duck_direction()
    duck.spr_x_mod = get_duck_spr_x_mod(duck)
   end
  end
 end
end

function drop_duck(duck)
 if duck.x > 101 or duck.x < 22 then
  duck.down = true
  if duck.y == 96 then
   duck.x = get_duck_x_pos(duck, 2)
   duck.y = 104
   duck.spr = 1 + spr_light_mod
   duck.spr_x_mod = get_duck_spr_x_mod(duck)
   duck.spr_y_mod = get_duck_spr_y_mod(duck)
   duck.counter = 0
  elseif duck.y == 104 then
   if duck.counter > 2 then
    duck.x = get_duck_x_pos(duck, 2)
    duck.y = 112
    duck.spr = 2 + spr_light_mod
    duck.spr_x_mod = get_duck_spr_x_mod(duck)
    duck.spr_y_mod = get_duck_spr_y_mod(duck)
    duck.counter = 0
    sfx(2)
   else
    duck.counter = increment_counter(duck.counter)
   end
  elseif duck.y == 112 then
   if duck.counter > 2 then
    count = count - 1
    duck.x = get_duck_x_pos(duck, 2)
    duck.y = floor
    duck.spr = 4 + spr_light_mod
    duck.spr_x_mod = get_duck_spr_x_mod(duck)
    duck.spr_y_mod = get_duck_spr_y_mod(duck)
    light = true
   else
    duck.counter = increment_counter(duck.counter)
   end
  else
   if light and duck.spr > 4 then
    duck.spr = duck.spr - 4
   elseif not light and duck.spr < 5 then
    duck.spr = duck.spr + 4
   end
  end
 else
  duck.down = false
 end
end

function get_duck_direction()
 direction = rnd()
 if direction <= 0.5 then
  return 'r'
 else
  return 'l'
 end
end

function get_duck_spr_x_mod(duck)
 if duck.direction == 'r' then
  return nil
 else
  return 'flip_x'
 end
end

function get_duck_spr_y_mod(duck)
 if not duck.down or duck.y == floor then
  return nil
 else
  return 'flip_y'
 end
end

function get_duck_x_pos(duck, steps)
 if duck.direction == 'r' then
  return duck.x + steps
 else
  return duck.x - steps
 end
end

function get_cursor_position(val)
 local str = ''..val
 return 64 - (#str * 2) 
end
