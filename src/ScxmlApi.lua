package.path="./modules/lxsc-min-0.12.1.lua"
local LXSC = require"lxsc-min-12"
--Meta class
Interpreter = {name=0}
local currentstate
local INSTANTIATED, INITIALIZED, IDLE = 0, 1, 2

--INSTANTIATED : Interpreter instance instantiated
--INITLIAZED : Interpreter initialized
--IDLE : Interpreter is in idle state and the event queue is empty
-- Base class method new

function Interpreter:setStateMachine (o,nam)
  o = o or {}
  setmetatable(o,self)
  self.__index = self
  nam = nam or 0
  local scxml   = io.open(nam):read('*all')
  machine = LXSC:parse(scxml)
  self.name = machine
  currentstate=INSTANTIATED
  return o
end

-- Base class method printName

function Interpreter:start()
  machine:start()
  currentstate=INITIALIZED

end

function Interpreter:triggerEvents()
  machine:step()
  currentstate=IDLE
end

function Interpreter:triggerEvent(event)
  machine:fireEvent(event)
  machine:step()
  currentstate=IDLE
end

function Interpreter:allStateIds()
  return machine:allStateIds()
end

function Interpreter:isActiveState(stateId)
  return machine:isActive(stateId)
end

function Interpreter:addEventToQueue(event)
  machine:fireEvent(event)
  currentstate=INSTANTIATED

end

function Interpreter:getInterpreterState()
  return currentstate
end

function Interpreter:addMonitor()
  machine.onBeforeExit = function(stateId,stateKind,isAtomic)
    print("-------------onExit:",stateId .. "",stateKind .. "",isAtomic)
  end

  machine.onAfterEnter = function(stateId,stateKind,isAtomic)
    print("-------------onEnter:",stateId .. "",stateKind .. "",isAtomic)
  end

  machine.onTransition = function(transitionTable)
    print("-------------onTransition")
  end

  currentstate=INITIALIZED


end

-- LSXC Profile Extended Monitor
function Interpreter:addLXSCMonitor()
  machine.onDataSet = function(dataid,newvalue)
    print("-------------onDataSet".."dataId:",dataid.." newValue:",newvalue)
  end

  machine.onEnteredAll = function()
    print("-------------onEnteredAll")
  end

  machine.onEventFired = function(evt)
    print("-------------onEventFired:",evt.name)
  end

  currentstate=INITIALIZED


end


