Menu = require('lib')

machine = Menu.Machine:new()

mainmenu = Menu.Room:new()
mainmenu:addItem({ text = "New Game" })
mainmenu:addItem({ text = "Load Game" })
mainmenu:addItem({ text = "Settings" })
mainmenu:addItem({ text = "Quit" })

mainmenu:addEvent( 'init', function (self) 
  self.cursor = 1
  self:trigger( 'draw' )
end)

mainmenu:addEvent( 'draw', function (self)
  self:trigger( 'clear' )
  for i, v in ipairs(self:getItems()) do
    print( (self.cursor == i and '> ' or '  ') .. v.text)
  end
end)

mainmenu:addEvent( 'clear', function (self)
  os.execute('clear')
end)

mainmenu:addEvent( 'down', function (self)
  if (self.cursor >= #self:getItems()) then return false end
  self.cursor = self.cursor + 1
  self:trigger( 'draw' )
  return true
end)

mainmenu:addEvent( 'up', function (self)
  if (self.cursor <= 1) then return false end
  self.cursor = self.cursor - 1
  self:trigger( 'draw' )
  return true
end)

mainmenu:addEvent( 'destroy', function (self) 
  self:trigger( 'clear' )
  self.cursor = nil 
end)

machine:addRoom( 'mainmenu', mainmenu )

machine:init ( 'mainmenu' )

os.execute("sleep 1")
machine:trigger('down')
machine:trigger('down')
machine:trigger('down')
machine:trigger('down')
os.execute("sleep 1")
machine:trigger('up')