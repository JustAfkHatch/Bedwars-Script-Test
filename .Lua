    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord"))()
    local window = library:Window("Dev V4 🔒 Private 🔒")
    
    ["PaintRemote"] = getremote(debug.getconstants(KnitClient.Controllers.PaintShotgunController.fire)),
    ["ProjectileHitRemote"] = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.ProjectileController.createLocalProjectile, 1))),

    BedwarsSection:Button("MultiAura", function(v)
  runcode(function()
    local Multiaura = {["Enabled"] = false}
      Multiaura = GuiLibrary["ObjectsThatCanBeSaved"]["BlatantWindow"]["Api"].CreateOptionsButton({
          ["Name"] = "MultiAura",
          ["Function"] = function(callback)
              if callback then
                  task.spawn(function()
            repeat
              task.wait(0.03)
              if (GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"]["Api"]["Enabled"] == false or matchState ~= 0) and Killaura["Enabled"] then
                local plrs = GetAllNearestHumanoidToPosition(true, 17.999, 1, false)
                for i,plr in pairs(plrs) do
                  local selfpos = entity.character.HumanoidRootPart.Position
                  local newpos = plr.RootPart.Position
                  bedwars["ClientHandler"]:Get(bedwars["PaintRemote"]):SendToServer(selfpos, CFrame.lookAt(selfpos, newpos).lookVector)
                end
              end
            until Killaura["Enabled"] == false
          end)
              end
          end,
          ["HoverText"] = "Attack players around you\nwithout aiming at them."
      })
  end)
  end)
  
  BedwarsSection:Button("Slient Bow Aim", function(v)
  runcode(function()
	local BowExploit = {["Enabled"] = false}
	local BowExploitTarget = {["Value"] = "Mouse"}
	local BowExploitCamera = {["Enabled"] = false}
	local BowExploitAutoShoot = {["Enabled"] = false}
	local BowExploitAutoShootFOV = {["Value"] = 1000}
	local oldrealremote
	local noveloproj = {
		"fireball",
		"telepearl"
	}

	local function getriches(plr)
		local richval = 0
		for i,v in pairs(bedwars["getInventory"](plr)["items"]) do 
			if v.itemType == "emerald" then
				richval = richval + v.amount * 2
			elseif v.itemType == "diamond" then
				richval = richval +  v.amount * 1.5
			elseif v.itemType == "iron" then
				richval = richval +  v.amount
			end
		end
		return richval
	end

	local function getriches2(plr)
		local richval = 0
		for i,v in pairs(bedwars["getInventory"](plr)["armor"]) do 
			if v ~= "empty" then 
				richval = richval + bedwars["ItemTable"][v.itemType].armor.damageReductionMultiplier
			end
		end
		return richval
	end

	local function getRich()
		local closest, returnedplayer = 0, nil
		if entity.isAlive then
			for i, v in pairs(entity.entityList) do -- loop through players
				if (v.Targetable or targetcheck) and targetCheck(v) then
					local mag = getriches(v)
					if mag >= closest then
						closest = mag
						returnedplayer = v
					end
				end
			end
		end
		return returnedplayer
	end

	local function getArmorRich(richcheck)
		local closest, returnedplayer = (richcheck and 0 or 99999), nil
		if entity.isAlive then
			for i, v in pairs(entity.entityList) do -- loop through players
				if (v.Targetable or targetcheck) and targetCheck(v) then
					local mag = getriches2(v)
					if (richcheck and mag >= closest or (not richcheck) and mag <= closest) then
						closest = mag
						returnedplayer = v
					end
				end
			end
		end
		return returnedplayer
	end

	BowExploit = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "ProjectileExploit",
		["Function"] = function(callback)
			if callback then 
				oldrealremote = debug.getupvalue(debug.getupvalue(bedwars["BowTable"].launchProjectileWithValues, 2), 10)
				debug.setupvalue(debug.getupvalue(bedwars["BowTable"].launchProjectileWithValues, 2), 10, {
					Client = {
						WaitFor = function(self6, remote)
							local res = bedwars["ClientHandler"]:Get(remote)
							return {
								andThen = function(self5, func) 
									return func({
										CallServerAsync = function(self, shooting, proj, proj2, launchpos1, launchpos2, launchvelo, tag, tab1, ...) 
											local plr
											if BowExploitTarget["Value"] == "Mouse" then 
												plr = GetNearestHumanoidToMouse(true, 10000, false)
											elseif BowExploitTarget["Value"] == "Range" then
												plr = GetNearestHumanoidToPosition(true, BowExploitAutoShootFOV["Value"])
											elseif BowExploitTarget["Value"] == "Rich" then
												plr = getRich()
											else
												plr = getArmorRich(BowExploitTarget["Value"]:find("Rich") and true or false)
											end
											if plr then
												local newlaunchpos = (plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, plr.Character.Humanoid.MoveDirection ~= Vector3.new() and 0.5 or 1, 0)).p
												local newlaunchvelo = plr.Character.Humanoid.MoveDirection ~= Vector3.new() and table.find(noveloproj, proj2) == nil and CFrame.lookAt(newlaunchpos, plr.Character.HumanoidRootPart.CFrame.p + plr.Character.Humanoid.MoveDirection).lookVector.Unit * bedwars["ProjectileMeta"][proj2].launchVelocity or Vector3.new(0, -1, 0).Unit * bedwars["ProjectileMeta"][proj2].launchVelocity
												launchvelo = newlaunchvelo
												launchpos1 = newlaunchpos
												tab1.drawDurationSeconds = 10
											end
											launchpos2 = shared.VapeRealCharacter and shared.VapeRealCharacter.HumanoidRootPart.Position or lplr.Character.HumanoidRootPart.Position
											local called = res:CallServerAsync(shooting, proj, proj2, launchpos1, launchpos2, launchvelo, tag, tab1, ...)
											if plr then 
												spawn(function()
													task.wait(0.4)
													for i = 1, 3 do 
														bedwars["ClientHandler"]:Get(bedwars["ProjectileHitRemote"]):SendToServer(tag, plr.Character)
													end
												end)
											end
											return called
										end
									})
								end
							}
						end
					}
				})
			else
				if isAlive() then
					cam.CameraSubject = lplr.Character.Humanoid
				end
				debug.setupvalue(debug.getupvalue(bedwars["BowTable"].launchProjectileWithValues, 2), 10, {
					Client = bedwars["ClientHandler"]
				})
				oldrealremote = nil
			end
		end
	})
	BowExploitTarget = BowExploit.CreateDropdown({
		["Name"] = "Mode",
		["List"] = {"Mouse", "Range", "Rich", "Armor Rich", "Armor Poor"},
		["Function"] = function() end
	})

	local function getBow()
		local bestsword, ammo, bestswordnum  = nil, nil, 0
		for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
			if v5["itemType"]:find("bow") then
				local tab = bedwars["ItemTable"][v5["itemType"]].projectileSource.ammoItemTypes
				local tab2 = tab[#tab]
				if bedwars["ProjectileMeta"][tab2].combat.damage > bestswordnum then
					bestswordnum = bedwars["ProjectileMeta"][tab2].combat.damage
					bestsword = v5["tool"]
					ammo = tab2
				end
			end
		end
		return bestsword, ammo
	end

	local function shootproj(bow)
		debug.getupvalue(debug.getupvalue(bedwars["BowTable"].launchProjectileWithValues, 2), 10).Client:WaitFor(bedwars["ProjectileRemote"]):andThen(function(rem)
			local pos = shared.VapeRealCharacter and shared.VapeRealCharacter.HumanoidRootPart.Position or lplr.Character.HumanoidRootPart.Position
			local tag = game:GetService("HttpService"):GenerateGUID(true)
			local tab = bedwars["ItemTable"][bow.Name].projectileSource.ammoItemTypes
			local ammo = tab[#tab]
			rem:CallServerAsync(bow, ammo, ammo, pos, pos, Vector3.new(0, -1, 0), tag, {
				drawDurationSeconds = 10
			})
		end)
	end

	BowExploitCamera = BowExploit.CreateToggle({
		["Name"] = "Camera View",
		["Function"] = function() end
	})
	BowExploitAutoShoot = BowExploit.CreateToggle({
		["Name"] = "AutoShoot",
		["Function"] = function(callback) 
			if callback then 
				spawn(function()
					repeat
						task.wait()
						if BowExploit["Enabled"] then 
							local bow = getItem("wood_bow")
							local bow2 = getItem("wood_crossbow")
							local bow3 = getItem("tactical_crossbow")
							if getItem("arrow") then 
								local plr
								if BowExploitTarget["Value"] == "Mouse" then 
									plr = GetNearestHumanoidToMouse(true, 10000, false)
								elseif BowExploitTarget["Value"] == "Range" then
									plr = GetNearestHumanoidToPosition(true, BowExploitAutoShootFOV["Value"])
								elseif BowExploitTarget["Value"] == "Rich" then
									plr = getRich()
								else
									plr = getArmorRich(BowExploitTarget["Value"]:find("Rich") and true or false)
								end
								if plr then
									if BowExploitCamera["Enabled"] and isAlive() then 
										cam.CameraSubject = plr.Character.Humanoid
									end
									local nowait = false
									if bow then 
										shootproj(bow.tool)
										task.wait(0.4)
										nowait = true
									end
									if bow2 then 
										shootproj(bow2.tool)
										task.wait(nowait and 0.4 or 0.7)
										nowait = true
									end
									if bow3 then 
										shootproj(bow3.tool)
										task.wait(nowait and 0.4 or 0.7)
										nowait = true
									end
								else
									if BowExploitCamera["Enabled"] and isAlive() then 
										cam.CameraSubject = lplr.Character.Humanoid
									end
								end
							end
						end
					until (not BowExploitAutoShoot["Enabled"])
				end)
			end
		end 
	})
	BowExploitAutoShootFOV = BowExploit.CreateSlider({
		["Name"] = "AutoShoot FOV",
		["Function"] = function() end,
		["Min"] = 1,
		["Max"] = 1000,
		["Default"] = 1000
	})
end)
end)

BedwarsSection:Button("Dupe", function(v)
runcode(function()
	local FastDrop = {["Enabled"] = false}
	FastDrop = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Dupe",
		["Function"] = function(callback)
			if callback then
				local monkey = getEquipped()
				if monkey and monkey["Object"] and monkey.amount ~= math.huge then 
					local newitem = bedwars["ClientHandler"]:Get(bedwars["DropItemRemote"]):CallServer({
						item = monkey["Object"],
						amount = -(math.huge)
					})
					if newitem then 
						newitem:Destroy()
					end
				end
				FastDrop["ToggleButton"](false)
			end
		end
	})
end)
end)
