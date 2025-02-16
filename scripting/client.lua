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

exports("useDialog", function(dialogType, data, callback)
    if type(dialogType) ~= "string" then
        return print("ERROR: dialog type must be a string")
    end
    if type(data) ~= "table" then
        return print("ERROR: dialog data must be a table")
    end

    if dialogType == "alert" then
        if not data.message or #data.message <= 0 then
            return print("ERROR: no message was provided, add message in your data table")
        end
        if not data.title or #data.title <= 0 then
            data.title = "Alert"
        end
        OpenAlertDialog(data.title, data.message)
        if callback then callback() end
    elseif dialogType == "input" then
        if not data.title or #data.title <= 0 then
            return print("ERROR: no title was provided, add title in your data table")
        end
        if not data.options or type(data.options) ~= "table" then
            return print("ERROR: no options provided in data.options")
        end

        for _, v in pairs(data.options) do
            if not v.label or #v.label <= 0 then
                return print("ERROR: no label provided")
            end
            if not v.placeholder or #v.placeholder <= 0 then
                return print("ERROR: no placeholder provided")
            end
            if not v.type or #v.type <= 0 then
                v.type = "text"
            end
        end

        OpenInputDialog(data.title, data.options, function(values)
            if callback then callback(values) end
        end)
    elseif dialogType == "dialog" then
        if not data.message or #data.message <= 0 then
            data.message = "Are you sure you want to continue?"
        end
        if not data.title or #data.title <= 0 then
            data.title = "Confirm Action"
        end

        OpenConfirmationDialog(data.title, data.message, function(response)
            if callback then callback(response) end
        end)
    else
        print("ERROR: Dialog type must be either 'alert', 'input', or 'dialog'")
        return
    end
end)

