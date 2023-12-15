local BotNicknames = {
	"batname1",
  	"botname2"
}

--ANTI_AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait(1)
	vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)


local gl = {
	
	

	DevMode = { --EXPERIMENTAL! IF FIRST ARG IS TRUE AND ARG2 CHATTED, ISDESTROYED GONNA BE ACTIVATED.
		true,
		"Be free.",
		"Bot's are deactivated by the owner."
	},
	FunPh = {
	},
	trolls = {
	},
	--Changable in-game. Depends on you.
	prefix=".",

	--Ranks are higher depend on the number, you can add rank yourself by adding value inside of the ranks table and giving it a value.
	--You can make "KingRank (Name isn't matter) ",999, so it going to be 999. Number are important for some functions 
	--Number are important for some functions  and make other ranks stronger than others.
	--For an example, if your rank is 500, you can do commands on a 400, but can't with a 1000.

	--{TheRankName,Rank's Number, people within rank (You can put names right now for permament access, after script reloaded they will disappear. ADD YOUR NAME!)}
	ranks = {
		Owner={math.huge,{"owner1","owner2"},"Owner"},
		HeadAdmin={8,{},"HeadAdmin"},
		Admin ={6,{},"Admin"},
		VIP={5,{},"VIP"},
		Tester = {1,{},"Tester"}
	},

	IsLocked = false,
	IsDestroyed = false,
	MessageLocked = false,


	glFunctions = {
		TableSearch = function(val,t)
			for i,v in pairs(t) do
				if v == val then
					return true
				end
			end
			return false
		end,
		Thread= function(func)
			coroutine.wrap(func)()
		end,
	},
	followPlr = nil,
	isFollow = false,
	globalMake = 4,
	isPublic = false,
	activeFix = true,
	isScream = false,
	isSilent = true

}


local LocalPlayer = game.Players.LocalPlayer
local events = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
local messageDoneFiltering = events:WaitForChild("OnMessageDoneFiltering")
local players = game:GetService("Players")

function BotChecker()
	return true
	
	--for i,v in pairs(BotNicknames) do
		--if v == LocalPlayer.Name then
			--return true
		--end
	--end
	--return false
end

function BasicChat(msg)
	game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg,"All")
end

local commands = {
	fix = {
		(function(args,plr)
			for i,v in pairs(BotNicknames) do
				local suc = pcall((function()
					local gm = game.Players[v]
				end))
				if not suc then
					table.remove(BotNicknames,i)
				end
			end
		end),
		requirements = {
			accessRank = 1,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	say = {
		(function(args,plr)
			local msg = ""
			for i,v in pairs(args) do
				if i == 1 then
					msg = msg ..""..v
				else
					msg = msg .." "..v
				end
			end
			game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg,"All")
		end),
		requirements = {
			accessRank = 1,
			depend = {
				gl.MessageLocked == false,
				gl.IsLocked == false
			}
		}
	},
	
	giveRank = {
		(function(args,plr)
			local rank,rankplr = args[1],args[2]
			
			if gl.glFunctions.TableSearch(game.Players[rankplr],game.Players:GetPlayers()) then
				local plrRank
				local RankerRank
				for i,v in pairs(gl.ranks) do
					if gl.glFunctions.TableSearch(rankplr,v[2]) then
						plrRank = v[1]
					end
					if gl.glFunctions.TableSearch(plr.Name,v[2]) then
						RankerRank = v[1]
					end
				end

				if plrRank == nil then
					table.insert(gl.ranks[rank][2],rankplr)
					game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(rankplr..", an authorized user just gave you ".. rank.."!","All")
					print(rankplr.. "is successfully added brother")
				elseif RankerRank == nil then
					return false
				elseif RankerRank > plrRank then
					table.insert(gl.ranks[rank][2],rankplr)
					game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(rankplr..", an authorized user just gave you ".. rank.."!","All")
					print(rankplr.. "is successfully added brother")
				end
			end
			
		end),
		requirements = {
			accessRank = 1,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	lookRank = {
		(function(args,plr)
			local lookplr = args[1]
			
			for i,v in pairs(gl.ranks) do
				if gl.glFunctions.TableSearch(lookplr,v[2]) == true then
					BasicChat(lookplr.." is a: ".. v[3])
				end
			end

		end),
		requirements = {
			accessRank = 1,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	removeRank = {
		(function(args,plr)
			local rank,rankplr = args[1],args[2]

			if gl.glFunctions.TableSearch(game.Players[rankplr],game.Players:GetPlayers()) then
				local plrRank
				local RankerRank
				for i,v in pairs(gl.ranks) do
					if gl.glFunctions.TableSearch(rankplr,v[2]) then
						plrRank = v[1]
					end
					if gl.glFunctions.TableSearch(plr.Name,v[2]) then
						RankerRank = v[1]
					end
				end

				if plrRank == math.huge then
					for i,v in pairs(gl.ranks) do
						if gl.glFunctions.TableSearch(rankplr,v[2]) then
							table.remove(v[2],table.find(v[2],rankplr))
							game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(rankplr..", an authorized user just removed your ranks.","All")
						end
					end
				end
			end
	

		end),
		requirements = {
			accessRank = 1,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	follow = {
		(function(args,plr)
			local followPlr = args[1]
			local way = args[2] or nil
			
			
			if followPlr == "me" then
				gl.followPlr = plr.Name
			elseif gl.glFunctions.TableSearch(game.Players[followPlr],game.Players:GetPlayers()) then
				gl.followPlr = followPlr
			else
				return false
			end
			print("Thread is there right now.")
			gl.isFollow = false
			wait(0.1)
			gl.isFollow = true
			gl.glFunctions.Thread((function()
				while wait(0.01) do
					if gl.isFollow == true then
						local makes = gl.globalMake
						local makesCFrame = CFrame.new(-makes,0,0)
						
						if way == "x" then
							for i,v in pairs(BotNicknames) do
								if v == LocalPlayer.Name then
									local LocalCharacter = LocalPlayer.Character
									local PlrCharacter = game.Players[gl.followPlr].Character
									--LocalCharacter:MoveTo((CFrame.new(0,makes,0) * PlrCharacter:FindFirstChild("HumanoidRootPart").CFrame).Position)
									LocalCharacter.PrimaryPart.CFrame = CFrame.new(-makes,0,0) * PlrCharacter.PrimaryPart.CFrame
								end
								makes += gl.globalMake
							end
						elseif way == "y" then
							for i,v in pairs(BotNicknames) do
								if v == LocalPlayer.Name then
									local LocalCharacter = LocalPlayer.Character
									local PlrCharacter = game.Players[gl.followPlr].Character
									--LocalCharacter:MoveTo((CFrame.new(0,makes,0) * PlrCharacter:FindFirstChild("HumanoidRootPart").CFrame).Position)
									LocalCharacter.PrimaryPart.CFrame = CFrame.new(0,makes,0) * PlrCharacter.PrimaryPart.CFrame
								end
								makes += gl.globalMake
							end
						elseif way == "z" then
							for i,v in pairs(BotNicknames) do
								if v == LocalPlayer.Name then
									local LocalCharacter = LocalPlayer.Character
									local PlrCharacter = game.Players[gl.followPlr].Character
									--LocalCharacter:MoveTo((CFrame.new(0,makes,0) * PlrCharacter:FindFirstChild("HumanoidRootPart").CFrame).Position)
									LocalCharacter.PrimaryPart.CFrame = CFrame.new(0,0,-makes) * PlrCharacter.PrimaryPart.CFrame
								end
								makes += gl.globalMake
							end
						else
							for i,v in pairs(BotNicknames) do
								if v == LocalPlayer.Name then
									local LocalCharacter = LocalPlayer.Character
									local PlrCharacter = game.Players[gl.followPlr].Character
									--LocalCharacter:MoveTo((CFrame.new(0,makes,0) * PlrCharacter:FindFirstChild("HumanoidRootPart").CFrame).Position)
									LocalCharacter.PrimaryPart.CFrame = CFrame.new(-makes,0,0) * PlrCharacter.PrimaryPart.CFrame
								end
								makes += gl.globalMake
							end
						end
					else
						break
					end
				end
			end))
		end),
		requirements = {
			accessRank = 2,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	unfollow = {
		(function(args,plr)
			gl.isFollow = false
		end),
		requirements = {
			accessRank = 6,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	globalChange = {
		--globalchange value (optional v) newValue
		(function(args,plr)
			local value = args[1]
			local enterValue
			local code
			if args[2]:sub(1,1) == "-" then
				enterValue = args[3]
				code = args[2]:sub(2)
			else
				enterValue = args[2]
			end
			
			if gl[value] ~= nil then
				if code ~= nil then
					if code == "v" then
						if enterValue == "true" then
							BasicChat("TRUE")
							gl[value] = true
						elseif enterValue == "false" then
							BasicChat("FALSE")
							gl[value] = false
						end
					end
				else
					gl[value] = enterValue
				end
			else
				return
			end
			BasicChat("Specified value is successfuly changed.")
		end),
		requirements = {
			accessRank = 8,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	count = {
		(function(args,plr)
			local val = 1
			for i,v in pairs(BotNicknames) do
				if v == LocalPlayer.Name then
					BasicChat(tostring(val))
				end
				val += 1
			end
		end),
		requirements = {
			accessRank = 5,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	troll = {
		(function(args,plr)
			local val = 1
			local text = gl.trolls[tonumber(args[1])]
			for i,v in pairs(BotNicknames) do
				wait(0.05)
				if v == LocalPlayer.Name then
					BasicChat(text:sub(val,val))
				end
				if val >= #text then
					break
				end
				val += 1
			end
		end),
		requirements = {
			accessRank = 5,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	row = {
		(function(args,plr)
			local followPlr = args[1]
			local way = args[2] or nil


			if followPlr == "me" then
				gl.followPlr = plr.Name
			elseif gl.glFunctions.TableSearch(game.Players[followPlr],game.Players:GetPlayers()) then
				gl.followPlr = followPlr
			else
				return false
			end
			print("Thread is there right now.")
			gl.isFollow = false
			wait(0.1)
			gl.isFollow = true
			gl.glFunctions.Thread((function()
				local makes = gl.globalMake
				local makesCFrame = CFrame.new(-makes,0,0)
				
				if way == "x" then
					for i,v in pairs(BotNicknames) do
						if v == LocalPlayer.Name then
							local LocalCharacter = LocalPlayer.Character
							local PlrCharacter = game.Players[gl.followPlr].Character
							--LocalCharacter:MoveTo((CFrame.new(0,makes,0) * PlrCharacter:FindFirstChild("HumanoidRootPart").CFrame).Position)
							LocalCharacter.PrimaryPart.CFrame = CFrame.new(-makes,0,0) * PlrCharacter.PrimaryPart.CFrame
						end
						makes += gl.globalMake
					end
				elseif way == "y" then
					for i,v in pairs(BotNicknames) do
						if v == LocalPlayer.Name then
							local LocalCharacter = LocalPlayer.Character
							local PlrCharacter = game.Players[gl.followPlr].Character
							--LocalCharacter:MoveTo((CFrame.new(0,makes,0) * PlrCharacter:FindFirstChild("HumanoidRootPart").CFrame).Position)
							LocalCharacter.PrimaryPart.CFrame = CFrame.new(0,makes,0) * PlrCharacter.PrimaryPart.CFrame
						end
						makes += gl.globalMake
					end
				elseif way == "z" then
					for i,v in pairs(BotNicknames) do
						if v == LocalPlayer.Name then
							local LocalCharacter = LocalPlayer.Character
							local PlrCharacter = game.Players[gl.followPlr].Character
							--LocalCharacter:MoveTo((CFrame.new(0,makes,0) * PlrCharacter:FindFirstChild("HumanoidRootPart").CFrame).Position)
							LocalCharacter.PrimaryPart.CFrame = CFrame.new(0,0,-makes) * PlrCharacter.PrimaryPart.CFrame
						end
						makes += gl.globalMake
					end
				end
			end))
		end),
		requirements = {
			accessRank = 2,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	kill = {
		(function(args,plr)
			LocalPlayer.Character.Humanoid.Health = 0
		end),
		requirements = {
			accessRank = 5,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	advancedChat = {
		(function(args,plr)
			local msg = ""
			for i,v in pairs(args) do
				if i == 1 then
					msg = msg ..""..v
				else
					msg = msg .." "..v
				end
			end
			game:GetService("Players"):Chat(msg)
		end),
		requirements = {
			accessRank = 1,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	wave = {
		(function(args,plr)
			for i,v in pairs(BotNicknames) do
				if v == LocalPlayer.Name then
					LocalPlayer.Character.Humanoid.Jump = true
					wait(0.05)
				end
			end
		end),
		requirements = {
			accessRank = 1,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	tellMe = {
		(function(args,plr)
			local theValue = args[1]
			
			if gl[theValue] ~= nil then
				BasicChat(theValue)
			else
				BasicChat("Wrong element.")
			end
		end),
		requirements = {
			accessRank = 1,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	help = {
		(function(args,plr)
			local SelectedPlayer = BotNicknames[math.random(#BotNicknames)]
			table.remove(BotNicknames,table.find(BotNicknames,SelectedPlayer))
			if LocalPlayer.Name == SelectedPlayer then
				gl.glFunctions.Thread((function()
					local IsDone = false
					
					local TargetCharacter = plr.Character
					local LocalCharacter = LocalPlayer.Character
					gl.glFunctions.Thread((function()
						wait(6)
						IsDone = true
					end))
					BasicChat("For the bot commands and support; join our server! k2RHnQyv8e")
					while IsDone == false do
						wait()
						LocalCharacter.PrimaryPart.CFrame = TargetCharacter.PrimaryPart.CFrame * CFrame.new(0,0,2)
					end
					table.insert(BotNicknames,SelectedPlayer)
				end))
			end
		end),
		requirements = {
			accessRank = 0,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	scream = {
		(function(args,plr)
			local targetPlr = game.Players[args[1]]
			if #BotNicknames > 4 then
				local Bots = {}
				for i = 1,4 do
					local Selected = BotNicknames[math.random(#BotNicknames)]
					table.insert(Bots,Selected)
					table.remove(BotNicknames,table.find(BotNicknames,Selected))
					
					i+=1
				end
				
				gl.isScream = false
				wait(0.1)
				gl.isScream = true
				gl.glFunctions.Thread((function()
					while wait() do
						if gl.isScream == true then
							wait(4)
							for i,v in pairs(Bots) do
								if LocalPlayer.Name == v then
									local chats = {
										"HEY HOWS GOING?",
										"HAHAHA",
										"NOOB!",
										"LOOK AT YOU!",
										"AAAAAA",
										"BOOOOO",
										"EEEEE",
										"LOOK AT ME",
										"IM HERE!",
										"LAST ON TOP",
										"AM I CUTE",
										"SPAM!",
										"IM FUNNY, AREN'T I?"
									}
									BasicChat(chats[math.random(#chats)])
								end
							end
						else
							break
						end
					end
				end))
				gl.glFunctions.Thread((function()
					while wait() do
						local lok = 1
						if gl.isScream == true then
							for i,v in pairs(Bots) do
								if LocalPlayer.Name == v then
									local botChr = game.Players[v].Character
									local targetChr = targetPlr.Character
									if lok == 1 then
										botChr.PrimaryPart.CFrame = CFrame.new(6,1,0) * targetChr.PrimaryPart.CFrame
									elseif lok == 2 then
										botChr.PrimaryPart.CFrame = CFrame.new(-6,1,0) * targetChr.PrimaryPart.CFrame
									elseif lok == 3 then
										botChr.PrimaryPart.CFrame = CFrame.new(0,1,6) * targetChr.PrimaryPart.CFrame
									elseif lok == 4 then
										botChr.PrimaryPart.CFrame = CFrame.new(0,1,-6) * targetChr.PrimaryPart.CFrame
										break
									end
								end
								lok += 1
							end
						else
							break
						end
					end
				end))
				
			end
		end),
		requirements = {
			accessRank = 5,
			depend = {
				gl.IsLocked == false
			}
		}
	},
	unScream = {
		(function(args,plr)
			gl.isScream = false
		end),
		requirements = {
			accessRank = 5,
			depend = {
				gl.IsLocked == false
			}
		}
	},
}


function RankChecker(command,arguments,plr)
	if gl.IsPublic == true then
		return true
	end
	if commands[command] == nil then
		return false
	end
	local CommandRequirements = commands[command]["requirements"]
	for i,v in pairs(gl.ranks) do
		if v[1] >= CommandRequirements["accessRank"] and gl.glFunctions.TableSearch(plr.Name,v[2]) == true then
			return true
		elseif CommandRequirements["accessRank"] == 0 then
			return true
		end
	end
	return false
end

function DependChecker(command)
	local depend = commands[command]["requirements"]["depend"]
	for i,v in pairs(depend) do
		if v == false then
			return false
		end
	end
	return true
end

function fix()
	commands.fix[1]()
end

function PassFunction(command,arguments,plr)
	print("passing")
	--Player Rank and Depend Check and Bot Check
	print("Rank Check: ".. tostring(RankChecker(command,arguments,plr)))
	print("Depend Check: "..tostring(DependChecker(command) == true))
	print("Bot Check: ".. tostring(BotChecker()))
	if RankChecker(command,arguments,plr) == true and DependChecker(command) == true and BotChecker() == true then
		commands[command][1](arguments,plr)
	end
end

function ProcessMessage(msg,person)
	if msg:sub(1,#gl.prefix) == gl.prefix then
		print("A PREFIX MATCH THERE")
		if gl.activeFix == true then
			gl.glFunctions.Thread(fix)
		end
		local Args = msg:split(" ")
		local Command = Args[1]:sub(2,#Args[1])

		--Arguments for the command
		local CmdArgs = {}
		for i,v in pairs(Args) do
			if i == 1 then
				continue
			else
				table.insert(CmdArgs,v)
			end
		end

		PassFunction(Command,CmdArgs,person)
	end	
end


if gl.DevMode[1] == true then
	print("haha!")
	if gl.isSilent ~= true then
		commands.say[1]({"Activated."})
	end
	fix()
end

messageDoneFiltering.OnClientEvent:Connect(function(message)
	if gl.IsDestroyed == false then
		local plr = players:FindFirstChild(message.FromSpeaker)
		local msg = message.Message or ""
		
		
		if gl.FunPh[msg] ~= nil then
			BasicChat(gl.FunPh[msg])
		end

		if msg == gl.DevMode[2] and gl.DevMode[1] == true then --DEV MODE
			gl.IsDestroyed = true
			gl.followPlr = nil
			gl.isFollow = false
			gl.isScream = false
			if gl.isSilent ~= true  then
				commands.say[1]({gl.DevMode[3]})
			end
			return false
		end

		--Passing like that because gotta pass additional argument.
		ProcessMessage(msg,plr)
	end
end)
