"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[506],{39221:e=>{e.exports=JSON.parse('{"functions":[{"name":"CallServer","desc":"Calls the server.\\n\\n```lua\\nCDC:CallServer(\\"Hey This is a test name.\\", AArgumentVar, ASecondArgumentVar)\\n```","params":[{"name":"EventName","desc":"","lua_type":"string"},{"name":"...","desc":"","lua_type":"Tuple"}],"returns":[],"function_type":"method","source":{"line":57,"path":"src/CSCClient/init.lua"}},{"name":"DelayCallServer","desc":"Calls the server after a certain amount of time.","params":[{"name":"Delay","desc":"","lua_type":"Seconds"},{"name":"EventName","desc":"","lua_type":"string"},{"name":"...","desc":"","lua_type":"Tuple"}],"returns":[],"function_type":"method","since":"1.2.0","yields":true,"source":{"line":69,"path":"src/CSCClient/init.lua"}},{"name":"AddCallback","desc":"Adds a callback to be executed when client is invoked.\\n\\n```lua\\nlocal Callback = function(EventName, ArgumentOne, ArgumentTwo)\\n    -- Code\\nend\\nCSC:AddCallback(Callback)\\n```","params":[{"name":"Callback","desc":"","lua_type":"(EventName:string, ...any) -> any"}],"returns":[],"function_type":"method","tags":["Experimental"],"since":"1.2.0","source":{"line":87,"path":"src/CSCClient/init.lua"}},{"name":"InvokeServer","desc":"Invokes the server and executes all callbacks added to it.\\n\\n```lua\\nCSC:InvokeServer(\\"This is a Event Name\\", ArgumentOne, ArgumentTwo)\\n```","params":[{"name":"EventName","desc":"","lua_type":"string"},{"name":"...","desc":"","lua_type":"Tuple"}],"returns":[{"desc":"","lua_type":"any"}],"function_type":"method","tags":["Experimental"],"since":"1.2.0","yields":true,"source":{"line":104,"path":"src/CSCClient/init.lua"}}],"properties":[{"name":"ClientCalled","desc":"A signal that fires when client is called.\\n```lua\\nCSC.ClientCalled:Connect(EventName, ArgumentOne, ArgumentTwo)\\n```","lua_type":"RBXScriptSignal","source":{"line":44,"path":"src/CSCClient/init.lua"}}],"types":[{"name":"Seconds","desc":"","lua_type":"number","source":{"line":12,"path":"src/CSCClient/init.lua"}}],"name":"CSCClient","desc":"The Client Side of CSC.\\n\\nYields thread till server was init.","realm":["Client"],"source":{"line":22,"path":"src/CSCClient/init.lua"}}')}}]);