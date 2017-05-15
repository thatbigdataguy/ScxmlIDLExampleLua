local scxmlApi = require("ScxmlApi")
local test = require"LXSCProfile"

scxmlInterpreter = Interpreter:setStateMachine(nil,"resource/StopWatch.scxml")
print("After setStateMachine(): ",scxmlInterpreter:getInterpreterState())
scxmlInterpreter:addMonitor()
print("After addMonitor(): ",scxmlInterpreter:getInterpreterState())

scxmlInterpreter:start()
scxmlInterpreter:triggerEvent("watch.start")
print("After triggerEvent(): ",scxmlInterpreter:getInterpreterState())



for stateId,_ in pairs(scxmlInterpreter:allStateIds()) do
  print("One of the states has this id:",stateId)
end

print("Is the foo-bar state active?", scxmlInterpreter:isActiveState('stopped'))

for stateId,_ in pairs(machine:activeStateIds()) do
  print("This state is currently active:",stateId)
end

--LXSC Extended Monitor Profile
scxmlInterpreter:addLXSCMonitor()
scxmlInterpreter:addEventToQueue("watch.start")
scxmlInterpreter:addEventToQueue("watch.stop")

scxmlInterpreter:triggerEvents()
print("After triggerEvents(): ",scxmlInterpreter:getInterpreterState())

for stateId,_ in pairs(machine:activeStateIds()) do
  print("This state is currently active:",stateId)
end


