local Players = game:GetService("Players")

local function forceR6(character)
	local humanoid = character:WaitForChild("Humanoid")
	if humanoid.RigType == Enum.HumanoidRigType.R15 then
		-- Jika Anda ingin benar-benar memaksa R6 lewat script, 
		-- cara terbaik adalah mengatur Game Settings. 
		-- Tapi script ini akan memberikan peringatan jika settingan masih salah.
		warn("Karakter terdeteksi R15! Harap ubah Game Settings > Avatar > Avatar Type ke R6 agar sistem combat berjalan.")
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(forceR6)
end)

-- Catatan: Mengubah RigType secara runtime lewat script sangat beresiko crash.
-- Sangat disarankan untuk tetap mengubahnya melalui:
-- Game Settings -> Avatar -> Avatar Type -> R6
