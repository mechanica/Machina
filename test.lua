local Menu = {}

function Menu:new ( rooms, initial )
  o = {}
  local current = rooms[initial]

  function o:trigger( event )
    current['on' .. event](current)
  end
  
  current:init()
  return o
end

local menu = Menu:new ({ 
  mainmenu = {
    init = function (self) 
      self.cursor = 1
      self:draw()
    end,
    draw = function (self)
      self:clear()
      for i, v in ipairs(self) do
        print( (self.cursor == i and '> ' or '  ') .. v.text)
      end
    end,
    clear = function (self)
      os.execute('clear')
    end,
    onDown = function (self)
      if (self.cursor >= #self) then return false end
      self.cursor = self.cursor + 1
      self:draw()
      return true
    end,
    onUp = function (self)
      if (self.cursor <= 1) then return false end
      self.cursor = self.cursor - 1
      self:draw()
      return true
    end,
    destroy = function (self) 
      self:clear()
      self.cursor = nil 
    end,
    { text = "New Game" },
    { text = "Load Game" },
    { text = "Settings" },
    { text = "Quit" },
  }
  
}, 'mainmenu')

os.execute("sleep 1")
menu:trigger('Down')
menu:trigger('Down')
menu:trigger('Down')
menu:trigger('Down')
os.execute("sleep 1")
menu:trigger('Up')
