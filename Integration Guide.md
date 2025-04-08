# 🧠 Advanced Dialog System  
Created by **Echo Labs**  
Support: [https://discord.gg/rUyXeRzbqm](https://discord.gg/rUyXeRzbqm)


## 🚀 Installation Steps Guide

1. Add the resource to your "resources" folder.
2. Add this line to your "server.cfg":

ensure Advanced-Dialog-System
That's it — you're ready to use the Advanced Dialog System.


## How to use the export in scripts?

-- Export

exports['Advanced-Dialog-System']:useDialog(dialogType, data, callback)
dialogType: "dialog", "alert", or "input"

data: Table containing required information (see below)

callback: Function that receives the user's response

# 🔘 Dialog Types & Examples

 1. Confirmation Dialog
 ```
exports['Advanced-Dialog-System']:useDialog("dialog", {
    title = "Are you sure you dont want to buy from us?",
    message = "Are you sure you want buy from other stores?"
}, function(confirmed)
    if confirmed then
        -- Do something
    else
        -- Canceled
    end
end)
```

 2. Alert Dialog
```
exports['Advanced-Dialog-System']:useDialog("alert", {
    title = "Access Denied",
    message = "You do not have permission to do this."
}, function()
    -- Alert closed
end)
```

3. Input Dialog
```
exports['Advanced-Dialog-System']:useDialog("input", {
    title = "Enter Information",
    options = {
        { label = "Username", placeholder = "echolabs", type = "text" },
        { label = "Age", placeholder = "25", type = "number" }
    }
}, function(values)
    local username = values[1]
    local age = tonumber(values[2])
    -- Handle the input
end)
```
📞 Support
Need help or want to request a custom feature?

🧪 Join the Echo Labs Discord: https://discord.gg/rUyXeRzbqm
