local Menu = require('machina')

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
end

local function up ( room )
  if (room.cursor <= 1) then return false end
  room.cursor = room.cursor - 1
  room:trigger( 'draw' )
end

local function enter ( room, machine )
  local item = room:getItems()[room.cursor];
  return item:trigger( 'action', room, machine )
end

local function destroy ( room )
  room:trigger( 'clear' )
  room.cursor = nil
end

---------------

local machine = Menu.Machine:new()

local mainmenu = machine:createRoom( 'mainmenu' )

local newgame = mainmenu:createItem()
newgame:set( 'text', "New Game" )
newgame:on( 'action', function ( item, room, machine ) machine:move( 'newgamemenu' ) end)

local loadgame = mainmenu:createItem()
loadgame:set( 'text', "Load Game" )

local settings = mainmenu:createItem()
settings:set( 'text', "Settings" )
settings:on( 'action', function ( item, room, machine ) return machine:follow( 'settings', item, room ) end)
settings:route( 'settings', 'settingsmenu', function ( route, item, room, machine ) print( 'before', 'In ' .. room.name ) end, function (route, item, room, machine ) print( 'after', 'In ' .. room.name ) end )

local quit = mainmenu:createItem()
quit:set( 'text', "Quit" )
quit:on( 'action', function () print('Exiting...'); os.exit() end)

mainmenu:on( 'init', init )
mainmenu:on( 'draw', draw )
mainmenu:on( 'clear', clear )
mainmenu:on( 'down', down )
mainmenu:on( 'up', up )
mainmenu:on( 'enter', enter )
mainmenu:on( 'destroy', destroy )

local newgamemenu = machine:createRoom( 'newgamemenu' )

local settingsmenu = Menu.Room:new()

local game = Menu.Item:new()
game:set( 'text', "Game" )
settingsmenu:addItem( game )

local video = Menu.Item:new()
video:set( 'text', "Video" )
settingsmenu:addItem( video )

local audio = Menu.Item:new()
audio:set( 'text', "Audio" )
settingsmenu:addItem( audio )

local back = Menu.Item:new()
back:set( 'text', "Back" )
back:on( 'action', function ( item, room, machine ) return machine:move( 'mainmenu' ) end)
settingsmenu:addItem( back )

settingsmenu:on( 'init', init )
settingsmenu:on( 'draw', draw )
settingsmenu:on( 'clear', clear )
settingsmenu:on( 'down', down )
settingsmenu:on( 'up', up )
settingsmenu:on( 'enter', enter )
settingsmenu:on( 'destroy', destroy )
machine:addRoom( 'settingsmenu', settingsmenu )

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
os.execute("sleep 1")
machine:trigger('down')
machine:trigger('down')
machine:trigger('down')
machine:trigger('down')
os.execute("sleep 1")
machine:trigger('enter')
os.execute("sleep 1")
machine:trigger('enter')