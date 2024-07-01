local QBCore = exports['qb-core']:GetCoreObject()

function sm_alert(title, message, time, type)
	SendNUIMessage({
		action = 'open',
		title = title,
		type = type,
		message = message,
		time = time,
	})
end
function sm_advanced(title, subject, message, icon, iconType, time, type)
	SendNUIMessage({
		action = 'open',
		title = title,
		subject = subject,
		message = message,
		icon = icon,
		iconType = iconType,
		time = time,
		type = type,
		
	})
end

function sm_SendNotify(sm_notifydata)

	SendNUIMessage({
		action = 'open',
		title = sm_notifydata["label"],
		type = sm_notifydata["type"],
		message = sm_notifydata["text"],
		time = sm_notifydata["time"],
	})
end
function Sendsm_advanced(sm_notifydata)

	SendNUIMessage({
		action = 'open_advanced',
		title = sm_notifydata["title"],
		type = sm_notifydata["type"],
		subject = sm_notifydata["subject"],
		msg = sm_notifydata["msg"],
		icon = sm_notifydata["icon"],
		iconType = sm_notifydata["iconType"],
		time = sm_notifydata["time"],

	})
end

RegisterNetEvent('sm-notification:sm_alert')
AddEventHandler('sm-notification:sm_alert', function(title, message, time, type)
	sm_alert(title, message, time, type)
end)

RegisterNetEvent('sm-notification:sm_advanced')
AddEventHandler('sm-notification:sm_advanced', function(title, subject, message, icon, iconType, time, type)
    sm_advanced(title, subject, message, icon, iconType, time, type)
end)

RegisterCommand('test', function()
    exports['sm-notification']:sm_advanced("TEST", "SUBJECT", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", "CHAR_BANK_MAZE", 1, 5000, 'warning')
end)

 RegisterCommand('success', function()
     exports['sm-notification']:sm_alert("SUCCESS", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'success')
 end)

 RegisterCommand('info', function()
     exports['sm-notification']:sm_alert("INFO", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'info')
 end)

 RegisterCommand('error', function()
     exports['sm-notification']:sm_alert("ERROR", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'error')
 end)

 RegisterCommand('warning', function()
     exports['sm-notification']:sm_alert("WARNING", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'warning')
 end)
 RegisterCommand('allnotify', function()
    exports['sm-notification']:sm_alert("SUCCESS", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'success')
    exports['sm-notification']:sm_alert("WARNING", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'warning')
    exports['sm-notification']:sm_alert("ERROR", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'error')
    exports['sm-notification']:sm_alert("INFO", "Lorem ipsum dolor sit amet, consectetur adipiscing elit e pluribus unum", 5000, 'info')

end)