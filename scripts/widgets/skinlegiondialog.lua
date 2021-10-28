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
local PopupDialogScreen = require "screens/redux/popupdialog"

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

local function GetDescItem(skin)
    local data = SKINS_LEGION[skin]
    if data ~= nil and data.string ~= nil and data.string.descitem ~= nil then
        return data.string.descitem
    else
        return ""
    end
end

function PushPopupDialog(self, title, message, buttontext, fn)
    if self.context_popup ~= nil then
        TheFrontEnd:PopScreen(self.context_popup)
    end

    self.context_popup = PopupDialogScreen(title, message, {
        {
            text = buttontext or STRINGS.UI.POPUPDIALOG.OK,
            cb = function()
                TheFrontEnd:PopScreen(self.context_popup)
                self.context_popup = nil
                if fn then fn() end
            end
        }
    })
    TheFrontEnd:PushScreen(self.context_popup)

    local screen = TheFrontEnd:GetActiveScreen()
    if screen then screen:Enable() end
end

local SkinLegionDialog = Class(Widget, function(self, owner)
	Widget._ctor(self, "SkinLegionDialog")

    if not owner or owner.userid == nil or owner.userid == "" then
        self:Kill()
        return
    end
    self.owner = owner

    self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetPosition(0, 0, 0)

    --整体背景图
    self.bg = self.proot:AddChild(TEMPLATES.CenterPanel(nil, nil, true))
    self.bg:SetScale(.51, .74)
    self.bg:SetPosition(0, 0)

    --关闭弹窗按钮
    self.button_close = self.proot:AddChild(TEMPLATES.SmallButton(STRINGS.UI.PLAYER_AVATAR.CLOSE, 26, .5, function() self:Close() end))
    self.button_close:SetPosition(0, -215)

    --cdk兑换区域的分割线
    self.horizontal_line3 = self.proot:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line.tex"))
    self.horizontal_line3:SetScale(.32, .25)
    self.horizontal_line3:SetPosition(140, -105)

    --cdk输入框
    self.input_cdk = self.proot:AddChild(TEMPLATES2.StandardSingleLineTextEntry(nil, 200, 40))
    self.input_cdk.textbox:SetTextLengthLimit(20)
    self.input_cdk.textbox:EnableWordWrap(false)
    self.input_cdk.textbox:EnableScrollEditWindow(true)
    self.input_cdk.textbox:SetTextPrompt(STRINGS.SKIN_LEGION.UI_INPUT_CDK, UICOLOURS.GREY)
    self.input_cdk.textbox.prompt:SetHAlign(ANCHOR_MIDDLE)
    self.input_cdk.textbox:SetHAlign(ANCHOR_MIDDLE)
    self.input_cdk.textbox:SetCharacterFilter("-0123456789QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm")
    self.input_cdk:SetOnGainFocus( function() self.input_cdk.textbox:OnGainFocus() end )
    self.input_cdk:SetOnLoseFocus( function() self.input_cdk.textbox:OnLoseFocus() end )
    self.input_cdk:SetPosition(140, -130)
    self.input_cdk.focus_forward = self.input_cdk.textbox

    --cdk确认输入按钮
    self.button_cdk = self.proot:AddChild(
        ImageButton("images/global_redux.xml", "button_carny_long_normal.tex",
            "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex")
    )
    self.button_cdk.image:SetScale(.3, .35)
    self.button_cdk:SetFont(CHATFONT)
    self.button_cdk:SetPosition(140, -165)
    self.button_cdk.text:SetColour(0,0,0,1)
    self.button_cdk:SetTextSize(20)
    self.button_cdk:SetText(STRINGS.UI.MAINSCREEN.REDEEM)
    self.button_cdk:SetOnClick(function()
        --undo: 检测cdk是否正常
        local cdk = self.input_cdk.textbox:GetString()
        if cdk == nil or cdk == "" or cdk:utf8len() <= 6 then
            PushPopupDialog(self, "轻声提醒", "请输入正确的兑换码。", "知道啦", nil)
            return
        end
        self.button_cdk:SetText(STRINGS.SKIN_LEGION.UI_LOAD_CDK)
        self.input_cdk.textbox:SetString("")
    end)

    self.selected_item = nil
    self.context_popup = nil
    self.items = nil

    --初始化皮肤项
    local items = {}
    local myskins = SKINS_CACHE_L[owner.userid]
    for skinname,v in pairs(SKINS_LEGION) do
        local item = {
            item_key = skinname,
            item_id = skinname, --(不管)
            owned_count = 0, --已拥有数量(不管)
            isnew = false, --是否新皮肤(不管)
            isfocused = false, --是否处于被鼠标移入状态(不管)
            isselected = false, --是否处于选中状态
            isowned = false, --是否拥有该皮肤
            isunlockable = v.string.access == "DONATE", --是否可解锁
            idx = nil,
            context = nil, --存下的组件
        }
        -- if myskins ~= nil and myskins[skinname] then
        --     item.isowned = true
        -- end
        items[skinname] = item
    end
    self:SetItems(items)

	-- self.default_focus = self.menu
end)

function SkinLegionDialog:SetItems(itemsnew)
    --先清除已有数据
    self:SetItemInfo()
    if self.option_items ~= nil then
        self.option_items:Kill()
    end
    self.items_list = {} --皮肤组，1组3个ui
    self.items = itemsnew

    local start_x = -160
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
        v.context = a --记下皮肤项对应的ui，方便后续更改
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
        if itemcount%3 == 0 then --一排最多摆3个皮肤
            item_w = nil
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
            self.label_skindescitem = nil
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
                    self.button_access:SetText(STRINGS.SKIN_LEGION.UI_ACCESS)
                    self.button_access:SetOnClick(function()
                        local skin = SKINS_LEGION[item.item_key]
                        if skin ~= nil then
                            VisitURL("https://wap.fireleaves.cn/#/qrcode?userId="..self.owner.userid
                                .."&skinId="..skin.skin_id)
                            PushPopupDialog(self, "感谢支持！", "打赏成功了吗？请点击按钮刷新皮肤数据。", "弄好啦", function()
                                --undo: 向服务器发送更新请求
                            end)
                        end
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

        if self.label_skindescitem == nil then
            self.label_skindescitem = self.panel_iteminfo:AddChild(Text(CHATFONT, 20))
            self.label_skindescitem:SetPosition(0, -263)
            self.label_skindescitem:SetColour(UICOLOURS.BROWN_DARK)
            self.label_skindescitem:SetHAlign(ANCHOR_LEFT)
            self.label_skindescitem:SetVAlign(ANCHOR_TOP)
            self.label_skindescitem:EnableWordWrap(true)
            self.label_skindescitem:SetRegionSize(180, 60)
        end
        self.label_skindescitem:SetString(GetDescItem(item.item_key))
    end
end

function SkinLegionDialog:SetInteractionState(item)
    if item.context then
        item.context:SetInteractionState(item.isselected, item.isowned, item.isfocused, item.isunlockable, false)
    end
end

function SkinLegionDialog:OnControl(control, down)
    if SkinLegionDialog._base.OnControl(self, control, down) then return true end

    -- if control == CONTROL_CANCEL and not down then
    --     if #self.buttons > 1 and self.buttons[#self.buttons] then
    --         self.buttons[#self.buttons].cb()
    --         TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
    --         return true
    --     end
    -- end
end

function SkinLegionDialog:Close()
	self:Kill()
end

return SkinLegionDialog
