local Menu = {
  Machine = {},
  Room = {},
  Item = {},
}

function Menu.Machine:new ()
  local o = {}
  local ctrl = {}
  local rooms = {}
  local current

  function o:trigger( event )
    if ( not current or not event ) then return false end

    return current:trigger( event, ctrl )
  end
  ctrl.trigger = o.trigger
  
  function o:addRoom ( name, room )
    if ( not name or not room ) then return false end

    rooms[ name ] = room
    return true
  end

  function o:init ( name )
    if ( not name or current ) then return false end

    current = rooms[ name ]
    return self:trigger( 'init' )
  end
  
  function ctrl:move ( to )
    if ( not to or not self:trigger( 'destroy' ) ) then return false end
    
    current = rooms[ to ]
    return o:trigger( 'init' )
  end
  
  return o
end

function Menu.Room:new ()
  local o = {}
  local ctrl = {}
  local items = {}
  local events = {}
  
  function o:addItem ( item )
    if ( not item ) then return false end
    
    table.insert( items, item );
    return true
  end
  
  function ctrl:getItems ()
    return items
  end
  
  function o:on ( name, func )
    if ( not name or not func ) then return false end
    events[ name ] = func
    return true
  end
  
  function o:trigger ( name, machine )
    if ( not name ) then return false end
    
    return events[ name ]( ctrl, machine )
  end
  ctrl.trigger = o.trigger
  
  return o
end

function Menu.Item:new ()
  local o = {}
  local props = {}
  local events = {}
  
  function o:get ( name )
    if ( not name ) then return false end
    
    return props[ name ]
  end
  
  function o:set ( name, value )
    if ( not name or not value ) then return false end
    
    props[ name ] = value
    return true
  end
  
  function o:on ( name, func )
    if ( not name or not func ) then return false end
    
    events[ name ] = func
    return true
  end
  
  function o:trigger ( name, room, machine )
    if ( not name ) then return false end
    
    return events[ name ]( self, room, machine )
  end
  
  return o
end

return Menu