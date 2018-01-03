pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
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
 duck.counter = duck.counter + 1
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
   if duck.direction == 'r' then
    duck.x = duck.x + 8
   else
    duck.x = duck.x - 8
   end
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
   if duck.direction == 'r' then
    duck.x = duck.x + 8
   else
    duck.x = duck.x - 8
   end
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
   if duck.direction == 'r' then
    duck.x = duck.x + 2
   else
    duck.x = duck.x - 2
   end
   duck.y = 104
   duck.spr = 1 + spr_light_mod
   duck.spr_x_mod = get_duck_spr_x_mod(duck)
   duck.spr_y_mod = get_duck_spr_y_mod(duck)
   duck.counter = 0
  elseif duck.y == 104 then
   if duck.counter > 2 then
    sfx(2)
    if duck.direction == 'r' then
     duck.x = duck.x + 2
    else
     duck.x = duck.x - 2
    end
    duck.y = 112
    duck.spr = 2 + spr_light_mod
    duck.spr_x_mod = get_duck_spr_x_mod(duck)
    duck.spr_y_mod = get_duck_spr_y_mod(duck)
    duck.counter = 0
   else
    duck.counter = duck.counter + 1
   end
  elseif duck.y == 112 then
   if duck.counter > 2 then
    count = count - 1
    light = true
    if duck.direction == 'r' then
     duck.x = duck.x + 2
    else
     duck.x = duck.x - 2
    end
    duck.y = floor
    duck.spr = 4 + spr_light_mod
    duck.spr_x_mod = get_duck_spr_x_mod(duck)
    duck.spr_y_mod = get_duck_spr_y_mod(duck)
   else
    duck.counter = duck.counter + 1
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

function get_cursor_position(val)
 local str = ''..val
 return 64 - (#str * 2) 
end
__gfx__
0000000000000000000009000090000000000a000000000000000400004000000000090000000000000000000000000000000000000000000000015555100000
0000000000000000000090aa090aa00004990a000000000000004099040990000544090000000000000000000000000000000000000000000000000550000000
00700700000090000000090000900000009990900000400000000400004000000044404000000000000000000000000000000000000000000000000050000000
0007700000090aa00009999099990000049909000004099000044440444400000544040000000000000000000000000000000000000000000000000500000000
00077000000090000000999009990000444444440000400000004440044400005555555500000000000000000000000000000000000000000000000600000000
00700700009999000000404004040000444444440044440000005050050500005555555500000000000000000000000000000000000000000000000050000000
00000000000999000000000000000000000000000004440000000000000000000000000000000000000000000000000000000000000000000000000050000000
00000000000404000000000000000000000000000005050000000000000000000000000000000000000000000000000000000000000000000000000560000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000053333000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000333333330000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003333553333000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005355551530000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000511551150000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000051511500000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005555000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05151515155115515151515001511151511111151511151055555555555555550000000000000000000000000000000000000000000000000000015555100000
51111111111111111111111511111111111111111111111100055000000550000000000000000000000000000000000000000000000000000000000660000000
11111111111111111111111111111111111111111111111100055000000550000000000000000000000000000000000000000000000000000000000070000000
11111111111111111111111111111111111111111111111100050000000050000000000000001100000100000000000000000000000000000000000700000000
11111111111111111111111111111111111111111111111155555555555555555555555555555555555555550000000000000000000000000000000700000000
11111111111111111111111151111111111111111111111555555555555555555555555555555555555555550000000000000000000000000000000070000000
51111111111111111111111555111111111111111111115500000000000000000000000000000000000000000000000000000000000000000000000070000000
05151515111551115151515055555555555555555555555500000000000000000000000000000000000000000000000000000000000000000000000660000000
06c6c6c6c66cc66c6c6c6c600c6ccc6c6cccccc6c6ccc6c05555555555555555000000000000000000000000000000000000000000000000000003bbbb000000
6cccccccccccccccccccccc6cccccccccccccccccccccccc00055000000550000000000000000000000000000000000000000000000000000000bbbbbbbb0000
cccccccccccccccccccccccccccccccccccccccccccccccc0005500000055000000000000000110000010000000000000000000000000000000bbbb53bbbb000
cccccccccccccccccccccccccccccccccccccccccccccccc00050000000050000000000000015500001110000000000000000000000000000003b77a573b0000
cccccccccccccccccccccccccccccccccccccccccccccccc4444444444444444444444444444444444444444000000000000000000000000000077a77a770000
cccccccccccccccccccccccc5cccccccccccccccccccccc5444444444444444444444444444444444444444400000000000000000000000000000aa7aa700000
6cccccccccccccccccccccc655cccccccccccccccccccc550000000000000000000000000000000000000000000000000000000000000000000000aa77000000
06c6c6c6ccc66ccc6c6c6c6055555555555555555555555500000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000030313131313131313132002b2b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000033343434343434343435002b2b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
38383836383938383838383a3738383800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000002b2b2b2b2b002b00002b2b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000202121212121212121222b2b2b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000232424242424242424252b2b2b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
28282826282928282828282a2728282800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000012300d700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000153501c35003350023000000000000000000c700000000000000000000000000009700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 01424344

