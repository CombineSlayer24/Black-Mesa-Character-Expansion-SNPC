ENT.Base 			= "npc_vj_bmce_base" -- List of all base types: https://github.com/DrVrej/VJ-Base/wiki/Base-Types
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Pyri"
ENT.Contact 		= "http://steamcommunity.com/id/swellseeker7820"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Black Mesa CE"

if CLIENT then
    function ENT:Initialize()        
        local firstname = VJ_PICK(VJ_BMCE_NAMES_FIRST_M)
        local lastname = VJ_PICK(VJ_BMCE_NAMES_LAST)
        local rank = VJ_PICK(VJ_BMCE_RANKS_BMSF)
        
        self.PrintName = rank .. firstname .. lastname
    end
end