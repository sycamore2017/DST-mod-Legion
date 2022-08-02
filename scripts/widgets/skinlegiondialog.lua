local Widget = require "widgets/widget"
local Screen = require "widgets/screen"
local AnimButton = require "widgets/animbutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local TEMPLATES = require "widgets/templates"
local TEMPLATES2 = require "widgets/redux/templates"
local ItemImage = require "widgets/redux/itemimage"
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

local function DoRpc(type, data)
    if data == nil then
        SendModRPCToServer(GetModRPC("LegionSkined", "BarHandle"), type, nil)
        return
    end

    local success, result  = pcall(json.encode, data)
	if success then
        SendModRPCToServer(GetModRPC("LegionSkined", "BarHandle"), type, result)
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

    --cdk兑换区域的分割线
    self.horizontal_line3 = self.proot:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line.tex"))
    self.horizontal_line3:SetScale(.32, .25)
    self.horizontal_line3:SetPosition(140, -105)

    --cdk输入框(tip: 皮肤获取通道删除)
    -- self.input_cdk = self.proot:AddChild(TEMPLATES2.StandardSingleLineTextEntry(nil, 200, 40))
    -- self.input_cdk.textbox:SetTextLengthLimit(20)
    -- self.input_cdk.textbox:EnableWordWrap(false)
    -- self.input_cdk.textbox:EnableScrollEditWindow(true)
    -- self.input_cdk.textbox:SetTextPrompt(STRINGS.SKIN_LEGION.UI_INPUT_CDK, UICOLOURS.GREY)
    -- self.input_cdk.textbox.prompt:SetHAlign(ANCHOR_MIDDLE)
    -- self.input_cdk.textbox:SetHAlign(ANCHOR_MIDDLE)
    -- self.input_cdk.textbox:SetCharacterFilter("-0123456789QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm")
    -- self.input_cdk:SetOnGainFocus( function() self.input_cdk.textbox:OnGainFocus() end )
    -- self.input_cdk:SetOnLoseFocus( function() self.input_cdk.textbox:OnLoseFocus() end )
    -- self.input_cdk:SetPosition(140, -130)
    -- self.input_cdk.focus_forward = self.input_cdk.textbox

    --cdk确认输入按钮(tip: 皮肤获取通道删除)
    -- self.button_cdk = self.proot:AddChild(
    --     ImageButton("images/global_redux.xml", "button_carny_long_normal.tex",
    --         "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex")
    -- )
    -- self.button_cdk.image:SetScale(.3, .35)
    -- self.button_cdk:SetFont(CHATFONT)
    -- self.button_cdk:SetPosition(140, -165)
    -- self.button_cdk.text:SetColour(0,0,0,1)
    -- self.button_cdk:SetTextSize(20)
    -- self.button_cdk:SetText(STRINGS.UI.MAINSCREEN.REDEEM)
    -- self.button_cdk:SetOnClick(function()
    --     if self.loadtag_cdk == 0 then
    --         return
    --     end

    --     local cdk = self.input_cdk.textbox:GetString()
    --     if cdk == nil or cdk == "" or cdk:utf8len() <= 6 then
    --         PushPopupDialog(self, "轻声提醒", "请输入正确的兑换码。", "知道啦", nil)
    --         return
    --     end
    --     self:SetCdkState(0, nil) --后续的状态更新需要服务端返回结果过来
    --     DoRpc(2, { cdk = cdk })
    -- end)

    --关闭弹窗按钮
    self.button_close = self.proot:AddChild(TEMPLATES.SmallButton(STRINGS.UI.PLAYER_AVATAR.CLOSE, 26, .5, function() self:Close() end))
    self.button_close:SetPosition(0, -215)

    --主动刷新皮肤按钮
    self.button_regetskins = self.proot:AddChild(TEMPLATES.IconButton(
        "images/button_icons.xml", "refresh.tex", "刷新我的皮肤", false, false,
        function()
            DoRpc(1, nil)
        end,
        nil, "self_inspect_mod.tex"
    ))
    self.button_regetskins.icon:SetScale(.15)
    self.button_regetskins.icon:SetPosition(-5, 6)
    self.button_regetskins:SetScale(0.65)
    self.button_regetskins:SetPosition(110, -220)

    self.selected_item = nil
    self.context_popup = nil
    self.items = nil

    self:ResetItems()

	-- self.default_focus = self.menu
end)

function SkinLegionDialog:SetCdkState(state, poptype)
    self.loadtag_cdk = state
	if state == 0 then
        self.button_cdk:SetText(STRINGS.SKIN_LEGION.UI_LOAD_CDK)
    elseif state == 1 then
        self.button_cdk:SetText(STRINGS.UI.MAINSCREEN.REDEEM)
        self.input_cdk.textbox:SetString("")

        if poptype then
            PushPopupDialog(self, "感谢支持！", "兑换成功！来，试试看。", "好的", nil)
        end
    elseif state == -1 then
        self.button_cdk:SetText(STRINGS.UI.MAINSCREEN.REDEEM)

        if poptype then
            local str = nil
            if poptype == -1 or poptype == 4 then
                str = "兑换失败！请检查兑换码、网络、已有皮肤情况。实在不行请联系作者。"
            elseif poptype == 2 then
                str = "操作太快了，请等几秒再试试。"
            elseif poptype == 3 then
                str = "服务器调用失败，请联系作者反馈情况。"
            else
                str = "未知情况["..tostring(poptype).."]：请联系作者反馈情况。"
            end
            PushPopupDialog(self, "小声提醒", str, "知道了", nil)
        end
    else
        self.button_cdk:SetText(STRINGS.UI.MAINSCREEN.REDEEM)
        self.input_cdk.textbox:SetString("")
    end
end

function SkinLegionDialog:ResetItems()
    --记下之前选中的皮肤
	local selected_skin = self.selected_item ~= nil and self.selected_item.item_key or nil
    local selected_item = nil

    --初始化皮肤项
    local items = {}
    local myskins = SKINS_CACHE_L[self.owner.userid]
    for idx,skinname in pairs(SKIN_IDX_LEGION) do
        local v = SKINS_LEGION[skinname]
        if v ~= nil then
            if not v.noshopshow then
                local isowned = false
                if v.skin_id == "freeskins" or (myskins ~= nil and myskins[skinname]) then
                    isowned = true
                end
                if not v.onlyownedshow or isowned then
                    local item = {
                        item_key = skinname,
                        item_id = skinname, --(不管)
                        owned_count = 0, --已拥有数量(不管)
                        isnew = false, --是否新皮肤(不管)
                        isfocused = false, --是否处于被鼠标移入状态(不管)
                        isselected = false, --是否处于选中状态
                        isowned = isowned, --是否拥有该皮肤
                        isunlockable = v.string.access == "DONATE", --是否可解锁
                        idx = nil,
                        context = nil, --存下的组件
                    }
                    table.insert(items, item)

                    if selected_item == nil and selected_skin ~= nil and selected_skin == skinname then
                        selected_item = item
                    end
                end
            end
        end
    end
    self:SetItems(items)

    if selected_item ~= nil then --恢复之前选中的皮肤
        self:SetItemInfo(selected_item)
    else --默认选中第一个
        self:SetItemInfo(items[1])
    end
end

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

        --皮肤名称
        if self.label_skinname == nil then
            self.label_skinname = self.panel_iteminfo:AddChild(Text(UIFONT, 30))
            self.label_skinname:SetColour(UICOLOURS.GOLD_SELECTED)
            -- self.label_skinname:SetHAlign(ANCHOR_LEFT)
            -- self.label_skinname:SetRegionSize(180, 30)
            self.label_skinname:SetPosition(0, 0)
        end
        self.label_skinname:SetString(GetSkinName(item.item_key))

        --皮肤品质
        if self.label_skinrarity == nil then
            self.label_skinrarity = self.panel_iteminfo:AddChild(Text(HEADERFONT, 20))
            -- self.label_skinrarity:SetHAlign(ANCHOR_LEFT)
            -- self.label_skinrarity:SetRegionSize(180, 20)
            self.label_skinrarity:SetPosition(0, -20)
        end
        self.label_skinrarity:SetString(GetCollection(item.item_key))
        self.label_skinrarity:SetColour(GetColorForItem(item.item_key))

        --标题分割线
        if self.horizontal_line == nil then
            self.horizontal_line = self.panel_iteminfo:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line_break.tex"))
            self.horizontal_line:SetScale(.45, .3)
            self.horizontal_line:SetPosition(-3, -38)
        end

        --皮肤小故事
        if self.label_skindesc == nil then
            self.label_skindesc = self.panel_iteminfo:AddChild(Text(CHATFONT, 20))
            self.label_skindesc:SetPosition(0, -128)
            self.label_skindesc:SetColour(UICOLOURS.BROWN_DARK)
            self.label_skindesc:SetHAlign(ANCHOR_LEFT)
            self.label_skindesc:SetVAlign(ANCHOR_TOP)
            self.label_skindesc:EnableWordWrap(true)
            self.label_skindesc:SetRegionSize(180, 150)
        end
        self.label_skindesc:SetString(GetDescription(item.item_key))

        --皮肤获取方式描述
        if self.label_skinaccess == nil then
            self.label_skinaccess = self.panel_iteminfo:AddChild(Text(HEADERFONT, 20))
            self.label_skinaccess:SetHAlign(ANCHOR_LEFT)
            self.label_skinaccess:SetRegionSize(180, 20)
            self.label_skinaccess:SetColour(UICOLOURS.BRONZE)
            self.label_skinaccess:SetPosition(0, -215)
        end
        self.label_skinaccess:SetString(GetAccess(item.item_key))

        --获取按钮(tip: 皮肤获取通道删除)
        -- if item.isowned then
        --     if self.button_access ~= nil then
        --         self.button_access:Kill()
        --         self.button_access = nil
        --     end
        -- else
        --     if item.isunlockable then
        --         if self.button_access == nil then
        --             self.button_access = self.panel_iteminfo:AddChild(
        --                 ImageButton("images/global_redux.xml", "button_carny_long_normal.tex",
        --                     "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex")
        --             )
        --             self.button_access.image:SetScale(.2, .35)
        --             self.button_access:SetFont(CHATFONT)
        --             self.button_access:SetPosition(50, -212)
        --             self.button_access.text:SetColour(0,0,0,1)
        --             self.button_access:SetTextSize(20)
        --             self.button_access:SetText(STRINGS.SKIN_LEGION.UI_ACCESS)
        --             self.button_access:SetOnClick(function()
        --                 local skin = SKINS_LEGION[item.item_key]
        --                 if skin ~= nil then
        --                     VisitURL("https://wap.fireleaves.cn/#/qrcode?userId="..self.owner.userid
        --                         .."&skinId="..skin.skin_id)
        --                     PushPopupDialog(self, "感谢支持！", "打赏成功了吗？请点击按钮刷新皮肤数据。", "弄好了吧？", function()
        --                         DoRpc(1, nil)
        --                     end)
        --                 end
        --             end)
        --         end
        --     else
        --         if self.button_access ~= nil then
        --             self.button_access:Kill()
        --             self.button_access = nil
        --         end
        --     end
        -- end

        --中部分割线
        if self.horizontal_line2 == nil then
            self.horizontal_line2 = self.panel_iteminfo:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line.tex"))
            self.horizontal_line2:SetScale(.32, .25)
            self.horizontal_line2:SetPosition(-5, -227)
        end

        --皮肤包含项描述
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
