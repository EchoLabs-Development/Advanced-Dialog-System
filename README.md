# Advanced-Dialog-System

# 📚 FiveM Dialog System Integration Guide
Thanks for choosing Echo Labs
This guide will help you **integrate and use** confirmation dialogs, alerts, and input dialogs in your **FiveM client script**.

---

## 1️⃣ Setting Up Your Client Script  
Make sure you have a **client script** (`client.lua`) inside your resource folder. If not, create one and open it.

---

## 2️⃣ Adding the Dialog Functions  
Copy and paste these functions inside your `client.lua` file. They will handle different types of dialogs.

### 🚩 Confirmation Dialog  
Asks the player to **confirm or decline** an action.

```lua
function OpenConfirmationDialog(title, text, callback)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openDialog",
        title = title or "Are you sure?",
        text = text or "Are you sure you want to proceed?"
    })
    RegisterNUICallback('dialogResponse', function(data, cb)
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "closeDialog" })

        if data.response then
            TriggerEvent('dialog:confirmed')
            if callback then callback(true) end
        else
            TriggerEvent('dialog:declined')
            if callback then callback(false) end
        end

        cb('ok')
    end)
end
```

### ⚠️ Alert Dialog  
Displays a **warning or information message** to the player.

```lua
function OpenAlertDialog(title, text)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openAlert",
        title = title or "Alert",
        text = text or "This is an alert message."
    })
    RegisterNUICallback('alertResponse', function(_, cb)
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "closeAlert" })
        cb('ok')
    end)
end
```

### 🗂️ Input Dialog  
Allows the player to **enter information** (e.g., name, age, or any other data).

```lua
function OpenInputDialog(title, inputs, callback)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openInput",
        title = title or "Input",
        description = "Enter the required information below to proceed.",
        inputs = inputs
    })

    RegisterNUICallback('inputResponse', function(data, cb)
        if not data.values or #data.values == 0 then
            return
        end
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "closeInput" })
        if callback then
            callback(data.values)
        end
        cb('ok')
    end)
end
```

---

## 3️⃣ Handling User Responses  
You can **listen for user actions** (confirmed or declined) with events.

```lua
RegisterNetEvent('dialog:confirmed', function()
    -- Action when the user confirms
    print("✅ User confirmed the action.")
end)

RegisterNetEvent('dialog:declined', function()
    -- Action when the user declines
    print("❌ User declined the action.")
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeDialog" })
end)
```

---

## 4️⃣ Using the Dialogs in Your Code  

### 🚩 Example: Open a Confirmation Dialog  
```lua
OpenConfirmationDialog("Confirm Purchase", "Are you sure you want to buy this item?", function(response)
    if response then
        print("✅ User confirmed the purchase.")
        -- Proceed with purchase logic
    else
        print("❌ User canceled the purchase.")
        -- Handle cancellation
    end
end)
```

### ⚠️ Example: Show an Alert Message  
```lua
OpenAlertDialog("Warning", "You do not have enough money for this purchase.")
```

### 🗂️ Example: Ask for User Input (Name & Age)  
```lua
OpenInputDialog("User Information", {
    { label = "Your Name", placeholder = "Enter your name", type = "text" },
    { label = "Age", placeholder = "Enter your age", type = "text" }
}, function(values)
    local name = values[1]
    local age = values[2]
    print("👤 User Name:", name)
    print("🎂 User Age:", age)
end)
```

---

## 5️⃣ Testing the Dialogs in FiveM  
To test the dialogs, **register commands** so you can trigger them in the game.

```lua
RegisterCommand('testdialog', function()
    OpenConfirmationDialog("Confirm Action", "Are you sure you want to continue?", function(response)
        if response then
            print("✅ User confirmed action.")
        else
            print("❌ User declined action.")
        end
    end)
end, false)

RegisterCommand('alertme', function(source, args)
    local message = table.concat(args, " ")
    if message == "" then message = "This is an alert message." end
    OpenAlertDialog("⚠️ Alert", message)
end, false)

RegisterCommand('testinput', function()
    OpenInputDialog("User Information", {
        { label = "Your Name", placeholder = "Enter your name", type = "text" },
        { label = "Age", placeholder = "Enter your age", type = "text" }
    }, function(values)
        print("📜 User input:", values)
    end)
end, false)
```

---

## 6️⃣ Running the Commands in FiveM  
1️⃣ Start your FiveM server.  
2️⃣ Join as a client.  
3️⃣ Open the console (`F8`) and type:  

- `/testdialog` → Opens a confirmation dialog.  
- `/alertme Hello, this is a test.` → Opens an alert with a custom message.  
- `/testinput` → Opens an input dialog for the user to enter details.  

🎉 **Now your dialogs should be working in your FiveM server!** 🚀

---

## 7️⃣ Extra Tips 🛠️  
✔️ Ensure your **NUI (HTML/CSS/JS) is properly handling** `SendNUIMessage` actions like `"openDialog"`, `"openAlert"`, and `"openInput"`.  
✔️ Use `SetNuiFocus(false, false)` after a dialog to return control to the game.  
✔️ Modify the scripts as needed to fit your server’s needs.  

---

### 📌 Summary  
✅ **Dialogs Supported**: Confirmation, Alert, Input  
✅ **User Responses**: Handled via callbacks and events  
✅ **Testing Commands**: `/testdialog`, `/alertme`, `/testinput`  
✅ **Works in FiveM Client Scripts**  

Let me know if you need more help! 🚀🔥

https://discord.gg/rUyXeRzbqm
Echo Labs
