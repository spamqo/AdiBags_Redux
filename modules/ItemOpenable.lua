
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
local updateCache = {}

function mod:OnEnable()
	self:RegisterMessage('AdiBags_UpdateButton', 'UpdateButton')
	self:SendMessage('AdiBags_UpdateAllButtons')
end

function mod:OnDisable()
	wipe(updateCache)
	for _, text in pairs(texts) do
		text:Hide()
	end
end

local function CreateText(button)
	local text = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	text:SetPoint("TOPLEFT", button, 3, -1)
	text:Hide()
	texts[button] = text
	return text
end


function mod:UpdateButton(event, button)
	local text = texts[button]
	local link = button:GetItemLink()

	if link then
		local _, _, quality, _, reqLevel, _, _, _, loc = GetItemInfo(link)
		local item = Item:CreateFromBagAndSlot(button.bag, button.slot)
		local openText = isOpenable(button)
		if openText then
			if not text then
				text = CreateText(button)
			end
			text:SetText(openText)
			text:SetTextColor(.1,1,.1)
			text:Show()
		else
			if text then
				text:Hide()
			end
		end
	end
end


function isOpenable(button)
	local tooltip = CreateFrame("Gametooltip")
	tooltip:SetOwner(UIParent,"ANCHOR_NONE")
	tooltip:ClearLines()

	local isRetail = C_TooltipInfo

	if isRetail then
		tooltip = C_TooltipInfo.GetBagItem(button.bag, button.slot)
    for i, line in ipairs(tooltip.lines) do
			local ttText = line.leftText
			if ttText and (string.find(ttText, OPENABLE_CONTAINER) or string.find(ttText, OPENABLE_USEOPEN) or string.find(ttText, OPENABLE_RIGHTCLICK)) then
				return "Open"
			end
    end
	else
	if button.bag == BANK_CONTAINER then
		tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(button.slot, nil))
	else
		tooltip:SetBagItem(button.bag, button.slot)
	end
  local regions = {GameTooltip:GetRegions()}
  for i, r in ipairs(regions) do
    if r:IsObjectType("FontString") then
      local ttText = r:GetText()
				if ttText and (string.find(ttText, OPENABLE_CONTAINER) or string.find(ttText, OPENABLE_USEOPEN) or string.find(ttText, OPENABLE_RIGHTCLICK)) then
					return "Open"
				end
			end
		end
	end

	return nil
end




