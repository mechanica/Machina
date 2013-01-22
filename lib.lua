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

return Menu