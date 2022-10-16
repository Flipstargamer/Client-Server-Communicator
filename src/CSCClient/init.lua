local RunService = game:GetService("RunService")

if RunService:IsServer() then
    error("Don't require the CSCClient using server instead require the parent of this script to make it easier.")
    return nil
end

--[=[
    @class CSCClient
    @client

    The Client Side of CSC
]=]
local Client = {}

local MainEvent:RemoteEvent = script.Parent:WaitForChild("MainRemote")

local ClientCalled:BindableEvent = script:FindFirstChild("ClientCalled")
if not ClientCalled then
    ClientCalled = Instance.new("BindableEvent")
    ClientCalled.Name = "ClientCalled"
    ClientCalled.Parent = script
end
local ClientInvoked:BindableEvent = script:FindFirstChild("ClientInvoked")
if not ClientInvoked then
    ClientInvoked = Instance.new("BindableEvent")
    ClientInvoked.Name = "ClientInvoked"
    ClientInvoked.Parent = script
end

--[=[
    @prop ClientCalled RBXScriptSignal
    @within CSCClient
    A signal that fires when client is called.
    ```lua
    CSC.ClientCalled:Connect(EventName, ArgumentOne, ArgumentTwo)
    ```
]=]
Client.ClientCalled = ClientCalled.Event

--[=[
    @within CSCClient

    Calls the server.

    ```lua
    CDC:CallServer("Hey This is a test name.", AArgumentVar, ASecondArgumentVar)
    ```

    @param ... Tuple
]=]
function Client:CallServer(EventName:string, ...)
    MainEvent:FireServer(EventName, ...)
end

MainEvent.OnClientEvent:Connect(function(EventName, ...)
    ClientCalled:Fire(EventName, ...)
end)

return Client