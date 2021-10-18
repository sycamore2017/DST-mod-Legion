local Widget = require "widgets/widget"
local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local Menu = require "widgets/menu"
local Text = require "widgets/text"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"
local TEMPLATES = require "widgets/templates"
local TEMPLATES2 = require "widgets/redux/templates"
local ItemImage = require "widgets/redux/itemimage"
local ClothingExplorerPanel = require "widgets/redux/clothingexplorerpanel"
local AccountItemFrame = require "widgets/redux/accountitemframe"
local ScrollableList = require "widgets/scrollablelist"

local function GetCollection(skin)
    local data = SKINS_LEGION[skin]
    if data ~= nil and data.string ~= nil and data.string.collection ~= nil then
        return STRINGS.SKIN_LEGION.COLLECTION[data.string.collection]
    else
        return STRINGS.SKIN_LEGION.COLLECTION.UNKNOWN
    end
end

local function GetDescription(skin)
    local data = SKINS_LEGION[skin]
    if data ~= nil and data.string ~= nil and data.string.description ~= nil then
        return data.string.description
    else
        return STRINGS.SKIN_LEGION.UNKNOWN_STORY
    end
end

local function GetAccess(skin)
    local data = SKINS_LEGION[skin]
    if data ~= nil and data.string ~= nil and data.string.access ~= nil then
        return STRINGS.SKIN_LEGION.ACCESS[data.string.access]
    else
        return STRINGS.SKIN_LEGION.ACCESS.UNKNOWN
    end
end

local SkinLegionDialog = Class(Widget, function(self, owner, text)
	Widget._ctor(self, "SkinLegionDialog")

    self.owner = owner

    self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetPosition(0, 0, 0)

    self.bg = self.proot:AddChild(TEMPLATES.CenterPanel(nil, nil, true))
    self.bg:SetScale(.51, .74)
    self.bg:SetPosition(0, 0)

    --竖线
    -- self.vertical_line = self.proot:AddChild(Image("images/ui.xml", "line_vertical_5.tex"))
    -- self.vertical_line:SetScale(.5, .6)
    -- self.vertical_line:SetPosition(45, 8)

    -- self.x_button = self.proot:AddChild(
    --     ImageButton("images/global_redux.xml", "button_carny_long_normal.tex",
    --         "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex")
    -- )
    -- self.x_button.image:SetScale(.5)
    -- self.x_button:SetFont(CHATFONT)
    -- self.x_button:SetPosition(0, -220)
    -- self.x_button.text:SetColour(0,0,0,1)
    -- self.x_button:SetTextSize(26)
    -- self.x_button:SetText("关闭")
    -- self.x_button:SetOnClick(function()
    --     self:Close()
    -- end)

    self.x_button = self.proot:AddChild(TEMPLATES.SmallButton(STRINGS.UI.PLAYER_AVATAR.CLOSE, 26, .5, function() self:Close() end))
    self.x_button:SetPosition(0, -215)

    -- self.y_button = self.proot:AddChild(
    --     ImageButton("images/global_redux.xml", "button_carny_long_normal.tex",
    --         "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex")
    -- )
    -- self.y_button.image:SetScale(.5)
    -- self.y_button:SetFont(CHATFONT)
    -- self.y_button:SetPosition(160, -220)
    -- self.y_button.text:SetColour(0,0,0,1)
    -- self.y_button:SetTextSize(26)
    -- self.y_button:SetText("测试")
    -- self.y_button:SetOnClick(function()
    --     self:SetItems()
    -- end)

	self.buttons = {}

    self.selected_item = nil
    self:SetItems()

	-- self.default_focus = self.menu
end)

function SkinLegionDialog:SetItems(itemsnew)
    self:SetItemInfo()
    if self.option_items ~= nil then
        self.option_items:Kill()
    end

    self.items = {
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell", --(不管)
            owned_count = 0, --已拥有数量(不管)
            isnew = false, --是否新皮肤(不管)
            context = nil, --存下的组件
            isselected = false, --是否处于选中状态
            isfocused = false, --是否处于被鼠标移入状态(不管)
            isowned = true, --是否拥有该皮肤
            isunlockable = true, --是否可解锁
            idx = 1,
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 0,
            isowned = false,
            isunlockable = true,
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 2,
            isowned = true,
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 2
        },
        {
            item_key = "wilson_rose",
            item_id = "rosorns_spell",
            owned_count = 0,
            isnew = math.random() < 0.5,
            isunlockable = true,
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 2,
            isnew = math.random() < 0.5,
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 0,
            isnew = math.random() < 0.5,
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 2
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 2
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 2
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 2
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 2
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 2
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 2
        },
        {
            item_key = "willow_rose",
            item_id = "rosorns_spell",
            owned_count = 2
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 99
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 2
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 5
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 4
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 3
        },
        {
            item_key = "rosorns_spell",
            item_id = "rosorns_spell",
            owned_count = 2
        },
    }

    local start_x = -160
    self.items_list = {}
    local itemcount = 0
    local x = start_x
    local item_w = nil
    for k, v in pairs(self.items) do
        if item_w == nil then
            item_w = self.proot:AddChild(Widget("SkinItem"..k))
            table.insert(self.items_list, item_w)
        end
        local a = item_w:AddChild(ItemImage(nil, {
            show_hover_text = true
        }))
        a:ApplyDataToWidget(self, v, nil)
        a.frame:SetAge(v.isnew)
        v.context = a
        -- a.warn_marker:Show()
        -- if a.frame.age_text then
        --     a.frame.age_text:SetString("拥有")
        -- end

        --是否已选：会在图标右下方表上“√”
        --是否拥有该皮肤：没有这个皮肤会是暗淡的色调
        --是否处于鼠标移入状态：会在边角上显示金色线
        --是否可解锁：未拥有且可解锁时，会在左下方显示“锁”的图案
        --是否该dlc拥有：不懂，为false即可
        a:SetInteractionState(v.isselected, v.isowned, v.isfocused, v.isunlockable, false)
        a:SetPosition(x, 0)

        if a.SetOnClick then
            a:SetOnClick(function()
                self:SetItemInfo(v)
            end)
        end

        itemcount = itemcount + 1
        v.idx = itemcount
        if itemcount%3 == 0 then
            item_w = nil
            -- itemcount = 0
            x = start_x
        else
            x = x + 78
        end
    end

    self.option_items = self.proot:AddChild(ScrollableList(self.items_list, 55, 370, 73, 3))
    self.option_items:SetPosition(0, 0)
end

function SkinLegionDialog:SetItemInfo(item)
    if item == nil then
        if self.selected_item ~= nil then
            self.selected_item.isselected = false
            self:SetInteractionState(self.selected_item)
            self.selected_item = nil
        end

        if self.panel_iteminfo ~= nil then
            self.panel_iteminfo:Kill()
            self.panel_iteminfo = nil
            self.label_skinname = nil
            self.label_skinrarity = nil
            self.horizontal_line = nil
            self.label_skindesc = nil
            self.label_skinaccess = nil
            self.horizontal_line2 = nil
            self.button_access = nil
        end
    else
        if self.selected_item ~= nil then
            if self.selected_item.idx == item.idx then
                return
            end
            self.selected_item.isselected = false
            self:SetInteractionState(self.selected_item)
        end
        item.isselected = true
        self:SetInteractionState(item)
        self.selected_item = item

        local startpos_x = 144
        local startpos_y = 190
        if self.panel_iteminfo == nil then
            self.panel_iteminfo = self.proot:AddChild(Widget("SkinItemInfo"))
            self.panel_iteminfo:SetPosition(startpos_x, startpos_y)
        end

        if self.label_skinname == nil then
            self.label_skinname = self.panel_iteminfo:AddChild(Text(UIFONT, 30))
            self.label_skinname:SetColour(UICOLOURS.GOLD_SELECTED)
            -- self.label_skinname:SetHAlign(ANCHOR_LEFT)
            -- self.label_skinname:SetRegionSize(180, 30)
            self.label_skinname:SetPosition(0, 0)
        end
        self.label_skinname:SetString(GetSkinName(item.item_key))

        if self.label_skinrarity == nil then
            self.label_skinrarity = self.panel_iteminfo:AddChild(Text(HEADERFONT, 20))
            -- self.label_skinrarity:SetHAlign(ANCHOR_LEFT)
            -- self.label_skinrarity:SetRegionSize(180, 20)
            self.label_skinrarity:SetPosition(0, -20)
        end
        self.label_skinrarity:SetString(GetCollection(item.item_key))
        self.label_skinrarity:SetColour(GetColorForItem(item.item_key))

        if self.horizontal_line == nil then
            self.horizontal_line = self.panel_iteminfo:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line_break.tex"))
            self.horizontal_line:SetScale(.45, .3)
            self.horizontal_line:SetPosition(-3, -38)
        end

        if self.label_skindesc == nil then
            self.label_skindesc = self.panel_iteminfo:AddChild(Text(CHATFONT, 21))
            self.label_skindesc:SetPosition(0, -128)
            self.label_skindesc:SetColour(UICOLOURS.BROWN_DARK)
            self.label_skindesc:SetHAlign(ANCHOR_LEFT)
            self.label_skindesc:SetVAlign(ANCHOR_TOP)
            self.label_skindesc:EnableWordWrap(true)
            self.label_skindesc:SetRegionSize(180, 150)
        end
        self.label_skindesc:SetString(GetDescription(item.item_key))

        if self.label_skinaccess == nil then
            self.label_skinaccess = self.panel_iteminfo:AddChild(Text(HEADERFONT, 20))
            self.label_skinaccess:SetHAlign(ANCHOR_LEFT)
            self.label_skinaccess:SetRegionSize(180, 20)
            self.label_skinaccess:SetColour(UICOLOURS.BRONZE)
            self.label_skinaccess:SetPosition(0, -215)
        end
        self.label_skinaccess:SetString(GetAccess(item.item_key))

        if item.isowned then
            if self.button_access ~= nil then
                self.button_access:Kill()
                self.button_access = nil
            end
        else
            if item.isunlockable then
                if self.button_access == nil then
                    self.button_access = self.panel_iteminfo:AddChild(
                        ImageButton("images/global_redux.xml", "button_carny_long_normal.tex",
                            "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex")
                    )
                    self.button_access.image:SetScale(.2, .35)
                    self.button_access:SetFont(CHATFONT)
                    self.button_access:SetPosition(50, -212)
                    self.button_access.text:SetColour(0,0,0,1)
                    self.button_access:SetTextSize(20)
                    self.button_access:SetText("获取") --undo：英文化
                    self.button_access:SetOnClick(function()
                        self:Close()
                    end)
                end
            else
                if self.button_access ~= nil then
                    self.button_access:Kill()
                    self.button_access = nil
                end
            end
        end

        if self.horizontal_line2 == nil then
            self.horizontal_line2 = self.panel_iteminfo:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line.tex"))
            self.horizontal_line2:SetScale(.32, .25)
            self.horizontal_line2:SetPosition(-5, -227)
        end
    end
end

function SkinLegionDialog:SetInteractionState(item)
    if item.context then
        item.context:SetInteractionState(item.isselected, item.isowned, item.isfocused, item.isunlockable, false)
    end
end

function SkinLegionDialog:OnControl(control, down)
    if SkinLegionDialog._base.OnControl(self,control, down) then return true end

    if control == CONTROL_CANCEL and not down then
        if #self.buttons > 1 and self.buttons[#self.buttons] then
            self.buttons[#self.buttons].cb()
            TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
            return true
        end
    end
end


function SkinLegionDialog:Close()
	self:Kill()
end

return SkinLegionDialog
