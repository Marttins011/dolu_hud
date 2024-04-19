RegisterNetEvent('qbx_core:client:onSetMetaData', function(key, oldValue, newValue)
	statuses = {
		hunger = QBX.PlayerData.metadata.hunger,
		thirst = QBX.PlayerData.metadata.thirst,
		stress = statuses.stress or 0
	}
	SendNUIMessage({ action = 'setStatuses', data = { statuses = statuses } })
	utils.debug(1, json.encode(statuses, {indent=true}))
end)