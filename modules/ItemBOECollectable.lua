
local addonName, addon = ...
local L = addon.L

local _G = _G
local GetItemInfo = _G.GetItemInfo
local GetContainerItemID = C_Container and _G.C_Container.GetContainerItemID or _G.GetContainerItemID

local C_TooltipInfo = _G.C_TooltipInfo
local GameTooltipTextLeft = _G.GameTooltipTextLeft

local ITEM_COLLECTABLE = "haven't collected"
local ITEM_BOE = "Binds when equipped"


local mod = addon:NewModule('ItemBOECollectable', 'ABEvent-1.0')
mod.uiName = L['Item BOE or transmog collectable']
mod.uiDesc = L['Mark an item as BOE or colelctable.']

local texts = {}

function mod:OnEnable()
	self:RegisterMessage('AdiBags_UpdateButton', 'UpdateButton')
	self:SendMessage('AdiBags_UpdateAllButtons')
end

function mod:OnDisable()
	for _, text in pairs(texts) do
		text:Hide()
	end
end


function mod:UpdateButton(event, button)
	local text = texts[button]
	if not text then
		text = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
		text:SetPoint("BOTTOMLEFT", button, 3, 1)
		texts[button] = text
	end

	text:Hide()

	local isRetail = C_TooltipInfo

	if isRetail then

		local tooltip = C_TooltipInfo.GetBagItem(button.bag, button.slot)
		if not tooltip then
			return
		end
    for i, line in ipairs(tooltip.lines) do
			local ttText = line.leftText
			if ttText and (string.find(ttText, ITEM_COLLECTABLE)) then
				text:SetText("TMog")
				text:SetTextColor(1,.5,1)
				text:Show()
			elseif ttText and (string.find(ttText, ITEM_BOE)) then
				text:SetText("BOE")
				text:SetTextColor(.1,.9,1)
				text:Show()
			end
    end

	end



end






