local Menu = require('lib')
local inspect = require('inspect')

---------------

local function init ( room ) 
  room.cursor = 1
  room:trigger( 'draw' )
end

local function draw ( room )
  room:trigger( 'clear' )
  for i, v in ipairs(room:getItems()) do
    print( (room.cursor == i and '> ' or '  ') .. v:get('text') )
  end
end

local function clear ( room )
  os.execute('clear')
end

local function down ( room )
  if (room.cursor >= #room:getItems()) then return false end
  room.cursor = room.cursor + 1
  room:trigger( 'draw' )
  return true
end

local function up ( room )
  if (room.cursor <= 1) then return false end
  room.cursor = room.cursor - 1
  room:trigger( 'draw' )
  return true
end

local function enter ( room, machine )
  local item = room:getItems()[room.cursor];
  return item:trigger( 'action', room, machine )
end

local function destroy ( room ) -- room == room (2)
  room:trigger( 'clear' )
  room.cursor = nil 
end

---------------

local machine = Menu.Machine:new()

local mainmenu = Menu.Room:new()

local newgame = Menu.Item:new()
newgame:set( 'text', "New Game" )
mainmenu:addItem( newgame )

local loadgame = Menu.Item:new()
loadgame:set( 'text', "Load Game" )
mainmenu:addItem( loadgame )

local settings = Menu.Item:new()
settings:set( 'text', "Settings" )
settings:on( 'action', function ( item, room, machine ) print('SETTINGS!', inspect( room ), inspect( machine )) end)
mainmenu:addItem( settings )

local quit = Menu.Item:new()
quit:set( 'text', "Quit" )
mainmenu:addItem( quit )

mainmenu:on( 'init', init )
mainmenu:on( 'draw', draw )
mainmenu:on( 'clear', clear )
mainmenu:on( 'down', down )
mainmenu:on( 'up', up )
mainmenu:on( 'enter', enter )
mainmenu:on( 'destroy', destroy )
machine:addRoom( 'mainmenu', mainmenu )

machine:init ( 'mainmenu' )

---------------

os.execute("sleep 1")
machine:trigger('down')
machine:trigger('down')
machine:trigger('down')
machine:trigger('down')
os.execute("sleep 1")
machine:trigger('up')
os.execute("sleep 1")
machine:trigger('enter')

---------------

-- Как дать возможность предмету производить переход между комнатами (по сути, управлять машиной):
-- 1) напрямую через ссылку на машину - криво
-- 2) (!) посредством передачи ссылки на родителя (createRoom, createItem)
-- 3) через какое-нить странное приватное свойство, связывающее предметы и машину