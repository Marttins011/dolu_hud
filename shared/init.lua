local server = IsDuplicityVersion()
Config = json.decode(LoadResourceFile(cache.resource, 'config.json'))

if server then
	lib.versionCheck('Marttins011/dolu_hud')
	SetConvarReplicated('game_enableFlyThroughWindscreen', 'true') -- Enable flying trough windscreen while in vehicle
	SetConvarReplicated('voice_enableUi', 'false') -- Hide pma_voice hud
else
	PlayerIsLoaded = false
	PlayerIsDead = false
	statuses = {}

	local function init()
		local playerPed = cache.ped

		-- Set max ped entity to 200 (NPCs and mp_f_freemode_01 has lower values)
		if Config.setMaxHealth then
			SetEntityMaxHealth(playerPed, 200)
		end

		local data = {
			toggle = true,
			statuses = {
				hunger = QBX.PlayerData.metadata.hunger,
				thirst = QBX.PlayerData.metadata.thirst,
				stress = 0
			},
			health = utils.percent(GetEntityHealth(playerPed)-100, GetEntityMaxHealth(playerPed)-100),
			armour = utils.percent(GetPedArmour(playerPed), GetPlayerMaxArmour(cache.playerId)),
			voice = LocalPlayer.state.proximity.index or 2,
			playerId = cache.serverId
		}

		SendNUIMessage({
			action = 'setStatuses',
			data = data
		})

		utils.debug(1, "Loaded status ", json.encode(data, {indent=true}))
	end

	AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
		PlayerIsLoaded = true
		init()
	end)

	AddEventHandler('QBCore:Client:OnPlayerUnload', function()
		SendNUIMessage({ action = 'toggleVisibility', data = false })
		PlayerIsLoaded = false
		nuiReady = false
		statuses = {}
	end)

	RegisterNUICallback('nuiReady', function(_, cb)
		cb(1)
		nuiReady = true
		SendNUIMessage({
			action = 'setConfig',
			data = Config or {}
		})
	end)

	-- Death handler
	AddStateBagChangeHandler('dead', 'player:' .. cache.serverId, function(_, _, value)
		if not nuiReady or not PlayerIsLoaded then return end

		if value then
			-- Just dead
			SendNUIMessage({ action = 'toggleVisibility', data = false })
		elseif PlayerIsDead then
			-- Just revived
			init()
		end
		PlayerIsDead = value
	end)

	-- Support resource restart
	AddEventHandler('onResourceStart', function(resourceName)
		if GetCurrentResourceName() ~= resourceName then return end
		Wait(500)
		PlayerIsLoaded = true
		init()
	end)
end

