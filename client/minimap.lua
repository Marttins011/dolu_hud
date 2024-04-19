-- Hide Health & Armour under minimap
CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")

	local defaultAspectRatio = 1920 / 1080 -- Don't change this.
	local resolutionX, resolutionY = GetActiveScreenResolution()
	local aspectRatio = resolutionX / resolutionY
	local minimapOffset = 0
	if aspectRatio > defaultAspectRatio then
		minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.020
	end
	SetMinimapClipType(0)
	AddReplaceTexture('platform:/textures/graphics', 'radarmasksm', 'squaremap', 'radarmasksm')
	AddReplaceTexture('platform:/textures/graphics', 'radarmask1g', 'squaremap', 'radarmasksm')
	SetMinimapComponentPosition('minimap', 'L', 'B', 0.0 + minimapOffset, -0.047, 0.1638, 0.183)
	SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0 + minimapOffset, 0.0, 0.128, 0.0)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01 + minimapOffset, 0.040, 0.320, 0.300)
	SetBlipAlpha(GetNorthRadarBlip(), 0)
	SetBigmapActive(true, false)
	SetMinimapClipType(0)
	Wait(50)
	SetBigmapActive(false, false)
    SetRadarZoom(1150)
    while true do
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        Wait(0)
    end
end)

-- Hide radar if not in a vehicle
if Config.hideRadarOnFoot then
	CreateThread(function()
		local isRadarDisplayed = false
		DisplayRadar(false)

		while true do
			if PlayerIsLoaded and not PlayerIsDead and cache.vehicle and not isRadarDisplayed then
				DisplayRadar(true)
			elseif (not cache.vehicle or PlayerIsDead or not PlayerIsLoaded) and isRadarDisplayed then
				DisplayRadar(false)
			end
			isRadarDisplayed = not isRadarDisplayed
			Wait(200)
		end
	end)
end