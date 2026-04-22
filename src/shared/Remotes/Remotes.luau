local ReplicatedStorage = game:GetService("ReplicatedStorage")

local folder = ReplicatedStorage:FindFirstChild("Remotes")
if not folder then
	folder = Instance.new("Folder")
	folder.Name = "Remotes"
	folder.Parent = ReplicatedStorage
end

local function getRemoteEvent(name)
	local remote = folder:FindFirstChild(name)
	if remote and remote:IsA("RemoteEvent") then
		return remote
	end

	remote = Instance.new("RemoteEvent")
	remote.Name = name
	remote.Parent = folder
	return remote
end

return {
	TestEvent = getRemoteEvent("TestEvent"),
	InteractRequest = getRemoteEvent("InteractRequest"),
	Characters = getRemoteEvent("Characters"),
	CamShake = getRemoteEvent("CamShake"),
	Lighting = getRemoteEvent("Lighting"),
	Cutsense = getRemoteEvent("Cutsense"),
	-- Character Remotes
	Deku = getRemoteEvent("Deku"),
	Denji = getRemoteEvent("Denji"),
	Gojo = getRemoteEvent("Gojo"),
	Goku = getRemoteEvent("Goku"),
	Gon = getRemoteEvent("Gon"),
	Ichigo = getRemoteEvent("Ichigo"),
	Luffy = getRemoteEvent("Luffy"),
	Luffy2 = getRemoteEvent("Luffy2"),
	Reigen = getRemoteEvent("Reigen"),
	Rengoku = getRemoteEvent("Rengoku"),
	Yuji = getRemoteEvent("Yuji"),
	Yuta = getRemoteEvent("Yuta"),
}
