# Client and Server Communicator
Roblox remote events but in one module.

## Installation
Download module and put it in workspace.

## Getting the Client/Server Module
CSC is build that you can require the main module which will return the client or server depending on what script was used to require it.
Example:
```lua
local CSC = require(workspace:WaitForChild(CSC))
```

## Client

### .ClientCalled
When the client is called this event fires.
```lua
CSC.ClientCalled:Connect(function(EventName : String, Arguments : Tuple)
	-- Code here
end)
```

### :CallServer
Calls server.
```lua
CSC:CallServer(EventName : String, Arguments : Tuple)
```
