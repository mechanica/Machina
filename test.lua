local Menu = {
  Machine = {},
  Room = {},
}

function Menu.Machine:new ()
  local o = {}
  local rooms = {}
  local current

  function o:trigger( event )
    if ( not current or not event ) then return false end

    return current.trigger( current, event )
  end
  
  function o:addRoom ( name, room )
    if ( not name or not room ) then return false end

    rooms[ name ] = room
    return true
  end

  function o:init ( name )
    if ( not name ) then return false end

    current = rooms[ name ]
    return self:trigger( 'init' )
  end
  
  return o
end

function Menu.Room:new ()
  local o = {}
  local items = {}
  local events = {}
  
  function o:addItem ( item )
    if ( not item ) then return false end
    
    table.insert( items, item );
    return true
  end
  
  function o:getItems ()
    return items
  end
  
  function o:addEvent ( name, func )
    if ( not name or not func ) then return false end
    events[ name ] = func
    return true
  end
  
  function o:trigger ( name )
    if ( not name ) then return false end
    
    return events[ name ]( self )
  end
  
  return o
end

--------------------------------------------

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