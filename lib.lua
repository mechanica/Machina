local Machina = {
  Machine = {},
  Room = {},
  Item = {},
}

function Machina.Machine:new ()
  local o = {}
  local ctrl = {}
  local rooms = {}
  local current

  function o:trigger( event )
    if ( not current or not event ) then return false end

    return current:trigger( event, ctrl )
  end
  ctrl.trigger = o.trigger
  
  function o:createRoom ( name )
    local room = Machina.Room:new()
    if ( not self:addRoom ( name, room ) ) then return false end
    return room
  end
  
  function o:addRoom ( name, room )
    if ( not name or not room ) then return false end

    room:_getCtrlContext().name = name
    rooms[ name ] = room
    return true
  end

  function o:init ( name )
    if ( not name or current ) then return false end

    current = rooms[ name ]
    return self:trigger( 'init' ) ~= false
  end
  
  function ctrl:move ( to )
    if ( not to or self:trigger( 'destroy' ) == false ) then return false end
    
    current = rooms[ to ]
    return o:trigger( 'init' ) ~= false
  end
  
  function ctrl:follow ( to, item )
    if ( not to or not item or not item:hasRoute(to) ) then return false end
    local route = item:getRoute( to )
    if ( route.before and route:before( item, current:_getCtrlContext(), self ) == false ) then return false end
    self:move ( route.to or to )
    if ( route.after ) then route:after( item, current:_getCtrlContext(), self ) end
    return true
  end
  
  return o
end

function Machina.Room:new ()
  local o = {}
  local ctrl = {}
  local items = {}
  local events = {
    init = function () return true end,
    destroy = function () return true end,
  }
  
  -- Worst day in my career. Ever. =) You should never ever use this until you absolutely sure.
  function o:_getCtrlContext()
    return ctrl;
  end
  
  function o:createItem ()
    local item = Machina.Item:new()
    if ( not self:addItem ( item ) ) then return false end
    return item
  end
  
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
    if ( not name or not events[ name ]) then return false end
    
    return events[ name ]( ctrl, machine ) ~= false
  end
  ctrl.trigger = o.trigger
  
  return o
end

function Machina.Item:new ()
  local o = {}
  local props = {}
  local events = {}
  local routes = {}
  
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
    if ( not name or not events[ name ]) then return false end
    
    return events[ name ]( self, room, machine ) ~= false
  end
  
  function o:route ( name, to, before, after )
    if ( not name ) then return false end
    
    routes[ name ] = {
      to = to,
      before = before,
      after = after
    }
    return true
  end
  
  function o:hasRoute ( to )
    if ( not to or not routes[ to ] ) then return false end
    return true
  end
  
  function o:getRoute ( to )
    if ( not to ) then return false end
    return routes[ to ]
  end
  
  return o
end

return Machina