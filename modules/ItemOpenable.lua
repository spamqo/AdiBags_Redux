
local addonName, addon = ...
local L = addon.L

local _G = _G
local GetItemInfo = _G.GetItemInfo
local GetContainerItemID = C_Container and _G.C_Container.GetContainerItemID or _G.GetContainerItemID

local C_TooltipInfo = _G.C_TooltipInfo
local GameTooltipTextLeft = _G.GameTooltipTextLeft

local OPENABLE_CONTAINER = "Open the container"
local OPENABLE_USEOPEN = "Use: Open"
local OPENABLE_RIGHTCLICK = "Click to Open"


local mod = addon:NewModule('ItemOpenable', 'ABEvent-1.0')
mod.uiName = L['Item openable']
mod.uiDesc = L['Mark an item as openable.']

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
		text:SetPoint("TOPLEFT", button, 3, -1)
		texts[button] = text
	end

	text:Hide()
	if isOpenable(button) then
		text:SetText("Open")
		text:SetTextColor(.1,1,.1)
		text:Show()
	end


end


function isOpenable(button)
	local isRetail = C_TooltipInfo

	if isRetail then
		local tooltip = C_TooltipInfo.GetBagItem(button.bag, button.slot)
		if not tooltip then
			return false
		end
    for i, line in ipairs(tooltip.lines) do
			local ttText = line.leftText
			if ttText and (string.find(ttText, OPENABLE_CONTAINER) or string.find(ttText, OPENABLE_USEOPEN) or string.find(ttText, OPENABLE_RIGHTCLICK)) then
				return true
			end
    end
	else
		GameTooltip:SetOwner(UIParent,"ANCHOR_NONE")
		GameTooltip:ClearLines()
		if button.bag == BANK_CONTAINER then
			GameTooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(button.slot, nil))
		else
			GameTooltip:SetBagItem(button.bag, button.slot)
		end

		local regions = {GameTooltip:GetRegions()}
		for i, r in ipairs(regions) do
			if r:IsObjectType("FontString") then
				local ttText = r:GetText()
				if ttText and (string.find(ttText, OPENABLE_CONTAINER) or string.find(ttText, OPENABLE_USEOPEN) or string.find(ttText, OPENABLE_RIGHTCLICK)) then
					return true
				end
			end
		end

		GameTooltip:Hide()

	end

	return false
end




