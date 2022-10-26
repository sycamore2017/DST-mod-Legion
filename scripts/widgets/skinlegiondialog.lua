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
local TrueScrollArea = require "widgets/truescrollarea"

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
    self.bg:SetScale(.71, .85)
    self.bg:SetPosition(-50, 0)

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

    local x_btn = -60
    local y_btn = -248

    --关闭弹窗按钮
    self.button_close = self.proot:AddChild(TEMPLATES.SmallButton(STRINGS.UI.PLAYER_AVATAR.CLOSE, 26, .5, function() self:Close() end))
    self.button_close:SetPosition(x_btn, y_btn)

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
    self.button_regetskins:SetPosition(x_btn+110, y_btn-5)

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
    self.items_list = {} --皮肤组，1组5个ui
    self.items = itemsnew

    local start_x = -309
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
        if itemcount%5 == 0 then --一排最多摆5个皮肤
            item_w = nil
            x = start_x
        else
            x = x + 78
        end
    end

    self.option_items = self.proot:AddChild(ScrollableList(self.items_list, 55, 444, 73, 3)) --总高度=(73+1)x展示行数
    self.option_items:SetPosition(6, -1)
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
            self.horizontal_line2 = nil
            self.label_skinaccess = nil
            self.label_skindescitem = nil
            self.horizontal_line3 = nil
            self.scroll_skindesc = nil
            -- self.button_access = nil --获取按钮(tip: 皮肤获取通道删除)
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

        local startpos_x = 168
        local startpos_y = 224
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
            self.label_skinrarity = self.panel_iteminfo:AddChild(Text(HEADERFONT, 21))
            -- self.label_skinrarity:SetHAlign(ANCHOR_LEFT)
            -- self.label_skinrarity:SetRegionSize(180, 20)
            self.label_skinrarity:SetPosition(0, -22)
        end
        self.label_skinrarity:SetString(GetCollection(item.item_key))
        self.label_skinrarity:SetColour(GetColorForItem(item.item_key))

        --标题分割线
        if self.horizontal_line == nil then
            self.horizontal_line = self.panel_iteminfo:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line_break.tex"))
            self.horizontal_line:SetScale(.6, .3)
            self.horizontal_line:SetPosition(0, -38)
        end

        --中部分割线
        if self.horizontal_line2 == nil then
            self.horizontal_line2 = self.panel_iteminfo:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line.tex"))
            self.horizontal_line2:SetScale(.36, .25)
            self.horizontal_line2:SetPosition(0, -180)
        end

        --皮肤获取方式描述
        if self.label_skinaccess == nil then
            self.label_skinaccess = self.panel_iteminfo:AddChild(Text(HEADERFONT, 21))
            self.label_skinaccess:SetHAlign(ANCHOR_LEFT)
            self.label_skinaccess:SetRegionSize(200, 20)
            self.label_skinaccess:SetColour(UICOLOURS.BRONZE)
            self.label_skinaccess:SetPosition(0, -190)
        end
        self.label_skinaccess:SetString(GetAccess(item.item_key))

        --皮肤包含项描述
        if self.label_skindescitem == nil then
            self.label_skindescitem = self.panel_iteminfo:AddChild(Text(CHATFONT, 20))
            self.label_skindescitem:SetPosition(0, -218)
            self.label_skindescitem:SetColour(UICOLOURS.BROWN_DARK)
            self.label_skindescitem:SetHAlign(ANCHOR_LEFT)
            self.label_skindescitem:SetVAlign(ANCHOR_TOP)
            self.label_skindescitem:EnableWordWrap(true)
            self.label_skindescitem:SetRegionSize(200, 40)
        end
        self.label_skindescitem:SetString(GetDescItem(item.item_key))

        --底部分割线
        if self.horizontal_line3 == nil then
            self.horizontal_line3 = self.panel_iteminfo:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line.tex"))
            self.horizontal_line3:SetScale(.36, -.25)
            self.horizontal_line3:SetPosition(0, -236)
        end

        --动画展示区域 undo

        ------

        --皮肤小故事
        if self.scroll_skindesc ~= nil then
            self.scroll_skindesc:Kill()
        end
        self.scroll_skindesc = self.panel_iteminfo:AddChild( self:BuildSkinDesc(GetDescription(item.item_key)) )
        self.scroll_skindesc:SetPosition(-108, -340)

        --获取按钮(tip: 皮肤获取通道删除)
        --[[
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
                            PushPopupDialog(self, "感谢支持！", "打赏成功了吗？请点击按钮刷新皮肤数据。", "弄好了吧？", function()
                                DoRpc(1, nil)
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
        ]]--
    end
end

function SkinLegionDialog:BuildSkinDesc(str)
    local width = 220
    local height = 0
    local max_visible_height = 195
	local padding = 5
    local left = 0

    local w = Widget("skindesc_text")
    w.cell_root = w:AddChild(Text(CHATFONT, 21))
    w.cell_root:SetColour(UICOLOURS.BROWN_DARK)
    w.cell_root:SetHAlign(ANCHOR_LEFT)
    w.cell_root:SetVAlign(ANCHOR_TOP)
    w.cell_root:EnableWordWrap(true)
    w.cell_root:SetMultilineTruncatedString(str, 100, width)

    local x, y = w.cell_root:GetRegionSize()
    w.cell_root:SetPosition(left + 0.5 * x, height - 0.5 * y)
    height = height - y
    height = math.abs(height)

	-- local top = math.min(height, max_visible_height)/2 - padding
    local top = max_visible_height/2 - padding --固定一个高度，这样就能对齐 底部分割线

    local scissor_data = {x = 0, y = -max_visible_height/2, width = width, height = max_visible_height}
	local context = {widget = w, offset = {x = 0, y = top}, size = {w = width, height = height + padding} }
	local scrollbar = { scroll_per_click = 20*3, h_offset = -13 }

    local scroll_area = TrueScrollArea(context, scissor_data, scrollbar)

    scroll_area.up_button:SetTextures("images/ui.xml", "arrow_scrollbar_up.tex")
    -- scroll_area.up_button:SetScale(0.5)
    -- scroll_area.up_button:SetPosition(-13, 96)

	scroll_area.down_button:SetTextures("images/ui.xml", "arrow_scrollbar_down.tex")
    -- scroll_area.down_button:SetScale(0.5)
    -- scroll_area.down_button:SetPosition(-13, -96)

	scroll_area.scroll_bar_line:SetTexture("images/ui.xml", "scrollbarline.tex")
	scroll_area.scroll_bar_line:SetScale(.3)
    -- scroll_area.scroll_bar_line:SetPosition(-13, 0)

    -- scroll_area.scroll_bar:SetTextures("images/ui.xml", "scrollbarbox.tex", "scrollbarbox.tex", "scrollbarbox.tex")
	-- scroll_area.scroll_bar:SetScale(.6)
    -- scroll_area.scroll_bar:SetPosition(-13, 100)

	scroll_area.position_marker:SetTextures("images/ui.xml", "scrollbarbox.tex", "scrollbarbox.tex", "scrollbarbox.tex")
    scroll_area.position_marker:OnGainFocus() --获取焦点，以刷新图片
    -- scroll_area.position_marker:SetScale(.6)
    -- scroll_area.position_marker:SetPosition(-13, 100)

    return scroll_area
end

function SkinLegionDialog:BuildSkinDesc__()
    local function ScrollWidgetsCtor(context, index)
        local w = Widget("skindesc-cell-".. index)

        w.cell_root = w:AddChild(Text(CHATFONT, 21))
        w.cell_root:SetColour(UICOLOURS.BROWN_DARK)
        w.cell_root:SetHAlign(ANCHOR_LEFT)
        w.cell_root:SetVAlign(ANCHOR_TOP)
        w.cell_root:EnableWordWrap(true)
        w.cell_root:SetRegionSize(220, 210)
        w.cell_root:SetPosition(0, -0)

		return w
    end

    local function ScrollWidgetSetData(context, widget, data, index)
		widget.data = data
		if data ~= nil then
			widget.cell_root:Show()
            -- widget.cell_root:SetMultilineTruncatedString(data.str, 10, 220)
            widget.cell_root:SetString(data.str)
			widget:Enable()
		else
			widget:Disable()
			widget.cell_root:Hide()
		end
    end

    local grid = TEMPLATES2.ScrollingGrid(
        {},
        {
            context = {},
            widget_width  = 220,
            widget_height = 200,
			force_peek    = true,
            num_visible_rows = 1,
            num_columns      = 1,
            item_ctor_fn = ScrollWidgetsCtor,
            apply_fn     = ScrollWidgetSetData,
            scrollbar_offset = 20,
            scrollbar_height_offset = -60
        }
    )

	

    return grid
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
    if self.panel_iteminfo ~= nil then
        self.panel_iteminfo:Kill()
    end
	self:Kill()
end

return SkinLegionDialog
