local MainEvent = script.Parent.Parent:WaitForChild("MainRemote")
local ServerCalled = script.Parent:WaitForChild("ServerCalled")

MainEvent.OnServerEvent:Connect(function(Player, EventName, ...)
    ServerCalled:Fire(Player, EventName, ...)
end)