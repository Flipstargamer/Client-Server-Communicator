local RunService = game:GetService("RunService")

if RunService:IsServer() then
    error("Don't require the CSCClient using server instead require the parent of this script to make it easier.")
    return nil
end

--[=[
    @within CSCClient
    @type Seconds number
]=]
type Seconds = number

--[=[
    @class CSCClient
    @client

    The Client Side of CSC.

    Yields thread till server was init.
]=]
local Client = {}

local Functions = {}

local MainEvent:RemoteEvent = script.Parent:WaitForChild("MainRemote")
local MainFunction:RemoteFunction = script.Parent:WaitForChild("MainFunction")

local ClientCalled:BindableEvent = script:FindFirstChild("ClientCalled")
if not ClientCalled then
    ClientCalled = Instance.new("BindableEvent")
    ClientCalled.Name = "ClientCalled"
    ClientCalled.Parent = script
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

--[=[
    @within CSCClient
    @yields
    @since 1.2.0
    Calls the server after a certain amount of time.

    @param ... Tuple
]=]
function Client:DelayCallServer(Delay:Seconds, EventName:string, ...)
    task.wait(Delay)
    self:CallServer(EventName, ...)
end

--[=[
    @within CSCClient
    @since 1.2.0
    @tag Experimental
    Adds a callback to be executed when client is invoked.

    ```lua
    local Callback = function(ArgumentOne, ArgumentTwo)
        -- Code
    end
    CSC:AddCallback("This is a event name.",Callback)
    ```
]=]
function Client:AddCallback(EventName:string, Callback: (...any) -> any)
    table.insert(Functions, {EventName, Callback})
end

--[=[
    @within CSCClient
    @since 1.2.0
    @tag Experimental
    @yields
    Invokes the server and executes all callbacks added to it.

    ```lua
    CSC:InvokeServer("This is a Event Name", ArgumentOne, ArgumentTwo)
    ```
    @param ... Tuple
    @return any
]=]
function Client:InvokeServer(EventName:string, ...)
    return MainFunction:InvokeServer(EventName, ...)
end

MainEvent.OnClientEvent:Connect(function(EventName, ...)
    ClientCalled:Fire(EventName, ...)
end)

MainFunction.OnClientInvoke = function(EventName, ...)
    local ToReturn
    for _, Callback in ipairs(Functions) do
        if Callback[1] == EventName then
            ToReturn = Callback[2](...)
        end
    end
    return ToReturn
end

return Client