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

RegisterNetEvent('dialog:confirmed', function()
end)

RegisterNetEvent('dialog:declined', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeDialog" })
end)

RegisterCommand('testdialog', function()
    OpenConfirmationDialog("Confirm Action", "Are you sure you want to continue?", function(response)
        if response then
        end
    end)
end, false)

RegisterCommand('alertme', function(source, args)
    local message = table.concat(args, " ")
    if message == "" then message = "This is an alert message." end
    OpenAlertDialog("Alert", message)
end, false)

RegisterCommand('testinput', function()
    OpenInputDialog("User Information", {
        { label = "Your Name", placeholder = "Enter your name", type = "text" },
        { label = "Age", placeholder = "Enter your age", type = "text" }
    }, function(values)
    end)
end, false)
