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
        local firstname = VJ_PICK(VJ_BMCE_NAMES_FIRST_F)
        local lastname = VJ_PICK(VJ_BMCE_NAMES_LAST)
        local sci_ranks = VJ_PICK(VJ_BMCE_RANKS_SCI)
        local random = math.random
        local rc = random(1,2)

        if rc == 1 then
            self.PrintName = sci_ranks .. firstname .. lastname
        elseif rc == 2 then
            self.PrintName = firstname .. lastname
        end
    end
end