local Menu = require('lib')

---------------

local function init ( self ) 
  self.cursor = 1
  self:trigger( 'draw' )
end

local function draw ( self )
  self:trigger( 'clear' )
  for i, v in ipairs(self:getItems()) do
    print( (self.cursor == i and '> ' or '  ') .. v:getProp('text') )
  end
end

local function clear ( self )
  os.execute('clear')
end

local function down ( self )
  if (self.cursor >= #self:getItems()) then return false end
  self.cursor = self.cursor + 1
  self:trigger( 'draw' )
  return true
end

local function up ( self )
  if (self.cursor <= 1) then return false end
  self.cursor = self.cursor - 1
  self:trigger( 'draw' )
  return true
end

local function enter ( self )
  local item = self:getItems()[self.cursor];
  return item:trigger( 'action' )
end

local function destroy ( self ) -- self == room (2)
  self:trigger( 'clear' )
  self.cursor = nil 
end

---------------

local machine = Menu.Machine:new()

local mainmenu = Menu.Room:new()

local newgame = Menu.Item:new()
newgame:setProp( 'text', "New Game" )
mainmenu:addItem( newgame )

local loadgame = Menu.Item:new()
loadgame:setProp( 'text', "Load Game" )
mainmenu:addItem( loadgame )

local settings = Menu.Item:new()
settings:setProp( 'text', "Settings" )
settings:addEvent( 'action', function () print('SETTINGS!') end)
mainmenu:addItem( settings )

local quit = Menu.Item:new()
quit:setProp( 'text', "Quit" )
mainmenu:addItem( quit )

mainmenu:addEvent( 'init', init )
mainmenu:addEvent( 'draw', draw )
mainmenu:addEvent( 'clear', clear )
mainmenu:addEvent( 'down', down )
mainmenu:addEvent( 'up', up )
mainmenu:addEvent( 'enter', enter )
mainmenu:addEvent( 'destroy', destroy )
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