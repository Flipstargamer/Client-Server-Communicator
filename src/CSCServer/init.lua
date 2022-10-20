local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

if RunService:IsClient() then
    error("Don't require the CSCServer using client instead require the parent of this script to make it easier.")
    return nil
end

--[=[
    @within CSCServer
    @type Seconds number
]=]
type Seconds = number

--[=[
    @class CSCServer
    @server

    The Server Side of CSC
]=]
local Server = {}

local Functions = {}

local Promise
if script.Parent:FindFirstChild("Packages") then
    Promise = require(script.Parent:WaitForChild("Packages"):WaitForChild("Promise"))
else
    Promise = require(script.Parent.Parent:WaitForChild("Promise"))
end

local MainEvent:RemoteEvent
local RemoteFunction:RemoteFunction

local ServerCalled:BindableEvent

--[=[
    @within CSCServer

    Inits the CDC.

    ```lua
    CDC:Init():catch(warn)
    ```
]=]

local Init = false
function Server:Init()
    if Init then
        return Promise.reject("CSC is already initialize.")
    end
    Init = true

    return Promise.new(function()
        RemoteFunction = Instance.new("RemoteFunction")
        RemoteFunction.Name = "MainFunction"
        RemoteFunction.Parent = script.Parent
        MainEvent = Instance.new("RemoteEvent")
        MainEvent.Name = "MainRemote"
        MainEvent.Parent = script.Parent

        ServerCalled = Instance.new("BindableEvent")
        ServerCalled.Name = "ServerCalled"
        ServerCalled.Parent = script

        --[=[
            @prop ServerCalled RBXScriptSignal
            @within CSCServer
            A signal that fires when server is called.
            ```lua
            CSC.ServerCalled:Connect(Player, EventName, ArgumentOne, ArgumentTwo)
            ```
        ]=]
        self.ServerCalled = ServerCalled.Event
    end)
end

--[=[
    @within CSCServer

    Calls a client that is given.

    ```lua
    CSC:CallClient(APlayerVar, "Hey This is a test name.", AArgumentVar, ASecondArgumentVar)
    ```

    @param ... Tuple
]=]
function Server:CallClient(Player:Player, EventName:string, ...)
    MainEvent:FireClient(Player, EventName, ...)
end

--[=[
    @within CSCServer

    Calls all clients that are available.

    ```lua
    CSC:CallAllClients("Hey This is a test name.", AArgumentVar, ASecondArgumentVar)
    ```

    @param ... Tuple
]=]
function Server:CallAllClients(EventName:string, ...)
    MainEvent:FireAllClients(EventName, ...)
end

--[=[
    @within CSCServer
    @since v1.1.0
    Calls clients in a table.

    ```lua
    local TableOfPlayers = {
        APlayerVar,
        SecondPlayerVar
    }
    CSC:CallClientsInTable(TableOfPlayers, "Hey This is a test name.", AArgumentVar, ASecondArgumentVar) -- You can add as much arguments as you want.
    ```

    @param ... Tuple
]=]
function Server:CallClientsInTable(Players:table, EventName:string, ...)
    for _, Player in ipairs(Players) do
        MainEvent:FireClient(Player)
    end
end

--[=[
    @within CSCServer
    @yields
    @since 1.2.0
    Calls specified client after a certain amount of time.

    @param ... Tuple
]=]
function Server:DelayCallClient(Delay:Seconds, Player:Player, EventName:string, ...)
    task.wait(Delay)
    self:CallClient(Player, EventName, ...)
end

--[=[
    @within CSCServer
    @since 1.2.0
    @tag Experimental
    Adds a callback to be executed when server is invoked.

    ```lua
    local Callback = function(Player, EventName, ArgumentOne, ArgumentTwo)
        -- Code
    end
    CSC:AddCallback(Callback)
    ```
]=]
function Server:AddCallback(EventName:string, Callback: (Player:Player, ...any) -> any)
    table.insert(Functions, {EventName, Callback})
end

--[=[
    @within CSCServer
    @since 1.2.0
    @tag Experimental
    @yields
    Invokes the client and executes all callbacks added to it.

    ```lua
    CSC:InvokeServer(Player, "This is a Event Name", ArgumentOne, ArgumentTwo)
    ```
    @param ... Tuple
    @return any
]=]
function Server:InvokeClient(Player:Player, EventName:string, ...)
    return RemoteFunction:InvokeClient(Player, EventName, ...)
end

coroutine.resume(coroutine.create(function()
    local Wait = script.Parent:WaitForChild("MainRemote")
    if Wait then
        MainEvent.OnServerEvent:Connect(function(Player, EventName, ...)
            ServerCalled:Fire(Player, EventName, ...)
        end)
        RemoteFunction.OnServerInvoke = function(Player:Player, EventName:string, ...)
            local ToReturn
            for _, Callback in ipairs(Functions) do
                if Callback[1] == EventName then
                    ToReturn = Callback[2](Player, ...)
                end
            end
            return ToReturn
        end
    end
end))

return Server