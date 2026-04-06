--[[
  ╔══════════════════════════════════════════════════════════════════════╗
  ║   SL SIDEBAR PREMIUM — PC EDITION  v5.0  ★ HTML SYNC ★            ║
  ║                                                                      ║
  ║   SYNC 100% ke RobloxStudio_shell.html:                             ║
  ║   • Palette: bg0#1a1a1a bg1#242424 bg2#2d2d2d bg3#363636 bg4#404040║
  ║   • Accent:  #00a2ff / #0075cc                                      ║
  ║   • Text:    #e8e8e8 / #c0c0c0 / #8a8a8a                           ║
  ║   • Border:  #404040 / #505050                                      ║
  ║   • Roblox Red: #e2231a  Green: #4caf50                             ║
  ║   • Menubar: #1c1c1c  Toolbar: #242424                              ║
  ║   • Panel Toolbox: layout + pill cats + scrollbar sync              ║
  ╚══════════════════════════════════════════════════════════════════════╝
]]

local CoreGui   = game:GetService("CoreGui")
local Players   = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenSvc  = game:GetService("TweenService")

-- Bersihkan semua versi lama
for _, nm in ipairs({
    "SL_THEME","SL_THEME_V2","SL_THEME_V3",
    "SL_THEME_V33","SL_THEME_V34","SL_THEME_V35",
    "SL_THEME_V36","SL_THEME_V37","SL_THEME_V38",
    "SL_THEME_V39","SL_THEME_V40","SL_THEME_V50"
}) do
    pcall(function()
        local o = CoreGui:FindFirstChild(nm)
        if o then o:Destroy() end
    end)
end

local root    = Instance.new("Folder")
root.Name     = "SL_THEME_V50"
root.Parent   = CoreGui

local LP        = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui", 20)
local StudioGui = PlayerGui and PlayerGui:WaitForChild("StudioGui", 20)
if not StudioGui then warn("[SL v4.0] StudioGui tidak ditemukan"); return end

-- ══════════════════════════════════════════════
--  PALETTE (v3.9)
-- ══════════════════════════════════════════════
-- ══════════════════════════════════════════════
--  PALETTE — SYNC 100% KE HTML CSS VARS
--  --bg0:#1a1a1a  --bg1:#242424  --bg2:#2d2d2d
--  --bg3:#363636  --bg4:#404040
--  --accent:#00a2ff  --accent2:#0075cc
--  --text0:#e8e8e8  --text1:#c0c0c0  --text2:#8a8a8a
--  --border:#404040  --border2:#505050
--  --roblox-red:#e2231a  --green:#4caf50
-- ══════════════════════════════════════════════
local C = {
    bg0   = Color3.fromRGB( 26,  26,  26),   -- #1a1a1a  body bg
    bg1   = Color3.fromRGB( 36,  36,  36),   -- #242424  toolbar/panel bg
    bg2   = Color3.fromRGB( 45,  45,  45),   -- #2d2d2d  secondary bg
    bg3   = Color3.fromRGB( 54,  54,  54),   -- #363636  input/hover bg
    bg4   = Color3.fromRGB( 64,  64,  64),   -- #404040  active/border
    bg5   = Color3.fromRGB( 80,  80,  80),   -- #505050  border2
    accA  = Color3.fromRGB(  0, 162, 255),   -- #00a2ff  accent
    accB  = Color3.fromRGB(  0, 117, 204),   -- #0075cc  accent2
    accC  = Color3.fromRGB(  0,  80, 160),   -- darker accent (pressed)
    glow  = Color3.fromRGB( 80, 180, 255),   -- glow accent
    txtP  = Color3.fromRGB(232, 232, 232),   -- #e8e8e8  text0 primary
    txtS  = Color3.fromRGB(192, 192, 192),   -- #c0c0c0  text1 secondary
    txtD  = Color3.fromRGB(138, 138, 138),   -- #8a8a8a  text2 dim
    bdr   = Color3.fromRGB( 64,  64,  64),   -- #404040  border
    bdrB  = Color3.fromRGB( 80,  80,  80),   -- #505050  border2
    bdrA  = Color3.fromRGB(  0, 117, 204),   -- accent border
    selBg = Color3.fromRGB(  0,  75, 150),   -- selection bg
    tbBg  = Color3.fromRGB( 28,  28,  28),   -- #1c1c1c  menubar bg
    panBg = Color3.fromRGB( 36,  36,  36),   -- #242424  panel bg
    red   = Color3.fromRGB(226,  35,  26),   -- #e2231a  roblox red
    green = Color3.fromRGB( 76, 175,  80),   -- #4caf50  green play
}

local PFX = "SLv50_"
local function isOwn(o)
    return type(o.Name)=="string" and o.Name:sub(1,#PFX)==PFX
end

-- ══════════════════════════════════════════════
--  UI HELPERS
-- ══════════════════════════════════════════════
local function corner(p, r)
    local u = Instance.new("UICorner")
    u.CornerRadius = UDim.new(0, r or 8)
    u.Parent = p; return u
end
local function stroke(p, col, thick, trans)
    local s = p:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
    s.Color=col or C.bdrB; s.Thickness=thick or 1
    s.Transparency=trans or 0; s.Parent=p; return s
end
local function gradient(p, c0, c1, rot)
    local g = p:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    g.Color=ColorSequence.new(c0,c1); g.Rotation=rot or 90; g.Parent=p; return g
end
local function tw(obj, info, props)
    pcall(function() TweenSvc:Create(obj,info,props):Play() end)
end
local FAST = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function lum(c)    return c.R*0.299+c.G*0.587+c.B*0.114 end
local function isBlue(c) return c.B>0.25 and c.B>c.R+0.07 and c.B>c.G+0.07 end
local function isPlay(o)
    local n=o.Name:lower()
    return n=="play" or n=="playbtn" or n=="playbutton"
        or (n:sub(1,4)=="play" and #n<=12)
end

-- ══════════════════════════════════════════════
--  THEME ENGINE (v3.9 — threshold 0.62)
-- ══════════════════════════════════════════════
local lockedText = {}

local function themeObj(obj)
    if isOwn(obj) then return end
    pcall(function()

        if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
            if obj.BackgroundTransparency >= 0.62 then return end
            local c=obj.BackgroundColor3; local b=lum(c)
            if isBlue(c) and b>0.10 then obj.BackgroundColor3=C.selBg; return end
            if     b>0.82 then obj.BackgroundColor3=C.bg0   -- putih → bg0 #1a1a1a
            elseif b>0.60 then obj.BackgroundColor3=C.bg1   -- abu terang → bg1 #242424
            elseif b>0.38 then obj.BackgroundColor3=C.bg2   -- abu sedang → bg2 #2d2d2d
            elseif b>0.20 then obj.BackgroundColor3=C.bg3   -- abu gelap → bg3 #363636
            else                obj.BackgroundColor3=C.bg4  -- paling gelap → bg4 #404040
            end
            if obj:IsA("ScrollingFrame") then
                obj.ScrollBarThickness=3
                obj.ScrollBarImageColor3=C.accB
            end
            return
        end

        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            -- Jangan beri background pada tombol "Select Multi" dan sejenisnya
            local nm = obj.Name:lower()
            local isMultiSelect = nm:find("selectmulti") or nm:find("select_multi")
                or nm:find("multi") or nm:find("selectchildren")
                or (nm:find("select") and nm:find("multi"))
            if not isMultiSelect then
                local t=obj.BackgroundTransparency
                if t<0.62 then
                    local b=lum(obj.BackgroundColor3)
                    if b>0.18 and not isBlue(obj.BackgroundColor3) then
                        obj.BackgroundColor3=C.bg3
                        obj.BackgroundTransparency=0.38
                    end
                end
            else
                -- Select Multi: paksa transparent, tanpa background
                pcall(function()
                    obj.BackgroundTransparency=1
                end)
            end
            pcall(function() obj.Active=true end)
            pcall(function() obj.AutoButtonColor=false end)
        end

        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            local target=isPlay(obj) and C.red or C.txtP
            obj.TextColor3=target
            if not lockedText[obj] then
                lockedText[obj]=true
                obj:GetPropertyChangedSignal("TextColor3"):Connect(function()
                    pcall(function()
                        if obj.TextColor3~=target then obj.TextColor3=target end
                    end)
                end)
            end
        end

        -- Image: JANGAN ubah ImageColor3, pastikan visible
        if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            pcall(function()
                if obj.ImageTransparency>0.05 then obj.ImageTransparency=0 end
                if obj.BackgroundTransparency<0.85 then
                    if lum(obj.BackgroundColor3)>0.15 then
                        obj.BackgroundColor3=C.bg3
                    end
                end
            end)
        end
    end)
end

local function themeAll()
    for _,obj in ipairs(StudioGui:GetDescendants()) do pcall(themeObj,obj) end
end
local function startThemeWatcher()
    StudioGui.DescendantAdded:Connect(function(obj)
        task.defer(function() pcall(themeObj,obj) end)
    end)
end

-- ══════════════════════════════════════════════
--  SNAP POPUP THEMING v1.0
--  Deteksi popup angka snap bawaan Studio Lite
--  (muncul di dekat tombol Move/Rotate/Scale saat hover)
--  Popup biasanya: Frame kecil (<120x80) berisi TextLabel angka + TextLabel label
--  Kita theme total: dark bg, border biru, rounded, font premium
-- ══════════════════════════════════════════════
local themedPopups = {}

local function isSnapPopup(obj)
    -- Popup snap: Frame kecil dekat toolbar, bukan milik kita
    if isOwn(obj) then return false end
    if not (obj:IsA("Frame") or obj:IsA("ScreenGui")) then return false end
    local w = obj.AbsoluteSize.X; local h = obj.AbsoluteSize.Y
    -- Ukuran kecil (popup snap ~40-130px lebar, ~40-90px tinggi)
    if w < 20 or w > 160 or h < 20 or h > 100 then return false end
    -- Posisi dekat toolbar (Y < 25% layar)
    local scrH = StudioGui.AbsoluteSize.Y
    if obj.AbsolutePosition.Y > scrH * 0.30 then return false end
    -- Harus punya anak TextLabel berisi angka
    local hasNum = false
    for _, ch in ipairs(obj:GetDescendants()) do
        if ch:IsA("TextLabel") or ch:IsA("TextBox") then
            local t = ch.Text or ""
            if t:match("^%s*%-?%d+%.?%d*%s*$") then hasNum = true; break end
        end
    end
    return hasNum
end

local function styleSnapPopup(obj)
    if themedPopups[obj] then return end
    themedPopups[obj] = true

    pcall(function()
        -- Background gelap premium
        obj.BackgroundColor3     = C.bg2
        obj.BackgroundTransparency = 0
        obj.BorderSizePixel      = 0

        -- Corner radius
        local uc = obj:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
        uc.CornerRadius = UDim.new(0, 6)
        uc.Parent = obj

        -- Border accent biru
        local us = obj:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
        us.Color       = C.accB
        us.Thickness   = 1
        us.Transparency = 0.35
        us.Parent = obj

        -- Theme semua descendant
        for _, ch in ipairs(obj:GetDescendants()) do
            pcall(function()
                if isOwn(ch) then return end

                if ch:IsA("Frame") then
                    ch.BackgroundColor3     = C.bg2
                    ch.BackgroundTransparency = 0
                    ch.BorderSizePixel      = 0
                end

                if ch:IsA("TextLabel") or ch:IsA("TextBox") then
                    local t = ch.Text or ""
                    local isNum = t:match("^%s*%-?%d+%.?%d*%s*$")
                    ch.BackgroundColor3       = C.bg3
                    ch.BackgroundTransparency = isNum and 0 or 1
                    ch.BorderSizePixel        = 0
                    ch.TextColor3             = isNum and C.accA or C.txtS
                    ch.Font                   = isNum and Enum.Font.GothamBold or Enum.Font.Gotham
                    ch.TextSize               = isNum and 11 or 9
                    ch.TextXAlignment         = Enum.TextXAlignment.Center

                    if isNum then
                        -- Box angka: corner + micro border
                        local uc2 = ch:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
                        uc2.CornerRadius = UDim.new(0, 4); uc2.Parent = ch
                        local us2 = ch:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
                        us2.Color = C.accB; us2.Thickness = 1; us2.Transparency = 0.5; us2.Parent = ch
                    end
                end
            end)
        end

        -- Watcher: kalau Studio Lite reset bg popup ini → kita paksa dark lagi
        obj:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
            task.defer(function()
                pcall(function()
                    if not isOwn(obj) then
                        obj.BackgroundColor3     = C.bg2
                        obj.BackgroundTransparency = 0
                    end
                end)
            end)
        end)
    end)
end

local function scanAndStylePopups()
    for _, obj in ipairs(StudioGui:GetDescendants()) do
        if isSnapPopup(obj) then
            pcall(styleSnapPopup, obj)
        end
    end
end

local function startSnapPopupWatcher()
    -- Scan semua yang sudah ada
    pcall(scanAndStylePopups)
    -- Watch descendant baru — popup biasanya muncul saat hover
    StudioGui.DescendantAdded:Connect(function(obj)
        task.defer(function()
            -- Cek obj itu sendiri
            if isSnapPopup(obj) then pcall(styleSnapPopup, obj); return end
            -- Cek parent (mungkin child masuk lebih dulu)
            local p = obj.Parent
            if p and isSnapPopup(p) then pcall(styleSnapPopup, p) end
        end)
    end)
end

-- ══════════════════════════════════════════════
--  SCROLLBAR
-- ══════════════════════════════════════════════
local function styleScrollbars()
    for _,obj in ipairs(StudioGui:GetDescendants()) do
        if obj:IsA("ScrollingFrame") and not isOwn(obj) then
            pcall(function()
                obj.ScrollBarThickness=3
                obj.ScrollBarImageColor3=C.accB
            end)
        end
    end
end

-- ══════════════════════════════════════════════
--  HOVER EFFECT (v3.9 tween)
-- ══════════════════════════════════════════════
local hovered = {}
local function applyHover(obj)
    if hovered[obj] then return end
    if isOwn(obj) then return end
    if not (obj:IsA("TextButton") or obj:IsA("ImageButton")) then return end
    -- Jangan terapkan hover pada tombol Select Multi
    local nm = obj.Name:lower()
    if nm:find("selectmulti") or nm:find("select_multi")
       or (nm:find("select") and nm:find("multi")) then return end
    local function setup()
        local sz=obj.AbsoluteSize
        if sz.X>240 or sz.Y>90 then return end
        hovered[obj]=true
        pcall(function() obj.Active=true end)
        pcall(function() obj.AutoButtonColor=false end)
        obj.MouseEnter:Connect(function()
            pcall(function()
                tw(obj,FAST,{BackgroundTransparency=0.84,BackgroundColor3=C.bg4})
                local s=obj:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
                s.Color=C.bdrB; s.Thickness=1; s.Transparency=0.3; s.Parent=obj
            end)
        end)
        obj.MouseLeave:Connect(function()
            pcall(function()
                tw(obj,FAST,{BackgroundTransparency=1})
                local s=obj:FindFirstChildOfClass("UIStroke")
                if s then s:Destroy() end
            end)
        end)
    end
    if obj.AbsoluteSize.X>0 then setup()
    else
        local conn
        conn=obj:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            conn:Disconnect(); setup()
        end)
    end
end
local function applyHoverAll()
    for _,obj in ipairs(StudioGui:GetDescendants()) do pcall(applyHover,obj) end
end

-- ══════════════════════════════════════════════
--  PANEL DECORATION (v3.9)
-- ══════════════════════════════════════════════
local decorated = {}
local function addAccent(frame, side, name)
    if frame:FindFirstChild(name) then return end
    local bar=Instance.new("Frame"); bar.Name=name
    bar.Size=(side=="left") and UDim2.new(0,2,1,0) or UDim2.new(0,2,1,0)
    bar.Position=(side=="left") and UDim2.new(0,0,0,0) or UDim2.new(1,-2,0,0)
    bar.BackgroundColor3=C.accB; bar.BorderSizePixel=0
    bar.BackgroundTransparency=0.25
    bar.ZIndex=(frame.ZIndex or 1)+15; bar.Parent=frame
    gradient(bar,Color3.fromRGB(40,100,230),Color3.fromRGB(20,55,140),180)
    corner(bar,2)
end
local function addTBDiv(tb)
    if tb:FindFirstChild(PFX.."TBDiv") then return end
    local d=Instance.new("Frame"); d.Name=PFX.."TBDiv"
    d.Size=UDim2.new(1,0,0,1); d.Position=UDim2.new(0,0,1,0)
    d.BackgroundColor3=C.bdrB; d.BorderSizePixel=0
    d.BackgroundTransparency=0.55
    d.ZIndex=(tb.ZIndex or 1)+8; d.Parent=tb
end
local function addHLine(frame)
    if frame:FindFirstChild(PFX.."HLine") then return end
    local l=Instance.new("Frame"); l.Name=PFX.."HLine"
    l.Size=UDim2.new(1,0,0,1); l.Position=UDim2.new(0,0,1,-1)
    l.BackgroundColor3=C.bdrB; l.BorderSizePixel=0
    l.BackgroundTransparency=0.4
    l.ZIndex=(frame.ZIndex or 1)+5; l.Parent=frame
end
local function decoratePanels()
    local scrH=StudioGui.AbsoluteSize.Y; local scrW=StudioGui.AbsoluteSize.X
    for _,obj in ipairs(StudioGui:GetDescendants()) do
        if isOwn(obj) then continue end
        if decorated[obj] then continue end
        if not (obj:IsA("Frame") or obj:IsA("ScrollingFrame")) then continue end
        pcall(function()
            local n=obj.Name:lower()
            local absH=obj.AbsoluteSize.Y; local absW=obj.AbsoluteSize.X
            if n:find("toolbar") or n:find("topbar") then
                obj.BackgroundColor3=C.tbBg; addTBDiv(obj); decorated[obj]=true  -- #1c1c1c menubar
            end
            if (n:find("explorer") or n:find("property") or n:find("dockright"))
               and absH>scrH*0.2 and absW<scrW*0.5 then
                obj.BackgroundColor3=C.bg1                                        -- #242424 panel
                addAccent(obj,"left",PFX.."RAccent"); decorated[obj]=true
            end
            if (n:find("sidebar") or n:find("iconbar") or n:find("leftsidebar"))
               and absW<110 and absH>scrH*0.3 then
                obj.BackgroundColor3=C.bg1                                        -- #242424 sidebar
                addAccent(obj,"right",PFX.."LAccent"); decorated[obj]=true
            end
            if n:find("header") or n:find("titlebar") or n:find("paneltop") then
                obj.BackgroundColor3=C.bg0; addHLine(obj); decorated[obj]=true   -- #1a1a1a header
            end
        end)
    end
end

-- ══════════════════════════════════════════════
--  ICON DRAW (v2.0 drawSeg style, warna dari v3.9)
-- ══════════════════════════════════════════════
local function drawSeg(p, x1,y1, x2,y2, T, col, zi)
    local dx,dy=x2-x1,y2-y1
    local len=math.sqrt(dx*dx+dy*dy)
    if len<0.5 then return end
    local f=Instance.new("Frame"); f.Name=PFX.."Ico"
    f.Size=UDim2.new(0,math.ceil(len),0,T)
    f.Position=UDim2.new(0,math.floor((x1+x2)/2-len/2),0,math.floor((y1+y2)/2-T/2))
    f.Rotation=math.deg(math.atan2(dy,dx))
    f.BackgroundColor3=col or C.txtP
    f.BorderSizePixel=0; f.ZIndex=zi or 6; f.Parent=p
    local u=Instance.new("UICorner"); u.CornerRadius=UDim.new(0,1); u.Parent=f
end

local function icoBlock(p,S,T)
    local cx=S/2
    drawSeg(p,cx,3,S-3,S/2-3,T,C.accA,46); drawSeg(p,S-3,S/2-3,cx,S/2+2,T,C.accA,46)
    drawSeg(p,cx,S/2+2,3,S/2-3,T,C.accA,46); drawSeg(p,3,S/2-3,cx,3,T,C.accA,46)
    drawSeg(p,3,S/2-3,3,S-5,T,C.txtS,46); drawSeg(p,3,S-5,cx,S-2,T,C.txtS,46)
    drawSeg(p,cx,S-2,cx,S/2+2,T,C.txtS,46); drawSeg(p,S-3,S/2-3,S-3,S-5,T,C.txtS,46)
    drawSeg(p,S-3,S-5,cx,S-2,T,C.txtS,46)
end
local function icoBall(p,S,T)
    local cx,cy,r=S/2,S/2,S/2-3
    for i=0,13 do
        local a1=(i/14)*math.pi*2; local a2=((i+1)/14)*math.pi*2
        drawSeg(p,cx+math.cos(a1)*r,cy+math.sin(a1)*r,cx+math.cos(a2)*r,cy+math.sin(a2)*r,T,C.accA,46)
    end
    for i=0,9 do
        local a1=(i/10)*math.pi*2; local a2=((i+1)/10)*math.pi*2
        drawSeg(p,cx+math.cos(a1)*r,cy+math.sin(a1)*(r*0.3),cx+math.cos(a2)*r,cy+math.sin(a2)*(r*0.3),T,C.txtS,46)
    end
end
local function icoCylinder(p,S,T)
    local cx,ry,rx,ty,by=S/2,S*0.14,S/2-3,4,S-4
    for i=0,11 do
        local a1=(i/12)*math.pi*2; local a2=((i+1)/12)*math.pi*2
        drawSeg(p,cx+math.cos(a1)*rx,ty+math.sin(a1)*ry,cx+math.cos(a2)*rx,ty+math.sin(a2)*ry,T,C.accA,46)
        drawSeg(p,cx+math.cos(a1)*rx,by+math.sin(a1)*ry,cx+math.cos(a2)*rx,by+math.sin(a2)*ry,T,C.txtS,46)
    end
    drawSeg(p,cx-rx,ty,cx-rx,by,T,C.txtS,46); drawSeg(p,cx+rx,ty,cx+rx,by,T,C.txtS,46)
end
local function icoWedge(p,S,T)
    drawSeg(p,3,S-3,S-3,S-3,T,C.accA,46); drawSeg(p,3,S-3,S/2,3,T,C.accA,46)
    drawSeg(p,S-3,S-3,S/2,3,T,C.txtS,46)
end
local function icoCorner(p,S,T)
    drawSeg(p,3,S-3,S-3,S-3,T,C.accA,46); drawSeg(p,3,S-3,3,3,T,C.accA,46)
    drawSeg(p,3,3,S-3,S-3,T,C.txtS,46); drawSeg(p,3,3,S-3,3,T,C.txtS,46)
    drawSeg(p,S-3,3,S-3,S-3,T,C.txtS,46)
end
local function icoTerrain(p,S,T)
    local sc=S/24
    local pts={{3,20},{9,8},{13,16},{16,11},{21,20},{3,20}}
    for i=1,#pts-1 do
        drawSeg(p,pts[i][1]*sc,pts[i][2]*sc,pts[i+1][1]*sc,pts[i+1][2]*sc,T,C.accA,46)
    end
    drawSeg(p,2,S-4,S-2,S-4,T,C.txtS,45)
end

-- ══════════════════════════════════════════════
--  TOOLBAR HELPERS
-- ══════════════════════════════════════════════
local cachedTB = nil
local function findToolbar()
    if cachedTB and cachedTB.Parent then return cachedTB end
    -- Prioritas 1: cari MainBar langsung (nama persis dari GuiCopy)
    local mb = StudioGui:FindFirstChild("MainBar")
    if mb and mb:IsA("Frame") and mb.AbsoluteSize.X > 150 then
        cachedTB = mb; return mb
    end
    -- Prioritas 2: scan button bawaan yang namanya persis (dari GuiCopy)
    for _, nm in ipairs({"select","move","scale","rotate","play","toolbox"}) do
        local btn = StudioGui:FindFirstChild(nm, true)
        if btn and btn.Parent and btn.Parent:IsA("Frame")
           and btn.Parent.AbsoluteSize.X > 150 then
            cachedTB = btn.Parent; return btn.Parent
        end
    end
    -- Prioritas 3: fallback scan lama
    for _,obj in ipairs(StudioGui:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            local n=obj.Name:lower()
            if n:find("play") or n:find("select") or n:find("pilih") or n:find("toolbox") then
                local p=obj.Parent
                if p and (p:IsA("Frame") or p:IsA("ScrollingFrame"))
                   and p.AbsoluteSize.X>150 then
                    cachedTB=p; return p
                end
            end
        end
    end
    return nil
end
local function getMaxX(tb)
    local mx=0
    for _,ch in ipairs(tb:GetChildren()) do
        if ch:IsA("GuiObject")
           and not ch:IsA("UIListLayout") and not ch:IsA("UICorner")
           and not ch:IsA("UIStroke")     and not ch:IsA("UIGradient") then
            pcall(function()
                local x=(ch.AbsolutePosition.X-tb.AbsolutePosition.X)+ch.AbsoluteSize.X
                if x>mx then mx=x end
            end)
        end
    end
    return mx
end
local function makeSep(tb, posX)
    local H=tb.AbsoluteSize.Y
    local sep=Instance.new("Frame"); sep.Name=PFX.."Sep"
    sep.Size=UDim2.new(0,1,0,math.floor(H*0.5))
    sep.Position=UDim2.new(0,posX+4,0,math.floor(H*0.25))
    sep.BackgroundColor3=C.bdrB; sep.BackgroundTransparency=0.4
    sep.BorderSizePixel=0; sep.ZIndex=5; sep.Parent=tb
end

-- ══════════════════════════════════════════════
--  INJECT BUTTONS (arsitektur v2.0 — cont/iconF/lbl/btn)
--  Hover: langsung set properti (bukan tween) seperti v2.0
--  ZERO selection manipulation
-- ══════════════════════════════════════════════
local function makePartBtn(tb, posX, label, icoFn, onClick)
    local H=tb.AbsoluteSize.Y
    local S=22; local T=2; local W=44
    local btnH=math.min(H-6,42)
    local padY=math.max(3,math.floor((btnH-S-14)/2))

    local cont=Instance.new("Frame"); cont.Name=PFX.."Btn_"..label
    cont.Size=UDim2.new(0,W,0,btnH)
    cont.Position=UDim2.new(0,posX,0,math.floor((H-btnH)/2))
    cont.BackgroundTransparency=1; cont.BorderSizePixel=0
    cont.ClipsDescendants=false; cont.ZIndex=5; cont.Active=true
    cont.Parent=tb; corner(cont,8)

    local icoF=Instance.new("Frame"); icoF.Name=PFX.."IcoF_"..label
    icoF.Size=UDim2.new(0,S,0,S)
    icoF.Position=UDim2.new(0,W/2-S/2,0,padY)
    icoF.BackgroundTransparency=1; icoF.ClipsDescendants=false
    icoF.ZIndex=6; icoF.Parent=cont
    pcall(icoFn,icoF,S,T)

    local lbl=Instance.new("TextLabel"); lbl.Name=PFX.."Lbl_"..label
    lbl.Size=UDim2.new(0,W,0,10)
    lbl.Position=UDim2.new(0,0,0,padY+S+2)
    lbl.BackgroundTransparency=1; lbl.Text=label:upper()
    lbl.TextColor3=C.txtD; lbl.TextSize=7
    lbl.Font=Enum.Font.GothamBold
    lbl.TextXAlignment=Enum.TextXAlignment.Center
    lbl.ZIndex=6; lbl.Parent=cont

    local btn=Instance.new("TextButton"); btn.Name=PFX.."Click_"..label
    btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1
    btn.Text=""; btn.ZIndex=7; btn.Active=true
    btn.AutoButtonColor=false; btn.Parent=cont

    -- Hover (v2.0 style — langsung set, tidak tween)
    btn.MouseEnter:Connect(function()
        pcall(function()
            cont.BackgroundColor3=C.bg4; cont.BackgroundTransparency=0
            stroke(cont,C.bdrB,1,0); lbl.TextColor3=C.txtS
        end)
    end)
    btn.MouseLeave:Connect(function()
        pcall(function()
            cont.BackgroundTransparency=1; lbl.TextColor3=C.txtD
            local s=cont:FindFirstChildOfClass("UIStroke")
            if s then s.Thickness=0 end
        end)
    end)
    btn.MouseButton1Down:Connect(function()
        pcall(function()
            cont.BackgroundColor3=C.accC; cont.BackgroundTransparency=0
        end)
    end)
    btn.MouseButton1Up:Connect(function()
        pcall(function()
            cont.BackgroundColor3=C.bg4; cont.BackgroundTransparency=0
        end)
    end)
    btn.MouseButton1Click:Connect(function()
        pcall(onClick)
    end)

    return cont, W
end

-- ══════════════════════════════════════════════
--  INSERT PART — logika v2.0 (ZERO selection touch)
-- ══════════════════════════════════════════════
local function insertPart(partType)
    pcall(function()
        local cam=Workspace.CurrentCamera
        local spawnCF=CFrame.new(0,5,0)
        if cam then
            local cf=cam.CFrame
            local fwd=Vector3.new(cf.LookVector.X,0,cf.LookVector.Z)
            if fwd.Magnitude>0.01 then fwd=fwd.Unit else fwd=Vector3.new(0,0,-1) end
            local pos=cf.Position+fwd*18
            spawnCF=CFrame.new(pos.X,math.max(pos.Y,3),pos.Z)
        end
        local part
        if     partType=="Block"       then part=Instance.new("Part");           part.Shape=Enum.PartType.Block
        elseif partType=="Ball"        then part=Instance.new("Part");           part.Shape=Enum.PartType.Ball
        elseif partType=="Cylinder"    then part=Instance.new("Part");           part.Shape=Enum.PartType.Cylinder
        elseif partType=="Wedge"       then part=Instance.new("WedgePart")
        elseif partType=="CornerWedge" then part=Instance.new("CornerWedgePart")
        else                                part=Instance.new("Part") end
        part.Size=Vector3.new(4,1.2,2); part.CFrame=spawnCF
        part.Anchored=true; part.Material=Enum.Material.SmoothPlastic
        part.Color=Color3.fromRGB(163,162,165); part.Parent=Workspace
        -- ✅ TIDAK ada sel:Set() — Selection service tidak disentuh

    end)
end

-- ══════════════════════════════════════════════
--  INJECT PART BUTTONS (arsitektur v2.0)
-- ══════════════════════════════════════════════
local partDone = false
local PARTS = {
    {name="Balok",    ico=icoBlock,    type="Block"},
    {name="Bola",     ico=icoBall,     type="Ball"},
    {name="Silinder", ico=icoCylinder, type="Cylinder"},
    {name="Wedge",    ico=icoWedge,    type="Wedge"},
    {name="Corner",   ico=icoCorner,   type="CornerWedge"},
}
local function injectParts()
    if partDone then return end
    local tb=findToolbar(); if not tb then return end
    if tb:FindFirstChild(PFX.."Btn_Balok") then partDone=true; return end
    for _,ch in ipairs(tb:GetChildren()) do
        local n=ch.Name:lower()
        if n:find("part") or n:find("insert") then
            pcall(function()
                ch.Visible=false
                for _,d in ipairs(ch:GetDescendants()) do
                    if d:IsA("GuiObject") then d.Visible=false end
                end
            end)
        end
    end
    local GAP=3; local curX=getMaxX(tb)+16; makeSep(tb,curX-12)
    for _,def in ipairs(PARTS) do
        local _,W=makePartBtn(tb,curX,def.name,def.ico,function() insertPart(def.type) end)
        curX=curX+W+GAP
    end
    partDone=true
end

-- ══════════════════════════════════════════════
--  ICON NATIVE TOOLBAR — drawSeg, sync HTML SVG
--  Semua fungsi ini dideklarasi SETELAH drawSeg
--  tersedia dan SETELAH findToolbar/isOwn tersedia
-- ══════════════════════════════════════════════
local function icoNatSelect(p,S,T)
    -- cursor arrow: outline + diagonal fill line
    drawSeg(p,S*.20,S*.10,S*.80,S*.50,T,C.accA,46)
    drawSeg(p,S*.80,S*.50,S*.50,S*.55,T,C.accA,46)
    drawSeg(p,S*.50,S*.55,S*.38,S*.88,T,C.accA,46)
    drawSeg(p,S*.38,S*.88,S*.20,S*.10,T,C.accA,46)
    drawSeg(p,S*.20,S*.10,S*.50,S*.55,T,C.glow,47)
end
local function icoNatMove(p,S,T)
    local cx,cy=S/2,S/2
    -- horizontal + vertical cross
    drawSeg(p,4,cy,S-4,cy,T,C.accA,46)
    drawSeg(p,cx,4,cx,S-4,T,C.accA,46)
    -- arrowheads L R U D
    drawSeg(p,4,cy,8,cy-3,T,C.txtS,46); drawSeg(p,4,cy,8,cy+3,T,C.txtS,46)
    drawSeg(p,S-4,cy,S-8,cy-3,T,C.txtS,46); drawSeg(p,S-4,cy,S-8,cy+3,T,C.txtS,46)
    drawSeg(p,cx,4,cx-3,8,T,C.txtS,46); drawSeg(p,cx,4,cx+3,8,T,C.txtS,46)
    drawSeg(p,cx,S-4,cx-3,S-8,T,C.txtS,46); drawSeg(p,cx,S-4,cx+3,S-8,T,C.txtS,46)
end
local function icoNatScale(p,S,T)
    -- outer square
    drawSeg(p,3,3,S-3,3,T,C.accA,46); drawSeg(p,S-3,3,S-3,S-3,T,C.accA,46)
    drawSeg(p,S-3,S-3,3,S-3,T,C.accA,46); drawSeg(p,3,S-3,3,3,T,C.accA,46)
    -- inner square
    local m=S*.32
    drawSeg(p,m,m,S-m,m,T,C.txtS,46); drawSeg(p,S-m,m,S-m,S-m,T,C.txtS,46)
    drawSeg(p,S-m,S-m,m,S-m,T,C.txtS,46); drawSeg(p,m,S-m,m,m,T,C.txtS,46)
    -- corner handles (glow dots)
    drawSeg(p,2,2,4,2,T+1,C.glow,47); drawSeg(p,S-2,2,S-4,2,T+1,C.glow,47)
    drawSeg(p,2,S-2,4,S-2,T+1,C.glow,47); drawSeg(p,S-2,S-2,S-4,S-2,T+1,C.glow,47)
end
local function icoNatRotate(p,S,T)
    local cx,cy,r=S/2,S/2,S/2-3
    -- arc ~11/12 lingkaran
    for i=0,10 do
        local a1=(i/12)*math.pi*2; local a2=((i+1)/12)*math.pi*2
        drawSeg(p,cx+math.cos(a1)*r,cy+math.sin(a1)*r,
                  cx+math.cos(a2)*r,cy+math.sin(a2)*r,T,C.accA,46)
    end
    -- arrowhead di ujung arc
    local ae=(11/12)*math.pi*2
    local ax=cx+math.cos(ae)*r; local ay=cy+math.sin(ae)*r
    drawSeg(p,ax,ay,ax-4,ay-3,T,C.glow,47)
    drawSeg(p,ax,ay,ax+2,ay-5,T,C.glow,47)
end
local function icoNatPlay(p,S,T)
    -- segitiga solid hijau (HTML #4caf50)
    drawSeg(p,S*.18,S*.10,S*.82,S*.50,T,C.green,46)
    drawSeg(p,S*.82,S*.50,S*.18,S*.90,T,C.green,46)
    drawSeg(p,S*.18,S*.90,S*.18,S*.10,T,C.green,46)
    -- fill horizontal scanlines
    for i=1,7 do
        local t=i/8
        local yl=S*.10+S*.80*t
        local xr=S*.18+S*.64*(1-t)
        drawSeg(p,S*.18,yl,xr,yl,T-1,C.green,45)
    end
end

-- Icon Toolbox custom: kotak terbuka (toolbox) + gagang + plus aksen
local function icoNatToolbox(p,S,T)
    -- Badan kotak (U-shape): kiri, bawah, kanan
    local bx0,bx1 = S*.12, S*.88
    local by0,by1 = S*.38, S*.88
    drawSeg(p, bx0,by0, bx0,by1, T, C.accA, 46)
    drawSeg(p, bx0,by1, bx1,by1, T, C.accA, 46)
    drawSeg(p, bx1,by1, bx1,by0, T, C.accA, 46)
    -- Tutup (lid) sedikit lebih lebar
    local lx0,lx1 = S*.08, S*.92
    local ly0,ly1 = S*.18, S*.40
    drawSeg(p, lx0,ly1, lx0,ly0, T, C.accA, 46)
    drawSeg(p, lx0,ly0, lx1,ly0, T, C.accA, 46)
    drawSeg(p, lx1,ly0, lx1,ly1, T, C.accA, 46)
    drawSeg(p, lx0,ly1, lx1,ly1, T, C.bdrB, 46)
    -- Gagang di atas tutup (glow)
    local hx0,hx1 = S*.35, S*.65
    drawSeg(p, hx0,ly1, hx0,ly0-S*.06, T, C.glow, 47)
    drawSeg(p, hx0,ly0-S*.06, hx1,ly0-S*.06, T, C.glow, 47)
    drawSeg(p, hx1,ly0-S*.06, hx1,ly1, T, C.glow, 47)
    -- Plus kecil di badan (aksen)
    local cx,cy,ar = S*.50, S*.64, S*.10
    drawSeg(p, cx-ar,cy, cx+ar,cy, T-1, C.glow, 48)
    drawSeg(p, cx,cy-ar, cx,cy+ar, T-1, C.glow, 48)
end

-- ══════════════════════════════════════════════
--  INJECT NATIVE REPLACE v3 — FULL TAKEOVER
--  Pakai nama PERSIS dari GuiCopy.txt:
--  MainBar > select / move / scale / rotate / play / toolbox
--  Semua visual asli di-blackout total, diganti icon kita
-- ══════════════════════════════════════════════
local NATIVE_MAP = {
    {name="select",  ico=icoNatSelect,  label="Select"},
    {name="move",    ico=icoNatMove,    label="Move"},
    {name="scale",   ico=icoNatScale,   label="Scale"},
    {name="rotate",  ico=icoNatRotate,  label="Rotate"},
    {name="play",    ico=icoNatPlay,    label="Play"},
    {name="toolbox", ico=icoNatToolbox, label="Toolbox"},
}

-- ══════════════════════════════════════════════
--  FULL TAKEOVER satu tombol bawaan Studio Lite
--  Dipanggil per-btn: bisa retry kapan saja (idempoten)
-- ══════════════════════════════════════════════
local function takeoverBtn(btn, def)
    if not btn or not btn.Parent then return end
    local ovName  = PFX.."OvIco_"..def.label
    local blkName = PFX.."OvBlk_"..def.label

    -- ── ① BLACKOUT semua visual asli (SETIAP descendant) ──────────────────
    -- Gunakan watcher persistent agar setiap perubahan dari Studio Lite
    -- langsung dibatalkan oleh kita
    local function blackoutDesc(d)
        if isOwn(d) then return end
        pcall(function()
            if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                d.ImageTransparency    = 1
                d.BackgroundTransparency = 1
            end
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                d.TextTransparency     = 1
                d.BackgroundTransparency = 1
            end
            if d:IsA("Frame") or d:IsA("ScrollingFrame") then
                d.BackgroundTransparency = 1
            end
        end)
    end
    for _, d in ipairs(btn:GetDescendants()) do blackoutDesc(d) end
    -- Blackout tombol itu sendiri (background-nya)
    pcall(function()
        btn.BackgroundTransparency = 1
        if btn:IsA("TextButton") or btn:IsA("TextLabel") then
            btn.TextTransparency = 1
        end
        if btn:IsA("ImageButton") or btn:IsA("ImageLabel") then
            btn.ImageTransparency = 1
        end
    end)
    -- Watcher: kalau Studio Lite restore visual asli → kita blackout lagi
    btn.DescendantAdded:Connect(function(d)
        task.defer(function() blackoutDesc(d) end)
    end)
    -- Watcher: kalau property berubah (mis. BackgroundTransparency di-reset)
    -- pasang listener di semua descendant yang ada sekarang
    for _, d in ipairs(btn:GetDescendants()) do
        if not isOwn(d) then
            pcall(function()
                if d:IsA("GuiObject") then
                    d:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
                        task.defer(function()
                            pcall(function()
                                if not isOwn(d) then
                                    d.BackgroundTransparency = 1
                                end
                            end)
                        end)
                    end)
                end
                if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                    d:GetPropertyChangedSignal("ImageTransparency"):Connect(function()
                        task.defer(function()
                            pcall(function()
                                if not isOwn(d) then d.ImageTransparency = 1 end
                            end)
                        end)
                    end)
                end
            end)
        end
    end

    -- ── ② BLOCKER FRAME — lapisan solid warna bg1 ukuran penuh ───────────
    --    Ini safety net: kalau ada visual asli yang lolos blackout,
    --    tertutup oleh blocker warna bg sebelum icon kita
    if not btn:FindFirstChild(blkName) then
        local H = btn.AbsoluteSize.Y; if H < 6 then H = 50 end
        local W = btn.AbsoluteSize.X; if W < 6 then W = 35 end
        local blk = Instance.new("Frame")
        blk.Name                 = blkName
        blk.Size                 = UDim2.new(1, 0, 1, 0)
        blk.Position             = UDim2.new(0, 0, 0, 0)
        blk.BackgroundColor3     = C.bg1          -- #242424 — sama dengan toolbar
        blk.BackgroundTransparency = 0
        blk.BorderSizePixel      = 0
        blk.ZIndex               = (btn.ZIndex or 5) + 2
        blk.Parent               = btn
    end

    -- ── ③ ICON OVERLAY kita ───────────────────────────────────────────────
    if btn:FindFirstChild(ovName) then return end  -- sudah ada, skip

    local H = btn.AbsoluteSize.Y; if H < 6 then H = 50 end
    local S = 20; local T = 2
    local padT = math.floor((H - S - 10) / 2)
    if padT < 2 then padT = 2 end
    local baseZ = (btn.ZIndex or 5) + 3

    local ov = Instance.new("Frame")
    ov.Name                   = ovName
    ov.Size                   = UDim2.new(0, S, 0, S)
    ov.Position               = UDim2.new(0.5, -S/2, 0, padT)
    ov.BackgroundTransparency = 1
    ov.ZIndex                 = baseZ
    ov.Parent                 = btn
    pcall(def.ico, ov, S, T)

    -- ── ④ LABEL OVERLAY ──────────────────────────────────────────────────
    local ovLbl = Instance.new("TextLabel")
    ovLbl.Name              = PFX.."OvLbl_"..def.label
    ovLbl.Size              = UDim2.new(1, 0, 0, 10)
    ovLbl.Position          = UDim2.new(0, 0, 0, padT + S + 2)
    ovLbl.BackgroundTransparency = 1
    ovLbl.Text              = def.label:upper()
    ovLbl.TextColor3        = (def.label == "Play") and C.green or C.txtD
    ovLbl.TextSize          = 7
    ovLbl.Font              = Enum.Font.GothamBold
    ovLbl.TextXAlignment    = Enum.TextXAlignment.Center
    ovLbl.ZIndex            = baseZ + 1
    ovLbl.Parent            = btn
end

-- ══════════════════════════════════════════════
--  INJECT NATIVE REPLACE v3 — FULL TAKEOVER
--  • Tidak pakai done-guard global (idempoten via FindFirstChild)
--  • Tangani tombol yang belum ada saat pertama run
--  • Watcher tb.ChildAdded agar tombol datang terlambat juga ditangkap
-- ══════════════════════════════════════════════
local nativeTBWatched = false  -- pastikan watcher toolbar hanya dipasang sekali

local function injectNativeReplace()
    local tb = findToolbar()
    if not tb then return end

    -- Pasang watcher sekali: kalau ada anak baru di toolbar, cek apakah
    -- itu tombol bawaan yang perlu di-takeover
    if not nativeTBWatched then
        nativeTBWatched = true
        tb.ChildAdded:Connect(function(ch)
            task.defer(function()
                for _, def in ipairs(NATIVE_MAP) do
                    if ch.Name:lower() == def.name then
                        task.wait(0.1)  -- beri sedikit waktu AbsoluteSize tersedia
                        pcall(takeoverBtn, ch, def)
                        break
                    end
                end
            end)
        end)
    end

    -- Proses semua tombol yang sudah ada di toolbar sekarang
    for _, def in ipairs(NATIVE_MAP) do
        local btn = nil
        for _, ch in ipairs(tb:GetChildren()) do
            if ch.Name:lower() == def.name then btn = ch; break end
        end
        -- fallback: cari di seluruh StudioGui
        if not btn then
            local found = StudioGui:FindFirstChild(def.name, true)
            if found and found.Parent == tb then btn = found end
        end
        if btn then
            pcall(takeoverBtn, btn, def)
        end
    end

end

_SL={}
_SL.LP=LP
_SL.PFX=PFX
_SL.PlayerGui=PlayerGui
_SL.TweenSvc=TweenSvc
_SL.Workspace=Workspace
_SL.CoreGui=CoreGui
_SL.Players=Players
_SL.StudioGui=StudioGui
_SL.root=root
_SL.PARTS=PARTS
_SL.corner=corner
_SL.stroke=stroke
_SL.gradient=gradient
_SL.drawSeg=drawSeg
_SL.findToolbar=findToolbar
_SL.getMaxX=getMaxX
_SL.makePartBtn=makePartBtn
_SL.makeSep=makeSep
_SL.icoTerrain=icoTerrain
_SL.applyHover=applyHover
_SL.applyHoverAll=applyHoverAll
_SL.decoratePanels=decoratePanels
_SL.injectParts=injectParts
_SL.insertPart=insertPart
_SL.partDone=partDone
_SL.injectNativeReplace=injectNativeReplace
_SL.startThemeWatcher=startThemeWatcher
_SL.startSnapPopupWatcher=startSnapPopupWatcher
_SL.styleScrollbars=styleScrollbars
_SL.themeAll=themeAll
_SL.themeObj=themeObj
_SL.publishApiKey=""        -- Shared: API key dari Publish Panel → bisa dibaca Voice Panel
_SL.publishUniverseId=""    -- Shared: Universe ID dari Publish Panel → sinkron ke Voice Panel
_SL.publishPlaceId=""       -- Shared: Place ID dari Publish Panel → sinkron ke Voice Panel
local function _sl_block1()
local LP,PFX,PlayerGui,TweenSvc,Workspace,CoreGui,corner,findToolbar,getMaxX,icoTerrain,makePartBtn,makeSep=_SL.LP,_SL.PFX,_SL.PlayerGui,_SL.TweenSvc,_SL.Workspace,_SL.CoreGui,_SL.corner,_SL.findToolbar,_SL.getMaxX,_SL.icoTerrain,_SL.makePartBtn,_SL.makeSep
local mouse=LP:GetMouse()
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
-- ══════════════════════════════════════════════
--  TERRAIN BRUSH PANEL v11 — PANEL BARU
-- ══════════════════════════════════════════════

local Workspace  = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")

local LP    = Players.LocalPlayer
local mouse = LP:GetMouse()

-- Bersihkan instance lama
pcall(function()
    local old = CoreGui:FindFirstChild(PFX.."TerrainGui")
    if old then old:Destroy() end
end)

-- ════════════════════════════════════════════════════════════
--  PANEL CONFIG
-- ════════════════════════════════════════════════════════════
PW          = 300
PH          = 300
local PANEL_X     = 80
local PANEL_Y_OFF = -280

-- ════════════════════════════════════════════════════════════
--  OMEGA COLOR PALETTE
-- ════════════════════════════════════════════════════════════
C_BG0    = Color3.fromRGB(4,6,15)
C_BG1    = Color3.fromRGB(6,9,18)
C_BG2    = Color3.fromRGB(8,12,24)
C_BG3    = Color3.fromRGB(12,17,32)
C_BG4    = Color3.fromRGB(16,21,40)
C_BG5    = Color3.fromRGB(20,26,48)
C_BORDER = Color3.fromRGB(14,24,48)
C_BORDER2= Color3.fromRGB(22,32,64)
C_BORDER3= Color3.fromRGB(30,46,88)
C_OMEGA  = Color3.fromRGB(0,255,231)
C_OMEGA2 = Color3.fromRGB(0,196,180)
C_OMEGA3 = Color3.fromRGB(0,122,112)
C_PLASMA = Color3.fromRGB(123,47,255)
C_FIRE   = Color3.fromRGB(255,106,0)
C_GOLD   = Color3.fromRGB(255,208,0)
C_RED    = Color3.fromRGB(255,26,64)
C_GREEN  = Color3.fromRGB(0,255,136)
C_TEXT   = Color3.fromRGB(204,232,255)
C_MUTED  = Color3.fromRGB(58,80,112)
C_DIM    = Color3.fromRGB(26,37,64)

-- ════════════════════════════════════════════════════════════
--  DRAG SYSTEM (legacy helpers, kept for compatibility)
-- ════════════════════════════════════════════════════════════
local function makeDrag(frame,handle)
  local h=handle or frame
  local dragging,dragStart,startPos=false,nil,nil
  h.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
      dragging=true;dragStart=input.Position;startPos=frame.Position
      input.Changed:Connect(function()
        if input.UserInputState==Enum.UserInputState.End then dragging=false end
      end)
    end
  end)
  h.InputChanged:Connect(function(input)
    if(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)and dragging then
      local d=input.Position-dragStart
      frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
  end)
end

-- ════════════════════════════════════════════════════════════
--  HELPER UI FUNCTIONS
-- ════════════════════════════════════════════════════════════
local function mkFrame(parent,x,y,w,h2,bg,zi)
  local f=Instance.new("Frame",parent)
  f.Position=UDim2.new(0,x,0,y); f.Size=UDim2.new(0,w,0,h2)
  f.BackgroundColor3=bg or C_BG3; f.BorderSizePixel=0; f.ZIndex=zi or 11
  return f
end
local function mkLbl(parent,x,y,w,h2,txt,tc,ts,xa,fnt)
  local l=Instance.new("TextLabel",parent)
  l.Position=UDim2.new(0,x,0,y); l.Size=UDim2.new(0,w,0,h2)
  l.BackgroundTransparency=1; l.Text=txt; l.TextSize=ts or 10
  l.Font=fnt or Enum.Font.GothamBold; l.TextColor3=tc or C_TEXT
  l.TextXAlignment=xa or Enum.TextXAlignment.Left; l.ZIndex=12
  return l
end
local function mkCorner(parent,r)
  local c=Instance.new("UICorner",parent); c.CornerRadius=UDim.new(0,r or 8); return c
end
local function mkStroke(parent,col,thick,trans)
  local s=Instance.new("UIStroke",parent); s.Color=col or C_BORDER3
  s.Thickness=thick or 1; s.Transparency=trans or 0; return s
end
local function omgBtn(parent,x,y,w,h2,txt,bgColor,accentCol)
  local b=Instance.new("TextButton",parent)
  b.Position=UDim2.new(0,x,0,y); b.Size=UDim2.new(0,w,0,h2)
  b.BackgroundColor3=bgColor or C_BG3; b.BorderSizePixel=0
  b.Text=txt; b.TextSize=9; b.Font=Enum.Font.GothamBold
  b.TextColor3=C_TEXT; b.AutoButtonColor=false; b.ZIndex=12
  b.ClipsDescendants=true
  mkCorner(b,8); mkStroke(b,accentCol or C_BORDER3,1,0.3)
  b.MouseEnter:Connect(function() b.BackgroundColor3=C_BG4 end)
  b.MouseLeave:Connect(function() b.BackgroundColor3=bgColor or C_BG3 end)
  return b
end
local function omgSec(parent,y,txt,colorKey)
  local cc = colorKey=="p" and C_PLASMA or colorKey=="f" and C_FIRE or colorKey=="g" and C_GOLD or C_OMEGA
  local row=mkFrame(parent,0,y,PW,22,Color3.fromRGB(0,0,0),11); row.BackgroundTransparency=1
  local ll=mkFrame(row,14,10,80,1,cc,12); ll.BackgroundTransparency=0.5
  local lg=Instance.new("UIGradient",ll)
  lg.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
  local dl=mkFrame(row,96,7,7,7,cc,12); Instance.new("UICorner",dl).CornerRadius=UDim.new(0,1); dl.Rotation=45
  local tl=mkLbl(row,106,1,PW-212,20,txt,cc,8,Enum.TextXAlignment.Center,Enum.Font.GothamBold); tl.TextTransparency=0.1
  local dr=mkFrame(row,PW-103,7,7,7,cc,12); Instance.new("UICorner",dr).CornerRadius=UDim.new(0,1); dr.Rotation=45
  local rl=mkFrame(row,PW-95,10,80,1,cc,12); rl.BackgroundTransparency=0.5
  local rg=Instance.new("UIGradient",rl)
  rg.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
  return row
end
local function mkModeCard(parent,x,y,w,h2,iconTxt,nameTxt,descTxt,onColor)
  local card=mkFrame(parent,x,y,w,h2,C_BG3,12); mkCorner(card,10); mkStroke(card,C_BORDER2,1,0)
  local iw=mkFrame(card,10,h2/2-18,32,32,C_BG2,13); mkCorner(iw,8); mkStroke(iw,C_BORDER3,1,0)
  local il=mkLbl(iw,0,0,32,32,iconTxt,C_MUTED,18,Enum.TextXAlignment.Center)
  il.TextYAlignment=Enum.TextYAlignment.Center
  mkLbl(card,50,6,w-100,14,nameTxt,C_MUTED,8,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  mkLbl(card,50,20,w-100,12,descTxt,C_MUTED,7,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  local dot=mkFrame(card,w-22,h2/2-5,10,10,C_DIM,13); mkCorner(dot,5)
  local sl=mkLbl(card,w-50,h2/2-6,42,12,"OFF",C_MUTED,7,Enum.TextXAlignment.Right); sl.Font=Enum.Font.GothamBold
  local isOn=false
  local btn2=Instance.new("TextButton",card)
  btn2.Size=UDim2.new(1,0,1,0); btn2.BackgroundTransparency=1; btn2.Text=""; btn2.ZIndex=14; btn2.BorderSizePixel=0
  local function setOn(v)
    isOn=v
    if v then
      card.BackgroundColor3=Color3.fromRGB(
        math.floor(onColor.R*255*0.08+C_BG3.R*255*0.92)/255,
        math.floor(onColor.G*255*0.08+C_BG3.G*255*0.92)/255,
        math.floor(onColor.B*255*0.08+C_BG3.B*255*0.92)/255)
      mkStroke(card,onColor,1,0.4)
      iw.BackgroundColor3=Color3.fromRGB(math.floor(onColor.R*255*0.12)/255,math.floor(onColor.G*255*0.12)/255,math.floor(onColor.B*255*0.12)/255)
      il.TextColor3=onColor; dot.BackgroundColor3=onColor; sl.TextColor3=onColor; sl.Text="ON"
    else
      card.BackgroundColor3=C_BG3; mkStroke(card,C_BORDER2,1,0)
      iw.BackgroundColor3=C_BG2; il.TextColor3=C_MUTED; dot.BackgroundColor3=C_DIM; sl.TextColor3=C_MUTED; sl.Text="OFF"
    end
  end
  return card,btn2,sl,setOn
end
local function mkDial(parent,x,y,label,initVal,maxVal,dialColor)
  local dialW=math.floor((PW-24)/3)
  local card=mkFrame(parent,x,y,dialW,110,C_BG3,12); mkCorner(card,11); mkStroke(card,C_BORDER2,1,0)
  mkLbl(card,0,8,dialW,14,label,C_MUTED,7,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
  local ringBg=mkFrame(card,dialW/2-25,24,50,50,C_BG2,13); mkCorner(ringBg,25); mkStroke(ringBg,dialColor,1,0.6)
  local vLbl=mkLbl(ringBg,0,10,50,30,tostring(initVal),Color3.fromRGB(255,255,255),18,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
  mkLbl(ringBg,0,34,50,12,"stud",C_MUTED,7,Enum.TextXAlignment.Center)
  local bm=omgBtn(card,14,82,40,22,"−",C_BG4,dialColor); bm.TextSize=16; bm.Font=Enum.Font.GothamBold; bm.TextColor3=dialColor
  local bp=omgBtn(card,dialW-54,82,40,22,"+",C_BG4,dialColor); bp.TextSize=16; bp.Font=Enum.Font.GothamBold; bp.TextColor3=dialColor
  return vLbl, bm, bp
end
local function mkSlider(parent,x,y,w,label,initVal,minV,maxV,fillColor,iconTxt)
  local container=mkFrame(parent,x,y,w,64,C_BG3,12); mkCorner(container,9); mkStroke(container,C_BORDER2,1,0)
  local ico=mkLbl(container,10,10,16,16,iconTxt,fillColor,12,Enum.TextXAlignment.Center)
  ico.TextYAlignment=Enum.TextYAlignment.Center
  mkLbl(container,28,10,w-80,16,label,C_TEXT,10,Enum.TextXAlignment.Left)
  local numLbl=mkFrame(container,w-52,8,44,20,C_BG4,13); mkCorner(numLbl,4); mkStroke(numLbl,C_BORDER3,1,0)
  local nTxt=mkLbl(numLbl,0,2,44,16,tostring(initVal),Color3.fromRGB(255,255,255),11,Enum.TextXAlignment.Center)
  nTxt.Font=Enum.Font.GothamBold
  local track=mkFrame(container,10,36,w-20,8,C_BG2,13); mkCorner(track,99)
  local frac=(initVal-minV)/(maxV-minV)
  local fill=mkFrame(track,0,0,math.floor((w-20)*frac),8,fillColor,14); mkCorner(fill,99)
  local fGrad=Instance.new("UIGradient",fill)
  fGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(math.floor(fillColor.R*150),math.floor(fillColor.G*150),math.floor(fillColor.B*150))),ColorSequenceKeypoint.new(1,fillColor)})
  local thumb=Instance.new("Frame"); thumb.Name="Thumb"
  thumb.Size=UDim2.new(0,14,0,14); thumb.AnchorPoint=Vector2.new(1,0.5)
  thumb.Position=UDim2.new(1,2,0.5,0); thumb.BackgroundColor3=Color3.fromRGB(255,255,255)
  thumb.BorderSizePixel=0; thumb.ZIndex=15; thumb.Parent=fill
  mkCorner(thumb,7); mkStroke(thumb,fillColor,2,0)
  local curVal=initVal; local isDrag=false
  local function applyFrac(fr)
    fr=math.clamp(fr,0,1); curVal=math.floor(fr*(maxV-minV)+minV)
    fill.Size=UDim2.new(fr,0,1,0); nTxt.Text=tostring(curVal)
  end
  local function posToFrac(screenX)
    local relX=screenX-track.AbsolutePosition.X; return math.clamp(relX/track.AbsoluteSize.X,0,1)
  end
  track.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
      isDrag=true; applyFrac(posToFrac(inp.Position.X))
    end
  end)
  track.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then isDrag=false end
  end)
  track.InputChanged:Connect(function(inp)
    if isDrag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
      applyFrac(posToFrac(inp.Position.X))
    end
  end)
  local function getVal() return curVal end
  local function setVal(v)
    v=math.clamp(v,minV,maxV); curVal=v
    local fr=(v-minV)/(maxV-minV); fill.Size=UDim2.new(fr,0,1,0); nTxt.Text=tostring(curVal)
  end
  return container, getVal, setVal
end
local function mkAksiCard(parent,x,y,w,h2,iconTxt,titleTxt,subtitleTxt,bgCol,strokeCol)
  local card=mkFrame(parent,x,y,w,h2,bgCol,12); mkCorner(card,11); mkStroke(card,strokeCol,1,0.2)
  local iw=mkFrame(card,12,h2/2-18,36,36,Color3.fromRGB(math.floor(bgCol.R*255+20)/255,math.floor(bgCol.G*255+10)/255,math.floor(bgCol.B*255+10)/255),13)
  mkCorner(iw,9); mkStroke(iw,Color3.fromRGB(1,1,1),1,0.85)
  mkLbl(iw,0,0,36,36,iconTxt,Color3.fromRGB(255,255,255),20,Enum.TextXAlignment.Center).TextYAlignment=Enum.TextYAlignment.Center
  mkLbl(card,56,8,w-90,16,titleTxt,Color3.fromRGB(255,255,255),10,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  mkLbl(card,56,26,w-90,13,subtitleTxt,Color3.new(1,1,1),8,Enum.TextXAlignment.Left,Enum.Font.Gotham).TextTransparency=0.3
  mkLbl(card,w-24,h2/2-8,18,16,"›",C_MUTED,18,Enum.TextXAlignment.Center)
  local btn2=Instance.new("TextButton",card)
  btn2.Size=UDim2.new(1,0,1,0); btn2.BackgroundTransparency=1; btn2.Text=""; btn2.ZIndex=14; btn2.BorderSizePixel=0
  btn2.MouseEnter:Connect(function() card.BackgroundColor3=Color3.new(math.min(bgCol.R+0.06,1),math.min(bgCol.G+0.04,1),math.min(bgCol.B+0.04,1)) end)
  btn2.MouseLeave:Connect(function() card.BackgroundColor3=bgCol end)
  return btn2
end

-- ════════════════════════════════════════════════════════════
--  DATA TERRAIN
-- ════════════════════════════════════════════════════════════
W, H, D = 6, 6, 6
CBS = Vector3.new(W, H, D)
pE=false; pTE=false; aC=false; tM=false
sM=false; sMA=false; stM=false; stMA=false
plM=false; plMA=false; blM=false; blMA=false
tBR=false; tBA=false; bkM=false; bkMA=false
bkH=20; bkR=24; lBKBT=0
gnM=false; gnMA=false; lGNBT=0
gnH=18; gnR=20; gnSharp=50
gnDragStart=nil; gnDragY=nil
iMD=false; lBP=nil; lSP=nil
local lSBT,lSTBT,lPLBT,lBLBT,lTBT2=0,0,0,0,0
panelVisible=false; isSaving=false

mats={"Grass","Ground","Mud","Sand","Snow","LeafyGrass","Rock","Slate","Basalt","Cobblestone","Granite","Limestone","Pavement","Salt","CrackedLava","Marble","Water","Ice","Glacier","Brick","Concrete","Plastic","Wood","WoodPlanks","Metal","DiamondPlate"}
mN={Grass="Rumput",Ground="Tanah",Mud="Lumpur",Sand="Pasir",Snow="Salju",LeafyGrass="Rumput Daun",Rock="Batuan",Slate="Batu Tulis",Basalt="Basalt",Cobblestone="Bebatuan",Granite="Granit",Limestone="Batu Kapur",Pavement="Perkerasan",Salt="Garam",CrackedLava="Lava Retak",Marble="Marmer",Water="Air",Ice="Es",Glacier="Gletser",Brick="Bata",Concrete="Beton",Plastic="Plastik",Wood="Kayu",WoodPlanks="Papan",Metal="Logam",DiamondPlate="Diamond"}
mI=1; cM=mats[mI]
gC={
  {name="Hijau Muda",color=Color3.fromRGB(150,220,120)},{name="Hijau Cerah",color=Color3.fromRGB(120,200,100)},
  {name="Hijau Normal",color=Color3.fromRGB(75,151,75)},{name="Hijau Sedang",color=Color3.fromRGB(60,140,70)},
  {name="Hijau Tua",color=Color3.fromRGB(45,120,55)},{name="Hijau Gelap",color=Color3.fromRGB(30,100,40)},
  {name="Hijau Lumut",color=Color3.fromRGB(80,120,60)},{name="Hijau Zamrud",color=Color3.fromRGB(50,180,100)},
  {name="Hijau Mint",color=Color3.fromRGB(170,230,150)},{name="Hijau Daun",color=Color3.fromRGB(70,160,80)},
}
cGI=3
grC={{name="Coklat Muda",color=Color3.fromRGB(160,120,80)},{name="Coklat Normal",color=Color3.fromRGB(120,85,50)},{name="Coklat Tanah",color=Color3.fromRGB(102,92,59)},{name="Coklat Tua",color=Color3.fromRGB(75,55,30)},{name="Coklat Gelap",color=Color3.fromRGB(50,35,15)}}
cGrI=3
shapes={"Balok","Bola","Silinder","Baji"}
sI=1; cS=shapes[sI]
gOM={Grass=true,LeafyGrass=true}; gdOM={Ground=true,Mud=true}
colM={Grass=true,LeafyGrass=true,Ground=true,Mud=true}
tOM={Grass=true,Ground=true,Mud=true,Sand=true,Snow=true,LeafyGrass=true,Rock=true,Slate=true,Basalt=true,Cobblestone=true,Granite=true,Limestone=true,Pavement=true,Salt=true,CrackedLava=true,Marble=true,Water=true,Ice=true,Glacier=true}
mCol={Grass=Color3.fromRGB(75,151,75),Ground=Color3.fromRGB(102,92,59),Mud=Color3.fromRGB(92,64,51),Sand=Color3.fromRGB(194,178,128),Snow=Color3.fromRGB(239,240,240),LeafyGrass=Color3.fromRGB(106,134,64),Rock=Color3.fromRGB(110,110,110),Slate=Color3.fromRGB(85,87,98),Basalt=Color3.fromRGB(60,60,60),Cobblestone=Color3.fromRGB(132,126,135),Granite=Color3.fromRGB(130,130,130),Limestone=Color3.fromRGB(230,228,220),Pavement=Color3.fromRGB(115,115,115),Salt=Color3.fromRGB(230,230,230),CrackedLava=Color3.fromRGB(232,88,40),Marble=Color3.fromRGB(220,220,230),Water=Color3.fromRGB(0,162,255),Ice=Color3.fromRGB(175,221,255),Glacier=Color3.fromRGB(200,230,255),Brick=Color3.fromRGB(138,86,62),Concrete=Color3.fromRGB(150,150,150),Plastic=Color3.fromRGB(255,255,255),Wood=Color3.fromRGB(139,94,60),WoodPlanks=Color3.fromRGB(160,110,75),Metal=Color3.fromRGB(200,200,200),DiamondPlate=Color3.fromRGB(170,170,170)}
mE={Grass=Enum.Material.Grass,Ground=Enum.Material.Ground,Mud=Enum.Material.Mud,Sand=Enum.Material.Sand,Snow=Enum.Material.Snow,LeafyGrass=Enum.Material.LeafyGrass,Rock=Enum.Material.Rock,Slate=Enum.Material.Slate,Basalt=Enum.Material.Basalt,Cobblestone=Enum.Material.Cobblestone,Granite=Enum.Material.Granite,Limestone=Enum.Material.Limestone,Pavement=Enum.Material.Pavement,Salt=Enum.Material.Salt,CrackedLava=Enum.Material.CrackedLava,Marble=Enum.Material.Marble,Water=Enum.Material.Water,Ice=Enum.Material.Ice,Glacier=Enum.Material.Glacier,Brick=Enum.Material.Brick,Concrete=Enum.Material.Concrete,Plastic=Enum.Material.Plastic,Wood=Enum.Material.Wood,WoodPlanks=Enum.Material.WoodPlanks,Metal=Enum.Material.Metal,DiamondPlate=Enum.Material.DiamondPlate}
tDBM={}; undoStack={}; swD={}; blowedSet={}; brushGroupId=0
local brushPartsList={}

-- ════════════════════════════════════════════════════════════
--  FITUR BARU: State variables
-- ════════════════════════════════════════════════════════════
-- Brush Strength (1-100)
brushStrength = 75
-- Mode flags baru
smBrM=false; smBrA=false   -- Smooth Brush
rlM=false;   rlA=false     -- Raise/Lower Brush
rlDir=1                    -- 1=raise, -1=lower
ptM=false;   ptA=false     -- Paint Brush
ftM=false;   ftA=false     -- Flatten Brush
ftTargetY=nil              -- Y target flatten (nil=auto dari hit)
local lSmBT,lRLBT,lPTBT,lFTBT=0,0,0,0

-- ════════════════════════════════════════════════════════════
--  PERLIN NOISE (Pure Lua, multi-octave)
-- ════════════════════════════════════════════════════════════
do
  local perm={}
  local function fade(t) return t*t*t*(t*(t*6-15)+10) end
  local function lerp(t,a,b) return a+t*(b-a) end
  local function grad(hash,x,y,z)
    local h=hash%16; local u=h<8 and x or y; local v=h<4 and y or ((h==12 or h==14) and x or z)
    return ((h%2==0) and u or -u)+((math.floor(h/2)%2==0) and v or -v)
  end
  math.randomseed(os.time())
  for i=0,255 do perm[i]=i end
  for i=255,1,-1 do local j=math.random(0,i); perm[i],perm[j]=perm[j],perm[i] end
  for i=0,255 do perm[i+256]=perm[i] end
  local function noise3(x,y,z)
    local X=math.floor(x)%256; local Y=math.floor(y)%256; local Z=math.floor(z)%256
    x=x-math.floor(x); y=y-math.floor(y); z=z-math.floor(z)
    local u=fade(x); local v=fade(y); local w=fade(z)
    local A=perm[X]+Y; local AA=perm[A]+Z; local AB=perm[A+1]+Z
    local B=perm[X+1]+Y; local BA=perm[B]+Z; local BB=perm[B+1]+Z
    return lerp(w,
      lerp(v,lerp(u,grad(perm[AA],x,y,z),grad(perm[BA],x-1,y,z)),
             lerp(u,grad(perm[AB],x,y-1,z),grad(perm[BB],x-1,y-1,z))),
      lerp(v,lerp(u,grad(perm[AA+1],x,y,z-1),grad(perm[BA+1],x-1,y,z-1)),
             lerp(u,grad(perm[AB+1],x,y-1,z-1),grad(perm[BB+1],x-1,y-1,z-1))))
  end
  -- Fungsi publik: fbm (fractal brownian motion) multi-octave
  function perlinFBM(x, z, octaves, scale, persistence, lacunarity)
    octaves=octaves or 4; scale=scale or 0.04; persistence=persistence or 0.5; lacunarity=lacunarity or 2.0
    local val=0; local amp=1; local freq=scale; local maxVal=0
    for _=1,octaves do
      val=val+noise3(x*freq, 0.5, z*freq)*amp
      maxVal=maxVal+amp; amp=amp*persistence; freq=freq*lacunarity
    end
    return val/maxVal  -- range ~-1 to 1
  end
end

-- ════════════════════════════════════════════════════════════
--  UTILITY / LOGIKA TERRAIN
-- ════════════════════════════════════════════════════════════
local function c2R(c) return math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5) end
local function gAC(mn)
  if gOM[mn] then return c2R(gC[cGI].color)
  elseif gdOM[mn] then return c2R(grC[cGrI].color) end
  return 0,0,0
end
local function gFld(mn)
  local f=Workspace:FindFirstChild(mn); if not f then f=Instance.new("Folder"); f.Name=mn; f.Parent=Workspace end; return f
end
local function gTVC()
  local n=0
  for _,l in pairs(tDBM) do
    for _,e in ipairs(l) do
      local k=string.format("%.2f,%.2f,%.2f",e.position.X,e.position.Y,e.position.Z)
      if not blowedSet[k] then n=n+1 end
    end
  end
  for _,e in ipairs(swD) do
    local k=string.format("%.2f,%.2f,%.2f",e.position.X,e.position.Y,e.position.Z)
    if not blowedSet[k] then n=n+1 end
  end
  return n
end
local function sGCP()
  local T=Workspace:FindFirstChild("Terrain")
  if T then T:SetMaterialColor(Enum.Material.Grass,gC[cGI].color); T:SetMaterialColor(Enum.Material.LeafyGrass,gC[cGI].color) end
end
local function lGCP()
  local cfg=Workspace:FindFirstChild("TerrainBuilderConfig"); if not cfg then return false end
  local cv=cfg:FindFirstChild("GrassColorIndex"); if cv and gC[cv.Value] then cGI=cv.Value; return true end; return false
end

-- SNAPSHOT — ReadVoxels/WriteVoxels tidak tersedia di executor, gunakan stub
local VOXEL_RES = 2
local function snapshotRegion(pos, sz)
  -- Tidak bisa ReadVoxels di executor, return nil (undo pakai FillBlock Air)
  return nil
end
local function restoreSnapshot(snap2)
  -- Tidak dipakai karena snapshot selalu nil
end
local function addEntry(pos,sz,shape,mn)
  if not tOM[mn] then return nil end
  local ic=colM[mn] and true or false; local sr,sg2,sb=0,0,0; if ic then sr,sg2,sb=gAC(mn) end
  local snap2=snapshotRegion(pos,sz)
  local en={position=pos,size=sz,shape=shape,material=mn,isColorable=ic,grR=sr,grG=sg2,grB=sb,snapshot=snap2}
  if not tDBM[mn] then tDBM[mn]={} end; table.insert(tDBM[mn],en); table.insert(undoStack,en); return en
end
-- FILL_VS: ukuran voxel fill (stud). Makin kecil = terrain makin mulus & natural
local FILL_VS = 2

local function setMCol(T, me, mn)
  if gOM[mn] then T:SetMaterialColor(me, gC[cGI].color)
  elseif gdOM[mn] then T:SetMaterialColor(me, grC[cGrI].color) end
end

local function applyT(pos, sz, shape, mn)
  local T = Workspace:FindFirstChild("Terrain"); if not T then return end
  local me = mE[mn]; if not me then return end
  local vs = FILL_VS
  pcall(function()
    if shape == "Bola" then
      -- Bola: FillBall sudah smooth secara native di Roblox
      local r = math.max(sz.X, sz.Y, sz.Z) / 2
      T:FillBall(pos, r, me)
      setMCol(T, me, mn)
    elseif shape == "Silinder" then
      -- Silinder SEMPURNA: axis Y (vertikal), height = sz.Y, radius = max(X,Z)/2
      -- FillCylinder di Roblox: sumbu default = Y. Tidak perlu rotate.
      local height = sz.Y
      local radius = math.max(sz.X, sz.Z) / 2
      T:FillCylinder(CFrame.new(pos), height, radius, me)
      setMCol(T, me, mn)
    elseif shape == "Baji" then
      T:FillWedge(CFrame.new(pos), sz, me)
      setMCol(T, me, mn)
    else
      -- Balok: di-tile jadi grid voxel kecil (FILL_VS) agar tepi mulus & natural
      local hX = sz.X/2; local hY = sz.Y/2; local hZ = sz.Z/2
      local function snapV(v) return math.floor(v/vs)*vs end
      local sMinX = snapV(pos.X - hX); local sMinY = snapV(pos.Y - hY); local sMinZ = snapV(pos.Z - hZ)
      local sMaxX = snapV(pos.X + hX); local sMaxY = snapV(pos.Y + hY); local sMaxZ = snapV(pos.Z + hZ)
      local vSz = Vector3.new(vs, vs, vs)
      local count = 0
      for vx = sMinX, sMaxX, vs do
        for vy = sMinY, sMaxY, vs do
          for vz = sMinZ, sMaxZ, vs do
            T:FillBlock(CFrame.new(vx+vs/2, vy+vs/2, vz+vs/2), vSz, me)
            count = count + 1
            if count % 300 == 0 then task.wait() end
          end
        end
      end
      setMCol(T, me, mn)
    end
  end)
end
local function brushPartContinuous(pos)
  if lBP and (pos-lBP).Magnitude<math.min(W,H,D)*0.3 then return end; lBP=pos
  local folder=gFld("TerrainParts")
  local part=Instance.new("Part"); part.Size=CBS; part.CFrame=CFrame.new(pos)
  part.Anchored=true; part.Material=mE[cM] or Enum.Material.Plastic; part.Color=mCol[cM] or Color3.new(1,1,1)
  part.Parent=folder; table.insert(brushPartsList,part)
  if aC then applyT(pos,CBS,cS,cM) end
end
local function bTC(pos)
  if not tOM[cM] then return end
  if lBP and (pos-lBP).Magnitude<math.min(W,H,D)*0.1 then return end; lBP=pos
  addEntry(pos,CBS,cS,cM); applyT(pos,CBS,cS,cM)
end
local function bSw(pos)
  if not pos then return end; local t=tick(); if t-lSBT<0.05 then return end
  if lSP and (pos-lSP).Magnitude<math.min(W,H,D)*0.4 then return end; lSBT=t; lSP=pos
  local T=Workspace:FindFirstChild("Terrain"); if not T then return end; local tm=mE[cM]; if not tm then return end
  local sH=math.max(CBS.Y,8); local sSz=Vector3.new(CBS.X,sH,CBS.Z); local fP=Vector3.new(pos.X,pos.Y-sH*0.5,pos.Z)
  pcall(function() T:FillBlock(CFrame.new(fP),sSz,tm); setMCol(T,tm,cM) end)
  local ic=colM[cM] and true or false; local r2,g2,b2=0,0,0; if ic then r2,g2,b2=gAC(cM) end
  local en={position=fP,size=sSz,shape="Balok",material=cM,isColorable=ic,grR=r2,grG=g2,grB=b2}
  table.insert(swD,en); table.insert(undoStack,en)
end
local function bStack(pos)
  if not pos then return end; local t=tick(); if t-lSTBT<0.08 then return end
  if lSP and (pos-lSP).Magnitude<math.min(W,H,D)*0.5 then return end; lSTBT=t; lSP=pos
  local T=Workspace:FindFirstChild("Terrain"); if not T then return end; local me=mE[cM]; if not me then return end
  local topY=pos.Y
  -- Pakai Raycast untuk cari permukaan terrain teratas
  pcall(function()
    _rayParams.FilterDescendantsInstances = {T}
    local hit = workspace:Raycast(
      Vector3.new(pos.X, pos.Y+200, pos.Z),
      Vector3.new(0, -250, 0),
      _rayParams
    )
    if hit then topY = hit.Position.Y end
  end)
  local stackPos=Vector3.new(pos.X, topY + H/2, pos.Z)
  pcall(function() T:FillBlock(CFrame.new(stackPos),CBS,me); if gOM[cM] then T:SetMaterialColor(me,gC[cGI].color) elseif gdOM[cM] then T:SetMaterialColor(me,grC[cGrI].color) end end)
  addEntry(stackPos,CBS,"Balok",cM)
end
local function bPlant(pos)
  if not pos then return end; local t=tick(); if t-lPLBT<0.05 then return end
  if lSP and (pos-lSP).Magnitude<math.min(W,H,D)*0.3 then return end; lPLBT=t; lSP=pos
  local T=Workspace:FindFirstChild("Terrain"); if not T then return end; local me=mE[cM]; if not me then return end
  local roadSz=Vector3.new(W,math.max(4,H),D)
  pcall(function() T:FillBlock(CFrame.new(pos),Vector3.new(W+4,roadSz.Y+8,D+4),Enum.Material.Air) end); task.wait()
  pcall(function() T:FillBlock(CFrame.new(pos),roadSz,me); if gOM[cM] then T:SetMaterialColor(me,gC[cGI].color) elseif gdOM[cM] then T:SetMaterialColor(me,grC[cGrI].color) end end)
  local ic=colM[cM] and true or false; local r2,g2,b2=0,0,0; if ic then r2,g2,b2=gAC(cM) end
  local en={position=pos,size=roadSz,shape="Balok",material=cM,isColorable=ic,grR=r2,grG=g2,grB=b2}
  if not tDBM[cM] then tDBM[cM]={} end; table.insert(tDBM[cM],en); table.insert(undoStack,en)
end
local function bBlow(pos)
  if not pos then return end; local t=tick(); if t-lBLBT<0.05 then return end
  if lSP and (pos-lSP).Magnitude<math.min(W,H,D)*0.3 then return end; lBLBT=t; lSP=pos
  local T=Workspace:FindFirstChild("Terrain"); if not T then return end
  local vs=FILL_VS
  pcall(function()
    if cS=="Bola" then
      T:FillBall(pos, math.max(CBS.X,CBS.Y,CBS.Z)/2, Enum.Material.Air)
    elseif cS=="Silinder" then
      T:FillCylinder(CFrame.new(pos), CBS.Y, math.max(CBS.X,CBS.Z)/2, Enum.Material.Air)
    else
      -- Erase pakai voxel grid agar simetris dengan fill
      local hX=CBS.X/2; local hY=CBS.Y/2; local hZ=CBS.Z/2
      local function snapV(v) return math.floor(v/vs)*vs end
      local sMinX=snapV(pos.X-hX); local sMinY=snapV(pos.Y-hY); local sMinZ=snapV(pos.Z-hZ)
      local sMaxX=snapV(pos.X+hX); local sMaxY=snapV(pos.Y+hY); local sMaxZ=snapV(pos.Z+hZ)
      local vSz=Vector3.new(vs,vs,vs)
      for vx=sMinX,sMaxX,vs do for vy=sMinY,sMaxY,vs do for vz=sMinZ,sMaxZ,vs do
        T:FillBlock(CFrame.new(vx+vs/2,vy+vs/2,vz+vs/2),vSz,Enum.Material.Air)
      end end end
    end
  end)
  local bHW,bHH,bHD=CBS.X/2,CBS.Y/2,CBS.Z/2
  local bMinX=pos.X-bHW; local bMaxX=pos.X+bHW; local bMinY=pos.Y-bHH; local bMaxY=pos.Y+bHH; local bMinZ=pos.Z-bHD; local bMaxZ=pos.Z+bHD
  for mn2,lst in pairs(tDBM) do
    local newL={}
    for _,e in ipairs(lst) do
      local eHX=e.size.X/2; local eHY=e.size.Y/2; local eHZ=e.size.Z/2
      local overlap=(bMinX<e.position.X+eHX and bMaxX>e.position.X-eHX) and (bMinY<e.position.Y+eHY and bMaxY>e.position.Y-eHY) and (bMinZ<e.position.Z+eHZ and bMaxZ>e.position.Z-eHZ)
      if overlap then local k=string.format("%.2f,%.2f,%.2f",e.position.X,e.position.Y,e.position.Z); blowedSet[k]=true
      else table.insert(newL,e) end
    end; tDBM[mn2]=newL
  end
  local newSwD={}
  for _,e in ipairs(swD) do
    local eHX=e.size.X/2; local eHY=e.size.Y/2; local eHZ=e.size.Z/2
    local overlap=(bMinX<e.position.X+eHX and bMaxX>e.position.X-eHX) and (bMinY<e.position.Y+eHY and bMaxY>e.position.Y-eHY) and (bMinZ<e.position.Z+eHZ and bMaxZ>e.position.Z-eHZ)
    if not overlap then table.insert(newSwD,e) end
  end; swD=newSwD
  local newU={}
  for _,e in ipairs(undoStack) do
    local k=string.format("%.2f,%.2f,%.2f",e.position.X,e.position.Y,e.position.Z)
    if not blowedSet[k] then table.insert(newU,e) end
  end; undoStack=newU
end
local function cTun(pos)
  if not pos then return end; local T=Workspace:FindFirstChild("Terrain"); if not T then return end
  local vs=FILL_VS
  pcall(function()
    if cS=="Bola" then
      T:FillBall(pos, math.max(CBS.X,CBS.Y,CBS.Z)/2, Enum.Material.Air)
    elseif cS=="Silinder" then
      T:FillCylinder(CFrame.new(pos), CBS.Y, math.max(CBS.X,CBS.Z)/2, Enum.Material.Air)
    else
      local hX=CBS.X/2; local hY=CBS.Y/2; local hZ=CBS.Z/2
      local function snapV(v) return math.floor(v/vs)*vs end
      local sMinX=snapV(pos.X-hX); local sMinY=snapV(pos.Y-hY); local sMinZ=snapV(pos.Z-hZ)
      local sMaxX=snapV(pos.X+hX); local sMaxY=snapV(pos.Y+hY); local sMaxZ=snapV(pos.Z+hZ)
      local vSz=Vector3.new(vs,vs,vs)
      for vx=sMinX,sMaxX,vs do for vy=sMinY,sMaxY,vs do for vz=sMinZ,sMaxZ,vs do
        T:FillBlock(CFrame.new(vx+vs/2,vy+vs/2,vz+vs/2),vSz,Enum.Material.Air)
      end end end
    end
  end)
end
local function bTr(pos)
  if not pos then return end; local t=tick(); if t-lTBT2<0.5 then return end; lTBT2=t
  local tF=Workspace:FindFirstChild("POHON"); if not tF then warn("⚠ Folder POHON tidak ada!"); return end
  local og={}
  for _,v in ipairs(tF:GetChildren()) do if not v:GetAttribute("PohonClone") then v:SetAttribute("PohonOriginal",true); table.insert(og,v) end end
  if #og==0 then warn("⚠ Folder POHON kosong!"); return end
  local ori=og[math.random(1,#og)]; local cl=ori:Clone()
  cl:SetAttribute("PohonOriginal",nil); cl:SetAttribute("PohonClone",true)
  if cl:IsA("Model") then
    local ok3,cf2,sz2=pcall(function() return cl:GetBoundingBox() end)
    if ok3 and cf2 and sz2 then
      local pivotY=cf2.Position.Y; local baseY=pivotY-sz2.Y/2; local offsetY=pivotY-baseY
      cl:PivotTo(CFrame.new(pos.X,pos.Y+offsetY,pos.Z))
    else cl:PivotTo(CFrame.new(pos.X,pos.Y,pos.Z)) end
  elseif cl:IsA("BasePart") then
    cl.Position=Vector3.new(pos.X,pos.Y+cl.Size.Y/2,pos.Z); cl.Anchored=true
  end
  cl.Parent=tF
end
local function clrAll()
  for _,mn in ipairs(mats) do local f=Workspace:FindFirstChild(mn); if f then f:ClearAllChildren() end end
  tDBM={}; undoStack={}; swD={}; blowedSet={}; brushPartsList={}; paintData={}; lBP=nil; lSP=nil
end
local function convertPartsToTerrain()
  local T=Workspace:FindFirstChild("Terrain"); if not T then return 0 end; local c=0
  for _,matName in ipairs(mats) do
    if tOM[matName] then
      local f=Workspace:FindFirstChild(matName)
      if f then
        for _,part in ipairs(f:GetChildren()) do
          if part:IsA("BasePart") then
            local me2=mE[matName]
            pcall(function()
              if part.Shape==Enum.PartType.Ball then T:FillBall(part.Position,part.Size.X/2,me2)
              elseif part.Shape==Enum.PartType.Cylinder then T:FillCylinder(part.CFrame,part.Size.Y,math.max(part.Size.X,part.Size.Z)*0.6,me2)
              else T:FillBlock(part.CFrame,part.Size,me2) end
              if gOM[matName] then T:SetMaterialColor(me2,gC[cGI].color) elseif gdOM[matName] then T:SetMaterialColor(me2,grC[cGrI].color) end
            end)
            addEntry(part.Position,part.Size,"Balok",matName); c=c+1; if c%30==0 then task.wait() end
          end
        end
      end
    end
  end
  return c
end
local function bBukit(pos)
  if not pos then return end; local t=tick(); if t-lBKBT<0.12 then return end; lBKBT=t
  local T=Workspace:FindFirstChild("Terrain"); if not T then return end; local me=mE[cM]; if not me then return end
  local R=bkR; local hh=bkH; local stp=FILL_VS
  local cx,cy,cz=pos.X,pos.Y,pos.Z
  brushGroupId=brushGroupId+1; local gid=brushGroupId
  local nSeed=cx*0.01+cz*0.013  -- seed berdasar posisi agar konsisten
  task.spawn(function()
    local placed=0
    for dx=-R,R,stp do
      for dz=-R,R,stp do
        local dist=math.sqrt(dx*dx+dz*dz)
        if dist<=R then
          local t2=dist/R
          -- Base cosine dome
          local hfBase=(math.cos(t2*math.pi)+1)*0.5
          -- Perlin noise multi-octave: detail halus + kasar
          local n1=perlinFBM(cx+dx+nSeed, cz+dz+nSeed, 4, 0.06, 0.5, 2.0)  -- detail kecil
          local n2=perlinFBM(cx+dx+nSeed*2, cz+dz+nSeed*2, 3, 0.02, 0.6, 2.2)  -- gelombang besar
          -- Blend: noise lebih kuat di tengah, melemah di tepi
          local noiseWeight=hfBase*0.35
          local hf=hfBase + n1*noiseWeight*0.7 + n2*noiseWeight*0.5
          hf=math.clamp(hf,0,1.3)
          local colH=math.max(stp, math.floor((hf*hh)/stp+0.5)*stp)
          local colPos=Vector3.new(cx+dx, cy+colH/2, cz+dz)
          local colSz=Vector3.new(stp, colH, stp)
          local snap2=snapshotRegion(colPos,colSz)
          pcall(function()
            T:FillBlock(CFrame.new(colPos), colSz, me)
            setMCol(T, me, cM)
          end)
          local en={position=colPos,size=colSz,shape="Balok",material=cM,isColorable=colM[cM] and true or false,grR=0,grG=0,grB=0,groupId=gid,snapshot=snap2}
          local r2,g2,b2=gAC(cM); en.grR=r2;en.grG=g2;en.grB=b2
          if not tDBM[cM] then tDBM[cM]={} end; table.insert(tDBM[cM],en); table.insert(undoStack,en)
          placed=placed+1; if placed%120==0 then task.wait() end
        end
      end
    end
  end)
end
local function bGundukan(pos, extraH)
  if not pos then return end; local t=tick(); if t-lGNBT<0.15 then return end; lGNBT=t
  local T=Workspace:FindFirstChild("Terrain"); if not T then return end; local me=mE[cM]; if not me then return end
  local R=gnR; local hh=gnH+(extraH or 0); local stp=FILL_VS
  local cx,cy,cz=pos.X,pos.Y,pos.Z
  brushGroupId=brushGroupId+1; local gid=brushGroupId
  local sharp=math.clamp(gnSharp/100,0,1)
  local nSeed=cx*0.017+cz*0.011
  task.spawn(function()
    local placed=0
    for dx=-R,R,stp do
      for dz=-R,R,stp do
        local dist=math.sqrt(dx*dx+dz*dz)
        if dist<=R then
          local t2=dist/R
          local hfCos=(math.cos(t2*math.pi)+1)*0.5
          local hfLin=math.max(0,1-t2)
          local hfBase=hfCos*(1-sharp)+hfLin*sharp
          -- Perlin FBM: variasi organik natural
          local n1=perlinFBM(cx+dx+nSeed, cz+dz+nSeed, 4, 0.07, 0.5, 2.1)
          local n2=perlinFBM(cx+dx+nSeed*3, cz+dz+nSeed*3, 2, 0.025, 0.65, 2.0)
          local noiseWeight=hfBase*0.3
          local hf=hfBase + n1*noiseWeight*0.8 + n2*noiseWeight*0.4
          hf=math.clamp(hf,0,1.25)
          local colH=math.max(stp, math.floor((hf*hh)/stp+0.5)*stp)
          local colPos=Vector3.new(cx+dx, cy+colH/2, cz+dz)
          local colSz=Vector3.new(stp, colH, stp)
          local snap2=snapshotRegion(colPos,colSz)
          pcall(function()
            T:FillBlock(CFrame.new(colPos), colSz, me)
            setMCol(T, me, cM)
          end)
          local en={position=colPos,size=colSz,shape="Balok",material=cM,isColorable=colM[cM] and true or false,grR=0,grG=0,grB=0,groupId=gid,snapshot=snap2}
          local r2,g2,b2=gAC(cM); en.grR=r2;en.grG=g2;en.grB=b2
          if not tDBM[cM] then tDBM[cM]={} end; table.insert(tDBM[cM],en); table.insert(undoStack,en)
          placed=placed+1; if placed%120==0 then task.wait() end
        end
      end
    end
  end)
end

-- ════════════════════════════════════════════════════════════
--  BRUSH BARU: Smooth, Raise/Lower, Paint, Flatten
-- ════════════════════════════════════════════════════════════

-- Helper: baca ketinggian terrain di titik X,Z pakai Raycast (tidak butuh ReadVoxels)
local _rayParams = RaycastParams.new()
_rayParams.FilterType = Enum.RaycastFilterType.Include
local function getTerrainTopY(T, x, z, searchY, rangeUp, rangeDown)
  searchY = searchY or 0
  rangeUp = rangeUp or 150
  rangeDown = rangeDown or 150
  -- Raycast dari atas ke bawah
  local startY = searchY + rangeUp
  local origin = Vector3.new(x, startY, z)
  local direction = Vector3.new(0, -(rangeUp + rangeDown), 0)
  local ok, result = pcall(function()
    _rayParams.FilterDescendantsInstances = {T}
    return workspace:Raycast(origin, direction, _rayParams)
  end)
  if ok and result then
    return result.Position.Y
  end
  return searchY
end

-- SMOOTH BRUSH — rata-rata ketinggian di area R, haluskan permukaan
local function bSmooth(pos)
  if not pos then return end
  local t=tick(); if t-lSmBT<0.08 then return end; lSmBT=t
  local T=Workspace:FindFirstChild("Terrain"); if not T then return end
  local vs=FILL_VS
  local R=math.max(W,D)/2
  local str=math.clamp(brushStrength/100, 0.1, 1.0)
  local cx,cy,cz=pos.X,pos.Y,pos.Z
  -- Kumpulkan ketinggian sekitar untuk rata-rata
  local heights={}; local totalH=0; local count=0
  for dx=-R,R,vs*2 do
    for dz=-R,R,vs*2 do
      if math.sqrt(dx*dx+dz*dz)<=R then
        local topY=getTerrainTopY(T, cx+dx, cz+dz, cy, 60, 60)
        table.insert(heights, topY); totalH=totalH+topY; count=count+1
      end
    end
  end
  if count==0 then return end
  local avgY=totalH/count
  -- Terapkan smooth: setiap kolom didorong ke arah avgY sesuai strength
  task.spawn(function()
    local placed=0
    for dx=-R,R,vs do
      for dz=-R,R,vs do
        local dist=math.sqrt(dx*dx+dz*dz)
        if dist<=R then
          -- feather: efek lebih kuat di tengah
          local falloff=(math.cos(dist/R*math.pi)+1)*0.5
          local localTop=getTerrainTopY(T, cx+dx, cz+dz, cy, 60, 60)
          local targetY=localTop+(avgY-localTop)*str*falloff
          targetY=math.floor(targetY/vs+0.5)*vs
          local me=mE[cM]; if not me then return end
          pcall(function()
            if targetY>localTop then
              -- Naikkan: fill dari localTop ke targetY
              local fillH=targetY-localTop
              if fillH>=vs then
                T:FillBlock(CFrame.new(cx+dx, localTop+fillH/2, cz+dz), Vector3.new(vs,fillH,vs), me)
                setMCol(T, me, cM)
              end
            elseif targetY<localTop then
              -- Turunkan: hapus dari targetY ke localTop
              local clearH=localTop-targetY
              if clearH>=vs then
                T:FillBlock(CFrame.new(cx+dx, targetY+clearH/2, cz+dz), Vector3.new(vs,clearH,vs), Enum.Material.Air)
              end
            end
          end)
          placed=placed+1; if placed%80==0 then task.wait() end
        end
      end
    end
  end)
end

-- RAISE/LOWER BRUSH — naikkan atau turunkan terrain secara gradual
local function bRaiseLower(pos)
  if not pos then return end
  local t=tick(); if t-lRLBT<0.06 then return end; lRLBT=t
  local T=Workspace:FindFirstChild("Terrain"); if not T then return end
  local me=mE[cM]; if not me then return end
  local vs=FILL_VS
  local R=math.max(W,D)/2
  local str=math.clamp(brushStrength/100, 0.1, 1.0)
  local step=math.max(vs, math.floor(H*str/4+0.5)*vs)  -- seberapa tinggi naik per klik
  local dir=rlDir  -- 1=raise, -1=lower
  local cx,cy,cz=pos.X,pos.Y,pos.Z
  brushGroupId=brushGroupId+1; local gid=brushGroupId
  task.spawn(function()
    local placed=0
    for dx=-R,R,vs do
      for dz=-R,R,vs do
        local dist=math.sqrt(dx*dx+dz*dz)
        if dist<=R then
          local falloff=(math.cos(dist/R*math.pi)+1)*0.5  -- feather tepi
          local actualStep=math.max(vs, math.floor(step*falloff/vs+0.5)*vs)
          local vx,vz=cx+dx,cz+dz
          local topY=getTerrainTopY(T, vx, vz, cy, 80, 80)
          pcall(function()
            if dir==1 then
              -- Raise: tambah kolom di atas
              T:FillBlock(CFrame.new(vx, topY+actualStep/2+vs/2, vz), Vector3.new(vs,actualStep,vs), me)
              setMCol(T, me, cM)
            else
              -- Lower: hapus dari atas
              T:FillBlock(CFrame.new(vx, topY-actualStep/2+vs/2, vz), Vector3.new(vs,actualStep+vs,vs), Enum.Material.Air)
            end
          end)
          placed=placed+1; if placed%100==0 then task.wait() end
        end
      end
    end
  end)
end

-- ════════════════════════════════════════════════════════════
--  PAINT DATA — simpan semua paint operations untuk save/load
-- ════════════════════════════════════════════════════════════
paintData = {}   -- {position, size, material, surfaceY}

-- PAINT BRUSH v2 — Studio PC style
-- Cara kerja:
--   1. Raycast multi-arah untuk temukan permukaan terrain yang TEPAT per kolom
--   2. Hitung ketebalan terrain di bawah permukaan (bounding scan ke bawah)
--   3. Ganti material HANYA pada blok surface (tidak menambah/mengurangi tinggi)
--   4. Sama persis seperti Studio PC Paint: material diganti, bentuk tetap
local function bPaint(pos)
  if not pos then return end
  local t=tick(); if t-lPTBT<0.04 then return end; lPTBT=t
  local T=Workspace:FindFirstChild("Terrain"); if not T then return end
  local me=mE[cM]; if not me then return end
  local vs=FILL_VS
  local R=math.max(W,D)/2
  -- Kedalaman cat: cukup beberapa voxel agar material kelihatan (tidak menembus jauh)
  local PAINT_LAYERS = 3
  local cx,cy,cz=pos.X,pos.Y,pos.Z
  task.spawn(function()
    local placed=0
    _rayParams.FilterDescendantsInstances = {T}
    for dx=-R,R,vs do
      for dz=-R,R,vs do
        local dist=math.sqrt(dx*dx+dz*dz)
        if dist<=R then
          -- Falloff: tepi brush agak mulus (bisa skip kolom di tepi)
          local falloff=(math.cos(dist/R*math.pi)+1)*0.5
          if falloff < 0.08 then placed=placed+1; continue end
          local vx,vz=cx+dx,cz+dz

          -- ── Step 1: Temukan top surface dengan raycast dari atas ──
          local topY=nil
          local ok2,hit=pcall(function()
            return workspace:Raycast(
              Vector3.new(vx, cy+120, vz),
              Vector3.new(0,-240,0),
              _rayParams
            )
          end)
          if ok2 and hit then
            topY=hit.Position.Y
          end

          if topY then
            -- ── Step 2: Snap topY ke grid voxel ──
            local snappedTop=math.floor(topY/vs+0.5)*vs

            -- ── Step 3: Paint lapisan surface saja ──
            -- Fill dari (snappedTop - PAINT_LAYERS*vs) sampai snappedTop
            -- Ini mengganti material tanpa menambah/hapus geometry
            local paintSzY=PAINT_LAYERS*vs
            local paintCenterY=snappedTop-(paintSzY/2)+(vs/2)
            pcall(function()
              T:FillBlock(
                CFrame.new(vx, paintCenterY, vz),
                Vector3.new(vs, paintSzY, vs),
                me
              )
            end)
            setMCol(T, me, cM)

            -- ── Step 4: Rekonstruksi bentuk asli di atas snappedTop ──
            -- Jika ada terrain tipis di permukaan, pastikan tidak hilang.
            -- Raycast kedua dari bawah topY untuk cek apakah ada "udara" di atas
            -- → ini memastikan fill hanya mengganti material, bukan menambah tinggi
            local aboveOk,aboveHit=pcall(function()
              return workspace:Raycast(
                Vector3.new(vx, snappedTop+vs*2, vz),
                Vector3.new(0,-vs*4,0),
                _rayParams
              )
            end)
            if aboveOk and aboveHit then
              local aboveY=aboveHit.Position.Y
              if aboveY > snappedTop+vs then
                -- ada terrain di atas snappedTop, fill ulang dengan material baru
                local aboveH=math.ceil((aboveY-snappedTop)/vs)*vs
                pcall(function()
                  T:FillBlock(
                    CFrame.new(vx, snappedTop+aboveH/2, vz),
                    Vector3.new(vs, aboveH, vs),
                    me
                  )
                end)
              end
            end

            -- ── Step 5: Record ke paintData untuk save ──
            local en={
              position=Vector3.new(vx, paintCenterY, vz),
              size=Vector3.new(vs, paintSzY, vs),
              material=cM,
              surfaceY=snappedTop,
              isPaint=true
            }
            table.insert(paintData, en)
            -- Juga masuk tDBM agar terhitung di VX counter
            if not tDBM[cM] then tDBM[cM]={} end
            table.insert(tDBM[cM], {
              position=en.position, size=en.size,
              shape="Balok", material=cM,
              isColorable=colM[cM] or false,
              grR=0, grG=0, grB=0,
              isPaint=true
            })
          end
          placed=placed+1; if placed%60==0 then task.wait() end
        end
      end
    end
  end)
end

-- FLATTEN BRUSH — ratakan terrain ke Y target tertentu
local function bFlatten(pos)
  if not pos then return end
  local t=tick(); if t-lFTBT<0.06 then return end; lFTBT=t
  local T=Workspace:FindFirstChild("Terrain"); if not T then return end
  local me=mE[cM]; if not me then return end
  local vs=FILL_VS
  local R=math.max(W,D)/2
  local str=math.clamp(brushStrength/100, 0.2, 1.0)
  local cx,cy,cz=pos.X,pos.Y,pos.Z
  -- Target Y: pakai ftTargetY jika set, atau ketinggian hit point
  local tY=ftTargetY or cy
  tY=math.floor(tY/vs+0.5)*vs
  brushGroupId=brushGroupId+1; local gid=brushGroupId
  task.spawn(function()
    local placed=0
    for dx=-R,R,vs do
      for dz=-R,R,vs do
        local dist=math.sqrt(dx*dx+dz*dz)
        if dist<=R then
          local falloff=(math.cos(dist/R*math.pi)+1)*0.5
          -- Tepi brush tidak fully flatten, blend ke str
          local blendT=falloff*str
          if blendT<0.15 then placed=placed+1; continue end
          local vx,vz=cx+dx,cz+dz
          local topY=getTerrainTopY(T, vx, vz, cy, 80, 80)
          local finalY=math.floor((topY+(tY-topY)*blendT)/vs+0.5)*vs
          pcall(function()
            if finalY>topY then
              local fillH=finalY-topY
              if fillH>=vs then T:FillBlock(CFrame.new(vx, topY+fillH/2+vs/2, vz), Vector3.new(vs,fillH,vs), me); setMCol(T,me,cM) end
            elseif finalY<topY then
              local clearH=topY-finalY
              if clearH>=vs then T:FillBlock(CFrame.new(vx, finalY+clearH/2+vs/2, vz), Vector3.new(vs,clearH+vs,vs), Enum.Material.Air) end
            end
          end)
          placed=placed+1; if placed%80==0 then task.wait() end
        end
      end
    end
  end)
end

local function svPrj(onDone)
  if isSaving then return end; isSaving=true
  task.spawn(function()
    local ok,err=pcall(function()
      local n=1; while Workspace:FindFirstChild("TP_S"..n) do n=n+1 end
      local PF=Instance.new("Folder"); PF.Name="TP_S"..n; PF.Parent=Workspace
      local aD={}
      -- Collect terrain fill entries
      for _,lst in pairs(tDBM) do for _,e in ipairs(lst) do
        local k=string.format("%.2f,%.2f,%.2f",e.position.X,e.position.Y,e.position.Z)
        if not blowedSet[k] then table.insert(aD,e) end
      end; task.wait() end
      for _,e in ipairs(swD) do
        local k=string.format("%.2f,%.2f,%.2f",e.position.X,e.position.Y,e.position.Z)
        if not blowedSet[k] then table.insert(aD,e) end
      end
      -- Collect paint entries
      for _,e in ipairs(paintData) do table.insert(aD,e) end
      task.wait()
      if #aD==0 then isSaving=false; if onDone then onDone(0) end; return end
      local MAX_CHARS=190000; local chunkIdx=1; local lines={}; local curLen=0
      local function flushChunk()
        if #lines==0 then return end
        local sv3=Instance.new("StringValue"); sv3.Name="_TEP_"..chunkIdx; sv3.Value=table.concat(lines,"\n"); sv3.Parent=PF
        chunkIdx=chunkIdx+1; lines={}; curLen=0
      end
      for i2=1,#aD do
        local e=aD[i2]; local p,s=e.position,e.size
        local row
        if e.isPaint then
          -- Format khusus paint: "PT,x,y,z,sx,sy,sz,material,surfaceY"
          row=string.format("PT,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%s,%.2f",
            p.X,p.Y,p.Z,s.X,s.Y,s.Z,e.material,e.surfaceY or p.Y)
        else
          local shCode; if e.shape=="Bola" then shCode="SP" elseif e.shape=="Silinder" then shCode="CY" elseif e.shape=="Baji" then shCode="WG" else shCode="B" end
          row=string.format("POS,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%s,%s",p.X,p.Y,p.Z,s.X,s.Y,s.Z,shCode,e.material)
        end
        if curLen+#row+1>MAX_CHARS then flushChunk() end
        table.insert(lines,row); curLen=curLen+#row+1
        if i2%500==0 then task.wait() end
      end
      flushChunk()
      local infoSV=Instance.new("StringValue"); infoSV.Name="_TEP_Info"
      infoSV.Value="posv2,chunks="..(chunkIdx-1)..",total="..#aD..",gi="..cGI.."|gri="..cGrI
      infoSV.Parent=PF
      isSaving=false; if onDone then onDone(#aD) end
    end)
    if not ok then isSaving=false; if onDone then onDone(-1) end end
  end)
end
local function ldAllProjects()
  local shDecode={B="Balok",SP="Bola",CY="Silinder",WG="Baji"}
  local T=Workspace:FindFirstChild("Terrain"); local total=0
  local folders={}
  for _,v in ipairs(Workspace:GetChildren()) do
    if v:IsA("Folder") and v:FindFirstChild("_TEP_Info") and (v.Name:match("^TP_S%d+$") or v.Name:match("^TerrainParts")) then table.insert(folders,v) end
  end
  for _,PF2 in ipairs(folders) do
    local infoSV2=PF2:FindFirstChild("_TEP_Info"); if not infoSV2 then continue end
    local gi2=infoSV2.Value:match("gi=(%d+)"); local gri2=infoSV2.Value:match("gri=(%d+)")
    if gi2 and gC[tonumber(gi2)] then cGI=tonumber(gi2) end
    if gri2 and grC[tonumber(gri2)] then cGrI=tonumber(gri2) end
    local chunks2={}
    for _,v in ipairs(PF2:GetChildren()) do
      if v:IsA("StringValue") and v.Name:sub(1,5)=="_TEP_" then local idx2=tonumber(v.Name:sub(6)); if idx2 then chunks2[idx2]=v.Value end end
    end
    local keys3={}; for k in pairs(chunks2) do table.insert(keys3,k) end; table.sort(keys3)
    for _,k in ipairs(keys3) do
      local data2=chunks2[k]; local pos2=1
      while pos2<=#data2 do
        local eol=data2:find("\n",pos2,true) or (#data2+1)
        local line2=data2:sub(pos2,eol-1); pos2=eol+1; line2=line2:match("^%s*(.-)%s*$")
        -- ── POS entry (fill/shape) ──
        if line2:sub(1,3)=="POS" then
          local cx,cy,cz,sw,sh2,sd,shCode,mn=line2:match("POS,([%-%.%d]+),([%-%.%d]+),([%-%.%d]+),([%-%.%d]+),([%-%.%d]+),([%-%.%d]+),(%w+),(%w+)")
          if cx and mn then
            local pos3=Vector3.new(tonumber(cx),tonumber(cy),tonumber(cz))
            local sz4=Vector3.new(tonumber(sw),tonumber(sh2),tonumber(sd))
            local shape2=shDecode[shCode] or "Balok"; local me4=mE[mn]
            if not tDBM[mn] then tDBM[mn]={} end
            local en2={position=pos3,size=sz4,shape=shape2,material=mn,isColorable=colM[mn]or false,grR=0,grG=0,grB=0}
            table.insert(tDBM[mn],en2); table.insert(undoStack,en2)
            if T and me4 then
              pcall(function()
                if shape2=="Bola" then T:FillBall(pos3, math.max(sz4.X,sz4.Y,sz4.Z)/2, me4)
                elseif shape2=="Silinder" then T:FillCylinder(CFrame.new(pos3), sz4.Y, math.max(sz4.X,sz4.Z)/2, me4)
                else T:FillBlock(CFrame.new(pos3),sz4,me4) end
                if gOM[mn] then T:SetMaterialColor(me4,gC[cGI].color) elseif gdOM[mn] then T:SetMaterialColor(me4,grC[cGrI].color) end
              end)
            end
            total=total+1; if total%80==0 then task.wait() end
          end
        -- ── PT entry (paint) ──
        elseif line2:sub(1,2)=="PT" then
          local px,py,pz,sw,sh2,sd,mn,sY=line2:match("PT,([%-%.%d]+),([%-%.%d]+),([%-%.%d]+),([%-%.%d]+),([%-%.%d]+),([%-%.%d]+),(%w+),([%-%.%d]+)")
          if px and mn then
            local pos3=Vector3.new(tonumber(px),tonumber(py),tonumber(pz))
            local sz4=Vector3.new(tonumber(sw),tonumber(sh2),tonumber(sd))
            local me4=mE[mn]
            -- Restore paint entry ke tDBM
            if not tDBM[mn] then tDBM[mn]={} end
            local en2={position=pos3,size=sz4,shape="Balok",material=mn,isColorable=colM[mn]or false,grR=0,grG=0,grB=0,isPaint=true,surfaceY=tonumber(sY) or pos3.Y}
            table.insert(tDBM[mn],en2); table.insert(paintData,en2)
            if T and me4 then
              pcall(function()
                T:FillBlock(CFrame.new(pos3),sz4,me4)
                if gOM[mn] then T:SetMaterialColor(me4,gC[cGI].color) elseif gdOM[mn] then T:SetMaterialColor(me4,grC[cGrI].color) end
              end)
            end
            total=total+1; if total%80==0 then task.wait() end
          end
        end
      end; task.wait()
    end
  end
  sGCP(); return total
end

-- ════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════
--  BANGUN UI PANEL  (Redesign: Studio Toolbar Style, Gray)
-- ════════════════════════════════════════════════════════════

-- Palette (globals agar bisa diakses lintas scope)
local S_BG      = Color3.fromRGB(46, 46, 46)
local S_BG1     = Color3.fromRGB(38, 38, 38)
local S_BG2     = Color3.fromRGB(55, 55, 55)
local S_BG3     = Color3.fromRGB(62, 62, 62)
local S_BG4     = Color3.fromRGB(32, 32, 32)
local S_BORDER  = Color3.fromRGB(28, 28, 28)
local S_BORDER2 = Color3.fromRGB(70, 70, 70)
local S_ACCENT  = Color3.fromRGB(0, 162, 255)
local S_TEXT    = Color3.fromRGB(230, 230, 230)
local S_MUTED   = Color3.fromRGB(150, 150, 150)
local S_DIM     = Color3.fromRGB(80, 80, 80)
local S_GREEN   = Color3.fromRGB(60, 180, 60)
local S_RED     = Color3.fromRGB(200, 60, 60)
local S_GOLD    = Color3.fromRGB(220, 170, 40)
local S_ORANGE  = Color3.fromRGB(210, 110, 30)
local S_PURPLE  = Color3.fromRGB(120, 80, 200)

PW = 300
PH = 300


local terrainDone      = false
local terrainActivated = false

local function injectTerrain()
    if terrainDone then return end
    local tb = findToolbar(); if not tb then return end
    if tb:FindFirstChild(PFX.."Btn_Terrain") then terrainDone=true; return end

    -- Bersihkan instance lama
    pcall(function()
        local old = CoreGui:FindFirstChild(PFX.."TerrainGui")
        if old then old:Destroy() end
    end)

local tbGui = Instance.new("ScreenGui")
tbGui.Name           = PFX.."TerrainGui"
tbGui.ResetOnSpawn   = false
tbGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
tbGui.IgnoreGuiInset = true
tbGui.DisplayOrder   = 9999
tbGui.Parent         = CoreGui

-- ════════════════════════════════════════════════════════════
--  HELPER UI FUNCTIONS
-- ════════════════════════════════════════════════════════════
local function makeDrag(frame, handle)
  local h = handle or frame
  local dragging, dragStart, startPos = false, nil, nil
  h.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true; dragStart = input.Position; startPos = frame.Position
      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then dragging = false end
      end)
    end
  end)
  h.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
      local d = input.Position - dragStart
      frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
  end)
end

local function mkFrame(parent, x, y, w, h2, bg, zi)
  local f = Instance.new("Frame", parent)
  f.Position = UDim2.new(0,x,0,y); f.Size = UDim2.new(0,w,0,h2)
  f.BackgroundColor3 = bg or S_BG2; f.BorderSizePixel = 0; f.ZIndex = zi or 11
  return f
end
local function mkLbl(parent, x, y, w, h2, txt, tc, ts, xa, fnt)
  local l = Instance.new("TextLabel", parent)
  l.Position = UDim2.new(0,x,0,y); l.Size = UDim2.new(0,w,0,h2)
  l.BackgroundTransparency = 1; l.Text = txt; l.TextSize = ts or 10
  l.Font = fnt or Enum.Font.GothamBold; l.TextColor3 = tc or S_TEXT
  l.TextXAlignment = xa or Enum.TextXAlignment.Left; l.ZIndex = 12
  return l
end
local function mkCorner(parent, r)
  local c = Instance.new("UICorner", parent); c.CornerRadius = UDim.new(0, r or 4); return c
end
local function mkStroke(parent, col, thick, trans)
  local s = Instance.new("UIStroke", parent)
  s.Color = col or S_BORDER; s.Thickness = thick or 1; s.Transparency = trans or 0
  return s
end
-- ════════════════════════════════════════════════════════════
--  VECTOR ICON SYSTEM — 100% Frame-based, no asset dependency
--  Setiap icon digambar manual pakai Frame rects, mirip Studio PC
-- ════════════════════════════════════════════════════════════
local function mkIcon(parent, x, y, sz, iconKey, col)
  local c = col or S_ACCENT
  -- container transparan
  local f = Instance.new("Frame", parent)
  f.Position = UDim2.new(0,x,0,y); f.Size = UDim2.new(0,sz,0,sz)
  f.BackgroundTransparency = 1; f.ZIndex = 15; f.ClipsDescendants = false
  -- primitive helpers
  local function rect(px,py,pw,ph,rc,rnd)
    if pw<=0 or ph<=0 then return end
    local l=Instance.new("Frame",f)
    l.BackgroundColor3=rc or c; l.BorderSizePixel=0
    l.Position=UDim2.new(0,math.floor(px),0,math.floor(py))
    l.Size=UDim2.new(0,math.max(1,math.floor(pw)),0,math.max(1,math.floor(ph)))
    l.ZIndex=16
    if rnd then Instance.new("UICorner",l).CornerRadius=UDim.new(0,rnd) end
    return l
  end
  local function circ(px,py,r,rc)
    return rect(px-r,py-r,r*2,r*2,rc,r)
  end
  -- scale factor
  local S=sz/16  -- icons designed at 16px base
  local dim = Color3.new(c.R*0.45, c.G*0.45, c.B*0.45)

  -- ══ TERRAIN: diamond/cube shape (add block to ground) ══
  if iconKey=="TERRAIN" then
    -- ground line
    rect(0,11*S,16*S,2*S,dim)
    -- cube top face (parallelogram via 3 rects)
    rect(4*S,2*S,8*S,4*S,c)
    -- cube left face
    rect(1*S,5*S,5*S,6*S,dim)
    -- cube right face
    rect(6*S,5*S,9*S,6*S, Color3.new(c.R*0.7,c.G*0.7,c.B*0.7))
    -- plus sign on top
    rect(7*S,3*S,2*S,2*S,Color3.new(1,1,1))
    rect(6*S,4*S,4*S,0.5*S+1,Color3.new(1,1,1))

  -- ══ REPLACE / AUTO-CONVERT: two arrows looping ══
  elseif iconKey=="REPLACE" then
    -- top arrow right
    rect(1*S,2*S,10*S,2*S,c)
    rect(9*S,0*S,4*S,4*S,dim) -- arrowhead box
    rect(10*S,1*S,3*S,2*S,c) -- tip
    -- bottom arrow left
    rect(5*S,12*S,10*S,2*S,c)
    rect(1*S,10*S,4*S,4*S,dim)
    rect(2*S,11*S,3*S,2*S,c)
    -- connecting verticals
    rect(13*S,2*S,2*S,6*S,c)
    rect(1*S,8*S,2*S,6*S,c)

  -- ══ SMOOTH / USAP: flat brush sweeping left ══
  elseif iconKey=="SMOOTH" then
    -- brush body diagonal
    rect(1*S,9*S,8*S,2*S,c,1)
    rect(3*S,7*S,8*S,2*S,c,1)
    rect(5*S,5*S,8*S,2*S,c,1)
    -- flat ground result
    rect(0,13*S,16*S,2*S,dim,1)
    -- handle
    rect(10*S,1*S,2*S,7*S,Color3.new(c.R*0.6,c.G*0.6,c.B*0.6),1)

  -- ══ STACK / TUMPUK: 3 layered blocks ══
  elseif iconKey=="STACK" then
    -- layer 3 (top, smallest)
    rect(4*S,1*S,8*S,3*S,c,1)
    -- layer 2 (middle)
    rect(2*S,5*S,12*S,3*S, Color3.new(c.R*0.75,c.G*0.75,c.B*0.75),1)
    -- layer 1 (bottom, biggest)
    rect(0,9*S,16*S,3*S,dim,1)
    -- shadow lines
    rect(0,12*S,16*S,1*S,Color3.new(0,0,0))

  -- ══ FLATTEN / PLANT: flat plane + level line ══
  elseif iconKey=="FLATTEN" then
    -- ground block
    rect(0,10*S,16*S,4*S,dim,1)
    -- level indicator line (bright)
    rect(0,9*S,16*S,2*S,c,1)
    -- arrow pointing down to level
    rect(7*S,2*S,2*S,7*S,c)
    rect(4*S,6*S,8*S,2*S,c) -- arrowhead h
    rect(5*S,7*S,6*S,2*S,c)
    rect(6*S,8*S,4*S,2*S,c)

  -- ══ BLOWER / ERASER: wind blast erasing terrain ══
  elseif iconKey=="BLOWER" then
    -- 3 wind streaks
    rect(0,3*S,10*S,2*S,c,1)
    rect(0,7*S,13*S,2*S, Color3.new(c.R*0.8,c.G*0.8,c.B*0.8),1)
    rect(0,11*S,8*S,2*S,dim,1)
    -- arrowhead (right)
    rect(10*S,1*S,2*S,6*S,c)
    rect(12*S,3*S,2*S,2*S,c)
    rect(14*S,4*S,2*S,2*S,c) -- tip pixel

  -- ══ TUNNEL / GALI: arch/tunnel shape ══
  elseif iconKey=="TUNNEL" then
    -- ground line
    rect(0,14*S,16*S,2*S,dim)
    -- left wall
    rect(0,6*S,3*S,8*S,c)
    -- right wall
    rect(13*S,6*S,3*S,8*S,c)
    -- arch top (3 segments approximating arc)
    rect(0,4*S,6*S,3*S,c)
    rect(5*S,1*S,6*S,4*S,c)
    rect(10*S,4*S,6*S,3*S,c)
    -- hollow inside (cut out)
    rect(3*S,6*S,10*S,8*S,Color3.fromRGB(28,28,28))

  -- ══ TREE / POHON: tree silhouette ══
  elseif iconKey=="TREE" then
    -- trunk
    rect(6*S,11*S,4*S,5*S, Color3.fromRGB(120,80,40))
    -- canopy 3 layers
    rect(3*S,8*S,10*S,4*S,c,2)
    rect(2*S,5*S,12*S,4*S, Color3.new(c.R*0.85,c.G*0.85,c.B*0.85),2)
    rect(4*S,2*S,8*S,4*S, Color3.new(c.R*0.7,c.G*0.7,c.B*0.7),2)

  -- ══ BUKIT / HILL: smooth dome hill ══
  elseif iconKey=="BUKIT" then
    -- ground
    rect(0,13*S,16*S,3*S,dim)
    -- hill dome (4 steps approximating bell curve)
    rect(1*S,11*S,14*S,2*S,c)
    rect(2*S,8*S,12*S,3*S,c)
    rect(3*S,6*S,10*S,2*S,c)
    rect(5*S,4*S,6*S,2*S, Color3.new(c.R*0.8,c.G*0.8,c.B*0.8))
    rect(6*S,3*S,4*S,2*S, Color3.new(c.R*0.65,c.G*0.65,c.B*0.65))

  -- ══ GUNDUK: mound + upward drag arrow ══
  elseif iconKey=="GUNDUK" then
    -- ground
    rect(0,14*S,16*S,2*S,dim)
    -- small mound
    rect(2*S,11*S,12*S,3*S,c)
    rect(4*S,8*S,8*S,3*S, Color3.new(c.R*0.75,c.G*0.75,c.B*0.75))
    rect(6*S,6*S,4*S,2*S, Color3.new(c.R*0.6,c.G*0.6,c.B*0.6))
    -- up arrow (drag indicator)
    rect(7*S,0,2*S,6*S,Color3.new(1,1,0.2))
    rect(4*S,3*S,8*S,1.5*S,Color3.new(1,1,0.2))
    rect(5*S,1.5*S,6*S,1.5*S,Color3.new(1,1,0.2))

  -- ══ MATERIAL: 3 colored dots (material palette) ══
  elseif iconKey=="MATERIAL" then
    circ(4*S,4*S,3*S, Color3.fromRGB(75,151,75))
    circ(12*S,4*S,3*S, Color3.fromRGB(194,178,128))
    circ(4*S,12*S,3*S, Color3.fromRGB(110,110,110))
    circ(12*S,12*S,3*S, Color3.fromRGB(0,162,255))

  -- ══ SHAPE: square outline (brush shape) ══
  elseif iconKey=="SHAPE" then
    -- outer square outline
    rect(1*S,1*S,14*S,2*S,c)  -- top
    rect(1*S,13*S,14*S,2*S,c) -- bottom
    rect(1*S,1*S,2*S,14*S,c)  -- left
    rect(13*S,1*S,2*S,14*S,c) -- right
    -- inner dot
    circ(8*S,8*S,2*S,dim)

  -- ══ SIZE: bidirectional resize arrows ══
  elseif iconKey=="SIZE" then
    -- horizontal arrow
    rect(0,7*S,16*S,2*S,c)
    rect(0,5*S,3*S,6*S,c)   -- left arrowhead
    rect(13*S,5*S,3*S,6*S,c) -- right arrowhead
    -- vertical arrow
    rect(7*S,0,2*S,16*S,dim)
    rect(5*S,0,6*S,3*S,dim)   -- top arrowhead
    rect(5*S,13*S,6*S,3*S,dim) -- bottom arrowhead

  -- ══ PART: 3D box (BasePart) ══
  elseif iconKey=="PART" then
    rect(3*S,4*S,10*S,8*S,c,1)           -- front face
    rect(3*S,4*S,10*S,2*S,Color3.new(c.R*0.7,c.G*0.7,c.B*0.7),1) -- top face
    rect(3*S,4*S,2*S,8*S,dim,1)          -- left face
    -- top parallelogram
    rect(5*S,2*S,10*S,3*S,Color3.new(c.R*0.85,c.G*0.85,c.B*0.85))
    -- right side
    rect(13*S,4*S,2*S,8*S,Color3.new(c.R*0.55,c.G*0.55,c.B*0.55))

  -- ══ AUTOCONV: circular loop arrow ══
  elseif iconKey=="AUTOCONV" then
    -- circle arc (top 3/4)
    rect(4*S,1*S,8*S,2*S,c,1)
    rect(1*S,3*S,2*S,8*S,c,1)
    rect(13*S,3*S,2*S,6*S,c,1)
    rect(4*S,12*S,6*S,2*S,c,1)
    -- arrowhead at bottom right
    rect(9*S,10*S,4*S,2*S,c)
    rect(11*S,8*S,2*S,2*S,c)

  -- ══ CONVERT (>>): double forward arrow ══
  elseif iconKey=="CONVERT" then
    -- first arrow
    rect(0,4*S,6*S,2*S,c)
    rect(4*S,2*S,4*S,6*S,c) -- v-shape right
    rect(6*S,3*S,2*S,4*S,c)
    -- second arrow (shifted right)
    rect(7*S,4*S,6*S,2*S,c)
    rect(11*S,2*S,4*S,6*S,c)
    rect(13*S,3*S,2*S,4*S,c)
    -- tip pixel
    rect(15*S,4*S,1*S,2*S,c)

  -- ══ DELETE / CLEAR: X inside box ══
  elseif iconKey=="DELETE" then
    -- box outline
    rect(1*S,1*S,14*S,2*S,c)
    rect(1*S,13*S,14*S,2*S,c)
    rect(1*S,1*S,2*S,14*S,c)
    rect(13*S,1*S,2*S,14*S,c)
    -- X cross
    rect(3*S,3*S,2*S,10*S,dim)
    rect(11*S,3*S,2*S,10*S,dim)
    rect(3*S,3*S,10*S,2*S,dim)
    rect(3*S,11*S,10*S,2*S,dim)

  -- ══ UNDO: counter-clockwise arc + arrow ══
  elseif iconKey=="UNDO" then
    -- arc body
    rect(2*S,4*S,2*S,8*S,c,1)
    rect(4*S,2*S,8*S,2*S,c,1)
    rect(12*S,4*S,2*S,6*S,c,1)
    rect(4*S,12*S,8*S,2*S,c,1)
    -- left arrowhead (pointing up-left)
    rect(0,2*S,4*S,2*S,c)
    rect(0,2*S,2*S,6*S,c)
    rect(2*S,4*S,4*S,2*S,c)

  -- ══ EXPORT: box with up arrow ══
  elseif iconKey=="EXPORT" then
    -- box bottom
    rect(0,10*S,16*S,2*S,c)
    rect(0,10*S,2*S,6*S,c)
    rect(14*S,10*S,2*S,6*S,c)
    rect(0,14*S,16*S,2*S,c)
    -- up arrow
    rect(7*S,1*S,2*S,9*S,c)
    rect(4*S,3*S,8*S,2*S,c)
    rect(5*S,1*S,6*S,2*S,c)
    rect(6*S,0,4*S,2*S,c)

  -- ══ SAVE / FLOPPY: save icon ══
  elseif iconKey=="SAVE" then
    -- outer body
    rect(0,0,14*S,14*S,c,2)
    -- notch top-right
    rect(10*S,0,4*S,5*S,dim)
    -- label area (lighter)
    rect(2*S,8*S,10*S,5*S, Color3.new(c.R*0.5,c.G*0.5,c.B*0.5),1)
    -- disk window
    rect(3*S,1*S,5*S,4*S, Color3.new(0.9,0.9,0.9),1)
    -- down arrow overlay
    rect(6*S,2*S,2*S,5*S,Color3.new(1,1,1))

  -- ══ LOAD: folder open ══
  elseif iconKey=="LOAD" then
    -- folder back
    rect(0,5*S,14*S,9*S,dim,1)
    -- folder tab
    rect(0,3*S,6*S,4*S,dim,1)
    -- folder front (lighter)
    rect(1*S,7*S,13*S,7*S,c,1)
    -- arrow pointing right (open)
    rect(3*S,9*S,7*S,2*S,Color3.new(1,1,1))
    rect(8*S,7*S,2*S,6*S,Color3.new(1,1,1))

  -- ══ MOUNTAIN (runcing/sharp): triangle peak ══
  elseif iconKey=="MOUNTAIN" then
    -- ground
    rect(0,13*S,16*S,3*S,dim)
    -- sharp peak (narrow triangle)
    rect(7*S,1*S,2*S,12*S,c)
    rect(5*S,4*S,6*S,2*S,c)
    rect(4*S,6*S,8*S,2*S,c)
    rect(3*S,8*S,10*S,2*S,c)
    rect(2*S,10*S,12*S,3*S,c)

  else
    -- fallback: question mark style dot
    circ(8*S,8*S,5*S,Color3.fromRGB(80,80,80))
    rect(7*S,5*S,2*S,5*S,c)
    rect(7*S,11*S,2*S,2*S,c)
  end
  return f
end

-- Helper: recolor all Frame children of an icon container
local function recolorIcon(ico, newCol)
  if not ico then return end
  for _,ch in ipairs(ico:GetDescendants()) do
    if ch:IsA("Frame") then ch.BackgroundColor3 = newCol end
  end
end
local function studioBtn(parent, x, y, w, h2, txt, bgColor, textColor)
  local b = Instance.new("TextButton", parent)
  b.Position = UDim2.new(0,x,0,y); b.Size = UDim2.new(0,w,0,h2)
  b.BackgroundColor3 = bgColor or S_BG2; b.BorderSizePixel = 0
  b.Text = txt; b.TextSize = 10; b.Font = Enum.Font.GothamBold
  b.TextColor3 = textColor or S_TEXT; b.AutoButtonColor = false; b.ZIndex = 12
  mkCorner(b,3); mkStroke(b,S_BORDER,1,0)
  b.MouseEnter:Connect(function() b.BackgroundColor3 = S_BG3 end)
  b.MouseLeave:Connect(function() b.BackgroundColor3 = bgColor or S_BG2 end)
  return b
end
local function studioSec(parent, y, txt)
  local row = mkFrame(parent,0,y,PW,24,S_BG1,11)
  mkStroke(row,S_BORDER,1,0)
  mkFrame(row,8,10,3,10,S_ACCENT,12)
  mkLbl(row,16,5,PW-24,14,txt,S_MUTED,9,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  return row
end

-- Toggle row: returns card, overlayBtn, pillLabel, setOnFn
local function studioToggleRow(parent, x, y, w, h2, iconKey, nameTxt, descTxt, accentCol)
  local card = mkFrame(parent,x,y,w,h2,S_BG2,12); mkCorner(card,4); mkStroke(card,S_BORDER,1,0)
  local iw = mkFrame(card,8,h2/2-12,24,24,S_BG4,13); mkCorner(iw,3)
  local il = mkIcon(iw, 4, 4, 16, iconKey, S_MUTED)
  mkLbl(card,38,6,w-100,13,nameTxt,S_TEXT,9,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  mkLbl(card,38,20,w-100,11,descTxt,S_MUTED,8,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  local pill = mkFrame(card,w-46,h2/2-8,38,16,S_BG4,13); mkCorner(pill,8); mkStroke(pill,S_DIM,1,0)
  local pTxt = mkLbl(pill,0,1,38,14,"OFF",S_MUTED,8,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
  local btn2 = Instance.new("TextButton",card)
  btn2.Size=UDim2.new(1,0,1,0); btn2.BackgroundTransparency=1; btn2.Text=""; btn2.ZIndex=14; btn2.BorderSizePixel=0
  local function setOn(v)
    if v then
      local r = math.clamp(math.floor(accentCol.R*25+40),0,255)/255
      local g = math.clamp(math.floor(accentCol.G*25+40),0,255)/255
      local b = math.clamp(math.floor(accentCol.B*25+40),0,255)/255
      card.BackgroundColor3 = Color3.new(r,g,b); mkStroke(card,accentCol,1,0.2)
      iw.BackgroundColor3 = Color3.new(accentCol.R*0.12,accentCol.G*0.12,accentCol.B*0.12)
      recolorIcon(il, accentCol)
      pill.BackgroundColor3 = accentCol; pTxt.TextColor3 = Color3.new(1,1,1); pTxt.Text = "ON"
      mkStroke(pill,accentCol,1,0)
    else
      card.BackgroundColor3 = S_BG2; mkStroke(card,S_BORDER,1,0)
      iw.BackgroundColor3 = S_BG4
      recolorIcon(il, S_MUTED)
      pill.BackgroundColor3 = S_BG4; pTxt.TextColor3 = S_MUTED; pTxt.Text = "OFF"
      mkStroke(pill,S_DIM,1,0)
    end
  end
  return card, btn2, pTxt, setOn
end

-- Action card row
local function studioActionCard(parent, x, y, w, h2, iconKey, titleTxt, subtTxt, accentCol)
  local card = mkFrame(parent,x,y,w,h2,S_BG2,12); mkCorner(card,4); mkStroke(card,S_BORDER,1,0)
  mkFrame(card,0,0,3,h2,accentCol,13)
  local iw = mkFrame(card,10,h2/2-12,24,24,S_BG4,13); mkCorner(iw,3)
  mkIcon(iw, 4, 4, 16, iconKey, accentCol)
  mkLbl(card,40,7,w-60,13,titleTxt,S_TEXT,9,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  mkLbl(card,40,22,w-60,11,subtTxt,S_MUTED,8,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  mkLbl(card,w-18,h2/2-7,12,14,">",S_MUTED,12,Enum.TextXAlignment.Center)
  local btn2 = Instance.new("TextButton",card)
  btn2.Size=UDim2.new(1,0,1,0); btn2.BackgroundTransparency=1; btn2.Text=""; btn2.ZIndex=14; btn2.BorderSizePixel=0
  btn2.MouseEnter:Connect(function() card.BackgroundColor3 = S_BG3 end)
  btn2.MouseLeave:Connect(function() card.BackgroundColor3 = S_BG2 end)
  return btn2
end

-- Dial widget
local function studioDial(parent, x, y, label, initVal, maxVal, dialColor)
  local dW = math.floor((PW-24)/3)
  local card = mkFrame(parent,x,y,dW,90,S_BG2,12); mkCorner(card,4); mkStroke(card,S_BORDER,1,0)
  mkLbl(card,0,6,dW,12,label,S_MUTED,8,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
  local valBox = mkFrame(card,dW/2-20,22,40,26,S_BG4,13); mkCorner(valBox,3); mkStroke(valBox,S_BORDER,1,0)
  local vLbl = mkLbl(valBox,0,4,40,18,tostring(initVal),S_TEXT,13,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
  mkLbl(card,0,52,dW,10,"stud",S_MUTED,7,Enum.TextXAlignment.Center)
  local bm = studioBtn(card,4,64,28,20,"−",S_BG4,dialColor); bm.TextSize=14
  local bp = studioBtn(card,dW-32,64,28,20,"+",S_BG4,dialColor); bp.TextSize=14
  return vLbl, bm, bp
end

-- Slider widget
local function studioSlider(parent, x, y, w, label, initVal, minV, maxV, fillColor, iconKey)
  local container = mkFrame(parent,x,y,w,52,S_BG2,12); mkCorner(container,4); mkStroke(container,S_BORDER,1,0)
  mkIcon(container, 8, 8, 14, iconKey or "SIZE", fillColor)
  mkLbl(container,24,8,w-80,14,label,S_TEXT,9,Enum.TextXAlignment.Left)
  local numBox = mkFrame(container,w-46,6,38,18,S_BG4,13); mkCorner(numBox,3); mkStroke(numBox,S_BORDER,1,0)
  local nTxt = mkLbl(numBox,0,2,38,14,tostring(initVal),S_TEXT,10,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
  local track = mkFrame(container,8,30,w-16,6,S_BG4,13); mkCorner(track,99); mkStroke(track,S_BORDER,1,0)
  local frac = (initVal-minV)/(maxV-minV)
  local fill = mkFrame(track,0,0,math.floor((w-16)*frac),6,fillColor,14); mkCorner(fill,99)
  local thumb = Instance.new("Frame")
  thumb.Size=UDim2.new(0,10,0,10); thumb.AnchorPoint=Vector2.new(1,0.5)
  thumb.Position=UDim2.new(1,2,0.5,0); thumb.BackgroundColor3=S_TEXT
  thumb.BorderSizePixel=0; thumb.ZIndex=15; thumb.Parent=fill
  mkCorner(thumb,5); mkStroke(thumb,fillColor,1,0)
  local curVal=initVal; local isDrag=false
  local function applyFrac(fr)
    fr=math.clamp(fr,0,1); curVal=math.floor(fr*(maxV-minV)+minV)
    fill.Size=UDim2.new(fr,0,1,0); nTxt.Text=tostring(curVal)
  end
  local function posToFrac(sx)
    return math.clamp((sx-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
  end
  track.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
      isDrag=true; applyFrac(posToFrac(inp.Position.X))
    end
  end)
  track.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then isDrag=false end
  end)
  track.InputChanged:Connect(function(inp)
    if isDrag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
      applyFrac(posToFrac(inp.Position.X))
    end
  end)
  local function getVal() return curVal end
  local function setVal(v)
    v=math.clamp(v,minV,maxV); curVal=v
    fill.Size=UDim2.new((v-minV)/(maxV-minV),0,1,0); nTxt.Text=tostring(curVal)
  end
  return container, getVal, setVal
end

-- ════════════════════════════════════════════════════════════
--  MAIN PANEL
-- ════════════════════════════════════════════════════════════
local panel = Instance.new("Frame")
panel.Name="MainPanel"; panel.Size=UDim2.new(0,PW,0,PH)
panel.Position=UDim2.new(0,80,0.5,-290)
panel.BackgroundColor3=S_BG; panel.BorderSizePixel=0
panel.ClipsDescendants=true; panel.Visible=false
panel.ZIndex=10; panel.Parent=tbGui
mkCorner(panel,6); mkStroke(panel,S_BORDER,1,0)

-- Header strip
local HEADER_H = 50
local header = mkFrame(panel,0,0,PW,HEADER_H,S_BG1,13)
mkStroke(header,S_BORDER,1,0)
do
  local logoBox = mkFrame(header,10,9,32,32,S_BG4,14); mkCorner(logoBox,4); mkStroke(logoBox,S_BORDER2,1,0)
  mkIcon(logoBox, 8, 8, 16, "TERRAIN", S_ACCENT).ZIndex=15
  mkLbl(header,50,4,200,14,"TERRAIN BRUSH",S_TEXT,12,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  mkLbl(header,50,20,200,11,"Advanced Terrain System v7.0",S_MUTED,7,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  local credLine = mkLbl(header,50,33,PW-120,11,"by SYGKMUNII  ·  MZYY STUDIO GAMING",S_ACCENT,7,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  credLine.TextTransparency=0.2
  mkFrame(header,0,HEADER_H-1,PW,1,S_BORDER,14)
end
local vxBox = mkFrame(header,PW-74,15,62,20,S_BG4,14); mkCorner(vxBox,3); mkStroke(vxBox,S_BORDER,1,0)
local vxLbl = mkLbl(vxBox,4,3,54,14,"VX: 0",S_MUTED,8,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
makeDrag(panel,header)

-- Nav tab bar — 5 tabs: TERRAIN | LIST | MODES | AKSI | PROJECT
local TAB_H = 32
local navBar = mkFrame(panel,0,HEADER_H,PW,TAB_H,S_BG1,13)
mkFrame(navBar,0,TAB_H-1,PW,1,S_BORDER,14)
local NUM_TABS = 5
for i=1,NUM_TABS-1 do mkFrame(navBar,i*math.floor(PW/NUM_TABS),6,1,TAB_H-12,S_BORDER2,14) end

local navTabs = {}
local TAB_NAMES = {"TERRAIN","LIST","MODES","AKSI","PROJECT"}
local TAB_W = math.floor(PW/NUM_TABS)
for i,tn in ipairs(TAB_NAMES) do
  local nb = Instance.new("TextButton",navBar)
  nb.Position=UDim2.new(0,(i-1)*TAB_W,0,0); nb.Size=UDim2.new(0,TAB_W,0,TAB_H-1)
  nb.BackgroundTransparency=1; nb.BorderSizePixel=0
  nb.Text=tn; nb.TextSize=7; nb.Font=Enum.Font.GothamBold
  nb.TextColor3=S_MUTED; nb.ZIndex=14
  local indicator = mkFrame(nb,0,TAB_H-3,TAB_W,2,S_ACCENT,15); indicator.Visible=false
  navTabs[i]={btn=nb,ind=indicator}
end

-- Scroll area
local CONTENT_Y = HEADER_H+TAB_H
scroll = Instance.new("ScrollingFrame",panel)
scroll.Size=UDim2.new(0,PW,0,PH-CONTENT_Y-36)
scroll.Position=UDim2.new(0,0,0,CONTENT_Y)
scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
scroll.ScrollBarThickness=4; scroll.ScrollBarImageColor3=S_BORDER2
scroll.ScrollingDirection=Enum.ScrollingDirection.Y
scroll.CanvasSize=UDim2.new(0,0,0,900); scroll.ZIndex=11

local pages = {}
for i=1,5 do
  local pg = mkFrame(scroll,0,0,PW,900,Color3.new(),11)
  pg.BackgroundTransparency=1; pg.Visible=(i==1); pages[i]=pg
end

local activeTab = 1
local function switchTab(idx)
  activeTab=idx
  for i,pg in ipairs(pages) do pg.Visible=(i==idx) end
  for i,t in ipairs(navTabs) do
    t.btn.TextColor3=(i==idx) and S_TEXT or S_MUTED
    t.btn.BackgroundTransparency=(i==idx) and 0.85 or 1
    if i==idx then t.btn.BackgroundColor3=S_BG2 end
    t.ind.Visible=(i==idx)
  end
  scroll.CanvasPosition=Vector2.new(0,0)
end
for i,t in ipairs(navTabs) do t.btn.MouseButton1Click:Connect(function() switchTab(i) end) end

-- ════════════════════════════════════════════════════════════
--  PAGE 1 BUILDER — TERRAIN (hanya info aktif + bentuk + ukuran)
--  Material & warna dipilih di tab LIST
-- ════════════════════════════════════════════════════════════
local matNameLbl, matDot, shNameLbl
local gcDot, gCBtn, gCNameLbl, grDot, grCBtn, grCNameLbl
local wLbl, hLbl, dLbl
local matNext, matPrev, shNext, shPrev
local gNB, gPB, grNB, grPB
local wP, wM, hP, hM, dP, dM

do
  local pg1 = pages[1]; local Y1 = 4

  -- ── INFO: Pilihan Aktif (readonly, hanya tampilan) ──────
  studioSec(pg1,Y1,"Pilihan Aktif  ·  Ubah di tab LIST"); Y1=Y1+28

  -- Baris info material aktif
  local infoMat = mkFrame(pg1,8,Y1,PW-16,30,S_BG2,12); mkCorner(infoMat,4); mkStroke(infoMat,S_BORDER,1,0)
  mkLbl(infoMat,10,5,60,12,"MATERIAL :",S_MUTED,7,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  matDot = mkFrame(infoMat,72,8,14,14,mCol[cM] or S_DIM,13); mkCorner(matDot,3)
  matNameLbl = mkLbl(infoMat,90,7,PW-110,16,mN[cM] or cM,S_TEXT,10,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  -- hint → LIST
  local hint1 = Instance.new("TextButton",infoMat)
  hint1.Size=UDim2.new(1,0,1,0); hint1.BackgroundTransparency=1; hint1.Text=""; hint1.ZIndex=14; hint1.BorderSizePixel=0
  hint1.MouseButton1Click:Connect(function() switchTab(2) end)   -- buka tab LIST
  Y1=Y1+36

  -- Baris info warna rumput aktif
  local infoGc = mkFrame(pg1,8,Y1,PW-16,30,S_BG2,12); mkCorner(infoGc,4); mkStroke(infoGc,S_BORDER,1,0)
  mkLbl(infoGc,10,5,70,12,"RUMPUT :",S_MUTED,7,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  gcDot = mkFrame(infoGc,72,8,14,14,gC[cGI].color,13); mkCorner(gcDot,5)
  gCNameLbl = mkLbl(infoGc,90,7,PW-140,16,gC[cGI].name,S_TEXT,10,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  gCBtn = mkFrame(infoGc,PW-42,8,28,14,gC[cGI].color,13); mkCorner(gCBtn,3)
  local hint2 = Instance.new("TextButton",infoGc)
  hint2.Size=UDim2.new(1,0,1,0); hint2.BackgroundTransparency=1; hint2.Text=""; hint2.ZIndex=14; hint2.BorderSizePixel=0
  hint2.MouseButton1Click:Connect(function() switchTab(2) end)
  Y1=Y1+36

  -- Baris info warna tanah aktif
  local infoGr = mkFrame(pg1,8,Y1,PW-16,30,S_BG2,12); mkCorner(infoGr,4); mkStroke(infoGr,S_BORDER,1,0)
  mkLbl(infoGr,10,5,70,12,"TANAH :",S_MUTED,7,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  grDot = mkFrame(infoGr,72,8,14,14,grC[cGrI].color,13); mkCorner(grDot,5)
  grCNameLbl = mkLbl(infoGr,90,7,PW-140,16,grC[cGrI].name,S_TEXT,10,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  grCBtn = mkFrame(infoGr,PW-42,8,28,14,grC[cGrI].color,13); mkCorner(grCBtn,3)
  local hint3 = Instance.new("TextButton",infoGr)
  hint3.Size=UDim2.new(1,0,1,0); hint3.BackgroundTransparency=1; hint3.Text=""; hint3.ZIndex=14; hint3.BorderSizePixel=0
  hint3.MouseButton1Click:Connect(function() switchTab(2) end)
  Y1=Y1+36

  -- Hint kecil "Klik baris di atas untuk buka LIST"
  local hintLbl = mkLbl(pg1,8,Y1,PW-16,14,"  ↑  Klik baris di atas untuk pilih material & warna di tab LIST",S_ACCENT,7,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  hintLbl.TextTransparency=0.3
  Y1=Y1+20

  -- ── BENTUK BRUSH ───────────────────────────────────────
  studioSec(pg1,Y1,"Bentuk Brush"); Y1=Y1+28
  shPrev = studioBtn(pg1,8,Y1,28,32,"<",S_BG2,S_TEXT)
  local shCard = mkFrame(pg1,40,Y1,PW-80,32,S_BG2,12); mkCorner(shCard,4); mkStroke(shCard,S_BORDER,1,0)
  mkIcon(shCard, 8, 8, 16, "SHAPE", S_ACCENT)
  shNameLbl = mkLbl(shCard,28,4,PW-150,24,cS,S_TEXT,11,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  shNameLbl.TextYAlignment=Enum.TextYAlignment.Center
  shNext = studioBtn(pg1,PW-36,Y1,28,32,">",S_BG2,S_TEXT)
  Y1=Y1+38

  -- ── UKURAN BRUSH ───────────────────────────────────────
  studioSec(pg1,Y1,"Ukuran Brush"); Y1=Y1+28
  local dW = math.floor((PW-24)/3)
  wLbl,wM,wP = studioDial(pg1,8,Y1,"LEBAR",W,100,S_ACCENT)
  hLbl,hM,hP = studioDial(pg1,8+dW+4,Y1,"TINGGI",H,100,S_PURPLE)
  dLbl,dM,dP = studioDial(pg1,8+dW*2+8,Y1,"DALAM",D,100,S_ORANGE)
  Y1=Y1+98

  -- ── BRUSH STRENGTH ─────────────────────────────────────
  studioSec(pg1,Y1,"Brush Strength"); Y1=Y1+28
  local strCard=mkFrame(pg1,8,Y1,PW-16,44,S_BG2,12); mkCorner(strCard,4); mkStroke(strCard,S_BORDER,1,0)
  mkLbl(strCard,10,5,80,14,"STRENGTH",S_TEXT,9,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  mkLbl(strCard,10,21,PW-80,12,"Kekuatan brush Smooth/Raise/Flatten",S_MUTED,7,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  local strBox=mkFrame(strCard,PW-58,8,44,20,S_BG4,13); mkCorner(strBox,3); mkStroke(strBox,S_BORDER,1,0)
  local strNumLbl=mkLbl(strBox,0,3,44,14,tostring(brushStrength).."%",S_ACCENT,9,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
  local strTrack=mkFrame(strCard,8,34,PW-32,6,S_BG4,13); mkCorner(strTrack,99); mkStroke(strTrack,S_BORDER,1,0)
  local strFill=mkFrame(strTrack,0,0,math.floor((PW-32)*(brushStrength/100)),6,S_ACCENT,14); mkCorner(strFill,99)
  local strThumb=Instance.new("Frame"); strThumb.Size=UDim2.new(0,10,0,10); strThumb.AnchorPoint=Vector2.new(1,0.5)
  strThumb.Position=UDim2.new(1,2,0.5,0); strThumb.BackgroundColor3=S_TEXT; strThumb.BorderSizePixel=0; strThumb.ZIndex=15; strThumb.Parent=strFill
  mkCorner(strThumb,5); mkStroke(strThumb,S_ACCENT,1,0)
  local strDrag=false
  strTrack.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
      strDrag=true
      local fr=math.clamp((inp.Position.X-strTrack.AbsolutePosition.X)/strTrack.AbsoluteSize.X,0,1)
      brushStrength=math.clamp(math.floor(fr*100+0.5),1,100)
      strFill.Size=UDim2.new(fr,0,1,0); strNumLbl.Text=tostring(brushStrength).."%"
    end
  end)
  strTrack.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then strDrag=false end end)
  strTrack.InputChanged:Connect(function(inp)
    if strDrag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
      local fr=math.clamp((inp.Position.X-strTrack.AbsolutePosition.X)/strTrack.AbsoluteSize.X,0,1)
      brushStrength=math.clamp(math.floor(fr*100+0.5),1,100)
      strFill.Size=UDim2.new(fr,0,1,0); strNumLbl.Text=tostring(brushStrength).."%"
    end
  end)
  Y1=Y1+50

  -- Dummy refs (agar koneksi button lama tidak error)
  matPrev = Instance.new("TextButton"); matPrev.Visible=false; matPrev.Parent=pg1
  matNext = Instance.new("TextButton"); matNext.Visible=false; matNext.Parent=pg1
  gPB = Instance.new("TextButton"); gPB.Visible=false; gPB.Parent=pg1
  gNB = Instance.new("TextButton"); gNB.Visible=false; gNB.Parent=pg1
  grPB = Instance.new("TextButton"); grPB.Visible=false; grPB.Parent=pg1
  grNB = Instance.new("TextButton"); grNB.Visible=false; grNB.Parent=pg1

  pages[1].Size=UDim2.new(0,PW,0,Y1+8)
end

-- ════════════════════════════════════════════════════════════
--  PAGE 2 BUILDER — LIST (Grid Visual: Material + Warna)
--  User bisa lihat & pilih semua material/warna sekaligus
-- ════════════════════════════════════════════════════════════
do
  local pg2L = pages[2]; local YL = 4

  -- ── SECTION: PILIH MATERIAL ──────────────────────────────
  studioSec(pg2L,YL,"🎨 Pilih Material"); YL=YL+28

  -- Preview material aktif
  local lpMatRow = mkFrame(pg2L,8,YL,PW-16,30,S_BG2,12); mkCorner(lpMatRow,4); mkStroke(lpMatRow,S_BORDER,1,0)
  mkLbl(lpMatRow,10,4,55,12,"AKTIF :",S_MUTED,7,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  local lpMatDot  = mkFrame(lpMatRow,58,8,14,14,mCol[cM] or S_DIM,13); mkCorner(lpMatDot,3)
  local lpMatName = mkLbl(lpMatRow,76,6,PW-100,18,mN[cM] or cM,S_TEXT,10,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  YL=YL+36

  -- Grid material — 4 kolom, swatch warna besar + nama Indonesia
  local LP_COLS = 4
  local LP_CW   = math.floor((PW-16-(LP_COLS-1)*4)/LP_COLS)
  local LP_CH   = 42
  local lpMatCells = {}

  local function lpSelectMat(idx)
    mI=idx; cM=mats[mI]
    -- Update semua cell
    for i2,cell in ipairs(lpMatCells) do
      local active = (i2==mI)
      cell.bg.BackgroundColor3 = active and Color3.fromRGB(18,34,58) or S_BG2
      cell.st.Color            = active and S_ACCENT or S_BORDER
      cell.st.Transparency     = active and 0 or 0
      cell.lbl.TextColor3      = active and S_TEXT or S_MUTED
    end
    lpMatDot.BackgroundColor3 = mCol[cM] or S_DIM
    lpMatName.Text = mN[cM] or cM
    -- Sync ke page 1 juga
    if matDot     then matDot.BackgroundColor3 = mCol[cM] or S_DIM end
    if matNameLbl then matNameLbl.Text = mN[cM] or cM end
  end

  for i2,mn in ipairs(mats) do
    local col2 = (i2-1)%LP_COLS
    local row2 = math.floor((i2-1)/LP_COLS)
    local cx = 8 + col2*(LP_CW+4)
    local cy = YL + row2*(LP_CH+4)
    local bg = mkFrame(pg2L,cx,cy,LP_CW,LP_CH, i2==mI and Color3.fromRGB(18,34,58) or S_BG2, 12)
    mkCorner(bg,4)
    local st = mkStroke(bg, i2==mI and S_ACCENT or S_BORDER, 1, 0)
    -- Swatch warna besar
    local sw = mkFrame(bg,3,4,LP_CW-6,18,mCol[mn] or S_DIM,13); mkCorner(sw,3)
    -- Nama
    local nl = mkLbl(bg,2,24,LP_CW-4,14,mN[mn] or mn, i2==mI and S_TEXT or S_MUTED, 7, Enum.TextXAlignment.Center, Enum.Font.GothamBold)
    -- Button overlay
    local ob = Instance.new("TextButton",bg)
    ob.Size=UDim2.new(1,0,1,0); ob.BackgroundTransparency=1; ob.Text=""; ob.ZIndex=14; ob.BorderSizePixel=0
    local cap = i2
    ob.MouseEnter:Connect(function() if mI~=cap then bg.BackgroundColor3=S_BG3 end end)
    ob.MouseLeave:Connect(function() if mI~=cap then bg.BackgroundColor3=S_BG2 end end)
    ob.MouseButton1Click:Connect(function() lpSelectMat(cap); if updDisp then updDisp() end end)
    lpMatCells[i2]={bg=bg,st=st,lbl=nl}
  end
  local lpMatRows = math.ceil(#mats/LP_COLS)
  YL = YL + lpMatRows*(LP_CH+4) + 8

  -- ── SECTION: WARNA RUMPUT ────────────────────────────────
  studioSec(pg2L,YL,"🌿 Warna Rumput (Grass / LeafyGrass)"); YL=YL+28

  -- Preview aktif
  local lpGcRow = mkFrame(pg2L,8,YL,PW-16,28,S_BG2,12); mkCorner(lpGcRow,4); mkStroke(lpGcRow,S_BORDER,1,0)
  mkLbl(lpGcRow,10,5,55,12,"AKTIF :",S_MUTED,7,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  local lpGcDot  = mkFrame(lpGcRow,58,9,12,10,gC[cGI].color,13); mkCorner(lpGcDot,5)
  local lpGcName = mkLbl(lpGcRow,74,7,PW-90,14,gC[cGI].name,S_TEXT,9,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  local lpGcSwatch = mkFrame(lpGcRow,PW-42,6,30,16,gC[cGI].color,13); mkCorner(lpGcSwatch,3)
  YL=YL+34

  -- Grid warna rumput — 5 kolom, swatch tinggi + nama
  local GCI_COLS = 5
  local GCI_CW   = math.floor((PW-16-(GCI_COLS-1)*4)/GCI_COLS)
  local GCI_CH   = 48
  local lpGcCells = {}

  local function lpSelectGrass(idx)
    cGI=idx
    local gc = gC[cGI]
    for i2,cell in ipairs(lpGcCells) do
      local active=(i2==cGI)
      cell.bg.BackgroundColor3 = active and Color3.new(math.clamp(gc.color.R*0.15+0.12,0,1),math.clamp(gc.color.G*0.15+0.12,0,1),math.clamp(gc.color.B*0.15+0.12,0,1)) or S_BG2
      cell.st.Color = active and gc.color or S_BORDER
      cell.st.Transparency = active and 0 or 0
      cell.lbl.TextColor3 = active and S_TEXT or S_MUTED
    end
    lpGcDot.BackgroundColor3    = gc.color
    lpGcName.Text               = gc.name
    lpGcSwatch.BackgroundColor3 = gc.color
    -- Sync ke page 1
    if gcDot     then gcDot.BackgroundColor3 = gc.color end
    if gCNameLbl then gCNameLbl.Text = gc.name end
    if gCBtn     then gCBtn.BackgroundColor3 = gc.color end
    sGCP()
  end

  for i2,gc in ipairs(gC) do
    local col2=(i2-1)%GCI_COLS
    local row2=math.floor((i2-1)/GCI_COLS)
    local cx=8+col2*(GCI_CW+4)
    local cy=YL+row2*(GCI_CH+4)
    local active=(i2==cGI)
    local bgCol = active and Color3.new(math.clamp(gc.color.R*0.15+0.12,0,1),math.clamp(gc.color.G*0.15+0.12,0,1),math.clamp(gc.color.B*0.15+0.12,0,1)) or S_BG2
    local bg2=mkFrame(pg2L,cx,cy,GCI_CW,GCI_CH,bgCol,12); mkCorner(bg2,4)
    local st2=mkStroke(bg2,active and gc.color or S_BORDER,1,0)
    -- Swatch warna besar (separuh tinggi cell)
    local sw2=mkFrame(bg2,3,4,GCI_CW-6,24,gc.color,13); mkCorner(sw2,3)
    -- Nama singkat
    local shortN = gc.name:gsub("Hijau ","")
    local nl2=mkLbl(bg2,2,30,GCI_CW-4,14,shortN,active and S_TEXT or S_MUTED,7,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
    -- Hex warna kecil di bawah nama
    local r2=math.floor(gc.color.R*255); local g2=math.floor(gc.color.G*255); local b2=math.floor(gc.color.B*255)
    mkLbl(bg2,2,40,GCI_CW-4,8,string.format("#%02X%02X%02X",r2,g2,b2),S_MUTED,6,Enum.TextXAlignment.Center,Enum.Font.Gotham)
    local ob2=Instance.new("TextButton",bg2)
    ob2.Size=UDim2.new(1,0,1,0); ob2.BackgroundTransparency=1; ob2.Text=""; ob2.ZIndex=14; ob2.BorderSizePixel=0
    local cap2=i2
    ob2.MouseEnter:Connect(function() if cGI~=cap2 then bg2.BackgroundColor3=S_BG3 end end)
    ob2.MouseLeave:Connect(function() if cGI~=cap2 then bg2.BackgroundColor3=S_BG2 end end)
    ob2.MouseButton1Click:Connect(function() lpSelectGrass(cap2); if updDisp then updDisp() end end)
    lpGcCells[i2]={bg=bg2,st=st2,lbl=nl2}
  end
  local gcRows=math.ceil(#gC/GCI_COLS)
  YL=YL+gcRows*(GCI_CH+4)+8

  -- ── SECTION: WARNA TANAH ─────────────────────────────────
  studioSec(pg2L,YL,"🟫 Warna Tanah / Lumpur (Ground / Mud)"); YL=YL+28

  -- Preview aktif
  local lpGrRow=mkFrame(pg2L,8,YL,PW-16,28,S_BG2,12); mkCorner(lpGrRow,4); mkStroke(lpGrRow,S_BORDER,1,0)
  mkLbl(lpGrRow,10,5,55,12,"AKTIF :",S_MUTED,7,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  local lpGrDot  = mkFrame(lpGrRow,58,9,12,10,grC[cGrI].color,13); mkCorner(lpGrDot,5)
  local lpGrName = mkLbl(lpGrRow,74,7,PW-90,14,grC[cGrI].name,S_TEXT,9,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  local lpGrSwatch = mkFrame(lpGrRow,PW-42,6,30,16,grC[cGrI].color,13); mkCorner(lpGrSwatch,3)
  YL=YL+34

  -- Grid warna tanah — 5 kolom
  local GRI_COLS=5
  local GRI_CW=math.floor((PW-16-(GRI_COLS-1)*4)/GRI_COLS)
  local GRI_CH=48
  local lpGrCells={}

  local function lpSelectGround(idx)
    cGrI=idx
    local grc=grC[cGrI]
    for i2,cell in ipairs(lpGrCells) do
      local active=(i2==cGrI)
      cell.bg.BackgroundColor3=active and Color3.new(math.clamp(grc.color.R*0.2+0.1,0,1),math.clamp(grc.color.G*0.15+0.08,0,1),math.clamp(grc.color.B*0.1+0.06,0,1)) or S_BG2
      cell.st.Color=active and grc.color or S_BORDER
      cell.st.Transparency=active and 0 or 0
      cell.lbl.TextColor3=active and S_TEXT or S_MUTED
    end
    lpGrDot.BackgroundColor3    = grc.color
    lpGrName.Text               = grc.name
    lpGrSwatch.BackgroundColor3 = grc.color
    -- Sync ke page 1
    if grDot     then grDot.BackgroundColor3 = grc.color end
    if grCNameLbl then grCNameLbl.Text = grc.name end
    if grCBtn    then grCBtn.BackgroundColor3 = grc.color end
  end

  for i2,grci in ipairs(grC) do
    local col2=(i2-1)%GRI_COLS
    local row2=math.floor((i2-1)/GRI_COLS)
    local cx=8+col2*(GRI_CW+4)
    local cy=YL+row2*(GRI_CH+4)
    local active=(i2==cGrI)
    local bgCol2=active and Color3.new(math.clamp(grci.color.R*0.2+0.1,0,1),math.clamp(grci.color.G*0.15+0.08,0,1),math.clamp(grci.color.B*0.1+0.06,0,1)) or S_BG2
    local bg3=mkFrame(pg2L,cx,cy,GRI_CW,GRI_CH,bgCol2,12); mkCorner(bg3,4)
    local st3=mkStroke(bg3,active and grci.color or S_BORDER,1,0)
    local sw3=mkFrame(bg3,3,4,GRI_CW-6,24,grci.color,13); mkCorner(sw3,3)
    local shortG=grci.name:gsub("Coklat ","")
    local nl3=mkLbl(bg3,2,30,GRI_CW-4,14,shortG,active and S_TEXT or S_MUTED,7,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
    local r3=math.floor(grci.color.R*255); local g3=math.floor(grci.color.G*255); local b3=math.floor(grci.color.B*255)
    mkLbl(bg3,2,40,GRI_CW-4,8,string.format("#%02X%02X%02X",r3,g3,b3),S_MUTED,6,Enum.TextXAlignment.Center,Enum.Font.Gotham)
    local ob3=Instance.new("TextButton",bg3)
    ob3.Size=UDim2.new(1,0,1,0); ob3.BackgroundTransparency=1; ob3.Text=""; ob3.ZIndex=14; ob3.BorderSizePixel=0
    local cap3=i2
    ob3.MouseEnter:Connect(function() if cGrI~=cap3 then bg3.BackgroundColor3=S_BG3 end end)
    ob3.MouseLeave:Connect(function() if cGrI~=cap3 then bg3.BackgroundColor3=S_BG2 end end)
    ob3.MouseButton1Click:Connect(function() lpSelectGround(cap3); if updDisp then updDisp() end end)
    lpGrCells[i2]={bg=bg3,st=st3,lbl=nl3}
  end
  local grRows2=math.ceil(#grC/GRI_COLS)
  YL=YL+grRows2*(GRI_CH+4)+8

  pages[2].Size=UDim2.new(0,PW,0,YL+8)
end

-- ════════════════════════════════════════════════════════════
--  PAGE 2 BUILDER
-- ════════════════════════════════════════════════════════════
local modeCards = {}
local pohonBtn, pohonSetOn
local bukitBtn, bukitSetOn
local gundukBtn, gundukSetOn
local getBkH, getBkR
local getGnH, getGnR, getGnSh
local brushPartBtn, autoConvBtn
-- For updDisp refs
local BPF, ACVF, bpStr, bpIco2, bpPill2, bpSl2, acStr, acIco2, acPill, acSl2

do
  local pg2 = pages[3]; local Y2 = 4
  local MROW_H = 44
  studioSec(pg2,Y2,"Mode Brush Aktif"); Y2=Y2+28

  local modeConfigs = {
    {"TERRAIN","TERRAIN","Generate terrain murni",S_ACCENT},
    {"REPLACE","AUTO-T","Auto convert parts",S_GREEN},
    {"SMOOTH","USAP","Ratakan terrain (sweep)",S_PURPLE},
    {"STACK","TUMPUK","Tumpuk lapisan terrain",S_ORANGE},
    {"FLATTEN","PLANT","Ratakan permukaan jalan",Color3.fromRGB(0,180,100)},
    {"BLOWER","BLOWER","Hapus terrain AABB",S_RED},
    {"TUNNEL","GALI","Gali / buat terowongan",Color3.fromRGB(160,100,40)},
  }
  local MCARD_W = math.floor((PW-24)/2)
  local mc_y = Y2
  for i,cfg in ipairs(modeConfigs) do
    local col=(i-1)%2; local row=math.floor((i-1)/2)
    local cx=8+col*(MCARD_W+8); local cy=mc_y+row*(MROW_H+6)
    local card,btn2,sl,setOn = studioToggleRow(pg2,cx,cy,MCARD_W,MROW_H,cfg[1],cfg[2],cfg[3],cfg[4])
    modeCards[cfg[2]]={card=card,btn=btn2,sl=sl,setOn=setOn}
  end
  Y2=Y2+math.ceil(#modeConfigs/2)*(MROW_H+6)+6

  -- Full-width mode rows
  local function mkFullModeRow(parent, y, iconKey, name, desc, oc)
    local card=mkFrame(parent,8,y,PW-16,MROW_H,S_BG2,12); mkCorner(card,4); mkStroke(card,S_BORDER,1,0)
    mkFrame(card,0,0,3,MROW_H,oc,13)
    local iw=mkFrame(card,10,MROW_H/2-10,20,20,S_BG4,13); mkCorner(iw,3)
    local il=mkIcon(iw, 2, 2, 16, iconKey, S_MUTED)
    mkLbl(card,36,7,PW-110,13,name,S_TEXT,9,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
    mkLbl(card,36,22,PW-110,11,desc,S_MUTED,8,Enum.TextXAlignment.Left,Enum.Font.Gotham)
    local pill=mkFrame(card,PW-58,MROW_H/2-8,38,16,S_BG4,13); mkCorner(pill,8); mkStroke(pill,S_DIM,1,0)
    local pTxt=mkLbl(pill,0,1,38,14,"OFF",S_MUTED,8,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
    local btn2=Instance.new("TextButton",card); btn2.Size=UDim2.new(1,0,1,0); btn2.BackgroundTransparency=1; btn2.Text=""; btn2.ZIndex=14; btn2.BorderSizePixel=0
    local function setOn(v)
      if v then
        card.BackgroundColor3=Color3.new(math.clamp(oc.R*0.1+0.16,0,1),math.clamp(oc.G*0.1+0.16,0,1),math.clamp(oc.B*0.1+0.16,0,1))
        mkStroke(card,oc,1,0.2); recolorIcon(il, oc)
        pill.BackgroundColor3=oc; pTxt.TextColor3=Color3.new(1,1,1); pTxt.Text="ON"; mkStroke(pill,oc,1,0)
      else
        card.BackgroundColor3=S_BG2; mkStroke(card,S_BORDER,1,0); recolorIcon(il, S_MUTED)
        pill.BackgroundColor3=S_BG4; pTxt.TextColor3=S_MUTED; pTxt.Text="OFF"; mkStroke(pill,S_DIM,1,0)
      end
    end
    return btn2, pTxt, setOn
  end

  local pohonSl, gundukSl, bukitSl
  pohonBtn,pohonSl,pohonSetOn  = mkFullModeRow(pg2,Y2,"TREE","POHON","Scatter pohon di terrain",S_GREEN); Y2=Y2+MROW_H+6
  bukitBtn,bukitSl,bukitSetOn  = mkFullModeRow(pg2,Y2,"BUKIT","BUKIT","Hill generator smooth dome",S_ORANGE); Y2=Y2+MROW_H+6
  gundukBtn,gundukSl,gundukSetOn = mkFullModeRow(pg2,Y2,"GUNDUK","GUNDUKAN","Drag ke atas → bergelombang",S_GOLD); Y2=Y2+MROW_H+10

  studioSec(pg2,Y2,"Parameter Bukit"); Y2=Y2+28
  local _,getBkH2,_ = studioSlider(pg2,8,Y2,PW-16,"Tinggi Bukit",bkH,4,100,S_ACCENT,"SIZE"); Y2=Y2+58; getBkH=getBkH2
  local _,getBkR2,_ = studioSlider(pg2,8,Y2,PW-16,"Radius Bukit",bkR,8,128,S_PURPLE,"SIZE"); Y2=Y2+58; getBkR=getBkR2

  studioSec(pg2,Y2,"Bentuk Kolom Bukit/Gundukan"); Y2=Y2+28

  do
    local COL_W3 = math.floor((PW-28)/3)
    local function mkShapeToggle(parent,x,y,w,h2,iconKey,label,col)
      local f=mkFrame(parent,x,y,w,h2,S_BG2,12); mkCorner(f,4); local fs=mkStroke(f,S_BORDER,1,0)
      local il=mkIcon(f, w/2-8, 5, 16, iconKey, S_MUTED)
      local nl=mkLbl(f,0,h2-15,w,12,label,S_MUTED,7,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
      local btn2=Instance.new("TextButton",f); btn2.Size=UDim2.new(1,0,1,0); btn2.BackgroundTransparency=1; btn2.Text=""; btn2.ZIndex=14; btn2.BorderSizePixel=0
      local function setActive(v)
        f.BackgroundColor3=v and Color3.new(math.clamp(col.R*0.12+0.12,0,1),math.clamp(col.G*0.12+0.12,0,1),math.clamp(col.B*0.12+0.12,0,1)) or S_BG2
        fs.Color=v and col or S_BORDER; fs.Transparency=v and 0.2 or 0
        recolorIcon(il, v and col or S_MUTED)
        nl.TextColor3=v and col or S_MUTED
      end
      return btn2, setActive
    end
    local bsColBtn, bsColSet   = mkShapeToggle(pg2,8,Y2,COL_W3,42,"SHAPE","BALOK",S_ACCENT)
    local bsCylBBtn, bsCylBSet = mkShapeToggle(pg2,8+COL_W3+6,Y2,COL_W3,42,"COLOR","BULAT",S_PURPLE)
    local bsCylRBtn, bsCylRSet = mkShapeToggle(pg2,8+COL_W3*2+12,Y2,COL_W3,42,"MOUNTAIN","RUNCING",S_GOLD)
    Y2=Y2+48
    local bsMode = "Balok"
    local function updateBsButtons()
      bsColSet(bsMode=="Balok"); bsCylBSet(bsMode=="Silinder"); bsCylRSet(bsMode=="Runcing")
    end
    bsColBtn.MouseButton1Click:Connect(function() bsMode="Balok"; updateBsButtons() end)
    bsCylBBtn.MouseButton1Click:Connect(function() bsMode="Silinder"; updateBsButtons() end)
    bsCylRBtn.MouseButton1Click:Connect(function() bsMode="Runcing"; updateBsButtons() end)
    updateBsButtons()
  end

  studioSec(pg2,Y2,"Parameter Gundukan"); Y2=Y2+28
  local _,getGnH2,_ = studioSlider(pg2,8,Y2,PW-16,"Tinggi Gundukan",gnH,4,80,S_GOLD,"SIZE"); Y2=Y2+58; getGnH=getGnH2
  local _,getGnR2,_ = studioSlider(pg2,8,Y2,PW-16,"Radius Gundukan",gnR,6,80,S_ORANGE,"SIZE"); Y2=Y2+58; getGnR=getGnR2
  local _,getGnSh2,_ = studioSlider(pg2,8,Y2,PW-16,"Runcing (0=Kubah, 100=Kerucut)",gnSharp,0,100,S_PURPLE,"MOUNTAIN"); Y2=Y2+58; getGnSh=getGnSh2

  -- Part & AutoConv rows
  local MCARD_W2 = math.floor((PW-24)/2)
  BPF  = mkFrame(pg2,8,Y2,MCARD_W2,MROW_H,S_BG2,12); mkCorner(BPF,4)
  bpStr  = mkStroke(BPF,S_BORDER,1,0)
  bpIco2 = mkIcon(BPF, 8, MROW_H/2-10, 20, "PART", S_MUTED)
  mkLbl(BPF,32,7,MCARD_W2-80,13,"PART",S_TEXT,9,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  mkLbl(BPF,32,22,MCARD_W2-80,11,"Taruh terrain part",S_MUTED,8,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  bpPill2 = mkFrame(BPF,MCARD_W2-46,MROW_H/2-8,38,16,S_BG4,13); mkCorner(bpPill2,8); mkStroke(bpPill2,S_DIM,1,0)
  bpSl2   = mkLbl(bpPill2,0,1,38,14,"OFF",S_MUTED,8,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
  brushPartBtn = Instance.new("TextButton",BPF); brushPartBtn.Size=UDim2.new(1,0,1,0); brushPartBtn.BackgroundTransparency=1; brushPartBtn.Text=""; brushPartBtn.ZIndex=14; brushPartBtn.BorderSizePixel=0

  ACVF   = mkFrame(pg2,8+MCARD_W2+8,Y2,MCARD_W2,MROW_H,S_BG2,12); mkCorner(ACVF,4)
  acStr  = mkStroke(ACVF,S_BORDER,1,0)
  acIco2 = mkIcon(ACVF, 8, MROW_H/2-10, 20, "AUTOCONV", S_MUTED)
  mkLbl(ACVF,32,7,MCARD_W2-80,13,"AUTO-CONV",S_TEXT,9,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  mkLbl(ACVF,32,22,MCARD_W2-80,11,"Toggle auto convert",S_MUTED,8,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  acPill = mkFrame(ACVF,MCARD_W2-46,MROW_H/2-8,38,16,S_BG4,13); mkCorner(acPill,8); mkStroke(acPill,S_DIM,1,0)
  acSl2  = mkLbl(acPill,0,1,38,14,"OFF",S_MUTED,8,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
  autoConvBtn = Instance.new("TextButton",ACVF); autoConvBtn.Size=UDim2.new(1,0,1,0); autoConvBtn.BackgroundTransparency=1; autoConvBtn.Text=""; autoConvBtn.ZIndex=14; autoConvBtn.BorderSizePixel=0
  Y2=Y2+MROW_H+8
  pages[3].Size=UDim2.new(0,PW,0,Y2+8)
end

-- ════════════════════════════════════════════════════════════
--  FORWARD DECLARATIONS (harus ada sebelum page builders)
-- ════════════════════════════════════════════════════════════
local resetModes, updDisp
local _pausePillRef = nil  -- ref ke pausePill di footer, diisi saat footer dibuat

-- ════════════════════════════════════════════════════════════
--  PAGE 3 BUILDER
-- ════════════════════════════════════════════════════════════
local cvBtn, clBtn, undoAksiBtn, exportBtn, stLbl
-- Refs untuk new brush mode cards di page 3
local newModeCards = {}

do
  local pg3=pages[4]; local Y3=4
  local MROW_H=44; local MCARD_W=math.floor((PW-24)/2)

  studioSec(pg3,Y3,"🎨 Brush Realistis"); Y3=Y3+28

  -- Smooth Brush card
  do
    local card,btn2,sl,setOn=studioToggleRow(pg3,8,Y3,MCARD_W,MROW_H,"SMOOTH","SMOOTH","Haluskan permukaan bergelombang",S_PURPLE)
    newModeCards["SMOOTH"]={card=card,btn=btn2,sl=sl,setOn=setOn}; Y3=Y3
  end
  -- Raise Brush card
  do
    local card,btn2,sl,setOn=studioToggleRow(pg3,8+MCARD_W+8,Y3,MCARD_W,MROW_H,"TERRAIN","RAISE","Naikkan terrain secara gradual",S_GREEN)
    newModeCards["RAISE"]={card=card,btn=btn2,sl=sl,setOn=setOn}
  end
  Y3=Y3+MROW_H+6
  -- Lower Brush card
  do
    local card,btn2,sl,setOn=studioToggleRow(pg3,8,Y3,MCARD_W,MROW_H,"BLOWER","LOWER","Turunkan terrain secara gradual",S_RED)
    newModeCards["LOWER"]={card=card,btn=btn2,sl=sl,setOn=setOn}; Y3=Y3
  end
  -- Paint Brush card
  do
    local card,btn2,sl,setOn=studioToggleRow(pg3,8+MCARD_W+8,Y3,MCARD_W,MROW_H,"REPLACE","PAINT","Ganti material tanpa ubah bentuk",S_GOLD)
    newModeCards["PAINT"]={card=card,btn=btn2,sl=sl,setOn=setOn}
  end
  Y3=Y3+MROW_H+6
  -- Flatten Brush card (full width)
  do
    local card=mkFrame(pg3,8,Y3,PW-16,MROW_H,S_BG2,12); mkCorner(card,4); mkStroke(card,S_BORDER,1,0)
    mkFrame(card,0,0,3,MROW_H,S_ACCENT,13)
    local iw=mkFrame(card,10,MROW_H/2-10,20,20,S_BG4,13); mkCorner(iw,3)
    local il=mkIcon(iw,2,2,16,"FLATTEN",S_MUTED)
    mkLbl(card,36,7,PW-110,13,"FLATTEN",S_TEXT,9,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
    mkLbl(card,36,22,PW-110,11,"Ratakan terrain ke target Y (klik untuk set Y)",S_MUTED,8,Enum.TextXAlignment.Left,Enum.Font.Gotham)
    local pill=mkFrame(card,PW-58,MROW_H/2-8,38,16,S_BG4,13); mkCorner(pill,8); mkStroke(pill,S_DIM,1,0)
    local pTxt=mkLbl(pill,0,1,38,14,"OFF",S_MUTED,8,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
    local btn2=Instance.new("TextButton",card); btn2.Size=UDim2.new(1,0,1,0); btn2.BackgroundTransparency=1; btn2.Text=""; btn2.ZIndex=14; btn2.BorderSizePixel=0
    local function setOn(v)
      if v then
        card.BackgroundColor3=Color3.fromRGB(20,36,60); mkStroke(card,S_ACCENT,1,0.2); recolorIcon(il,S_ACCENT)
        pill.BackgroundColor3=S_ACCENT; pTxt.TextColor3=Color3.new(1,1,1); pTxt.Text="ON"; mkStroke(pill,S_ACCENT,1,0)
      else
        card.BackgroundColor3=S_BG2; mkStroke(card,S_BORDER,1,0); recolorIcon(il,S_MUTED)
        pill.BackgroundColor3=S_BG4; pTxt.TextColor3=S_MUTED; pTxt.Text="OFF"; mkStroke(pill,S_DIM,1,0)
      end
    end
    newModeCards["FLATTEN"]={card=card,btn=btn2,sl=pTxt,setOn=setOn}
    Y3=Y3+MROW_H+6
  end

  -- Flatten target Y indicator
  local ftYRow=mkFrame(pg3,8,Y3,PW-16,28,S_BG2,12); mkCorner(ftYRow,4); mkStroke(ftYRow,S_BORDER,1,0)
  mkLbl(ftYRow,10,6,120,16,"Target Y Flatten:",S_MUTED,8,Enum.TextXAlignment.Left,Enum.Font.Gotham)
  local ftYLbl=mkLbl(ftYRow,130,6,80,16,"(auto dari klik)",S_ACCENT,8,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  local ftYReset=studioBtn(ftYRow,PW-70,4,56,20,"RESET Y",S_BG4,S_RED); ftYReset.TextSize=7
  ftYReset.MouseButton1Click:Connect(function() ftTargetY=nil; ftYLbl.Text="(auto dari klik)" end)
  Y3=Y3+34

  studioSec(pg3,Y3,"⚡ Aksi Terrain"); Y3=Y3+28
  cvBtn       = studioActionCard(pg3,8,Y3,PW-16,46,"CONVERT","PART => TERRAIN","Generate terrain dari Part yang dipilih",S_ACCENT); Y3=Y3+52
  clBtn       = studioActionCard(pg3,8,Y3,PW-16,46,"DELETE","CLEAR ALL","Hapus semua terrain di workspace",S_RED); Y3=Y3+52
  undoAksiBtn = studioActionCard(pg3,8,Y3,PW-16,46,"UNDO","UNDO TERAKHIR","Kembalikan aksi terrain sebelumnya",S_ACCENT); Y3=Y3+52
  exportBtn   = studioActionCard(pg3,8,Y3,PW-16,46,"EXPORT","EXPORT TERRAIN","Simpan terrain ke file eksternal",S_GOLD); Y3=Y3+56
  stLbl = mkLbl(pg3,0,Y3,PW,18,"",S_ACCENT,9,Enum.TextXAlignment.Center,Enum.Font.GothamBold); Y3=Y3+22

  -- Wire up new mode buttons (klik = aktifkan saja, tidak bisa OFF dari panel)
  if newModeCards["SMOOTH"]  then newModeCards["SMOOTH"].btn.MouseButton1Click:Connect(function()
    resetModes(); smBrM=true; smBrA=true; brushPaused=false; updDisp()
  end) end
  if newModeCards["RAISE"]   then newModeCards["RAISE"].btn.MouseButton1Click:Connect(function()
    resetModes(); rlM=true; rlDir=1; rlA=true; brushPaused=false; updDisp()
  end) end
  if newModeCards["LOWER"]   then newModeCards["LOWER"].btn.MouseButton1Click:Connect(function()
    resetModes(); rlM=true; rlDir=-1; rlA=true; brushPaused=false; updDisp()
  end) end
  if newModeCards["PAINT"]   then newModeCards["PAINT"].btn.MouseButton1Click:Connect(function()
    resetModes(); ptM=true; ptA=true; brushPaused=false; updDisp()
  end) end
  if newModeCards["FLATTEN"] then newModeCards["FLATTEN"].btn.MouseButton1Click:Connect(function()
    resetModes(); ftM=true; ftA=true; brushPaused=false
    if mouse.Hit then
      ftTargetY=math.floor(mouse.Hit.Position.Y/FILL_VS+0.5)*FILL_VS
      if ftYLbl then ftYLbl.Text="Y = "..tostring(ftTargetY) end
    end
    updDisp()
  end) end

  pages[4].Size=UDim2.new(0,PW,0,Y3+8)
end

-- ════════════════════════════════════════════════════════════
--  PAGE 4 BUILDER
-- ════════════════════════════════════════════════════════════
local prjStatusLbl, paLoad, paSave, prjStLbl

do
  local pg4=pages[5]; local Y4=4
  studioSec(pg4,Y4,"Project Manager"); Y4=Y4+28
  prjStatusLbl = mkLbl(pg4,12,Y4,PW-24,18,"Saved Projects",S_MUTED,9,Enum.TextXAlignment.Left,Enum.Font.GothamBold); Y4=Y4+24
  local PA_W = math.floor((PW-24)/2)
  paLoad = studioBtn(pg4,8,Y4,PA_W,34,"",Color3.fromRGB(30,50,30),S_GREEN)
  paLoad.TextSize=9; paLoad.Font=Enum.Font.GothamBold; mkStroke(paLoad,S_GREEN,1,0.5)
  mkIcon(paLoad, 8, 9, 16, "LOAD", S_GREEN)
  mkLbl(paLoad, 28, 10, PA_W-36, 14, "LOAD SEMUA", S_GREEN, 9, Enum.TextXAlignment.Left, Enum.Font.GothamBold)
  paSave = studioBtn(pg4,8+PA_W+8,Y4,PA_W,34,"",Color3.fromRGB(20,32,52),S_ACCENT)
  paSave.TextSize=9; paSave.Font=Enum.Font.GothamBold; mkStroke(paSave,S_ACCENT,1,0.5)
  mkIcon(paSave, 8, 9, 16, "SAVE", S_ACCENT)
  mkLbl(paSave, 28, 10, PA_W-36, 14, "SAVE PROJECT", S_ACCENT, 9, Enum.TextXAlignment.Left, Enum.Font.GothamBold)
  Y4=Y4+40
  prjStLbl = mkLbl(pg4,0,Y4,PW,18,"",S_ACCENT,9,Enum.TextXAlignment.Center,Enum.Font.GothamBold)
  pages[4].Size=UDim2.new(0,PW,0,Y4+30)
end

-- ── FOOTER ──
do
  local footer=mkFrame(panel,0,PH-36,PW,36,S_BG1,13)
  mkFrame(footer,0,0,PW,1,S_BORDER,14)
  local sPill=mkFrame(footer,10,10,54,16,Color3.fromRGB(30,50,30),13); mkCorner(sPill,3); mkStroke(sPill,S_GREEN,1,0.5)
  mkLbl(sPill,8,1,40,14,"AKTIF",S_GREEN,7,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  -- Label status pause di footer (ditampilkan saat brush di-pause)
  local pausePill=mkFrame(footer,68,10,66,16,Color3.fromRGB(60,20,20),13); mkCorner(pausePill,3); mkStroke(pausePill,S_RED,1,0.5)
  pausePill.Visible=false
  mkLbl(pausePill,6,1,56,14,"⏸ PAUSED",S_RED,7,Enum.TextXAlignment.Left,Enum.Font.GothamBold)
  mkLbl(footer,PW-148,11,136,14,"TB v7.0 by SYGKMUNII",S_MUTED,7,Enum.TextXAlignment.Right,Enum.Font.Gotham)
  -- pausePill diupdate via _pausePill ref yang diakses di updDisp bawah
  _pausePillRef = pausePill
end

-- ── SIDEBAR TOOLBAR BUTTONS ──
-- Posisi disejajarkan dengan logo Roblox (kanan+bawah sedikit)
local toggleLogo = Instance.new("TextButton")
toggleLogo.Size=UDim2.new(0,36,0,36); toggleLogo.Position=UDim2.new(0,16,0,66)
toggleLogo.BackgroundColor3=S_BG1; toggleLogo.BorderSizePixel=0
toggleLogo.AutoButtonColor=false; toggleLogo.Font=Enum.Font.GothamBold; toggleLogo.TextSize=9
toggleLogo.Text=""; toggleLogo.TextColor3=S_TEXT; toggleLogo.ZIndex=100; toggleLogo.Visible=true; toggleLogo.Parent=tbGui
mkCorner(toggleLogo,4); mkStroke(toggleLogo,S_BORDER2,1,0)
do
  local ico=mkIcon(toggleLogo, 10, 10, 16, "TERRAIN", S_ACCENT)
  ico.ZIndex=101
end
toggleLogo.MouseEnter:Connect(function() toggleLogo.BackgroundColor3=S_BG3 end)
toggleLogo.MouseLeave:Connect(function() toggleLogo.BackgroundColor3=panelVisible and S_BG4 or S_BG1 end)

local quickDisableBtn = Instance.new("TextButton")
quickDisableBtn.Size=UDim2.new(0,36,0,36); quickDisableBtn.Position=UDim2.new(0,16,0,110)
quickDisableBtn.BackgroundColor3=Color3.fromRGB(80,30,30); quickDisableBtn.BorderSizePixel=0
quickDisableBtn.AutoButtonColor=false; quickDisableBtn.Font=Enum.Font.GothamBold; quickDisableBtn.TextSize=8
quickDisableBtn.Text=""; quickDisableBtn.TextColor3=S_RED; quickDisableBtn.ZIndex=100; quickDisableBtn.Visible=true; quickDisableBtn.Parent=tbGui
mkCorner(quickDisableBtn,4)
local qdStroke = mkStroke(quickDisableBtn,S_RED,1,0.4)
local qdIco=mkIcon(quickDisableBtn, 10, 10, 16, "ERASER", S_RED)
qdIco.ZIndex=101
quickDisableBtn.MouseEnter:Connect(function() quickDisableBtn.BackgroundColor3=S_BG3 end)
quickDisableBtn.MouseLeave:Connect(function() quickDisableBtn.BackgroundColor3=Color3.fromRGB(80,30,30) end)

-- ════════════════════════════════════════════════════════════
--  MODE STATE
-- ════════════════════════════════════════════════════════════

-- brushPaused: true = brush di-pause sementara oleh tombol merah luar panel
-- Mode tetap aktif di panel, hanya eksekusi brush yang diblokir
brushPaused = false

resetModes = function()
  pE=false;pTE=false;sM=false;sMA=false;bkM=false;bkMA=false
  stM=false;stMA=false;plM=false;plMA=false;blM=false;blMA=false
  tM=false;tBR=false;tBA=false;gnM=false;gnMA=false
  smBrM=false;smBrA=false;rlM=false;rlA=false
  ptM=false;ptA=false;ftM=false;ftA=false
  lBP=nil;lSP=nil;gnDragStart=nil;gnDragY=nil
end

-- ════════════════════════════════════════════════════════════
--  updDisp
-- ════════════════════════════════════════════════════════════
updDisp = function()
  pcall(function()
    CBS=Vector3.new(W,H,D)
    -- Update pausePill di footer
    if _pausePillRef then pcall(function() _pausePillRef.Visible = brushPaused end) end
    -- Sync slider values ke variabel brush
    if getBkH then bkH=getBkH() end
    if getBkR then bkR=getBkR() end
    if getGnH then gnH=getGnH() end
    if getGnR then gnR=getGnR() end
    if getGnSh then gnSharp=getGnSh() end
    -- Page 1 UI
    if matNameLbl then matNameLbl.Text=mN[cM] or cM end
    if matDot then matDot.BackgroundColor3=mCol[cM] or S_DIM end
    if gcDot then gcDot.BackgroundColor3=gC[cGI].color end
    if grDot then grDot.BackgroundColor3=grC[cGrI].color end
    if gCBtn then gCBtn.BackgroundColor3=gC[cGI].color end
    if gCNameLbl then gCNameLbl.Text=gC[cGI].name end
    if grCBtn then grCBtn.BackgroundColor3=grC[cGrI].color end
    if grCNameLbl then grCNameLbl.Text=grC[cGrI].name end
    if shNameLbl then shNameLbl.Text=cS end
    if wLbl then wLbl.Text=tostring(W) end
    if hLbl then hLbl.Text=tostring(H) end
    if dLbl then dLbl.Text=tostring(D) end
    if vxLbl then vxLbl.Text="VX: "..gTVC() end
    -- Mode cards page 2
    if modeCards and modeCards["TERRAIN"] then pcall(modeCards["TERRAIN"].setOn, pTE) end
    if modeCards and modeCards["AUTO-T"]  then pcall(modeCards["AUTO-T"].setOn,  aC)  end
    if modeCards and modeCards["USAP"]    then pcall(modeCards["USAP"].setOn,    sM)  end
    if modeCards and modeCards["TUMPUK"]  then pcall(modeCards["TUMPUK"].setOn,  stM) end
    if modeCards and modeCards["PLANT"]   then pcall(modeCards["PLANT"].setOn,   plM) end
    if modeCards and modeCards["BLOWER"]  then pcall(modeCards["BLOWER"].setOn,  blM) end
    if modeCards and modeCards["GALI"]    then pcall(modeCards["GALI"].setOn,    tM)  end
    if pohonSetOn  then pcall(pohonSetOn,  tBR) end
    if bukitSetOn  then pcall(bukitSetOn,  bkM) end
    if gundukSetOn then pcall(gundukSetOn, gnM) end
    -- Mode cards page 3
    if newModeCards and newModeCards["SMOOTH"]  then pcall(newModeCards["SMOOTH"].setOn,  smBrM)           end
    if newModeCards and newModeCards["RAISE"]   then pcall(newModeCards["RAISE"].setOn,   rlM and rlDir==1) end
    if newModeCards and newModeCards["LOWER"]   then pcall(newModeCards["LOWER"].setOn,   rlM and rlDir==-1)end
    if newModeCards and newModeCards["PAINT"]   then pcall(newModeCards["PAINT"].setOn,   ptM)             end
    if newModeCards and newModeCards["FLATTEN"] then pcall(newModeCards["FLATTEN"].setOn, ftM)             end
    -- Part btn
    if BPF    then BPF.BackgroundColor3   = pE and Color3.fromRGB(20,36,60) or S_BG2 end
    if bpStr  then bpStr.Color            = pE and S_ACCENT or S_BORDER
                   bpStr.Transparency     = pE and 0.2 or 0 end
    if bpIco2  then pcall(recolorIcon, bpIco2, pE and S_ACCENT or S_MUTED) end
    if bpPill2 then bpPill2.BackgroundColor3 = pE and S_ACCENT or S_BG4 end
    if bpSl2   then bpSl2.TextColor3 = pE and S_TEXT or S_MUTED; bpSl2.Text = pE and "ON" or "OFF" end
    -- AutoConv btn
    if ACVF   then ACVF.BackgroundColor3  = aC and Color3.fromRGB(20,45,25) or S_BG2 end
    if acStr  then acStr.Color            = aC and S_GREEN or S_BORDER
                   acStr.Transparency     = aC and 0.2 or 0 end
    if acIco2  then pcall(recolorIcon, acIco2, aC and S_GREEN or S_MUTED) end
    if acPill  then acPill.BackgroundColor3 = aC and S_GREEN or S_BG4 end
    if acSl2   then acSl2.TextColor3 = aC and S_TEXT or S_MUTED; acSl2.Text = aC and "ON" or "OFF" end
    -- Quick disable btn — tampilkan status: PAUSED / AKTIF / TIDAK ADA MODE
    local anyMode  = pE or pTE or sM or stM or plM or blM or tM or tBR or bkM or gnM or smBrM or rlM or ptM or ftM
    local brushOn  = (pE)or(pTE)or(sM and sMA)or(stM and stMA)or(plM and plMA)or(blM and blMA)or(tM)or(tBR and tBA)or(bkM and bkMA)or(gnM and gnMA)or(smBrM and smBrA)or(rlM and rlA)or(ptM and ptA)or(ftM and ftA)
    if quickDisableBtn and qdStroke and qdIco then
      if anyMode and brushPaused then
        -- Mode aktif tapi di-PAUSE oleh tombol merah → warna merah terang (tanda paused)
        quickDisableBtn.BackgroundColor3=Color3.fromRGB(80,20,20)
        qdStroke.Color=S_RED; qdStroke.Transparency=0
        pcall(recolorIcon, qdIco, S_RED)
      elseif brushOn and not brushPaused then
        -- Brush berjalan normal → hijau (aktif)
        quickDisableBtn.BackgroundColor3=Color3.fromRGB(20,55,30)
        qdStroke.Color=S_GREEN; qdStroke.Transparency=0.2
        pcall(recolorIcon, qdIco, S_GREEN)
      elseif anyMode then
        -- Ada mode aktif tapi belum paused (state transisi) → kuning
        quickDisableBtn.BackgroundColor3=Color3.fromRGB(60,45,10)
        qdStroke.Color=S_GOLD; qdStroke.Transparency=0.3
        pcall(recolorIcon, qdIco, S_GOLD)
      else
        -- Tidak ada mode aktif sama sekali → merah redup
        quickDisableBtn.BackgroundColor3=Color3.fromRGB(80,30,30)
        qdStroke.Color=S_RED; qdStroke.Transparency=0.4
        pcall(recolorIcon, qdIco, S_RED)
      end
    end
  end)
end

-- ════════════════════════════════════════════════════════════
--  BUTTON CONNECTIONS
-- ════════════════════════════════════════════════════════════
-- Material/color/shape nav buttons: matNext/matPrev kini dummy (grid visual)
-- Tetap dihubungkan agar tidak error jika ada referensi lain
if matNext then matNext.MouseButton1Click:Connect(function() mI=mI%#mats+1; cM=mats[mI]; updDisp() end) end
if matPrev then matPrev.MouseButton1Click:Connect(function() mI=(mI-2)%#mats+1; cM=mats[mI]; updDisp() end) end
if shNext  then shNext.MouseButton1Click:Connect(function() sI=sI%#shapes+1; cS=shapes[sI]; updDisp() end) end
if shPrev  then shPrev.MouseButton1Click:Connect(function() sI=(sI-2)%#shapes+1; cS=shapes[sI]; updDisp() end) end
-- gNB/gPB/grNB/grPB: dummy (warna kini dipilih via grid visual, koneksi di bawah kosong)
if gNB  then gNB.MouseButton1Click:Connect(function() end) end
if gPB  then gPB.MouseButton1Click:Connect(function() end) end
if grNB then grNB.MouseButton1Click:Connect(function() end) end
if grPB then grPB.MouseButton1Click:Connect(function() end) end
if wP then wP.MouseButton1Click:Connect(function() W=math.clamp(W+2,2,100); updDisp() end) end
if wM then wM.MouseButton1Click:Connect(function() W=math.clamp(W-2,2,100); updDisp() end) end
if hP then hP.MouseButton1Click:Connect(function() H=math.clamp(H+2,2,100); updDisp() end) end
if hM then hM.MouseButton1Click:Connect(function() H=math.clamp(H-2,2,100); updDisp() end) end
if dP then dP.MouseButton1Click:Connect(function() D=math.clamp(D+2,2,100); updDisp() end) end
if dM then dM.MouseButton1Click:Connect(function() D=math.clamp(D-2,2,100); updDisp() end) end

-- ── Panel mode buttons: klik hanya MENGAKTIFKAN mode (tidak bisa OFF dari panel)
-- Untuk mematikan sementara gunakan tombol merah di luar panel (quickDisableBtn)
if modeCards["TERRAIN"] then modeCards["TERRAIN"].btn.MouseButton1Click:Connect(function()
  resetModes(); pTE=true; brushPaused=false; updDisp()
end) end
if modeCards["AUTO-T"]  then modeCards["AUTO-T"].btn.MouseButton1Click:Connect(function()
  aC=true; brushPaused=false; updDisp()
end) end
if modeCards["USAP"]    then modeCards["USAP"].btn.MouseButton1Click:Connect(function()
  resetModes(); sM=true; sMA=true; brushPaused=false; updDisp()
end) end
if modeCards["TUMPUK"]  then modeCards["TUMPUK"].btn.MouseButton1Click:Connect(function()
  resetModes(); stM=true; stMA=true; brushPaused=false; updDisp()
end) end
if modeCards["PLANT"]   then modeCards["PLANT"].btn.MouseButton1Click:Connect(function()
  resetModes(); plM=true; plMA=true; brushPaused=false; updDisp()
end) end
if modeCards["BLOWER"]  then modeCards["BLOWER"].btn.MouseButton1Click:Connect(function()
  resetModes(); blM=true; blMA=true; brushPaused=false; updDisp()
end) end
if modeCards["GALI"]    then modeCards["GALI"].btn.MouseButton1Click:Connect(function()
  resetModes(); tM=true; brushPaused=false; updDisp()
end) end
if pohonBtn  then pohonBtn.MouseButton1Click:Connect(function()
  resetModes(); tBR=true; tBA=true; brushPaused=false; updDisp()
end) end
if bukitBtn  then bukitBtn.MouseButton1Click:Connect(function()
  resetModes(); bkM=true; bkMA=true; brushPaused=false; updDisp()
end) end
if gundukBtn then gundukBtn.MouseButton1Click:Connect(function()
  resetModes(); gnM=true; gnMA=true; brushPaused=false; updDisp()
end) end
if brushPartBtn then brushPartBtn.MouseButton1Click:Connect(function()
  resetModes(); pE=true; brushPaused=false; updDisp()
end) end
if autoConvBtn  then autoConvBtn.MouseButton1Click:Connect(function()
  aC=true; brushPaused=false; updDisp()
end) end
mouse.Button2Down:Connect(function()
  -- Right-click tidak mengubah active state saat paused
  if brushPaused then return end
  if sM then sMA=not sMA end; if stM then stMA=not stMA end
  if plM then plMA=not plMA end; if blM then blMA=not blMA end
  if tBR then tBA=not tBA end; if bkM then bkMA=not bkMA end
  if gnM then gnMA=not gnMA end; updDisp()
end)

if cvBtn then cvBtn.MouseButton1Click:Connect(function()
  if stLbl then stLbl.Text="Converting..." end; task.wait(0.1)
  local c=convertPartsToTerrain(); updDisp()
  if stLbl then stLbl.Text="Done: "..c.." parts" end; task.wait(2.5); if stLbl then stLbl.Text="" end
end) end
if clBtn then clBtn.MouseButton1Click:Connect(function()
  clrAll(); resetModes(); pE=false; pTE=false; aC=false; updDisp()
  if stLbl then stLbl.Text="Cleared" end; task.wait(2); if stLbl then stLbl.Text="" end
end) end
if undoAksiBtn then undoAksiBtn.MouseButton1Click:Connect(function()
  if #undoStack==0 then if stLbl then stLbl.Text="No undo available" end; task.wait(2); if stLbl then stLbl.Text="" end; return end
  local en=undoStack[#undoStack]; local T=Workspace:FindFirstChild("Terrain")
  local function removeEntry(e)
    if tDBM[e.material] then for i2=#tDBM[e.material],1,-1 do if tDBM[e.material][i2]==e then table.remove(tDBM[e.material],i2); break end end end
    for i2=#swD,1,-1 do if swD[i2]==e then table.remove(swD,i2); break end end
    local uk=string.format("%.2f,%.2f,%.2f",e.position.X,e.position.Y,e.position.Z); blowedSet[uk]=true
    if e.snapshot then restoreSnapshot(e.snapshot)
    elseif T then
      pcall(function()
        if e.shape=="Bola" then T:FillBall(e.position, math.max(e.size.X,e.size.Y,e.size.Z)/2, Enum.Material.Air)
        elseif e.shape=="Silinder" then T:FillCylinder(CFrame.new(e.position), e.size.Y, math.max(e.size.X,e.size.Z)/2, Enum.Material.Air)
        else T:FillBlock(CFrame.new(e.position),e.size,Enum.Material.Air) end
      end)
    end
  end
  if en.groupId then
    local gid=en.groupId; local removed=0
    for i2=#undoStack,1,-1 do local e2=undoStack[i2]; if e2.groupId==gid then removeEntry(e2); table.remove(undoStack,i2); removed=removed+1 end end
    if stLbl then stLbl.Text="Undo hill ("..removed.." col)" end
  else
    table.remove(undoStack,#undoStack); removeEntry(en); if stLbl then stLbl.Text="Undo: "..(en.material or "?") end
  end
  updDisp(); task.wait(2); if stLbl then stLbl.Text="" end
end) end
if exportBtn then exportBtn.MouseButton1Click:Connect(function()
  if stLbl then stLbl.Text="Exporting..." end
  task.spawn(function()
    local T=Workspace:FindFirstChild("Terrain")
    -- Kumpulkan semua data
    local aD={}
    for _,lst in pairs(tDBM) do
      for _,e in ipairs(lst) do
        local k=string.format("%.2f,%.2f,%.2f",e.position.X,e.position.Y,e.position.Z)
        if not blowedSet[k] then table.insert(aD,e) end
      end
    end
    for _,e in ipairs(swD) do
      local k=string.format("%.2f,%.2f,%.2f",e.position.X,e.position.Y,e.position.Z)
      if not blowedSet[k] then table.insert(aD,e) end
    end

    if #aD==0 then
      if stLbl then stLbl.Text="No data to export" end
      task.wait(2); if stLbl then stLbl.Text="" end; return
    end

    -- Buat folder export
    local expF=Workspace:FindFirstChild("TB_Export"); if expF then expF:Destroy() end
    expF=Instance.new("Folder"); expF.Name="TB_Export"; expF.Parent=Workspace

    -- Header info
    local header=string.format("# TerrainBrush Export v10 | entries=%d | gi=%d | gri=%d | time=%s",
      #aD, cGI, cGrI, tostring(math.floor(tick())))
    local infoSV=Instance.new("StringValue"); infoSV.Name="ExportInfo"
    infoSV.Value=header; infoSV.Parent=expF

    -- Serialize semua entries ke chunks
    local MAX_CHARS=190000; local chunkIdx=1; local lines={}; local curLen=0
    local function flushChunk()
      if #lines==0 then return end
      local sv=Instance.new("StringValue"); sv.Name="Chunk_"..chunkIdx
      sv.Value=table.concat(lines,"\n"); sv.Parent=expF
      chunkIdx=chunkIdx+1; lines={}; curLen=0
    end

    local paintCount=0; local fillCount=0
    for i2=1,#aD do
      local e=aD[i2]; local p,s=e.position,e.size
      local row
      if e.isPaint then
        -- Format paint
        row=string.format("PT,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%s,%.2f",
          p.X,p.Y,p.Z,s.X,s.Y,s.Z,e.material,e.surfaceY or p.Y)
        paintCount=paintCount+1
      else
        local shCode
        if e.shape=="Bola" then shCode="SP"
        elseif e.shape=="Silinder" then shCode="CY"
        elseif e.shape=="Baji" then shCode="WG"
        else shCode="B" end
        row=string.format("POS,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%s,%s",
          p.X,p.Y,p.Z,s.X,s.Y,s.Z,shCode,e.material)
        fillCount=fillCount+1
      end
      if curLen+#row+1>MAX_CHARS then flushChunk() end
      table.insert(lines,row); curLen=curLen+#row+1
      if i2%500==0 then task.wait() end
    end
    flushChunk()

    -- Summary string value (mudah di-copy dari Properties panel)
    local sumSV=Instance.new("StringValue"); sumSV.Name="ExportSummary"
    sumSV.Value=string.format("fill=%d|paint=%d|chunks=%d|total=%d",
      fillCount,paintCount,chunkIdx-1,#aD)
    sumSV.Parent=expF

    local msg=string.format("Exported %d entries (%d fill, %d paint) → TB_Export",
      #aD, fillCount, paintCount)
    if stLbl then stLbl.Text=msg end
    print("[TerrainBrush] "..msg)
    print("[TerrainBrush] Buka Workspace > TB_Export di Explorer untuk copy string")
    task.wait(4); if stLbl then stLbl.Text="" end
  end)
end) end

if paLoad then paLoad.MouseButton1Click:Connect(function()
  tDBM={}; undoStack={}; swD={}; blowedSet={}; paintData={}
  paLoad.Text="Loading..."; paLoad.BackgroundColor3=Color3.fromRGB(40,60,10)
  task.spawn(function()
    local n=ldAllProjects(); updDisp()
    local cnt=1; while Workspace:FindFirstChild("TP_S"..cnt) do cnt=cnt+1 end; cnt=cnt-1
    if prjStatusLbl then prjStatusLbl.Text="Saved Projects ("..(cnt>0 and cnt or 0)..")" end
    paLoad.Text="LOAD SEMUA"; paLoad.BackgroundColor3=Color3.fromRGB(30,50,30)
    if prjStLbl then prjStLbl.Text=n>0 and ("Loaded "..n.." entry") or "No projects found" end
    task.wait(3); if prjStLbl then prjStLbl.Text="" end
  end)
end) end
if paSave then paSave.MouseButton1Click:Connect(function()
  if isSaving then if prjStLbl then prjStLbl.Text="Saving..." end; return end
  paSave.Text="SAVING..."; paSave.BackgroundColor3=Color3.fromRGB(50,40,10)
  if prjStLbl then prjStLbl.Text="Saving data..." end
  svPrj(function(n)
    if n>0 then blowedSet={}; paSave.Text="SAVED ("..n..")"; paSave.BackgroundColor3=Color3.fromRGB(10,50,30); if prjStLbl then prjStLbl.Text="Saved "..n.." entries" end
    elseif n==0 then paSave.Text="No data"; paSave.BackgroundColor3=Color3.fromRGB(60,40,10); if prjStLbl then prjStLbl.Text="No data to save" end
    else paSave.Text="Error"; paSave.BackgroundColor3=Color3.fromRGB(70,10,10); if prjStLbl then prjStLbl.Text="Save error" end end
    task.wait(2.5); paSave.Text="SAVE PROJECT"; paSave.BackgroundColor3=Color3.fromRGB(20,32,52); if prjStLbl then prjStLbl.Text="" end
  end)
end) end

if toggleLogo then toggleLogo.MouseButton1Click:Connect(function()
  panelVisible=not panelVisible; panel.Visible=panelVisible
  toggleLogo.BackgroundColor3=panelVisible and S_BG4 or S_BG1
  toggleLogo.TextColor3=panelVisible and S_ACCENT or S_TEXT
end) end
if quickDisableBtn then quickDisableBtn.MouseButton1Click:Connect(function()
  -- Tombol merah = PAUSE / RESUME sementara
  -- Mode tetap aktif di panel, hanya eksekusi brush yang diblokir/diizinkan
  local anyMode = pE or pTE or sM or stM or plM or blM or tM or tBR or bkM or gnM or smBrM or rlM or ptM or ftM
  if anyMode then
    -- Ada mode aktif → toggle pause
    brushPaused = not brushPaused
  end
  -- Jika tidak ada mode aktif, tombol tidak melakukan apa-apa (brush sudah mati)
  updDisp()
end) end

-- ════════════════════════════════════════════════════════════
--  MOUSE + TOUCH INPUT
-- ════════════════════════════════════════════════════════════
local function gSP(hit)
  if not hit then return nil end; local pos=hit.Position; local g=4
  return Vector3.new(math.floor(pos.X/g+0.5)*g, math.floor(pos.Y/g+0.5)*g, math.floor(pos.Z/g+0.5)*g)
end
local lCP=nil; local gnDragBasePos=nil
local function doBrush(pos)
  if not pos then return end
  -- Jika brush di-pause oleh tombol merah, hentikan eksekusi
  if brushPaused then return end
  if gnM and gnMA then
    local extraH=0; if gnDragY then extraH=math.max(0,(gnDragY-UIS:GetMouseLocation().Y)*0.6) end
    bGundukan(gnDragBasePos or pos, extraH)
  elseif tBR and tBA then bTr(pos)
  elseif blM and blMA then bBlow(pos)
  elseif plM and plMA then bPlant(pos)
  elseif stM and stMA then bStack(pos)
  elseif sM  and sMA  then bSw(pos)
  elseif bkM and bkMA then bBukit(pos)
  elseif tM           then cTun(pos)
  elseif pTE          then bTC(pos)
  elseif pE           then brushPartContinuous(pos)
  -- Brush baru
  elseif smBrM and smBrA then bSmooth(pos)
  elseif rlM   and rlA   then bRaiseLower(pos)
  elseif ptM   and ptA   then bPaint(pos)
  elseif ftM   and ftA   then bFlatten(pos)
  end
end
mouse.Button1Down:Connect(function()
  iMD=true; lCP=nil; lBP=nil; lSP=nil; if not mouse.Hit then return end
  -- Jika paused, tetap set iMD=true tapi jangan jalankan brush
  if brushPaused then return end
  local pos=gSP(mouse.Hit); if not pos then return end; lCP=pos
  if gnM and gnMA then gnDragBasePos=pos; gnDragY=UIS:GetMouseLocation().Y; bGundukan(pos,0)
  else doBrush(pos) end; updDisp()
end)
mouse.Button1Up:Connect(function() iMD=false; lBP=nil; lSP=nil; lCP=nil; gnDragBasePos=nil; gnDragY=nil end)
UIS.TouchStarted:Connect(function(inp,gpe)
  if gpe then return end; iMD=true; lCP=nil; lBP=nil; lSP=nil
  local ray=workspace.CurrentCamera:ScreenPointToRay(inp.Position.X,inp.Position.Y)
  local result=workspace:Raycast(ray.Origin,ray.Direction*2000,RaycastParams.new())
  if not result then return end
  local pos=gSP(CFrame.new(result.Position)); if not pos then return end; lCP=pos
  if gnM and gnMA then gnDragBasePos=pos; gnDragY=inp.Position.Y; bGundukan(pos,0)
  else doBrush(pos) end; updDisp()
end)
UIS.TouchMoved:Connect(function(inp,gpe)
  if gpe or not iMD then return end
  local ray=workspace.CurrentCamera:ScreenPointToRay(inp.Position.X,inp.Position.Y)
  local result=workspace:Raycast(ray.Origin,ray.Direction*2000,RaycastParams.new())
  if not result then return end
  local pos=gSP(CFrame.new(result.Position)); if not pos then return end
  if lCP and (pos-lCP).Magnitude<2 then return end; lCP=nil
  if gnM and gnMA then
    local extraH=0; if gnDragY then extraH=math.max(0,(gnDragY-inp.Position.Y)*0.6) end
    bGundukan(gnDragBasePos or pos,extraH)
  else doBrush(pos) end
end)
UIS.TouchEnded:Connect(function() iMD=false; lBP=nil; lSP=nil; lCP=nil; gnDragBasePos=nil; gnDragY=nil end)
RunService.Heartbeat:Connect(function()
  if not iMD or not mouse.Hit then return end
  local pos=gSP(mouse.Hit); if not pos then return end
  if lCP and (pos-lCP).Magnitude<2 then return end; lCP=nil
  if gnM and gnMA then
    local extraH=0; if gnDragY then extraH=math.max(0,(gnDragY-UIS:GetMouseLocation().Y)*0.6) end
    bGundukan(gnDragBasePos or pos,extraH)
  else doBrush(pos) end
end)

-- ════════════════════════════════════════════════════════════
--  INIT
-- ════════════════════════════════════════════════════════════
switchTab(1)
task.spawn(function()
  task.wait(0.5); lGCP()
  gCBtn.BackgroundColor3=gC[cGI].color; gCNameLbl.Text=gC[cGI].name
  grCBtn.BackgroundColor3=grC[cGrI].color; grCNameLbl.Text=grC[cGrI].name
  gcDot.BackgroundColor3=gC[cGI].color; grDot.BackgroundColor3=grC[cGrI].color
  local cnt=1; while Workspace:FindFirstChild("TP_S"..cnt) do cnt=cnt+1 end; cnt=cnt-1
  prjStatusLbl.Text="Saved Projects ("..(cnt>0 and cnt or 0)..")"
  updDisp()
end)
updDisp()


    -- ── Tombol TERRAIN di toolbar ──
    local posX = getMaxX(tb) + 16; makeSep(tb, posX - 12)
    makePartBtn(tb, posX, "Terrain", icoTerrain, function()
        if not terrainActivated then
            terrainActivated        = true
            toggleLogo.Visible      = true
            quickDisableBtn.Visible = true
        else
            terrainActivated        = false
            toggleLogo.Visible      = false
            quickDisableBtn.Visible = false
            panelVisible            = false
            panel.Visible           = false
        end
    end)

    terrainDone = true
end
_SL.injectTerrain=injectTerrain
_SL.terrainDone=false
end
_sl_block1()
local function _sl_block2()
local LP,PFX,PlayerGui,Players,TweenSvc,Workspace,CoreGui,drawSeg,findToolbar,getMaxX,gradient,makePartBtn,makeSep,root,stroke,PARTS=_SL.LP,_SL.PFX,_SL.PlayerGui,_SL.Players,_SL.TweenSvc,_SL.Workspace,_SL.CoreGui,_SL.drawSeg,_SL.findToolbar,_SL.getMaxX,_SL.gradient,_SL.makePartBtn,_SL.makeSep,_SL.root,_SL.stroke,_SL.PARTS
local _rsok,RunService=pcall(function()return game:GetService("RunService")end);if not _rsok then RunService=nil end
local function commit(label) pcall(function() if pl_CHS then pl_CHS:SetWaypoint(label or "Action") end end) end
-- ══════════════════════════════════════════════
--  PLUGIN PANEL — TOOLS PANEL v12.1
-- ══════════════════════════════════════════════
local pl_UIS=game:GetService("UserInputService")
local pl_LIG=game:GetService("Lighting")
local pl_CG=game:GetService("CoreGui")
local pl_PLR=game:GetService("Players")
local pl_Sel;pcall(function()pl_Sel=game:GetService("Selection")end)
local pl_CHS;pcall(function()pl_CHS=game:GetService("ChangeHistoryService")end)
local pluginGui,pluginDone,pluginVisible=nil,false,false
local pl_MF,pl_glowOuter
local PW,PH,HDR_H,TAB_H,BODY_Y,BODY_H
local PR,colBtn,dragHandle
local lay,on,pad,row,pages,tabs,tabLine
local switchTab,newPage
local function icoPlugin(p,S,T)
local cx,cy=S/2,S/2
for i=0,5 do
local a=math.rad(i*60);local a2=math.rad(i*60+20)
local r=S*0.28;local rT=S*0.42
drawSeg(p,cx+r*math.cos(a),cy+r*math.sin(a),cx+rT*math.cos(a),cy+rT*math.sin(a),T,C.accA,46)
drawSeg(p,cx+rT*math.cos(a),cy+rT*math.sin(a),cx+rT*math.cos(a2),cy+rT*math.sin(a2),T,C.accA,46)
drawSeg(p,cx+rT*math.cos(a2),cy+rT*math.sin(a2),cx+r*math.cos(a2),cy+r*math.sin(a2),T,C.accA,46)
end
drawSeg(p,cx-S*0.12,cy,cx+S*0.12,cy,T,C.accA,45)
drawSeg(p,cx,cy-S*0.12,cx,cy+S*0.12,T,C.accA,45)
end
-- ── LOGIC PLUGIN (module level) ──
-- ║              COLOR PALETTE               ║
-- ╚══════════════════════════════════════════╝
local C = {
    BG0 = Color3.fromRGB(8, 8, 14),
    BG1 = Color3.fromRGB(12, 12, 20),
    BG2 = Color3.fromRGB(18, 18, 30),
    BG3 = Color3.fromRGB(24, 24, 40),
    BD0 = Color3.fromRGB(30, 44, 68),
    BD1 = Color3.fromRGB(50, 72, 108),
    A0  = Color3.fromRGB(0, 180, 255),
    A1  = Color3.fromRGB(30, 210, 255),
    A2  = Color3.fromRGB(120, 230, 255),
    T0  = Color3.fromRGB(230, 240, 255),
    T1  = Color3.fromRGB(160, 185, 215),
    T2  = Color3.fromRGB(90, 115, 150),
    T3  = Color3.fromRGB(48, 60, 88),
    GRN = Color3.fromRGB(40, 220, 120),
    RED = Color3.fromRGB(255, 70, 80),
    BLU = Color3.fromRGB(50, 160, 255),
    ORG = Color3.fromRGB(255, 165, 40),
    YLW = Color3.fromRGB(255, 215, 55),
    CYN = Color3.fromRGB(0, 215, 215),
    PNK = Color3.fromRGB(255, 90, 185),
    -- Button colors
    W_C  = Color3.fromRGB(0, 68, 140),    W_H = Color3.fromRGB(0, 95, 185),
    R_C  = Color3.fromRGB(0, 82, 58),     R_H = Color3.fromRGB(0, 114, 80),
    G_C  = Color3.fromRGB(0, 80, 45),     G_H = Color3.fromRGB(0, 110, 62),
    D_C  = Color3.fromRGB(88, 15, 15),    D_H = Color3.fromRGB(120, 22, 22),
    U_C  = Color3.fromRGB(45, 18, 18),    U_H = Color3.fromRGB(68, 28, 28),
    M_C  = Color3.fromRGB(0, 78, 130),    M_H = Color3.fromRGB(0, 108, 172),
    N_C  = Color3.fromRGB(18, 22, 38),    N_H = Color3.fromRGB(28, 35, 58),
    P_C  = Color3.fromRGB(72, 0, 108),    P_H = Color3.fromRGB(100, 0, 148),
}

-- ╔══════════════════════════════════════════╗
-- ║            UTILITY FUNCTIONS             ║
-- ╚══════════════════════════════════════════╝
local FC = {}
local function newFolder(base)
    FC[base] = (FC[base] or 0) + 1
    local f = Instance.new("Folder")
    f.Name = base .. "_" .. FC[base]
    f.Parent = Workspace
    return f
end

local function rnd8()
    local s = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local o = ""
    for _ = 1, 10 do
        local i = math.random(1, #s)
        o = o .. s:sub(i, i)
    end
    return o
end

local function mkHL(col, tr)
    local h = Instance.new("Highlight")
    h.FillColor = col
    h.FillTransparency = tr or 0.38
    h.OutlineColor = Color3.new(
        math.min(col.R + 0.28, 1),
        math.min(col.G + 0.28, 1),
        math.min(col.B + 0.28, 1)
    )
    h.DepthMode = Enum.HighlightDepthMode.Occluded
    h.Parent = pl_LIG
    return h
end

local function flash(p, col)
    if not p or not p.Parent then return end
    local h = Instance.new("Highlight")
    h.FillColor = col or C.GRN
    h.FillTransparency = 0.05
    h.OutlineColor = Color3.new(1, 1, 1)
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = p
    h.Parent = p.Parent or pl_LIG
    TweenSvc:Create(h, TweenInfo.new(0.45), { FillTransparency = 1 }):Play()
    task.delay(0.55, function() pcall(function() h:Destroy() end) end)
end

-- Raycast ke part (exclude list)
local function rayPart(x, y, bl)
    local cam = Workspace.CurrentCamera
    local ray = cam:ScreenPointToRay(x, y)
    local p = RaycastParams.new()
    p.FilterDescendantsInstances = bl or {}
    p.FilterType = Enum.RaycastFilterType.Exclude
    return Workspace:Raycast(ray.Origin, ray.Direction * 2000, p)
end

-- Raycast dengan titik hit (untuk posisi attachment)
local function rayPartHit(x, y, bl)
    local cam = Workspace.CurrentCamera
    local ray = cam:ScreenPointToRay(x, y)
    local p = RaycastParams.new()
    p.FilterDescendantsInstances = bl or {}
    p.FilterType = Enum.RaycastFilterType.Exclude
    local res = Workspace:Raycast(ray.Origin, ray.Direction * 2000, p)
    if res then
        return res.Instance, res.Position, res.Normal
    end
    return nil, nil, nil
end

-- Screen-to-world (untuk draw path)
local function s2w(x, y, wy)
    local cam = Workspace.CurrentCamera
    local r = cam:ScreenPointToRay(x, y)
    if math.abs(r.Direction.Y) < 0.0001 then return r.Origin + r.Direction * 200 end
    local t = (wy - r.Origin.Y) / r.Direction.Y
    if not t or t ~= t or t < 0 then t = 200 end
    return r.Origin + r.Direction * t
end

-- ╔══════════════════════════════════════════╗
-- ║           MODE MANAGER                   ║
-- ╚══════════════════════════════════════════╝
local activeMode = "none"
local modeConns = {}
local modeClearCB = {}

local function clearMode()
    activeMode = "none"
    for _, c in ipairs(modeConns) do pcall(function() c:Disconnect() end) end
    modeConns = {}
    for _, fn in ipairs(modeClearCB) do pcall(fn) end
end

local function addConn(c) table.insert(modeConns, c) end

-- ╔══════════════════════════════════════════╗
-- ║         WELD TOOL (WT)                   ║
-- ╚══════════════════════════════════════════╝
local wt = {
    mode = nil, p = {}, h = {}, staged = {}, hist = {},
    stLbl = nil, cntLbl = nil, mparts = {}, mhls = {}
}
local HLC = { C.RED, C.BLU, C.GRN, C.YLW, C.PNK, C.CYN, C.ORG, Color3.fromRGB(180, 120, 255) }

local function wt_hl()
    if wt.h[1] then wt.h[1].Adornee = nil end
    if wt.h[2] then wt.h[2].Adornee = nil end
    if wt.p[1] then
        if not wt.h[1] then wt.h[1] = mkHL(C.RED) end
        wt.h[1].Adornee = wt.p[1]
    end
    if wt.p[2] then
        if not wt.h[2] then wt.h[2] = mkHL(C.BLU) end
        wt.h[2].Adornee = wt.p[2]
    end
end

local function wt_mhl()
    for _, h in ipairs(wt.mhls) do pcall(function() h:Destroy() end) end
    wt.mhls = {}
    for i, p in ipairs(wt.mparts) do
        local h = mkHL(HLC[((i - 1) % #HLC) + 1])
        h.Adornee = p
        table.insert(wt.mhls, h)
    end
end

local function wt_updateCount()
    if not wt.cntLbl then return end
    local nw, nr = 0, 0
    for _, s in ipairs(wt.staged) do
        if s.type == "weld" then nw = nw + 1 else nr = nr + 1 end
    end
    wt.cntLbl.Text = string.format("STAGED:  %d WELD  |  %d ROPE", nw, nr)
    wt.cntLbl.TextColor3 = (#wt.staged > 0) and C.GRN or C.T3
end

local function wt_st()
    if not wt.stLbl then return end
    if wt.mode == "weld" then
        if not wt.p[1] then wt.stLbl.Text = "✦ MODE WELD — Klik Part 1"; wt.stLbl.TextColor3 = C.GRN
        elseif not wt.p[2] then wt.stLbl.Text = "SELECT PART 2 (BIRU)"; wt.stLbl.TextColor3 = C.BLU
        else wt.stLbl.Text = "SIAP >> APPLY WELD"; wt.stLbl.TextColor3 = C.GRN end
    elseif wt.mode == "rope" then
        if not wt.p[1] then wt.stLbl.Text = "✦ MODE ROPE — Klik Part 1"; wt.stLbl.TextColor3 = C.GRN
        elseif not wt.p[2] then wt.stLbl.Text = "SELECT PART 2 (BIRU)"; wt.stLbl.TextColor3 = C.BLU
        else wt.stLbl.Text = "SIAP >> APPLY ROPE"; wt.stLbl.TextColor3 = C.GRN end
    else
        wt.stLbl.Text = "Aktifkan Mode WELD atau ROPE"
        wt.stLbl.TextColor3 = C.T3
    end
end

local function wt_activate(ms)
    clearMode()
    if wt.mode == ms then wt.mode = nil; wt.p = {}; wt_hl(); wt_st(); return end
    wt.mode = ms; wt.p = {}; wt_hl(); wt_st()
    activeMode = "wt_" .. ms
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            local hit = res.Instance
            if not wt.p[1] then
                wt.p[1] = hit
            elseif not wt.p[2] and hit ~= wt.p[1] then
                wt.p[2] = hit
            end
            wt_hl(); wt_st()
        end
    end))
end

local function wt_applyWeld()
    if not wt.p[1] or not wt.p[2] then return end
    local p0, p1 = wt.p[1], wt.p[2]
    local w = Instance.new("WeldConstraint")
    w.Part0 = p0; w.Part1 = p1; w.Parent = p0
    flash(p0, C.GRN); flash(p1, C.GRN)
    table.insert(wt.staged, { type = "weld", p0 = p0, p1 = p1, constraint = w })
    wt.p = {}; wt_hl(); wt_st(); wt_updateCount()
    commit("WT: Apply Weld")
end

local function wt_applyRope()
    if not wt.p[1] or not wt.p[2] then return end
    local p0, p1 = wt.p[1], wt.p[2]
    local a0 = Instance.new("Attachment"); a0.Name = "WTAtt0"; a0.Parent = p0
    local a1 = Instance.new("Attachment"); a1.Name = "WTAtt1"; a1.Parent = p1
    local ropeLen = (p0.Position - p1.Position).Magnitude
    -- RopeConstraint: physics saja, Visible=false (tidak render saat PlayTest)
    local rope = Instance.new("RopeConstraint")
    rope.Attachment0 = a0; rope.Attachment1 = a1
    rope.Length = ropeLen; rope.Visible = false
    rope.Restitution = 0; rope.Parent = p0
    -- RopeConstraint — physics DAN visual sekaligus (Visible=true, gaya asli Roblox)
    local rope = Instance.new("RopeConstraint")
    rope.Attachment0 = a0; rope.Attachment1 = a1
    rope.Length      = ropeLen
    rope.Visible     = true                      -- ★ tali asli Roblox
    rope.Thickness   = 0.1
    rope.Color       = BrickColor.new("Black")
    rope.Restitution = 0; rope.Parent = p0
    flash(p0, C.ORG); flash(p1, C.ORG)
    table.insert(wt.staged, { type = "rope", p0 = p0, p1 = p1, constraint = rope, a0 = a0, a1 = a1 })
    wt.p = {}; wt_hl(); wt_st(); wt_updateCount()
    commit("WT: Apply Rope")
end

local function wt_mergeFolder()
    if #wt.staged == 0 then return end
    local folder = newFolder("WeldGroup")
    local merged = {}
    for _, s in ipairs(wt.staged) do
        if s.p0 and s.p0.Parent ~= folder then s.p0.Parent = folder end
        if s.p1 and s.p1.Parent ~= folder then s.p1.Parent = folder end
        table.insert(merged, s)
        flash(s.p0, C.CYN)
        pcall(function() flash(s.p1, C.CYN) end)
    end
    table.insert(wt.hist, { items = merged, folder = folder })
    wt.staged = {}; wt.mode = nil; wt.p = {}
    wt_hl(); wt_st(); wt_updateCount(); clearMode()
    commit("WT: Merge Folder")
end

local function wt_undo()
    if #wt.staged > 0 then
        local s = table.remove(wt.staged)
        pcall(function() s.constraint:Destroy() end)
        pcall(function() if s.a0 then s.a0:Destroy() end end)
        pcall(function() if s.a1 then s.a1:Destroy() end end)
        wt_updateCount(); commit("WT: Undo")
        return
    end
    if #wt.hist == 0 then return end
    local e = table.remove(wt.hist)
    for _, s in ipairs(e.items) do
        pcall(function() s.constraint:Destroy() end)
        pcall(function() if s.a0 then s.a0:Destroy() end end)
        pcall(function() if s.a1 then s.a1:Destroy() end end)
        pcall(function() if s.p0 then s.p0.Parent = Workspace end end)
        pcall(function() if s.p1 then s.p1.Parent = Workspace end end)
    end
    pcall(function() if e.folder and #e.folder:GetChildren() == 0 then e.folder:Destroy() end end)
    wt_updateCount(); commit("WT: Undo Folder")
end

local function wt_multiWeld()
    if not pl_Sel then return end
    local out = {}
    for _, o in ipairs(pl_Sel:Get()) do
        if o:IsA("BasePart") then table.insert(out, o) end
    end
    if #out < 2 then return end
    wt.mparts = out; wt_mhl()
    local main = wt.mparts[1]
    for i = 2, #wt.mparts do
        local p = wt.mparts[i]
        local w = Instance.new("WeldConstraint")
        w.Part0 = main; w.Part1 = p; w.Parent = main
        table.insert(wt.staged, { type = "weld", p0 = main, p1 = p, constraint = w })
        flash(p, C.YLW)
    end
    flash(main, C.GRN)
    wt.mparts = {}; wt_mhl(); wt_updateCount()
    commit("WT: Multi-Weld")
end

table.insert(modeClearCB, function()
    if wt.mode ~= nil then wt.mode = nil; wt_st() end
end)

-- ╔══════════════════════════════════════════════════════╗
-- ║   TALI v5 — KLIK TAHAN DRAG LEPAS = TALI JADI      ║
-- ╚══════════════════════════════════════════════════════╝
--[[
  CARA KERJA (SIMPEL):
  ① Tekan tombol TALI ON
  ② Klik & TAHAN di Part manapun → Part langsung MERAH
  ③ Drag mouse ke Part lain → tali HIDUP mengikuti cursor
  ④ Lepas di Part tujuan → tali terpasang, Part tujuan HIJAU
  Tidak perlu tombol attach, tidak perlu klik 2x.
  Beam = visual tali terlihat di Edit Mode DAN PlayTest.
]]

local function genName()
    local c = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local o = ""
    for _ = 1, 10 do o = o .. c:sub(math.random(1,#c), math.random(1,#c)) end
    return o
end

local function makeAtt(part, worldPos)
    local att = Instance.new("Attachment")
    att.Name = "RpAtt_"..genName()
    att.Position = part.CFrame:PointToObjectSpace(worldPos)
    att.Parent = part
    return att
end

-- ── TALI VISUAL: RopeConstraint Visible=true (gaya asli Roblox Studio) ───────
-- Pakai Visible=true + Thickness + Color persis seperti script referensi.
-- Tidak butuh Beam sama sekali — ini tali bawaan engine Roblox.
local function makeRopeVisual(att0, att1, parent)
    local r = Instance.new("RopeConstraint")
    r.Name        = "RopeVisual_" .. genName()
    r.Attachment0 = att0
    r.Attachment1 = att1
    r.Length      = (att0.WorldPosition - att1.WorldPosition).Magnitude
    r.Visible     = true                       -- ★ tampilkan visual tali bawaan Roblox
    r.Thickness   = 0.1                        -- ketebalan tali
    r.Color       = BrickColor.new("Black")    -- warna tali hitam seperti referensi
    r.Restitution = 0
    r.Parent      = parent
    return r
end

-- ── State ──────────────────────────────────────────────────────────
local rp = {
    active   = false,
    dragging = false,   -- sedang drag (mouse ditahan)
    p0       = nil,     -- part asal (diklik pertama)
    wp0      = nil,     -- world pos klik di p0
    a0       = nil,     -- attachment sementara di p0
    a1       = nil,     -- attachment hantu mengikuti cursor
    ghostP   = nil,     -- part hantu invisible untuk a1 saat drag
    ropeVis  = nil,     -- RopeConstraint preview saat drag (Visible=true)
    hlSrc    = nil,     -- highlight merah part asal
    hlTgt    = nil,     -- highlight hijau part tujuan hover
    hbConn   = nil,     -- heartbeat
    hist     = {},
    stLbl    = nil,
}

local function rp_stopHB()
    if rp.hbConn then rp.hbConn:Disconnect(); rp.hbConn = nil end
end

local function rp_clearHL()
    if rp.hlSrc then pcall(function() rp.hlSrc:Destroy() end); rp.hlSrc = nil end
    if rp.hlTgt then pcall(function() rp.hlTgt:Destroy() end); rp.hlTgt = nil end
end

local function rp_clearPreview()
    -- Hapus ropeVis preview dan attachment hantu
    if rp.ropeVis then pcall(function() rp.ropeVis:Destroy() end); rp.ropeVis = nil end
    if rp.a1      then pcall(function() rp.a1:Destroy()      end); rp.a1      = nil end
    if rp.a0      then pcall(function() rp.a0:Destroy()      end); rp.a0      = nil end
    if rp.ghostP  then pcall(function() rp.ghostP:Destroy()  end); rp.ghostP  = nil end
end

local function rp_st()
    if not rp.stLbl then return end
    if not rp.active then
        rp.stLbl.Text = "Tekan ON untuk mulai"
        rp.stLbl.TextColor3 = C.T3
    elseif not rp.dragging then
        rp.stLbl.Text = "✦ Klik & TAHAN part → drag ke part lain"
        rp.stLbl.TextColor3 = C.GRN
    else
        rp.stLbl.Text = "Drag ke part tujuan → lepas!"
        rp.stLbl.TextColor3 = C.ORG
    end
end

local function rp_undo()
    if #rp.hist == 0 then return end
    local e = table.remove(rp.hist)
    -- rope sekarang sekaligus visual (Visible=true), tidak ada beam terpisah
    pcall(function() e.rope:Destroy() end)
    pcall(function() e.a0:Destroy()   end)
    pcall(function() e.a1:Destroy()   end)
    -- Kembalikan nama asli (part tetap di Workspace, tidak perlu pindah parent)
    pcall(function() if e.p0 and e.p0.Parent then e.p0.Name = e.n0 end end)
    pcall(function() if e.p1 and e.p1.Parent then e.p1.Name = e.n1 end end)
    commit("Tali: Undo")
end

local function rp_toggle()
    rp.active = not rp.active
    if rp.active then
        clearMode(); activeMode = "rope"
        rp.dragging = false; rp_clearHL(); rp_clearPreview(); rp_st()

        -- ── MOUSE DOWN: catat part asal, mulai drag ──────────────────────
        addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
            if gpe or rp.dragging then return end
            if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
               inp.UserInputType ~= Enum.UserInputType.Touch then return end

            -- Raycast: exclude ghostP (nil saat ini = tidak ada masalah)
            local excludeList = {}
            local hit, pos, _ = rayPartHit(inp.Position.X, inp.Position.Y, excludeList)
            if not (hit and hit:IsA("BasePart")) then return end

            rp.p0       = hit
            rp.wp0      = pos
            rp.dragging = true

            -- Buat ghostPart untuk preview beam
            local gp = Instance.new("Part")
            gp.Name         = "TaliGhost"
            gp.Anchored     = true
            gp.CanCollide   = false
            gp.Transparency = 1
            gp.Size         = Vector3.new(0.1, 0.1, 0.1)
            gp.Position     = pos
            gp.Parent       = Workspace
            rp.ghostP = gp

            -- Attachment preview di part asal dan di ghostP
            rp.a0 = Instance.new("Attachment")
            rp.a0.Name     = "PrevAtt0"
            rp.a0.Position = hit.CFrame:PointToObjectSpace(pos)
            rp.a0.Parent   = hit

            rp.a1 = Instance.new("Attachment")
            rp.a1.Name   = "PrevAtt1"
            rp.a1.Parent = gp

            -- RopeConstraint preview (Visible=true = tali asli Roblox langsung terlihat)
            rp.ropeVis = makeRopeVisual(rp.a0, rp.a1, gp)

            rp_st()

            -- Heartbeat: gerakkan ghostP mengikuti mouse
            rp.hbConn = RunService.Heartbeat:Connect(function()
                if not rp.dragging or not rp.ghostP or not rp.ghostP.Parent then return end
                local mp = pl_UIS:GetMouseLocation()
                -- Exclude ghostP sendiri agar tidak mengenai dirinya
                local _, hPos, _ = rayPartHit(mp.X, mp.Y, {rp.ghostP})
                if hPos then
                    rp.ghostP.Position = hPos
                end
            end)
        end))

        -- ── MOUSE UP: pasang tali nyata, satukan ke folder ───────────────
        addConn(pl_UIS.InputEnded:Connect(function(inp)
            if not rp.dragging then return end
            if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
               inp.UserInputType ~= Enum.UserInputType.Touch then return end

            rp_stopHB()
            rp.dragging = false

            -- Simpan state penting
            local p0  = rp.p0
            local wp0 = rp.wp0

            -- Raycast di posisi mouse SEKARANG, exclude ghostP agar tidak kena sendiri
            local mp = pl_UIS:GetMouseLocation()
            local excludeList = {}
            if rp.ghostP then table.insert(excludeList, rp.ghostP) end
            local p1, wp1, _ = rayPartHit(mp.X, mp.Y, excludeList)

            -- Hapus semua preview SETELAH raycast selesai
            rp_clearHL()
            rp_clearPreview()

            -- Validasi kedua part
            if p0 and p0.Parent and p1 and p1:IsA("BasePart") and p1 ~= p0 and p1.Parent then

                -- [1] Rename parts (acak) agar bisa diundo dengan tepat
                local n0, n1 = p0.Name, p1.Name
                p0.Name = "Tali_" .. genName()
                p1.Name = "Tali_" .. genName()

                -- [2] Buat attachment permanen di masing-masing part
                local a0 = Instance.new("Attachment")
                a0.Name     = "TaliAtt_" .. genName()
                a0.Position = p0.CFrame:PointToObjectSpace(wp0)
                a0.Parent   = p0   -- attachment langsung di part, TIDAK di folder

                local a1 = Instance.new("Attachment")
                a1.Name     = "TaliAtt_" .. genName()
                a1.Position = p1.CFrame:PointToObjectSpace(wp1)
                a1.Parent   = p1   -- attachment langsung di part, TIDAK di folder

                -- [3] RopeConstraint — physics DAN visual sekaligus (Visible=true)
                local rope = Instance.new("RopeConstraint")
                rope.Name        = "Rope_" .. genName()
                rope.Attachment0 = a0
                rope.Attachment1 = a1
                rope.Length      = (a0.WorldPosition - a1.WorldPosition).Magnitude
                rope.Visible     = true                      -- ★ tali asli Roblox, terlihat Edit DAN PlayGame
                rope.Thickness   = 0.1                       -- ketebalan tali
                rope.Color       = BrickColor.new("Black")   -- warna tali
                rope.Restitution = 0
                rope.Parent      = p0

                -- Tidak ada Beam terpisah — RopeConstraint Visible=true sudah cukup

                flash(p0, C.ORG); flash(p1, C.GRN)
                table.insert(rp.hist, {
                    rope=rope, a0=a0, a1=a1,
                    p0=p0, p1=p1,
                    n0=n0, n1=n1   -- simpan nama asli untuk undo rename
                })
                commit("Tali: Pasang")
            end

            rp.p0 = nil; rp.wp0 = nil
            rp_st()
        end))
    else
        rp_stopHB()
        rp.dragging = false; rp.p0 = nil; rp.wp0 = nil
        rp_clearHL(); rp_clearPreview()
        clearMode(); rp_st()
    end
end

-- ╔══════════════════════════════════════════╗
-- ║          GAP FILL (GF)                   ║
-- ╚══════════════════════════════════════════╝
local gf = { p1 = nil, p2 = nil, h = {}, idx = 0, stLbl = nil }

local function gf_hl()
    if gf.h[1] then gf.h[1].Adornee = nil end
    if gf.h[2] then gf.h[2].Adornee = nil end
    if gf.p1 then if not gf.h[1] then gf.h[1] = mkHL(C.RED) end; gf.h[1].Adornee = gf.p1 end
    if gf.p2 then if not gf.h[2] then gf.h[2] = mkHL(C.BLU) end; gf.h[2].Adornee = gf.p2 end
end

local function gf_st()
    if not gf.stLbl then return end
    if not gf.p1 then gf.stLbl.Text = "▸ Klik Part 1"; gf.stLbl.TextColor3 = C.T3
    elseif not gf.p2 then gf.stLbl.Text = "▸ Klik Part 2"; gf.stLbl.TextColor3 = C.BLU
    else gf.stLbl.Text = "✓ Siap → FILL"; gf.stLbl.TextColor3 = C.GRN end
end

local function gf_click()
    if activeMode == "gf" then clearMode(); gf.p1 = nil; gf.p2 = nil; gf_hl(); gf_st(); return end
    clearMode(); activeMode = "gf"; gf.p1 = nil; gf.p2 = nil; gf_hl(); gf_st()
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            local hit = res.Instance
            if not gf.p1 then gf.p1 = hit
            elseif not gf.p2 and hit ~= gf.p1 then gf.p2 = hit; clearMode() end
            gf_hl(); gf_st()
        end
    end))
end

local function gf_fill()
    if not gf.p1 or not gf.p2 then return end
    gf.idx = gf.idx + 1
    local folder = newFolder("GapFill")
    gf.p1.Parent = folder; gf.p2.Parent = folder
    local d = gf.p2.Position - gf.p1.Position
    local ad = Vector3.new(math.abs(d.X), math.abs(d.Y), math.abs(d.Z))
    local s1, s2 = gf.p1.Size, gf.p2.Size
    local mid = (gf.p1.Position + gf.p2.Position) / 2
    local sz
    if ad.X >= ad.Y and ad.X >= ad.Z then
        sz = Vector3.new(math.max(ad.X - (s1.X + s2.X) / 2, 0.05), s1.Y, s1.Z)
    elseif ad.Y >= ad.X and ad.Y >= ad.Z then
        sz = Vector3.new(s1.X, math.max(ad.Y - (s1.Y + s2.Y) / 2, 0.05), s1.Z)
    else
        sz = Vector3.new(s1.X, s1.Y, math.max(ad.Z - (s1.Z + s2.Z) / 2, 0.05))
    end
    local fp = gf.p1:Clone()
    fp.Name = "GapFill_" .. gf.idx
    fp.Size = sz
    fp.CFrame = CFrame.new(mid) * gf.p1.CFrame.Rotation
    fp.Transparency = 0.75; fp.Parent = folder
    local w1 = Instance.new("WeldConstraint"); w1.Part0 = fp; w1.Part1 = gf.p1; w1.Parent = fp
    local w2 = Instance.new("WeldConstraint"); w2.Part0 = fp; w2.Part1 = gf.p2; w2.Parent = fp
    TweenSvc:Create(fp, TweenInfo.new(0.3), { Transparency = 0 }):Play()
    flash(fp, C.GRN)
    gf.p1 = nil; gf.p2 = nil; gf_hl(); gf_st()
    commit("GapFill: Fill")
end

local function gf_clear()
    gf.p1 = nil; gf.p2 = nil; gf_hl(); gf_st()
    if activeMode == "gf" then clearMode() end
end

-- ╔══════════════════════════════════════════╗
-- ║            BEND TOOL                     ║
-- ╚══════════════════════════════════════════╝
local bend = { p = nil, hl = nil, stLbl = nil, pm = { bend = 0, length = 1, segs = 8 } }

local function bend_hl()
    if bend.hl then bend.hl.Adornee = nil end
    if bend.p then
        if not bend.hl then bend.hl = mkHL(C.CYN) end
        bend.hl.Adornee = bend.p
    end
end

local function bend_st()
    if not bend.stLbl then return end
    if not bend.p then bend.stLbl.Text = "▸ Klik Part target"; bend.stLbl.TextColor3 = C.T3
    else bend.stLbl.Text = "Part: " .. bend.p.Name; bend.stLbl.TextColor3 = C.GRN end
end

local function bend_click()
    if activeMode == "bend" then clearMode(); bend.p = nil; bend_hl(); bend_st(); return end
    clearMode(); activeMode = "bend"; bend.p = nil; bend_hl(); bend_st()
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            bend.p = res.Instance; bend_hl(); bend_st(); clearMode()
        end
    end))
end

local function bend_apply()
    if not bend.p then return end
    local SEGS = math.max(math.floor(bend.pm.segs), 2)
    local radPerSeg = math.rad(bend.pm.bend) / SEGS
    local segLen = (bend.p.Size.Y * math.max(bend.pm.length, 0.1)) / SEGS
    local folder = newFolder("Bend"); bend.p.Parent = folder
    local cur = bend.p.CFrame * CFrame.new(0, -bend.p.Size.Y / 2, 0)
    for i = 1, SEGS do
        local seg = bend.p:Clone(); seg.Name = "Bend_" .. i
        seg.Size = Vector3.new(bend.p.Size.X, segLen, bend.p.Size.Z)
        seg.CFrame = cur * CFrame.new(0, segLen / 2, 0)
        seg.Parent = folder; flash(seg, C.CYN)
        cur = cur * CFrame.new(0, segLen, 0) * CFrame.Angles(radPerSeg, 0, 0)
    end
    pcall(function() bend.p:Destroy() end)
    bend.p = nil; bend_hl(); bend_st()
    commit("Bend: Apply")
end

-- ╔══════════════════════════════════════════╗
-- ║            DRAW PATH                     ║
-- ╚══════════════════════════════════════════╝
local draw = {
    src = nil, hl = nil, stLbl = nil, pts = {}, lines = {},
    active = false, conns = {}, worldY = 0, lastX = 0, lastY = 0, camType = nil
}
local DRAW_MIN = 6

local function draw_clearLines()
    for _, f in ipairs(draw.lines) do pcall(function() f:Destroy() end) end
    draw.lines = {}
end

local function draw_hl()
    if draw.hl then draw.hl.Adornee = nil end
    if draw.src then
        if not draw.hl then draw.hl = mkHL(C.BLU) end
        draw.hl.Adornee = draw.src
    end
end

local function draw_st()
    if not draw.stLbl then return end
    if not draw.src then draw.stLbl.Text = "▸ Klik Part sumber"; draw.stLbl.TextColor3 = C.T3
    elseif not draw.active then draw.stLbl.Text = "Tekan MULAI GAMBAR"; draw.stLbl.TextColor3 = C.YLW
    else draw.stLbl.Text = "Kamera lock — STOP"; draw.stLbl.TextColor3 = C.ORG end
end

local function draw_unlockCam()
    local cam = Workspace.CurrentCamera
    cam.CameraType = draw.camType or Enum.CameraType.Custom
    draw.camType = nil
end

local function draw_lockCam()
    local cam = Workspace.CurrentCamera
    draw.camType = cam.CameraType
    cam.CameraType = Enum.CameraType.Scriptable
end

local function draw_addSeg(sg, x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 2 then return end
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, len, 0, 3)
    f.Position = UDim2.new(0, x1, 0, y1)
    f.AnchorPoint = Vector2.new(0, 0.5)
    f.Rotation = math.deg(math.atan2(dy, dx))
    f.BackgroundColor3 = C.BLU; f.BorderSizePixel = 0; f.ZIndex = 300
    f.BackgroundTransparency = 0.2
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 2)
    f.Parent = sg; table.insert(draw.lines, f)
end

local function draw_addPoint(sg, sx, sy)
    local dx, dy = sx - draw.lastX, sy - draw.lastY
    if math.sqrt(dx * dx + dy * dy) < DRAW_MIN then return end
    local wp = s2w(sx, sy, draw.worldY)
    if #draw.pts > 0 then draw_addSeg(sg, draw.lastX, draw.lastY, sx, sy) end
    table.insert(draw.pts, wp); draw.lastX = sx; draw.lastY = sy
end

local function draw_stop()
    draw.active = false; draw_unlockCam()
    for _, c in ipairs(draw.conns) do pcall(function() c:Disconnect() end) end
    draw.conns = {}; draw_st()
end

local function draw_startDraw(sg)
    if not draw.src then return end
    if draw.active then draw_stop(); return end
    draw.active = true; draw.pts = {}; draw_clearLines(); draw_lockCam(); draw_st()
    local c1 = pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch then
            draw.lastX = inp.Position.X; draw.lastY = inp.Position.Y
            if #draw.pts == 0 then
                table.insert(draw.pts, s2w(inp.Position.X, inp.Position.Y, draw.worldY))
            end
        end
    end)
    local c2 = pl_UIS.InputChanged:Connect(function(inp)
        if not draw.active then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or
           inp.UserInputType == Enum.UserInputType.Touch then
            draw_addPoint(sg, inp.Position.X, inp.Position.Y)
        end
    end)
    table.insert(draw.conns, c1); table.insert(draw.conns, c2)
end

local function draw_selectPart()
    if activeMode == "draw_sel" then clearMode(); return end
    clearMode(); activeMode = "draw_sel"; draw.src = nil; draw_hl(); draw_st()
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            draw.src = res.Instance; draw.worldY = res.Position.Y
            draw.lastX = 0; draw.lastY = 0
            draw_hl(); draw_st(); clearMode()
        end
    end))
end

local function draw_build()
    if not draw.src then return end
    draw_stop()
    if #draw.pts < 2 then return end
    local folder = newFolder("DrawPath"); draw.src.Parent = folder
    local segs = {}; local totalLen = 0
    for i = 2, #draw.pts do
        local d = (draw.pts[i] - draw.pts[i - 1]).Magnitude
        totalLen = totalLen + d
        table.insert(segs, { from = draw.pts[i - 1], to = draw.pts[i], len = d })
    end
    if totalLen < 0.1 then return end
    local partLen = draw.src.Size.Z
    local count = math.max(math.floor(totalLen / partLen), 1)
    local step = totalLen / count
    local function getPosDir(d)
        local walked = 0
        for i = 1, #segs do
            if walked + segs[i].len >= d then
                local si_in = d - walked
                local s = segs[i]
                local t = math.clamp(si_in / s.len, 0, 1)
                return s.from:Lerp(s.to, t), (s.to - s.from).Unit
            end
            walked = walked + segs[i].len
        end
        local s = segs[#segs]
        return s.to, (s.to - s.from).Unit
    end
    for i = 0, count - 1 do
        local pos, dir = getPosDir(i * step + step / 2)
        local up = Vector3.new(0, 1, 0)
        local right = dir:Cross(up)
        if right.Magnitude < 0.001 then right = Vector3.new(1, 0, 0) end
        right = right.Unit; up = right:Cross(dir).Unit
        local cl = draw.src:Clone(); cl.Name = "Path_" .. rnd8()
        cl.Size = Vector3.new(draw.src.Size.X, draw.src.Size.Y, step)
        cl.CFrame = CFrame.fromMatrix(pos, right, up, dir)
        cl.Transparency = 0.75; cl.Parent = folder
        TweenSvc:Create(cl, TweenInfo.new(0.06 + i * 0.012, Enum.EasingStyle.Back),
            { Transparency = draw.src.Transparency }):Play()
    end
    draw_clearLines(); draw.pts = {}; draw.src = nil; draw_hl(); draw_st()
    commit("Draw: Build Path")
end

local function draw_reset()
    draw_stop(); draw_clearLines(); draw.pts = {}; draw.src = nil; draw_hl(); draw_st()
end

-- ╔══════════════════════════════════════════╗
-- ║          ARCHIMEDES ARC                  ║
-- ╚══════════════════════════════════════════╝
local arc = { p = nil, hl = nil, stLbl = nil, pm = { count = 8, angle = 360, height = 0, scale = 1 }, inp = {} }

local function arc_hlr()
    if arc.hl then arc.hl.Adornee = nil end
    if arc.p then
        if not arc.hl then arc.hl = mkHL(C.YLW) end
        arc.hl.Adornee = arc.p
    end
end

local function arc_st()
    if not arc.stLbl then return end
    if not arc.p then arc.stLbl.Text = "▸ Klik Part sumber"; arc.stLbl.TextColor3 = C.T3
    else arc.stLbl.Text = "Part: " .. arc.p.Name; arc.stLbl.TextColor3 = C.GRN end
end

local function arc_click()
    if activeMode == "arc" then clearMode(); arc.p = nil; arc_hlr(); arc_st(); return end
    clearMode(); activeMode = "arc"; arc.p = nil; arc_hlr(); arc_st()
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            arc.p = res.Instance; arc_hlr(); arc_st(); clearMode()
        end
    end))
end

local function arc_start()
    for k, tb in pairs(arc.inp) do
        local v = tonumber(tb.Text); if v then arc.pm[k] = v end
    end
    if not arc.p then return end
    local cnt = math.max(math.floor(arc.pm.count), 2)
    local ang = math.max(arc.pm.angle, 1)
    local hgt = arc.pm.height; local sc = math.max(arc.pm.scale, 0.01)
    local folder = newFolder("Archimedes"); local srcPart = arc.p; srcPart.Parent = folder
    local ctr = srcPart.Position
    local radius = math.max(srcPart.Size.X * cnt / (2 * math.pi), 4)
    local stepRad = math.rad(ang) / (cnt - (ang < 360 and 1 or 0))
    for i = 0, cnt - 1 do
        local theta = stepRad * i; local cl = srcPart:Clone()
        cl.Name = "Arc_" .. rnd8(); cl.Size = srcPart.Size * (sc ^ i)
        cl.CFrame = CFrame.new(
            ctr.X + radius * math.cos(theta),
            ctr.Y + hgt * i,
            ctr.Z + radius * math.sin(theta)
        ) * CFrame.Angles(0, -theta, 0)
        cl.Transparency = 0.8; cl.Parent = folder
        TweenSvc:Create(cl, TweenInfo.new(0.1 + i * 0.018, Enum.EasingStyle.Back),
            { Transparency = srcPart.Transparency }):Play()
    end
    pcall(function() srcPart:Destroy() end)
    arc.p = nil; arc_hlr(); arc_st()
    commit("Archimedes: Generate")
end

-- ╔══════════════════════════════════════════╗
-- ║          ARRAY DUPLICATOR                ║
-- ╚══════════════════════════════════════════╝
local arr = { p = nil, hl = nil, stLbl = nil, pm = { rows = 3, cols = 3, lvls = 1, gapX = 0, gapY = 0, gapZ = 0 } }

local function arr_hl()
    if arr.hl then arr.hl.Adornee = nil end
    if arr.p then if not arr.hl then arr.hl = mkHL(C.YLW) end; arr.hl.Adornee = arr.p end
end

local function arr_st()
    if not arr.stLbl then return end
    if not arr.p then arr.stLbl.Text = "▸ Klik Part sumber"; arr.stLbl.TextColor3 = C.T3
    else arr.stLbl.Text = "Part: " .. arr.p.Name; arr.stLbl.TextColor3 = C.GRN end
end

local function arr_click()
    if activeMode == "arr" then clearMode(); arr.p = nil; arr_hl(); arr_st(); return end
    clearMode(); activeMode = "arr"; arr.p = nil; arr_hl(); arr_st()
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            arr.p = res.Instance; arr_hl(); arr_st(); clearMode()
        end
    end))
end

local function arr_generate()
    if not arr.p then return end
    local folder = newFolder("Array"); local src = arr.p
    local rows = math.max(math.floor(arr.pm.rows), 1)
    local cols = math.max(math.floor(arr.pm.cols), 1)
    local lvls = math.max(math.floor(arr.pm.lvls), 1)
    local stepX = src.Size.X + arr.pm.gapX
    local stepY = src.Size.Y + arr.pm.gapY
    local stepZ = src.Size.Z + arr.pm.gapZ
    local startCF = src.CFrame
    for lv = 0, lvls - 1 do
        for rw = 0, rows - 1 do
            for cl = 0, cols - 1 do
                if lv == 0 and rw == 0 and cl == 0 then
                    src.Parent = folder; flash(src, C.GRN)
                else
                    local clone = src:Clone()
                    clone.Name = "Array_" .. rnd8()
                    clone.CFrame = startCF * CFrame.new(cl * stepX, lv * stepY, rw * stepZ)
                    clone.Transparency = 0.7; clone.Parent = folder
                    TweenSvc:Create(clone,
                        TweenInfo.new(0.05 + (lv * rows * cols + rw * cols + cl) * 0.01),
                        { Transparency = src.Transparency }):Play()
                end
            end
        end
    end
    arr.p = nil; arr_hl(); arr_st()
    commit("Array: Generate")
end

-- ╔══════════════════════════════════════════╗
-- ║          STAIRCASE GENERATOR             ║
-- ╚══════════════════════════════════════════╝
local stair = { p = nil, hl = nil, stLbl = nil, pm = { steps = 8, width = 4, rise = 1, run = 2 } }

local function stair_hl()
    if stair.hl then stair.hl.Adornee = nil end
    if stair.p then if not stair.hl then stair.hl = mkHL(C.ORG) end; stair.hl.Adornee = stair.p end
end

local function stair_st()
    if not stair.stLbl then return end
    if not stair.p then stair.stLbl.Text = "▸ Klik Part dasar"; stair.stLbl.TextColor3 = C.T3
    else stair.stLbl.Text = "Part: " .. stair.p.Name; stair.stLbl.TextColor3 = C.GRN end
end

local function stair_click()
    if activeMode == "stair" then clearMode(); stair.p = nil; stair_hl(); stair_st(); return end
    clearMode(); activeMode = "stair"; stair.p = nil; stair_hl(); stair_st()
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            stair.p = res.Instance; stair_hl(); stair_st(); clearMode()
        end
    end))
end

local function stair_generate()
    if not stair.p then return end
    local folder = newFolder("Staircase"); local src = stair.p
    local steps = math.max(math.floor(stair.pm.steps), 2)
    local w = math.max(stair.pm.width, 0.5)
    local rise = math.max(stair.pm.rise, 0.1)
    local run = math.max(stair.pm.run, 0.1)
    local baseCF = src.CFrame; src.Parent = folder
    for i = 0, steps - 1 do
        local s
        if i == 0 then s = src else s = src:Clone(); s.Name = "Step_" .. i end
        s.Size = Vector3.new(w, rise * (i + 1), run)
        s.CFrame = baseCF * CFrame.new(0, rise * i / 2, -run * i)
        s.Parent = folder; flash(s, C.ORG)
    end
    stair.p = nil; stair_hl(); stair_st()
    commit("Staircase: Generate")
end

-- ╔══════════════════════════════════════════╗
-- ║            MIRROR TOOL                   ║
-- ╚══════════════════════════════════════════╝
local mirr = { p = nil, hl = nil, stLbl = nil, axis = "X" }

local function mirr_hl()
    if mirr.hl then mirr.hl.Adornee = nil end
    if mirr.p then if not mirr.hl then mirr.hl = mkHL(C.PNK) end; mirr.hl.Adornee = mirr.p end
end

local function mirr_st()
    if not mirr.stLbl then return end
    if not mirr.p then mirr.stLbl.Text = "▸ Klik Part sumber"; mirr.stLbl.TextColor3 = C.T3
    else mirr.stLbl.Text = "Part: " .. mirr.p.Name .. "  Axis: " .. mirr.axis; mirr.stLbl.TextColor3 = C.GRN end
end

local function mirr_click()
    if activeMode == "mirr" then clearMode(); mirr.p = nil; mirr_hl(); mirr_st(); return end
    clearMode(); activeMode = "mirr"; mirr.p = nil; mirr_hl(); mirr_st()
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            mirr.p = res.Instance; mirr_hl(); mirr_st(); clearMode()
        end
    end))
end

local function mirr_apply()
    if not mirr.p then return end
    local folder = newFolder("Mirror"); local src = mirr.p; src.Parent = folder
    local cl = src:Clone(); cl.Name = "Mirror_" .. src.Name
    local rx, ry, rz = src.CFrame:ToEulerAnglesXYZ(); local pos = src.CFrame.Position
    if mirr.axis == "X" then
        cl.CFrame = CFrame.new(-pos.X, pos.Y, pos.Z) * CFrame.Angles(rx, -ry, -rz)
    elseif mirr.axis == "Y" then
        cl.CFrame = CFrame.new(pos.X, -pos.Y, pos.Z) * CFrame.Angles(-rx, ry, -rz)
    else
        cl.CFrame = CFrame.new(pos.X, pos.Y, -pos.Z) * CFrame.Angles(-rx, -ry, rz)
    end
    cl.Transparency = 0.8; cl.Parent = folder
    TweenSvc:Create(cl, TweenInfo.new(0.25, Enum.EasingStyle.Back), { Transparency = src.Transparency }):Play()
    flash(cl, C.PNK); mirr.p = nil; mirr_hl(); mirr_st()
    commit("Mirror: Apply")
end

-- ╔══════════════════════════════════════════╗
-- ║           VISUAL TOOLS                   ║
-- ╚══════════════════════════════════════════╝
local MAT_LIST = {
    "SmoothPlastic", "Plastic", "Wood", "WoodPlanks", "Marble", "Slate",
    "Concrete", "Granite", "Brick", "Pebble", "Sand", "CobbleStone",
    "Metal", "DiamondPlate", "Foil", "Grass", "Ice", "LeafyGrass",
    "Salt", "Neon", "Glass", "ForceField"
}
local matPaint = { active = false, curMat = "SmoothPlastic", stLbl = nil, matLbl = nil }

local function matpaint_st()
    if not matPaint.stLbl then return end
    matPaint.stLbl.Text = matPaint.active and "✦ AKTIF — Klik Part" or "Aktifkan lalu klik Part"
    matPaint.stLbl.TextColor3 = matPaint.active and C.GRN or C.T3
end

local function matpaint_toggle()
    matPaint.active = not matPaint.active
    if matPaint.active then
        clearMode(); activeMode = "matpaint"
        addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
            if gpe then return end
            if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
               inp.UserInputType ~= Enum.UserInputType.Touch then return end
            local res = rayPart(inp.Position.X, inp.Position.Y)
            if res and res.Instance and res.Instance:IsA("BasePart") then
                pcall(function() res.Instance.Material = Enum.Material[matPaint.curMat] end)
                flash(res.Instance, C.CYN)
                commit("Material: Paint")
            end
        end))
    else
        clearMode()
    end
    matpaint_st()
end

local colTool = { copied = nil, stLbl = nil }

local function colTool_st()
    if not colTool.stLbl then return end
    if colTool.copied then
        colTool.stLbl.Text = string.format("RGB(%d,%d,%d)",
            math.floor(colTool.copied.R * 255),
            math.floor(colTool.copied.G * 255),
            math.floor(colTool.copied.B * 255))
        colTool.stLbl.TextColor3 = colTool.copied
    else
        colTool.stLbl.Text = "Belum ada warna disalin"
        colTool.stLbl.TextColor3 = C.T3
    end
end

local function colTool_copy()
    clearMode(); activeMode = "col_copy"
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            colTool.copied = res.Instance.Color
            flash(res.Instance, C.CYN); clearMode(); colTool_st()
        end
    end))
end

local function colTool_paste()
    if not colTool.copied then return end
    clearMode(); activeMode = "col_paste"
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            res.Instance.Color = colTool.copied
            flash(res.Instance, C.PNK)
            commit("Color: Paste")
        end
    end))
end

local function colTool_stop() clearMode(); colTool_st() end

local trTool = { p = nil, hl = nil, stLbl = nil, val = 0 }

local function trTool_hl()
    if trTool.hl then trTool.hl.Adornee = nil end
    if trTool.p then
        if not trTool.hl then trTool.hl = mkHL(C.A2, 0.1) end
        trTool.hl.Adornee = trTool.p
    end
end

local function trTool_st()
    if not trTool.stLbl then return end
    if not trTool.p then trTool.stLbl.Text = "▸ Klik Part target"; trTool.stLbl.TextColor3 = C.T3
    else trTool.stLbl.Text = "Part: " .. trTool.p.Name; trTool.stLbl.TextColor3 = C.GRN end
end

local function trTool_click()
    if activeMode == "tr_sel" then clearMode(); trTool.p = nil; trTool_hl(); trTool_st(); return end
    clearMode(); activeMode = "tr_sel"; trTool.p = nil; trTool_hl(); trTool_st()
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            trTool.p = res.Instance; trTool.val = res.Instance.Transparency
            trTool_hl(); trTool_st(); clearMode()
        end
    end))
end

local function trTool_apply(v)
    if trTool.p then
        trTool.p.Transparency = v; trTool.val = v
        commit("Transparency: Apply")
    end
end

local neonActive = false
local function neon_toggle()
    neonActive = not neonActive
    if neonActive then
        clearMode(); activeMode = "neon"
        addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
            if gpe then return end
            if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
               inp.UserInputType ~= Enum.UserInputType.Touch then return end
            local res = rayPart(inp.Position.X, inp.Position.Y)
            if res and res.Instance and res.Instance:IsA("BasePart") then
                local p = res.Instance
                if p.Material == Enum.Material.Neon then
                    p.Material = Enum.Material.SmoothPlastic; flash(p, C.T2)
                else
                    p.Material = Enum.Material.Neon; flash(p, C.YLW)
                end
                commit("Neon: Toggle")
            end
        end))
    else
        clearMode(); neonActive = false
    end
end

-- ╔══════════════════════════════════════════╗
-- ║            UTILITY TOOLS                 ║
-- ╚══════════════════════════════════════════╝
local anchorTool = { active = false, stLbl = nil }

local function anchor_st()
    if not anchorTool.stLbl then return end
    anchorTool.stLbl.Text = anchorTool.active and "✦ AKTIF — klik Part toggle Anchor" or "Aktifkan lalu klik Part"
    anchorTool.stLbl.TextColor3 = anchorTool.active and C.GRN or C.T3
end

local function anchor_toggle()
    anchorTool.active = not anchorTool.active
    if anchorTool.active then
        clearMode(); activeMode = "anchor"
        addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
            if gpe then return end
            if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
               inp.UserInputType ~= Enum.UserInputType.Touch then return end
            local res = rayPart(inp.Position.X, inp.Position.Y)
            if res and res.Instance and res.Instance:IsA("BasePart") then
                local p = res.Instance; p.Anchored = not p.Anchored
                flash(p, p.Anchored and C.GRN or C.RED); anchor_st()
                commit("Anchor: Toggle")
            end
        end))
    else
        clearMode()
    end
    anchor_st()
end

local lockTool = { active = false, stLbl = nil }

local function lock_st()
    if not lockTool.stLbl then return end
    lockTool.stLbl.Text = lockTool.active and "✦ AKTIF — klik Part toggle Lock" or "Aktifkan lalu klik Part"
    lockTool.stLbl.TextColor3 = lockTool.active and C.GRN or C.T3
end

local function lock_toggle()
    lockTool.active = not lockTool.active
    if lockTool.active then
        clearMode(); activeMode = "lock"
        addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
            if gpe then return end
            if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
               inp.UserInputType ~= Enum.UserInputType.Touch then return end
            local res = rayPart(inp.Position.X, inp.Position.Y)
            if res and res.Instance and res.Instance:IsA("BasePart") then
                local p = res.Instance; p.Locked = not p.Locked
                flash(p, p.Locked and C.ORG or C.BLU); lock_st()
                commit("Lock: Toggle")
            end
        end))
    else
        clearMode()
    end
    lock_st()
end

local alignTool = { parts = {}, hls = {}, stLbl = nil }

local function align_clearHL()
    for _, h in ipairs(alignTool.hls) do pcall(function() h:Destroy() end) end
    alignTool.hls = {}
end

local function align_st()
    if not alignTool.stLbl then return end
    local n = #alignTool.parts
    if n == 0 then alignTool.stLbl.Text = "Pilih di Explorer lalu SYNC"; alignTool.stLbl.TextColor3 = C.T3
    else alignTool.stLbl.Text = n .. " part siap — pilih axis"; alignTool.stLbl.TextColor3 = C.GRN end
end

local function align_sync()
    if not pl_Sel then return end
    alignTool.parts = {}; align_clearHL()
    for _, o in ipairs(pl_Sel:Get()) do
        if o:IsA("BasePart") then
            table.insert(alignTool.parts, o)
            local h = mkHL(C.CYN); h.Adornee = o; table.insert(alignTool.hls, h)
        end
    end
    align_st()
end

local function align_do(axis, mode)
    if #alignTool.parts < 2 then return end
    local vals = {}
    for _, p in ipairs(alignTool.parts) do
        local pos = p.Position; local sz = p.Size; local v
        if axis == "X" then
            v = mode == "min" and pos.X - sz.X / 2 or mode == "max" and pos.X + sz.X / 2 or pos.X
        elseif axis == "Y" then
            v = mode == "min" and pos.Y - sz.Y / 2 or mode == "max" and pos.Y + sz.Y / 2 or pos.Y
        else
            v = mode == "min" and pos.Z - sz.Z / 2 or mode == "max" and pos.Z + sz.Z / 2 or pos.Z
        end
        table.insert(vals, v)
    end
    local target
    if mode == "center" then
        local s = 0; for _, v in ipairs(vals) do s = s + v end; target = s / #vals
    elseif mode == "min" then
        target = math.huge; for _, v in ipairs(vals) do if v < target then target = v end end
    else
        target = -math.huge; for _, v in ipairs(vals) do if v > target then target = v end end
    end
    for _, p in ipairs(alignTool.parts) do
        local pos = p.Position; local sz = p.Size; local np
        if axis == "X" then
            np = Vector3.new(mode == "min" and target + sz.X / 2 or mode == "max" and target - sz.X / 2 or target, pos.Y, pos.Z)
        elseif axis == "Y" then
            np = Vector3.new(pos.X, mode == "min" and target + sz.Y / 2 or mode == "max" and target - sz.Y / 2 or target, pos.Z)
        else
            np = Vector3.new(pos.X, pos.Y, mode == "min" and target + sz.Z / 2 or mode == "max" and target - sz.Z / 2 or target)
        end
        TweenSvc:Create(p, TweenInfo.new(0.2), { Position = np }):Play(); flash(p, C.CYN)
    end
    commit("Align: " .. axis .. " " .. mode)
end

local function selByColor()
    clearMode(); activeMode = "selcol"
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            local tc = res.Instance.Color; local found = {}
            for _, p in ipairs(Workspace:GetDescendants()) do
                if p:IsA("BasePart") and p.Color == tc then
                    table.insert(found, p); flash(p, C.CYN)
                end
            end
            if pl_Sel then pcall(function() pl_Sel:Set(found) end) end
            clearMode()
        end
    end))
end

local function selByMat()
    clearMode(); activeMode = "selmat"
    addConn(pl_UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and
           inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local res = rayPart(inp.Position.X, inp.Position.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            local tm = res.Instance.Material; local found = {}
            for _, p in ipairs(Workspace:GetDescendants()) do
                if p:IsA("BasePart") and p.Material == tm then
                    table.insert(found, p); flash(p, C.YLW)
                end
            end
            if pl_Sel then pcall(function() pl_Sel:Set(found) end) end
            clearMode()
        end
    end))
end

local infoHUD = { active = false, conn = nil, frame = nil, lbl = nil }

local function infoHUD_stop()
    infoHUD.active = false
    if infoHUD.conn then pcall(function() infoHUD.conn:Disconnect() end); infoHUD.conn = nil end
    if infoHUD.frame then infoHUD.frame.Visible = false end
end

local function infoHUD_start()
    if infoHUD.active then infoHUD_stop(); return end
    infoHUD.active = true
    if infoHUD.frame then infoHUD.frame.Visible = true end
    infoHUD.conn = RunService.Heartbeat:Connect(function()
        if not infoHUD.active then return end
        local mp = pl_UIS:GetMouseLocation()
        local res = rayPart(mp.X, mp.Y)
        if res and res.Instance and res.Instance:IsA("BasePart") then
            local p = res.Instance; local sz = p.Size; local pos = p.Position
            if infoHUD.lbl then
                infoHUD.lbl.Text = string.format(
                    "NAME: %s\nSIZE: %.2f × %.2f × %.2f\nPOS:  %.1f, %.1f, %.1f\nMAT:  %s\nANCH: %s",
                    p.Name, sz.X, sz.Y, sz.Z, pos.X, pos.Y, pos.Z,
                    tostring(p.Material):gsub("Enum.Material.", ""),
                    tostring(p.Anchored)
                )
            end
            if infoHUD.frame then
                infoHUD.frame.Position = UDim2.new(0, mp.X + 14, 0, mp.Y + 14)
                infoHUD.frame.Visible = true
            end
        else
            if infoHUD.frame then infoHUD.frame.Visible = false end
        end
    end)
end

-- GUI toggle lain
local function doToggle(name)
    local roots = { pl_CG }
    pcall(function() table.insert(roots, pl_PLR.LocalPlayer:FindFirstChildOfClass("PlayerGui")) end)
    for _, root in ipairs(roots) do
        for _, d in ipairs(root:GetDescendants()) do
            if d.Name == name then
                if d:IsA("ScreenGui") then d.Enabled = not d.Enabled
                elseif d:IsA("GuiObject") then d.Visible = not d.Visible end
            end
        end
    end
end

-- ╔══════════════════════════════════════════╗
local function mkLine(par, x, y, w, h, col, tr, zidx)
    local f = Instance.new("Frame", par)
    f.Position = UDim2.new(0, x, 0, y)
    f.Size = UDim2.new(0, w, 0, h)
    f.BackgroundColor3 = col or PR.line
    f.BackgroundTransparency = tr or 0
    f.BorderSizePixel = 0
    if zidx then f.ZIndex = zidx end
    return f
end

-- Garis dengan gradient fade di kedua ujung (horizontal)
local function mkLineGrad(par, x, y, w, h, col, tr)
    local f = mkLine(par, x, y, w, h, col, tr)
    local g = Instance.new("UIGradient", f)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.new(0,0,0)),
        ColorSequenceKeypoint.new(0.12, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(0.88, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1,    Color3.new(0,0,0))
    })
    return f
end

-- Garis vertikal dengan gradient fade atas-bawah
local function mkLineVGrad(par, x, y, w, h, col, tr, zi)
    local f = mkLine(par, x, y, w, h, col, tr, zi)
    local g = Instance.new("UIGradient", f)
    g.Rotation = 90
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.new(0,0,0)),
        ColorSequenceKeypoint.new(0.18, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(0.82, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1,    Color3.new(0,0,0))
    })
    return f
end

local function injectPlugin_buildUI()
-- ║              UI ENGINE  v12 PREMIUM      ║
-- ╚══════════════════════════════════════════╝
local pluginGui = Instance.new("ScreenGui")
pluginGui.Name = "TPv11"; pluginGui.ResetOnSpawn = false; pluginGui.IgnoreGuiInset = true
pluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; pluginGui.DisplayOrder = 9999; pluginGui.Parent = pl_CG

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║   DIMENSI PANEL — lebih compact & pendek                        ║
-- ╚══════════════════════════════════════════════════════════════════╝
PW = 252    -- lebar compact
PH = 430    -- tinggi lebih pendek
HDR_H = 40
TAB_H = 26
BODY_Y = HDR_H + TAB_H + 1
BODY_H = PH - BODY_Y

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║   PALET WARNA PREMIUM — gelap transparan dengan aksen cyan      ║
-- ╚══════════════════════════════════════════════════════════════════╝
PR = {
    bg    = Color3.fromRGB(5, 7, 13),
    bg1   = Color3.fromRGB(9, 12, 20),
    bg2   = Color3.fromRGB(13, 17, 28),
    line  = Color3.fromRGB(32, 50, 80),
    lineB = Color3.fromRGB(0, 148, 218),
    lineA = Color3.fromRGB(0, 218, 168),
    acc   = Color3.fromRGB(0, 195, 255),
    acc2  = Color3.fromRGB(0, 228, 185),
    t0    = Color3.fromRGB(220, 235, 255),
    t1    = Color3.fromRGB(118, 152, 195),
    t2    = Color3.fromRGB(48, 70, 105),
    t3    = Color3.fromRGB(22, 35, 55),
}

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║   HELPER — garis dekoratif                                      ║
-- ╚══════════════════════════════════════════════════════════════════╝

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║   MAIN FRAME — panel utama semi-transparan                      ║
-- ╚══════════════════════════════════════════════════════════════════╝
pl_MF = Instance.new("Frame", pluginGui)
pl_MF.Visible = false
pl_MF.Name = "TPv11_Main"
pl_MF.Size = UDim2.new(0, PW, 0, PH)
pl_MF.Position = UDim2.new(0, 16, 0, 52)
pl_MF.BackgroundColor3 = PR.bg
pl_MF.BackgroundTransparency = 0.28    -- transparan elegan
pl_MF.BorderSizePixel = 0
pl_MF.ClipsDescendants = true
Instance.new("UICorner", pl_MF).CornerRadius = UDim.new(0, 10)

-- ── Blur/glow layer di bawah panel ──────────────────────────────────
pl_glowOuter = Instance.new("Frame", pluginGui)
pl_glowOuter.Name = "TPv11_Glow"
pl_glowOuter.Visible = false
pl_glowOuter.Size = UDim2.new(0, PW + 16, 0, PH + 16)
pl_glowOuter.Position = UDim2.new(0, 8, 0, 44)
pl_glowOuter.BackgroundColor3 = Color3.fromRGB(0, 140, 200)
pl_glowOuter.BackgroundTransparency = 0.88
pl_glowOuter.BorderSizePixel = 0
pl_glowOuter.ZIndex = 0
Instance.new("UICorner", pl_glowOuter).CornerRadius = UDim.new(0, 14)

-- ── Border stroke utama (accent cyan tipis) ──────────────────────────
local mfS = Instance.new("UIStroke", pl_MF)
mfS.Color = PR.lineB; mfS.Thickness = 1; mfS.Transparency = 0.38

-- ═══ GARIS DEKORATIF PANEL ════════════════════════════════════════════

-- [TOP] Garis atas tebal bercahaya — full width + gradient
local topAccent = mkLine(pl_MF, 0, 0, PW, 2, PR.acc, 0, 12)
do
    local g = Instance.new("UIGradient", topAccent)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.06, Color3.fromRGB(0,195,255)),
        ColorSequenceKeypoint.new(0.38, Color3.fromRGB(160,242,255)),
        ColorSequenceKeypoint.new(0.62, Color3.fromRGB(160,242,255)),
        ColorSequenceKeypoint.new(0.94, Color3.fromRGB(0,195,255)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(0,0,0))
    })
end

-- [TOP] Garis atas ke-2 — lebih tipis, offset 3px, warna berbeda
do
    local l = mkLine(pl_MF, 20, 3, PW - 40, 1, PR.lineA, 0.55, 11)
    local g = Instance.new("UIGradient", l)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.new(0,0,0)),
        ColorSequenceKeypoint.new(0.25, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(0.75, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1,    Color3.new(0,0,0))
    })
end

-- [LEFT] Garis vertikal kiri — accent terang
mkLineVGrad(pl_MF, 0, 10, 2, PH - 20, PR.acc, 0.05, 12)

-- [LEFT] Garis vertikal kiri ke-2 — lebih redup, offset 3px
mkLineVGrad(pl_MF, 3, 24, 1, PH - 48, PR.lineA, 0.6, 11)

-- [RIGHT] Garis vertikal kanan — lebih redup (bayangan)
mkLineVGrad(pl_MF, PW - 2, 10, 2, PH - 20, PR.lineB, 0.42, 12)

-- [RIGHT] Garis vertikal kanan ke-2
mkLineVGrad(pl_MF, PW - 4, 24, 1, PH - 48, PR.line, 0.55, 11)

-- [BOTTOM] Garis bawah — redup fade
do
    local l = mkLine(pl_MF, 0, PH - 2, PW, 2, PR.lineB, 0.55, 12)
    local g = Instance.new("UIGradient", l)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.new(0,0,0)),
        ColorSequenceKeypoint.new(0.15, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(0.85, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1,    Color3.new(0,0,0))
    })
end

-- ═══ SUDUT BRACKET DEKORATIF ═════════════════════════════════════════

-- Bracket kiri atas ([ bright)
mkLine(pl_MF, 0,  0,  22, 2, PR.acc,   0,    13)   -- garis atas horizontal
mkLine(pl_MF, 0,  0,  2,  22, PR.acc,  0,    13)   -- garis kiri vertikal
-- inner accent
mkLine(pl_MF, 4,  4,  10, 1, PR.acc2,  0.35, 13)
mkLine(pl_MF, 4,  4,  1,  10, PR.acc2, 0.35, 13)

-- Bracket kanan atas (] bright)
mkLine(pl_MF, PW - 22, 0,  22, 2, PR.acc,  0,    13)
mkLine(pl_MF, PW - 2,  0,  2,  22, PR.acc, 0,    13)
-- inner accent
mkLine(pl_MF, PW - 14, 4, 10, 1, PR.acc2,  0.35, 13)
mkLine(pl_MF, PW - 5,  4, 1,  10, PR.acc2, 0.35, 13)

-- Bracket kiri bawah (redup)
mkLine(pl_MF, 0,  PH - 2, 22, 2, PR.lineB, 0.42, 13)
mkLine(pl_MF, 0,  PH - 22, 2, 22, PR.lineB, 0.42, 13)

-- Bracket kanan bawah (redup)
mkLine(pl_MF, PW - 22, PH - 2, 22, 2, PR.lineB, 0.42, 13)
mkLine(pl_MF, PW - 2, PH - 22, 2,  22, PR.lineB, 0.42, 13)

-- ═══ HEADER ══════════════════════════════════════════════════════════
local HDR = Instance.new("Frame", pl_MF)
HDR.Size = UDim2.new(1, 0, 0, HDR_H)
HDR.Position = UDim2.new(0, 0, 0, 2)
HDR.BackgroundTransparency = 1; HDR.BorderSizePixel = 0; HDR.ZIndex = 5

-- Gradient latar header (top-fade lebih terang)
local hdrBg = Instance.new("Frame", pl_MF)
hdrBg.Size = UDim2.new(1, 0, 0, HDR_H + 2)
hdrBg.Position = UDim2.new(0, 0, 0, 0)
hdrBg.BackgroundColor3 = Color3.fromRGB(0, 28, 48)
hdrBg.BackgroundTransparency = 0.55
hdrBg.BorderSizePixel = 0; hdrBg.ZIndex = 1
do
    local g = Instance.new("UIGradient", hdrBg)
    g.Rotation = 90
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(0.7, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1,   Color3.new(0,0,0))
    })
end

-- Garis pemisah header-tabbar (double line)
mkLineGrad(pl_MF, 8,  HDR_H,     PW - 16, 1, PR.acc,   0.18)
mkLineGrad(pl_MF, 22, HDR_H + 2, PW - 44, 1, PR.lineB, 0.55)

-- ── Badge / ikon ──────────────────────────────────────────────────────
local badge = Instance.new("Frame", HDR)
badge.Size = UDim2.new(0, 30, 0, 30)
badge.Position = UDim2.new(0, 10, 0.5, -15)
badge.BackgroundColor3 = Color3.fromRGB(0, 38, 65)
badge.BackgroundTransparency = 0.22; badge.BorderSizePixel = 0; badge.ZIndex = 6
Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 7)
local badgeS = Instance.new("UIStroke", badge)
badgeS.Color = PR.acc; badgeS.Thickness = 1; badgeS.Transparency = 0.28

-- Garis dekoratif sudut badge
mkLine(badge, 0, 0, 10, 1, PR.acc, 0.1, 7)
mkLine(badge, 0, 0, 1,  10, PR.acc, 0.1, 7)
mkLine(badge, 20, 0, 10, 1, PR.acc, 0.1, 7)
mkLine(badge, 29, 0, 1,  10, PR.acc, 0.1, 7)

local bkIcon = Instance.new("TextLabel", badge)
bkIcon.Size = UDim2.new(1, 0, 1, 0); bkIcon.BackgroundTransparency = 1
bkIcon.Text = "⚒"; bkIcon.TextColor3 = PR.acc
bkIcon.Font = Enum.Font.GothamBold; bkIcon.TextSize = 17; bkIcon.ZIndex = 7

-- ── Title ─────────────────────────────────────────────────────────────
local hTitle = Instance.new("TextLabel", HDR)
hTitle.Size = UDim2.new(0, 140, 0, 16)
hTitle.Position = UDim2.new(0, 48, 0, 5)
hTitle.BackgroundTransparency = 1; hTitle.Text = "TOOLS PANEL"
hTitle.TextColor3 = PR.t0; hTitle.Font = Enum.Font.GothamBold
hTitle.TextSize = 12; hTitle.TextXAlignment = Enum.TextXAlignment.Left; hTitle.ZIndex = 6

-- Underscore dekoratif di bawah title
do
    local ul = mkLine(HDR, 48, 22, 65, 1, PR.acc, 0.3, 6)
    local g = Instance.new("UIGradient", ul)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(0.7, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1,   Color3.new(0,0,0))
    })
end

local hSub = Instance.new("TextLabel", HDR)
hSub.Size = UDim2.new(0, 170, 0, 11)
hSub.Position = UDim2.new(0, 48, 0, 25)
hSub.BackgroundTransparency = 1; hSub.Text = "v12.0  ·  BY SYGKMUNII"
hSub.TextColor3 = PR.t2; hSub.Font = Enum.Font.Code
hSub.TextSize = 7.5; hSub.TextXAlignment = Enum.TextXAlignment.Left; hSub.ZIndex = 6

-- ── Tombol collapse ───────────────────────────────────────────────────
colBtn = Instance.new("TextButton", HDR)
colBtn.Size = UDim2.new(0, 24, 0, 24)
colBtn.Position = UDim2.new(1, -34, 0.5, -12)
colBtn.BackgroundColor3 = Color3.fromRGB(4, 14, 26)
colBtn.BackgroundTransparency = 0.18
colBtn.Text = "−"; colBtn.TextColor3 = PR.acc
colBtn.Font = Enum.Font.GothamBold; colBtn.TextSize = 14
colBtn.BorderSizePixel = 0; colBtn.ZIndex = 7
Instance.new("UICorner", colBtn).CornerRadius = UDim.new(0, 5)
local colBtnS = Instance.new("UIStroke", colBtn)
colBtnS.Color = PR.acc; colBtnS.Transparency = 0.5; colBtnS.Thickness = 1
colBtn.MouseEnter:Connect(function()
    TweenSvc:Create(colBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 42, 72), BackgroundTransparency = 0}):Play()
    colBtnS.Transparency = 0.1
end)
colBtn.MouseLeave:Connect(function()
    TweenSvc:Create(colBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(4, 14, 26), BackgroundTransparency = 0.18}):Play()
    colBtnS.Transparency = 0.5
end)

-- Drag handle
dragHandle = Instance.new("TextButton", HDR)
dragHandle.Size = UDim2.new(1, -48, 1, 0); dragHandle.BackgroundTransparency = 1
dragHandle.Text = ""; dragHandle.BorderSizePixel = 0; dragHandle.ZIndex = 6

-- ── INFO HUD TOOLTIP ─────────────────────────────────────────────────
local hudF = Instance.new("Frame", pluginGui)
hudF.Size = UDim2.new(0, 218, 0, 88)
hudF.BackgroundColor3 = PR.bg
hudF.BackgroundTransparency = 0.15; hudF.BorderSizePixel = 0; hudF.Visible = false; hudF.ZIndex = 9000
Instance.new("UICorner", hudF).CornerRadius = UDim.new(0, 7)
local hudS = Instance.new("UIStroke", hudF)
hudS.Color = PR.acc; hudS.Transparency = 0.45; hudS.Thickness = 1
-- Garis atas HUD (accent)
do
    local hl = mkLine(hudF, 0, 0, 218, 2, PR.acc, 0, 9001)
    local g = Instance.new("UIGradient", hl)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.new(0,0,0)),
        ColorSequenceKeypoint.new(0.1, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(0.9, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1,   Color3.new(0,0,0))
    })
end
local hudLbl = Instance.new("TextLabel", hudF)
hudLbl.Size = UDim2.new(1, -10, 1, -10); hudLbl.Position = UDim2.new(0, 7, 0, 7)
hudLbl.BackgroundTransparency = 1; hudLbl.Text = ""
hudLbl.TextColor3 = PR.t1; hudLbl.Font = Enum.Font.Code; hudLbl.TextSize = 8.5
hudLbl.TextXAlignment = Enum.TextXAlignment.Left; hudLbl.TextYAlignment = Enum.TextYAlignment.Top
hudLbl.TextWrapped = true; hudLbl.ZIndex = 9001
infoHUD.frame = hudF; infoHUD.lbl = hudLbl

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║   TAB BAR — premium dengan garis vertikal pemisah               ║
-- ╚══════════════════════════════════════════════════════════════════╝
local TABS_DEF = {
    { id = "WELD",  lbl = "WELD"  },
    { id = "TALI",  lbl = "TALI"  },
    { id = "SHAPE", lbl = "SHP"   },
    { id = "PATH",  lbl = "PATH"  },
    { id = "BUILD", lbl = "BLD"   },
    { id = "VIS",   lbl = "VIS"   },
    { id = "UTIL",  lbl = "UTIL"  },
    { id = "MISC",  lbl = "MISC"  },
}
local N_TABS   = #TABS_DEF
local TAB_W_EA = math.floor(PW / N_TABS)

-- Latar tab bar (lebih gelap dari panel)
local tabBar = Instance.new("Frame", pl_MF)
tabBar.Size = UDim2.new(1, 0, 0, TAB_H)
tabBar.Position = UDim2.new(0, 0, 0, HDR_H + 1)
tabBar.BackgroundColor3 = Color3.fromRGB(2, 5, 10)
tabBar.BackgroundTransparency = 0.08; tabBar.BorderSizePixel = 0; tabBar.ZIndex = 4

-- Garis atas tab bar (accent terang)
mkLineGrad(pl_MF, 6,  HDR_H,        PW - 12, 1, PR.acc,   0.15)
-- Garis ke-2 (lebih redup, inset)
mkLineGrad(pl_MF, 18, HDR_H + 2,    PW - 36, 1, PR.lineA, 0.62)
-- Garis bawah tab bar
mkLineGrad(pl_MF, 6,  HDR_H + TAB_H, PW - 12, 1, PR.lineB, 0.32)
-- Garis ke-2 bawah
mkLineGrad(pl_MF, 20, HDR_H + TAB_H + 2, PW - 40, 1, PR.line, 0.58)

local pageHolder = Instance.new("Frame", pl_MF)
pageHolder.Size = UDim2.new(1, 0, 0, BODY_H)
pageHolder.Position = UDim2.new(0, 0, 0, BODY_Y + 3)
pageHolder.BackgroundTransparency = 1; pageHolder.BorderSizePixel = 0; pageHolder.ClipsDescendants = true

local tabBtns = {}; pages = {}

-- Indicator bar bawah tab aktif (animated)
local tabIndicator = Instance.new("Frame", tabBar)
tabIndicator.Size = UDim2.new(0, TAB_W_EA - 6, 0, 2)
tabIndicator.Position = UDim2.new(0, 3, 1, -2)
tabIndicator.BackgroundColor3 = PR.acc; tabIndicator.BorderSizePixel = 0; tabIndicator.ZIndex = 8
Instance.new("UICorner", tabIndicator).CornerRadius = UDim.new(0, 1)
-- Glow efek di indicator
do
    local ig = Instance.new("UIGradient", tabIndicator)
    ig.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.new(0,0,0)),
        ColorSequenceKeypoint.new(0.15, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(0.85, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1,    Color3.new(0,0,0))
    })
end

-- Tab highlight frame (background aktif)
local tabHighlight = Instance.new("Frame", tabBar)
tabHighlight.Size = UDim2.new(0, TAB_W_EA, 1, 0)
tabHighlight.Position = UDim2.new(0, 0, 0, 0)
tabHighlight.BackgroundColor3 = Color3.fromRGB(0, 50, 85)
tabHighlight.BackgroundTransparency = 0.35; tabHighlight.BorderSizePixel = 0; tabHighlight.ZIndex = 3

local function switchTab(idx)
    for i, p in ipairs(pages) do p.Visible = (i == idx) end
    for i, b in ipairs(tabBtns) do
        on = (i == idx)
        b.TextColor3 = on and PR.acc or PR.t2
        b.BackgroundTransparency = 1
    end
    local targetX = (idx - 1) * TAB_W_EA
    -- Geser highlight ke tab aktif
    TweenSvc:Create(tabHighlight, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, targetX, 0, 0)
    }):Play()
    -- Geser indicator ke tab aktif
    TweenSvc:Create(tabIndicator, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, targetX + 3, 1, -2)
    }):Play()
end

for i, td in ipairs(TABS_DEF) do
    local tb = Instance.new("TextButton", tabBar)
    tb.Size = UDim2.new(0, TAB_W_EA, 1, 0)
    tb.Position = UDim2.new(0, (i - 1) * TAB_W_EA, 0, 0)
    tb.BackgroundTransparency = 1
    tb.Text = td.lbl
    tb.Font = Enum.Font.GothamBold; tb.TextSize = 7
    tb.TextColor3 = PR.t2; tb.BorderSizePixel = 0; tb.ZIndex = 5
    local ii = i; tb.MouseButton1Click:Connect(function() switchTab(ii) end)
    tb.MouseEnter:Connect(function()
        if pages[ii] and not pages[ii].Visible then
            TweenSvc:Create(tb, TweenInfo.new(0.08), { TextColor3 = PR.t1 }):Play()
        end
    end)
    tb.MouseLeave:Connect(function()
        if pages[ii] and not pages[ii].Visible then
            TweenSvc:Create(tb, TweenInfo.new(0.08), { TextColor3 = PR.t2 }):Play()
        end
    end)
    table.insert(tabBtns, tb)
    -- Garis vertikal pemisah antar tab (dengan gradient fade)
    if i < N_TABS then
        local dv = mkLine(tabBar, i * TAB_W_EA, 5, 1, TAB_H - 10, PR.line, 0.38, 6)
        local dg = Instance.new("UIGradient", dv)
        dg.Rotation = 90
        dg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(0,0,0)),
            ColorSequenceKeypoint.new(0.3, Color3.new(1,1,1)),
            ColorSequenceKeypoint.new(0.7, Color3.new(1,1,1)),
            ColorSequenceKeypoint.new(1,   Color3.new(0,0,0))
        })
    end
end

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║   UI HELPER FUNCTIONS — premium compact                         ║
-- ╚══════════════════════════════════════════════════════════════════╝

local function newPage()
    local sc = Instance.new("ScrollingFrame", pageHolder)
    sc.Size = UDim2.new(1, 0, 1, 0); sc.BackgroundTransparency = 1; sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 2; sc.ScrollBarImageColor3 = PR.acc
    sc.ScrollBarImageTransparency = 0.45
    sc.CanvasSize = UDim2.new(0, 0, 0, 0)
    sc.AutomaticCanvasSize = Enum.AutomaticSize.Y; sc.Visible = false
    lay = Instance.new("UIListLayout", sc)
    lay.SortOrder = Enum.SortOrder.LayoutOrder; lay.Padding = UDim.new(0, 3)
    pad = Instance.new("UIPadding", sc)
    pad.PaddingLeft  = UDim.new(0, 7); pad.PaddingRight  = UDim.new(0, 7)
    pad.PaddingTop   = UDim.new(0, 5); pad.PaddingBottom = UDim.new(0, 7)
    table.insert(pages, sc); return sc
end

-- ── Button dasar premium ──────────────────────────────────────────────
local function mkBtnBase(par, txt, bg, bgh, lo, h)
    local b = Instance.new("TextButton", par)
    b.LayoutOrder = lo or 0; b.Size = UDim2.new(1, 0, 0, h or 26)
    b.BackgroundColor3 = bg
    b.BackgroundTransparency = 0.15
    b.Text = txt
    b.TextColor3 = PR.t0
    b.Font = Enum.Font.GothamBold; b.TextSize = 9; b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    -- Stroke tipis premium
    local bs = Instance.new("UIStroke", b)
    bs.Color = bgh; bs.Thickness = 0.75; bs.Transparency = 0.5
    -- Garis atas tipis di dalam button (highlight effect)
    local bh = mkLine(b, 8, 0, 0, 1, Color3.new(1,1,1), 0.55, 3)
    bh.Size = UDim2.new(1, -16, 0, 1)
    b.MouseEnter:Connect(function()
        TweenSvc:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = bgh, BackgroundTransparency = 0.08}):Play()
        bs.Transparency = 0.2
    end)
    b.MouseLeave:Connect(function()
        TweenSvc:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = bg, BackgroundTransparency = 0.15}):Play()
        bs.Transparency = 0.5
    end)
    return b
end

-- ── Section header dengan garis kiri + garis bawah fade ──────────────
local function uiSec(pg, txt, lo)
    local f = Instance.new("Frame", pg)
    f.LayoutOrder = lo; f.Size = UDim2.new(1, 0, 0, 16)
    f.BackgroundTransparency = 1; f.BorderSizePixel = 0
    -- Garis vertikal kiri (aksen terang)
    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(0, 2, 1, -2); bar.Position = UDim2.new(0, 0, 0, 1)
    bar.BackgroundColor3 = PR.acc; bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 1)
    -- Garis ke-2 (acc2, offset 4px)
    local bar2 = Instance.new("Frame", f)
    bar2.Size = UDim2.new(0, 1, 0.6, 0); bar2.Position = UDim2.new(0, 4, 0.2, 0)
    bar2.BackgroundColor3 = PR.acc2; bar2.BorderSizePixel = 0; bar2.BackgroundTransparency = 0.35
    -- Garis bawah section (fade ke kanan)
    local sep = mkLine(f, 7, 15, PW - 14, 1, PR.line, 0.38)
    do
        local g = Instance.new("UIGradient", sep)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(1,1,1)),
            ColorSequenceKeypoint.new(0.65, Color3.new(1,1,1)),
            ColorSequenceKeypoint.new(1,   Color3.new(0,0,0))
        })
    end
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -12, 1, 0); l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1; l.Text = txt
    l.TextColor3 = PR.acc; l.Font = Enum.Font.GothamBold
    l.TextSize = 8; l.TextXAlignment = Enum.TextXAlignment.Left
end

-- ── Hint box (card gelap) ─────────────────────────────────────────────
local function uiHint(pg, txt, lo)
    local f = Instance.new("Frame", pg)
    f.LayoutOrder = lo; f.Size = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = PR.bg1; f.BackgroundTransparency = 0.15; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local fs = Instance.new("UIStroke", f)
    fs.Color = PR.line; fs.Thickness = 1; fs.Transparency = 0.2
    -- Garis atas hint tipis berwarna
    local ht = mkLine(f, 12, 0, 36, 1, PR.acc2, 0.2, 5)
    -- Titik aksen kiri
    local dot = mkLine(f, 5, 0, 3, 0, PR.acc, 0.1, 5)
    dot.Size = UDim2.new(0, 3, 1, -2); dot.Position = UDim2.new(0, 4, 0, 1)
    dot.BackgroundTransparency = 0.65; Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -16, 0, 0); l.Position = UDim2.new(0, 10, 0, 5)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.BackgroundTransparency = 1; l.Text = txt
    l.TextColor3 = PR.t2; l.Font = Enum.Font.Code
    l.TextSize = 8; l.TextXAlignment = Enum.TextXAlignment.Left; l.TextWrapped = true
    pad = Instance.new("UIPadding", f); pad.PaddingBottom = UDim.new(0, 5)
end

local function uiBtn(pg, lo, txt, bg, bgh, cb)
    local b = mkBtnBase(pg, txt, bg, bgh, lo); b.MouseButton1Click:Connect(cb); return b
end

local function uiSelBtn(pg, lo, txt, cb)
    return uiBtn(pg, lo, txt, Color3.fromRGB(0, 35, 62), Color3.fromRGB(0, 58, 100), cb)
end

local function uiBtnPair(pg, lo, t1, t2, c1, c2, h1, h2, cb1, cb2)
    row = Instance.new("Frame", pg)
    row.LayoutOrder = lo; row.Size = UDim2.new(1, 0, 0, 26)
    row.BackgroundTransparency = 1; row.BorderSizePixel = 0
    local b1 = mkBtnBase(row, t1, c1, h1, 0)
    b1.Size = UDim2.new(0.62, -3, 1, 0); b1.Position = UDim2.new(0, 0, 0, 0)
    b1.MouseButton1Click:Connect(cb1)
    local b2 = mkBtnBase(row, t2, c2, h2, 0)
    b2.Size = UDim2.new(0.38, -3, 1, 0); b2.Position = UDim2.new(0.62, 3, 0, 0)
    b2.MouseButton1Click:Connect(cb2)
end

-- ── Status bar ────────────────────────────────────────────────────────
local function uiStatus(pg, lo)
    local f = Instance.new("Frame", pg)
    f.LayoutOrder = lo; f.Size = UDim2.new(1, 0, 0, 19)
    f.BackgroundColor3 = PR.bg1; f.BackgroundTransparency = 0.12; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
    local fs = Instance.new("UIStroke", f)
    fs.Color = PR.line; fs.Thickness = 1; fs.Transparency = 0.28
    -- Garis kiri berwarna acc2
    local sb = Instance.new("Frame", f)
    sb.Size = UDim2.new(0, 2, 1, -6); sb.Position = UDim2.new(0, 3, 0, 3)
    sb.BackgroundColor3 = PR.acc2; sb.BorderSizePixel = 0
    Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 1)
    -- Titik LED kiri
    local led = Instance.new("Frame", f)
    led.Size = UDim2.new(0, 4, 0, 4); led.Position = UDim2.new(0, 8, 0.5, -2)
    led.BackgroundColor3 = PR.acc2; led.BorderSizePixel = 0; led.BackgroundTransparency = 0.2
    Instance.new("UICorner", led).CornerRadius = UDim.new(1, 0)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -20, 1, 0); l.Position = UDim2.new(0, 16, 0, 0)
    l.BackgroundTransparency = 1; l.Text = "..."
    l.TextColor3 = PR.t2; l.Font = Enum.Font.Code; l.TextSize = 8
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

-- ── Counter display ───────────────────────────────────────────────────
local function uiCounter(pg, lo)
    local f = Instance.new("Frame", pg)
    f.LayoutOrder = lo; f.Size = UDim2.new(1, 0, 0, 19)
    f.BackgroundColor3 = Color3.fromRGB(0, 18, 34); f.BackgroundTransparency = 0.12; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
    local fs = Instance.new("UIStroke", f); fs.Color = PR.lineB; fs.Thickness = 1; fs.Transparency = 0.38
    -- Garis atas tipis
    do
        local gl = mkLine(f, 10, 0, 60, 1, PR.lineB, 0.3, 3)
        local g = Instance.new("UIGradient", gl)
        g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(0,0,0))})
    end
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -12, 1, 0); l.Position = UDim2.new(0, 9, 0, 0)
    l.BackgroundTransparency = 1; l.Text = "STAGED: 0"
    l.TextColor3 = PR.acc; l.Font = Enum.Font.GothamBold; l.TextSize = 8
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

-- ── Divider (double line) ─────────────────────────────────────────────
local function uiDiv(pg, lo)
    local f = Instance.new("Frame", pg)
    f.LayoutOrder = lo; f.Size = UDim2.new(1, 0, 0, 6)
    f.BackgroundTransparency = 1; f.BorderSizePixel = 0
    local l1 = mkLine(f, 0, 1, PW - 14, 1, PR.line, 0.42)
    do
        local g = Instance.new("UIGradient", l1)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,    Color3.new(0,0,0)),
            ColorSequenceKeypoint.new(0.2,  Color3.new(1,1,1)),
            ColorSequenceKeypoint.new(0.8,  Color3.new(1,1,1)),
            ColorSequenceKeypoint.new(1,    Color3.new(0,0,0))
        })
    end
    local l2 = mkLine(f, 16, 4, PW - 48, 1, PR.line, 0.7)
    do
        local g = Instance.new("UIGradient", l2)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(0,0,0)),
            ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)),
            ColorSequenceKeypoint.new(1,   Color3.new(0,0,0))
        })
    end
end

local function uiSlider(pg, lo, lbl, mn, mx, def, fmt, cb)
    local f = Instance.new("Frame", pg)
    f.LayoutOrder = lo; f.Size = UDim2.new(1, 0, 0, 40)
    f.BackgroundColor3 = PR.bg1; f.BackgroundTransparency = 0.18; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local fs = Instance.new("UIStroke", f); fs.Color = PR.line; fs.Thickness = 1; fs.Transparency = 0.3
    local tl = Instance.new("TextLabel", f); tl.Size = UDim2.new(0.7, 0, 0, 14); tl.Position = UDim2.new(0, 9, 0, 4); tl.BackgroundTransparency = 1; tl.Text = lbl; tl.TextColor3 = PR.t1; tl.Font = Enum.Font.Code; tl.TextSize = 8; tl.TextXAlignment = Enum.TextXAlignment.Left
    local vl = Instance.new("TextLabel", f); vl.Size = UDim2.new(0.3, 0, 0, 14); vl.Position = UDim2.new(0.7, -9, 0, 4); vl.BackgroundTransparency = 1; vl.Text = fmt(def); vl.TextColor3 = PR.acc; vl.Font = Enum.Font.GothamBold; vl.TextSize = 8; vl.TextXAlignment = Enum.TextXAlignment.Right
    local track = Instance.new("Frame", f); track.Size = UDim2.new(1, -18, 0, 3); track.Position = UDim2.new(0, 9, 0, 25); track.BackgroundColor3 = Color3.fromRGB(6, 16, 30); track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 2)
    local fill = Instance.new("Frame", track); fill.Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0); fill.BackgroundColor3 = PR.acc; fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 2)
    local knob = Instance.new("Frame", track); knob.Size = UDim2.new(0, 10, 0, 10); knob.AnchorPoint = Vector2.new(0.5, 0.5); knob.Position = UDim2.new((def - mn) / (mx - mn), 0, 0.5, 0); knob.BackgroundColor3 = PR.acc; knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local cur = def; local dragging = false
    local function setVal(v)
        v = math.clamp(v, mn, mx); cur = v
        local t = (v - mn) / (mx - mn)
        fill.Size = UDim2.new(t, 0, 1, 0); knob.Position = UDim2.new(t, 0, 0.5, 0); vl.Text = fmt(v); cb(v)
    end
    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    pl_UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local rel = i.Position.X - track.AbsolutePosition.X
            local t = math.clamp(rel / track.AbsoluteSize.X, 0, 1); setVal(mn + t * (mx - mn))
        end
    end)
    pl_UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    return function() return cur end
end

local function uiNumInput(pg, lo, lbl, def, setPm)
    local f = Instance.new("Frame", pg); f.LayoutOrder = lo; f.Size = UDim2.new(1, 0, 0, 24); f.BackgroundColor3 = PR.bg1; f.BackgroundTransparency = 0.18; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local fs = Instance.new("UIStroke", f); fs.Color = PR.line; fs.Thickness = 1; fs.Transparency = 0.3
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6, 0, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.BackgroundTransparency = 1; l.Text = lbl; l.TextColor3 = PR.t1; l.Font = Enum.Font.Code; l.TextSize = 8.5; l.TextXAlignment = Enum.TextXAlignment.Left
    local tb = Instance.new("TextBox", f); tb.Size = UDim2.new(0.4, -11, 0, 16); tb.Position = UDim2.new(0.6, 3, 0.5, -8); tb.BackgroundColor3 = Color3.fromRGB(0, 15, 30); tb.Text = tostring(def); tb.TextColor3 = PR.acc; tb.Font = Enum.Font.Code; tb.TextSize = 8.5; tb.BorderSizePixel = 0; tb.ClearTextOnFocus = false; tb.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 3)
    tb.FocusLost:Connect(function() local v = tonumber(tb.Text); if v then setPm(v) end end)
end

local function uiNumRow(pg, lo, lbl, def, key)
    local f = Instance.new("Frame", pg); f.LayoutOrder = lo; f.Size = UDim2.new(1, 0, 0, 24); f.BackgroundColor3 = PR.bg1; f.BackgroundTransparency = 0.18; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
    local fs = Instance.new("UIStroke", f); fs.Color = PR.line; fs.Thickness = 1; fs.Transparency = 0.3
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6, 0, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.BackgroundTransparency = 1; l.Text = lbl; l.TextColor3 = PR.t1; l.Font = Enum.Font.Code; l.TextSize = 8.5; l.TextXAlignment = Enum.TextXAlignment.Left
    local tb = Instance.new("TextBox", f); tb.Size = UDim2.new(0.4, -11, 0, 16); tb.Position = UDim2.new(0.6, 3, 0.5, -8); tb.BackgroundColor3 = Color3.fromRGB(0, 15, 30); tb.Text = tostring(def); tb.TextColor3 = PR.acc; tb.Font = Enum.Font.Code; tb.TextSize = 8.5; tb.BorderSizePixel = 0; tb.ClearTextOnFocus = false; tb.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 3)
    tb.FocusLost:Connect(function() local v = tonumber(tb.Text); if v then arc.pm[key] = v end end)
    return tb
end

local function uiToggle(pg, lo, name, lbl)
    row = Instance.new("Frame", pg)
    row.LayoutOrder = lo; row.Size = UDim2.new(1, 0, 0, 26)
    row.BackgroundColor3 = PR.bg1; row.BackgroundTransparency = 0.18; row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
    local fs = Instance.new("UIStroke", row); fs.Color = PR.line; fs.Thickness = 1; fs.Transparency = 0.3
    local tl = Instance.new("TextLabel", row); tl.Size = UDim2.new(1, -50, 1, 0); tl.Position = UDim2.new(0, 10, 0, 0); tl.BackgroundTransparency = 1; tl.Text = lbl; tl.TextColor3 = PR.t1; tl.Font = Enum.Font.Code; tl.TextSize = 8.5; tl.TextXAlignment = Enum.TextXAlignment.Left
    local sw = Instance.new("TextButton", row); sw.Size = UDim2.new(0, 34, 0, 15); sw.Position = UDim2.new(1, -44, 0.5, -7); sw.BackgroundColor3 = Color3.fromRGB(5, 10, 20); sw.Text = ""; sw.BorderSizePixel = 0
    Instance.new("UICorner", sw).CornerRadius = UDim.new(0, 7)
    local swS = Instance.new("UIStroke", sw); swS.Color = PR.line; swS.Thickness = 1; swS.Transparency = 0.28
    local knob = Instance.new("Frame", sw); knob.Size = UDim2.new(0, 11, 0, 11); knob.Position = UDim2.new(0, 2, 0.5, -5); knob.BackgroundColor3 = Color3.fromRGB(35, 52, 75); knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local isOn = false
    local function setOn(v)
        isOn = v
        TweenSvc:Create(knob, TweenInfo.new(0.14), {
            Position = v and UDim2.new(0, 21, 0.5, -5) or UDim2.new(0, 2, 0.5, -5),
            BackgroundColor3 = v and PR.acc or Color3.fromRGB(35, 52, 75)
        }):Play()
        TweenSvc:Create(sw, TweenInfo.new(0.14), {
            BackgroundColor3 = v and Color3.fromRGB(0, 30, 52) or Color3.fromRGB(5, 10, 20)
        }):Play()
    end
    local function syncInit()
        local roots = { pl_CG }; pcall(function() table.insert(roots, pl_PLR.LocalPlayer:FindFirstChildOfClass("PlayerGui")) end)
        for _, root in ipairs(roots) do
            for _, d in ipairs(root:GetDescendants()) do
                if d.Name == name then
                    local cur = false
                    if d:IsA("ScreenGui") then cur = d.Enabled elseif d:IsA("GuiObject") then cur = d.Visible end
                    setOn(cur); return
                end
            end
        end
    end
    task.defer(syncInit)
    sw.MouseButton1Click:Connect(function() doToggle(name); setOn(not isOn) end)
end

-- ╔══════════════════════════════════════════╗
-- ║              PAGE BUILDERS               ║
-- ╚══════════════════════════════════════════╝

-- ── PAGE 1: WELD ─────────────────────────────────────────────────────
local function buildPageWT(pg)
    uiSec(pg, "WELD  //  2-PART CONSTRAINT", 1)
    uiHint(pg, "[01] Mode WELD → klik Part-1 (merah) lalu Part-2 (biru)\n[02] APPLY WELD → buat WeldConstraint\n[03] Ulangi sesuai kebutuhan → SATUKAN ke folder", 2)
    uiDiv(pg, 3)
    uiSelBtn(pg, 4, ">>  MODE WELD  ( pilih 2 part )", function() wt_activate("weld") end)
    wt.stLbl = uiStatus(pg, 5)
    uiBtnPair(pg, 6, "APPLY WELD", "UNDO", C.W_C, C.U_C, C.W_H, C.U_H, wt_applyWeld, wt_undo)
    uiDiv(pg, 7)
    uiSec(pg, "ROPE  //  PHYSICS CONSTRAINT", 8)
    uiHint(pg, "[01] Mode ROPE → klik Part-1 lalu Part-2\n[02] APPLY ROPE → buat RopeConstraint\n※ Gunakan tab TALI untuk posisi attachment bebas", 9)
    uiSelBtn(pg, 10, ">>  MODE ROPE  ( pilih 2 part )", function() wt_activate("rope") end)
    uiBtnPair(pg, 11, "APPLY ROPE", "UNDO", C.R_C, C.U_C, C.R_H, C.U_H, wt_applyRope, wt_undo)
    uiDiv(pg, 12)
    uiSec(pg, "MULTI-WELD  //  BULK SELECTION", 13)
    uiHint(pg, "Pilih beberapa part di Explorer lalu WELD ALL\nSemua terhubung ke Part pertama", 14)
    uiBtnPair(pg, 15, "WELD ALL", "UNDO", C.W_C, C.U_C, C.W_H, C.U_H, wt_multiWeld, wt_undo)
    uiDiv(pg, 16)
    wt.cntLbl = uiCounter(pg, 17)
    uiBtn(pg, 18, "SATUKAN SEMUA  >>  WeldGroup Folder", C.M_C, C.M_H, wt_mergeFolder)
end

-- ── PAGE 2: TALI ─────────────────────────────────────────────────────
local function buildPageTali(pg)
    uiSec(pg, "TALI v5  //  KLIK & DRAG", 1)
    uiHint(pg, "[01] Tekan TALI ON\n[02] Klik & TAHAN part → langsung MERAH\n[03] Drag ke part lain → tali ikut cursor\n[04] Lepas → tali terpasang!", 2)
    rp.stLbl = uiStatus(pg, 3)
    uiBtnPair(pg, 4, "TALI  ON / OFF", "UNDO", C.R_C, C.U_C, C.R_H, C.U_H, rp_toggle, rp_undo)
end

-- ── PAGE 3: SHAPE ────────────────────────────────────────────────────
local function buildPageShape(pg)
    uiSec(pg, "GAP FILL  //  AUTO BRIDGE", 1)
    uiHint(pg, "[01] Aktifkan → klik Part-1 lalu Part-2\n[02] FILL → otomatis isi celah di antara keduanya\n[03] Part pengisi di-weld ke kedua part", 2)
    uiSelBtn(pg, 3, ">>  AKTIFKAN PILIH PART", gf_click)
    gf.stLbl = uiStatus(pg, 4)
    uiBtnPair(pg, 5, "FILL GAP", "CLEAR", C.G_C, C.D_C, C.G_H, C.D_H, gf_fill, gf_clear)
    uiDiv(pg, 6)
    uiSec(pg, "BEND  //  FLEX PART TOOL", 7)
    uiHint(pg, "[01] Aktifkan → klik Part target\n[02] Atur Angle / Length / Segments\n[03] APPLY BEND — part dipecah jadi segmen bengkok", 8)
    uiSelBtn(pg, 9, ">>  AKTIFKAN PILIH PART", bend_click)
    bend.stLbl = uiStatus(pg, 10)
    local getBend = uiSlider(pg, 11, "Angle (deg)", -45, 45, 0,
        function(v) return string.format("%+.0f°", v) end,
        function(v) bend.pm.bend = v end)
    local getLen = uiSlider(pg, 12, "Length (×)", 0.5, 5, 1,
        function(v) return string.format("%.1f×", v) end,
        function(v) bend.pm.length = v end)
    local getSegs = uiSlider(pg, 13, "Segments", 2, 24, 8,
        function(v) return string.format("%d", v) end,
        function(v) bend.pm.segs = v end)
    uiBtn(pg, 14, "APPLY BEND", C.G_C, C.G_H, function()
        bend.pm.bend = getBend(); bend.pm.length = getLen(); bend.pm.segs = getSegs()
        bend_apply()
    end)
end

-- ── PAGE 4: PATH ─────────────────────────────────────────────────────
local function buildPagePath(pg)
    uiSec(pg, "DRAW PATH  //  FREEHAND BUILDER", 1)
    uiHint(pg, "[01] Pilih Part sumber\n[02] START → gambar jalur bebas\n[03] STOP → BUILD → part disusun sepanjang jalur", 2)
    uiSelBtn(pg, 3, ">>  AKTIFKAN PILIH PART SUMBER", draw_selectPart)
    draw.stLbl = uiStatus(pg, 4)
    uiBtnPair(pg, 5, "START / STOP", "RESET", C.W_C, C.D_C, C.W_H, C.D_H,
        function() draw_startDraw(pluginGui) end, draw_reset)
    uiBtn(pg, 6, "BUILD PARTS ON PATH", C.G_C, C.G_H, draw_build)
    uiDiv(pg, 7)
    uiSec(pg, "ARCHIMEDES  //  ARC DUPLICATOR", 8)
    uiHint(pg, "[01] Pilih Part sumber\n[02] Atur parameter → GENERATE\n    Count=jumlah, Angle=busur, Height=naik, Scale=besar/kecil", 9)
    uiSelBtn(pg, 10, ">>  AKTIFKAN PILIH PART SUMBER", arc_click)
    arc.stLbl = uiStatus(pg, 11)
    arc.inp.count  = uiNumRow(pg, 12, "Count (duplikat)", 8, "count")
    arc.inp.angle  = uiNumRow(pg, 13, "Arc Angle (deg)", 360, "angle")
    arc.inp.height = uiNumRow(pg, 14, "Height per step", 0, "height")
    arc.inp.scale  = uiNumRow(pg, 15, "Scale per step", 1, "scale")
    uiBtn(pg, 16, "GENERATE ARC", C.G_C, C.G_H, arc_start)
end

-- ── PAGE 5: BUILD ────────────────────────────────────────────────────
local function buildPageBuild(pg)
    uiSec(pg, "ARRAY DUPLICATOR  //  GRID 3D", 1)
    uiHint(pg, "[01] Aktifkan → klik Part sumber\n[02] Atur Rows/Cols/Levels & Gap → GENERATE\n    Hasil disusun dalam grid 3D otomatis", 2)
    uiSelBtn(pg, 3, ">>  AKTIFKAN PILIH PART", arr_click)
    arr.stLbl = uiStatus(pg, 4)
    uiNumInput(pg, 5, "Rows (Z)", 3, function(v) arr.pm.rows = v end)
    uiNumInput(pg, 6, "Cols (X)", 3, function(v) arr.pm.cols = v end)
    uiNumInput(pg, 7, "Levels (Y)", 1, function(v) arr.pm.lvls = v end)
    uiNumInput(pg, 8, "Gap X", 0, function(v) arr.pm.gapX = v end)
    uiNumInput(pg, 9, "Gap Y", 0, function(v) arr.pm.gapY = v end)
    uiNumInput(pg, 10, "Gap Z", 0, function(v) arr.pm.gapZ = v end)
    uiBtn(pg, 11, "GENERATE ARRAY", C.G_C, C.G_H, arr_generate)
    uiDiv(pg, 12)
    uiSec(pg, "STAIRCASE GENERATOR", 13)
    uiHint(pg, "[01] Aktifkan → klik Part dasar\n[02] Atur Steps / Width / Rise / Run → GENERATE", 14)
    uiSelBtn(pg, 15, ">>  AKTIFKAN PILIH PART", stair_click)
    stair.stLbl = uiStatus(pg, 16)
    uiNumInput(pg, 17, "Steps", 8, function(v) stair.pm.steps = v end)
    uiNumInput(pg, 18, "Width", 4, function(v) stair.pm.width = v end)
    uiNumInput(pg, 19, "Rise", 1, function(v) stair.pm.rise = v end)
    uiNumInput(pg, 20, "Run", 2, function(v) stair.pm.run = v end)
    uiBtn(pg, 21, "GENERATE STAIRCASE", C.G_C, C.G_H, stair_generate)
    uiDiv(pg, 22)
    uiSec(pg, "MIRROR TOOL  //  SIMETRI AXIS", 23)
    uiHint(pg, "[01] Aktifkan → klik Part\n[02] Pilih Axis mirror → APPLY MIRROR", 24)
    uiSelBtn(pg, 25, ">>  AKTIFKAN PILIH PART", mirr_click)
    mirr.stLbl = uiStatus(pg, 26)
    do
        local axRow = Instance.new("Frame", pg); axRow.LayoutOrder = 27; axRow.Size = UDim2.new(1, 0, 0, 30); axRow.BackgroundTransparency = 1; axRow.BorderSizePixel = 0
        local axes = { "X", "Y", "Z" }; local axBtns = {}
        for i, ax in ipairs(axes) do
            local b = Instance.new("TextButton", axRow)
            b.Size = UDim2.new(0.32, -4, 1, 0); b.Position = UDim2.new((i - 1) * 0.333, 2, 0, 0)
            b.Text = "AXIS " .. ax; b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.BorderSizePixel = 0
            b.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 72, 125) or Color3.fromRGB(18, 24, 40)
            b.TextColor3 = Color3.fromRGB(205, 228, 255)
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7); axBtns[i] = b
            local ai = i; local aax = ax
            b.MouseButton1Click:Connect(function()
                mirr.axis = aax; mirr_st()
                for j, bb in ipairs(axBtns) do
                    bb.BackgroundColor3 = j == ai and Color3.fromRGB(0, 72, 125) or Color3.fromRGB(18, 24, 40)
                end
            end)
        end
    end
    uiBtn(pg, 28, "APPLY MIRROR", C.P_C, C.P_H, mirr_apply)
end

-- ── PAGE 6: VISUAL ───────────────────────────────────────────────────
local function buildPageVisual(pg)
    uiSec(pg, "MATERIAL PAINTER  //  CAT MATERIAL", 1)
    uiHint(pg, "[01] Pilih material dari list\n[02] Aktifkan → klik Part manapun untuk cat", 2)
    matPaint.stLbl = uiStatus(pg, 3)
    do
        local sf = Instance.new("ScrollingFrame", pg); sf.LayoutOrder = 4; sf.Size = UDim2.new(1, 0, 0, 88)
        sf.BackgroundColor3 = Color3.fromRGB(4, 8, 15); sf.BackgroundTransparency = 0.18; sf.BorderSizePixel = 0
        sf.ScrollBarThickness = 2; sf.ScrollBarImageColor3 = Color3.fromRGB(0, 145, 195)
        sf.CanvasSize = UDim2.new(0, 0, 0, 0); sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UICorner", sf).CornerRadius = UDim.new(0, 7)
        lay = Instance.new("UIListLayout", sf); lay.SortOrder = Enum.SortOrder.LayoutOrder; lay.Padding = UDim.new(0, 3)
        pad = Instance.new("UIPadding", sf); pad.PaddingLeft = UDim.new(0, 6); pad.PaddingRight = UDim.new(0, 6); pad.PaddingTop = UDim.new(0, 6)
        local matBtns = {}
        for idx, mname in ipairs(MAT_LIST) do
            local mb = Instance.new("TextButton", sf); mb.LayoutOrder = idx; mb.Size = UDim2.new(1, 0, 0, 21)
            mb.Text = mname; mb.Font = Enum.Font.Code; mb.TextSize = 10; mb.TextColor3 = Color3.fromRGB(162, 205, 235)
            mb.BorderSizePixel = 0; mb.BackgroundColor3 = Color3.fromRGB(6, 14, 26); mb.BackgroundTransparency = 0.28
            Instance.new("UICorner", mb).CornerRadius = UDim.new(0, 5); matBtns[idx] = mb
            local mn = mname; local midx = idx
            mb.MouseButton1Click:Connect(function()
                matPaint.curMat = mn
                if matPaint.matLbl then matPaint.matLbl.Text = "Material: " .. mn end
                for j, bb in ipairs(matBtns) do
                    bb.BackgroundColor3 = j == midx and Color3.fromRGB(0, 58, 95) or Color3.fromRGB(6, 14, 26)
                    bb.TextColor3 = j == midx and Color3.fromRGB(0, 205, 255) or Color3.fromRGB(162, 205, 235)
                end
            end)
        end
        local mir = Instance.new("Frame", pg); mir.LayoutOrder = 5; mir.Size = UDim2.new(1, 0, 0, 22); mir.BackgroundTransparency = 1; mir.BorderSizePixel = 0
        matPaint.matLbl = Instance.new("TextLabel", mir); matPaint.matLbl.Size = UDim2.new(1, 0, 1, 0); matPaint.matLbl.BackgroundTransparency = 1; matPaint.matLbl.Text = "Material: SmoothPlastic"; matPaint.matLbl.TextColor3 = Color3.fromRGB(0, 185, 235); matPaint.matLbl.Font = Enum.Font.Code; matPaint.matLbl.TextSize = 10; matPaint.matLbl.TextXAlignment = Enum.TextXAlignment.Left
    end
    uiBtn(pg, 6, "AKTIFKAN / NONAKTIFKAN PAINTER", Color3.fromRGB(0, 72, 115), Color3.fromRGB(0, 105, 158), matpaint_toggle)
    uiDiv(pg, 7)
    uiSec(pg, "COLOR COPY  //  SALIN WARNA PART", 8)
    uiHint(pg, "COPY: klik part untuk salin warna\nPASTE: klik part untuk tempel warna\nSTOP: hentikan mode paste", 9)
    colTool.stLbl = uiStatus(pg, 10)
    do
        row = Instance.new("Frame", pg); row.LayoutOrder = 11; row.Size = UDim2.new(1, 0, 0, 30); row.BackgroundTransparency = 1; row.BorderSizePixel = 0
        local function mk3(txt, col, hcol, xs, xo, cb)
            local b = Instance.new("TextButton", row); b.Size = UDim2.new(0.333, -3, 1, 0); b.Position = UDim2.new(xs, xo, 0, 0)
            b.BackgroundColor3 = col; b.Text = txt; b.TextColor3 = Color3.fromRGB(205, 228, 248); b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.BorderSizePixel = 0
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
            b.MouseEnter:Connect(function() TweenSvc:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = hcol }):Play() end)
            b.MouseLeave:Connect(function() TweenSvc:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = col }):Play() end)
            b.MouseButton1Click:Connect(cb)
        end
        mk3("COPY",  Color3.fromRGB(0, 65, 102), Color3.fromRGB(0, 98, 148), 0,     0, colTool_copy)
        mk3("PASTE", Color3.fromRGB(0, 82, 48),  Color3.fromRGB(0, 112, 68),  0.333, 3, colTool_paste)
        mk3("STOP",  Color3.fromRGB(82, 18, 18), Color3.fromRGB(115, 28, 28), 0.666, 6, colTool_stop)
    end
    uiDiv(pg, 12)
    uiSec(pg, "TRANSPARENCY  //  SLIDER", 13)
    uiHint(pg, "[01] Aktifkan → klik Part\n[02] Geser slider  0=solid  1=invisible", 14)
    uiSelBtn(pg, 15, ">>  AKTIFKAN PILIH PART", trTool_click)
    trTool.stLbl = uiStatus(pg, 16)
    uiSlider(pg, 17, "Transparency", 0, 1, 0,
        function(v) return string.format("%.2f", v) end, trTool_apply)
    uiDiv(pg, 18)
    uiSec(pg, "NEON TOGGLE  //  GLOW MATERIAL", 19)
    uiHint(pg, "Aktifkan → klik Part untuk toggle Neon on/off", 20)
    do
        row = Instance.new("Frame", pg); row.LayoutOrder = 21; row.Size = UDim2.new(1, 0, 0, 30); row.BackgroundTransparency = 1; row.BorderSizePixel = 0
        local function mkN2(txt, col, hcol, xs, xo, cb)
            local b = Instance.new("TextButton", row); b.Size = UDim2.new(0.5, -3, 1, 0); b.Position = UDim2.new(xs, xo, 0, 0)
            b.BackgroundColor3 = col; b.Text = txt; b.TextColor3 = Color3.fromRGB(255, 242, 205); b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.BorderSizePixel = 0
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
            b.MouseEnter:Connect(function() TweenSvc:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = hcol }):Play() end)
            b.MouseLeave:Connect(function() TweenSvc:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = col }):Play() end)
            b.MouseButton1Click:Connect(cb)
        end
        mkN2("AKTIFKAN NEON", Color3.fromRGB(82, 62, 0), Color3.fromRGB(122, 95, 0), 0, 0, neon_toggle)
        mkN2("STOP", Color3.fromRGB(52, 12, 12), Color3.fromRGB(85, 20, 20), 0.5, 3,
            function() neonActive = false; clearMode() end)
    end
end

-- ── PAGE 7: UTIL ─────────────────────────────────────────────────────
local function buildPageUtil(pg)
    uiSec(pg, "ANCHOR TOGGLE  //  KLIK ANCHOR", 1)
    uiHint(pg, "Aktifkan → klik Part untuk toggle Anchored\nHijau = Anchored   Merah = Unanchored", 2)
    anchorTool.stLbl = uiStatus(pg, 3)
    uiBtn(pg, 4, "AKTIFKAN / NONAKTIFKAN ANCHOR", Color3.fromRGB(0, 92, 52), Color3.fromRGB(0, 126, 74), anchor_toggle)
    uiDiv(pg, 5)
    uiSec(pg, "LOCK / UNLOCK  //  KLIK LOCK", 6)
    uiHint(pg, "Aktifkan → klik Part untuk toggle Lock\nOrange = Locked   Biru = Unlocked", 7)
    lockTool.stLbl = uiStatus(pg, 8)
    uiBtn(pg, 9, "AKTIFKAN / NONAKTIFKAN LOCK", Color3.fromRGB(92, 56, 0), Color3.fromRGB(128, 80, 0), lock_toggle)
    uiDiv(pg, 10)
    uiSec(pg, "ALIGN TOOL  //  RATA-RATAKAN", 11)
    uiHint(pg, "[01] Pilih part di Explorer\n[02] SYNC → pilih axis dan mode MIN/CTR/MAX", 12)
    alignTool.stLbl = uiStatus(pg, 13)
    uiBtn(pg, 14, "SYNC DARI EXPLORER", Color3.fromRGB(0, 56, 92), Color3.fromRGB(0, 82, 130), align_sync)
    do
        local function uiAlignRow(pg2, lo2, axis)
            local sec = Instance.new("Frame", pg2); sec.LayoutOrder = lo2; sec.Size = UDim2.new(1, 0, 0, 30); sec.BackgroundTransparency = 1; sec.BorderSizePixel = 0
            local lbl = Instance.new("TextLabel", sec); lbl.Size = UDim2.new(0, 26, 1, 0); lbl.BackgroundTransparency = 1; lbl.Text = axis; lbl.TextColor3 = Color3.fromRGB(0, 175, 228); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
            local modes = { "MIN", "CTR", "MAX" }; local modKeys = { "min", "center", "max" }; local bW = (1 - 0.12) / 3
            for i, m in ipairs(modes) do
                local b = Instance.new("TextButton", sec); b.Size = UDim2.new(bW, -3, 1, 0); b.Position = UDim2.new(0.12 + (i - 1) * bW, 2, 0, 0)
                b.Text = m; b.Font = Enum.Font.GothamBold; b.TextSize = 9; b.BorderSizePixel = 0
                b.BackgroundColor3 = Color3.fromRGB(10, 30, 52); b.TextColor3 = Color3.fromRGB(182, 215, 245)
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
                local mk = modKeys[i]; local axi = axis
                b.MouseEnter:Connect(function() TweenSvc:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(0, 56, 92) }):Play() end)
                b.MouseLeave:Connect(function() TweenSvc:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(10, 30, 52) }):Play() end)
                b.MouseButton1Click:Connect(function() align_do(axi, mk) end)
            end
        end
        uiAlignRow(pg, 15, "X"); uiAlignRow(pg, 16, "Y"); uiAlignRow(pg, 17, "Z")
    end
    uiDiv(pg, 18)
    uiSec(pg, "SELECT BY  //  FILTER PART", 19)
    uiHint(pg, "Klik Part referensi:\nCOLOR = pilih semua part warna sama\nMATERIAL = pilih semua part material sama", 20)
    do
        row = Instance.new("Frame", pg); row.LayoutOrder = 21; row.Size = UDim2.new(1, 0, 0, 30); row.BackgroundTransparency = 1; row.BorderSizePixel = 0
        local function mk2(txt, col, hcol, xs, xo, cb)
            local b = Instance.new("TextButton", row); b.Size = UDim2.new(0.5, -3, 1, 0); b.Position = UDim2.new(xs, xo, 0, 0)
            b.BackgroundColor3 = col; b.Text = txt; b.TextColor3 = Color3.fromRGB(205, 228, 248); b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.BorderSizePixel = 0
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
            b.MouseEnter:Connect(function() TweenSvc:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = hcol }):Play() end)
            b.MouseLeave:Connect(function() TweenSvc:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = col }):Play() end)
            b.MouseButton1Click:Connect(cb)
        end
        mk2("BY COLOR",    Color3.fromRGB(0, 68, 115),  Color3.fromRGB(0, 95, 158), 0,   0, selByColor)
        mk2("BY MATERIAL", Color3.fromRGB(62, 42, 0),   Color3.fromRGB(92, 62, 0),  0.5, 3, selByMat)
    end
    uiDiv(pg, 22)
    uiSec(pg, "PART INFO HUD  //  HOVER TOOLTIP", 23)
    uiHint(pg, "Aktifkan → arahkan mouse ke Part\nMuncul: Name / Size / Position / Material / Anchor", 24)
    uiBtn(pg, 25, "AKTIFKAN / NONAKTIFKAN INFO HUD", Color3.fromRGB(0, 52, 82), Color3.fromRGB(0, 78, 120), infoHUD_start)
end

-- ── PAGE 8: MISC ─────────────────────────────────────────────────────
local function buildPageMisc(pg)
    uiSec(pg, "GUI TOGGLES  //  PANEL VISIBILITY", 1)
    uiHint(pg, "Tampilkan atau sembunyikan panel lain", 2)
    uiToggle(pg, 3, "UR_Lite", "UR_Lite")
    uiToggle(pg, 4, "UW_Lite", "UW_Lite")
    uiToggle(pg, 5, "ARC_Lite", "ARC_Lite")
    uiDiv(pg, 6)
    uiSec(pg, "ABOUT  //  v11.0", 7)
    uiHint(pg, "Tools Panel v11.0  |  BY SYGKMUNII\n\n[WELD]  2-Part, Multi-Weld, Rope Staging\n[TALI]  Surface Attachment Rope + Drag Mode\n[SHAPE] GapFill, Bend\n[PATH]  DrawPath, Archimedes\n[BUILD] Array, Staircase, Mirror\n[VIS]   Material, Color, Transparency, Neon\n[UTIL]  Anchor, Lock, Align, SelectBy, InfoHUD\n\nv11.0: Rombak total + ChangeHistoryService\n         Tali v2: drag attachment ke titik bebas\n         Semua aksi committed ke Studio History", 8)
end

-- ╔══════════════════════════════════════════╗
-- ║           BUILD ALL PAGES                ║
-- ╚══════════════════════════════════════════╝
local pgWT     = newPage(); local pgTali  = newPage()
local pgShape  = newPage(); local pgPath  = newPage()
local pgBuild  = newPage(); local pgVisual = newPage()
local pgUtil   = newPage(); local pgMisc  = newPage()

buildPageWT(pgWT)
buildPageTali(pgTali)
buildPageShape(pgShape)
buildPagePath(pgPath)
buildPageBuild(pgBuild)
buildPageVisual(pgVisual)
buildPageUtil(pgUtil)
buildPageMisc(pgMisc)
switchTab(1)

-- ╔══════════════════════════════════════════╗
-- ║         COLLAPSE / DRAG / CLEANUP        ║
-- ╚══════════════════════════════════════════╝
local collapsed = false
colBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    colBtn.Text = collapsed and "+" or "−"
    local targetH = collapsed and (HDR_H + 6) or PH
    TweenSvc:Create(pl_MF, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, PW, 0, targetH)
    }):Play()
    TweenSvc:Create(pl_glowOuter, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, PW + 16, 0, targetH + 16)
    }):Play()
end)

local pDrag = false; local pStartM = Vector2.zero; local pStartP = pl_MF.Position
dragHandle.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or
       i.UserInputType == Enum.UserInputType.Touch then
        pDrag = true
        pStartM = Vector2.new(i.Position.X, i.Position.Y)
        pStartP = pl_MF.Position
    end
end)
pl_UIS.InputChanged:Connect(function(i)
    if not pDrag then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement or
       i.UserInputType == Enum.UserInputType.Touch then
        local dx = i.Position.X - pStartM.X
        local dy = i.Position.Y - pStartM.Y
        local nx = pStartP.X.Offset + dx
        local ny = pStartP.Y.Offset + dy
        pl_MF.Position = UDim2.new(pStartP.X.Scale, nx, pStartP.Y.Scale, ny)
        pl_glowOuter.Position = UDim2.new(pStartP.X.Scale, nx - 8, pStartP.Y.Scale, ny - 8)
    end
end)
pl_UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or
       i.UserInputType == Enum.UserInputType.Touch then pDrag = false end
end)

-- Init status labels
wt_st(); wt_updateCount(); rp_st(); gf_st(); arc_st(); draw_st(); bend_st()
arr_st(); stair_st(); mirr_st(); matpaint_st(); colTool_st(); trTool_st()
anchor_st(); lock_st(); align_st()

-- Cleanup saat plugin/GUI dilepas
local function doCleanup()
    pcall(function()
        draw_clearLines(); clearMode(); draw_unlockCam()
        infoHUD_stop(); rp_stopHB(); rp_clearHL(); rp_clearPreview()
        for _, h in ipairs(pl_LIG:GetChildren()) do
            if h:IsA("Highlight") then pcall(function() h:Destroy() end) end
        end
    end)
end

local LP = pl_PLR.LocalPlayer
if LP then pl_PLR.PlayerRemoving:Connect(function(p) if p == LP then doCleanup() end end) end
pluginGui.AncestryChanged:Connect(function() if not pluginGui.Parent then doCleanup() end end)

end
local function injectPlugin()
if pluginDone then return end
local tb=findToolbar();if not tb then return end
if tb:FindFirstChild(PFX.."Btn_Plugin")then pluginDone=true;return end
local pg=LP:FindFirstChild("PlayerGui")or LP:WaitForChild("PlayerGui",10)
if not pg then return end
local oldG=pg:FindFirstChild(PFX.."PluginGui")
if oldG then oldG:Destroy()end
pluginGui=Instance.new("ScreenGui")
pluginGui.Name=PFX.."PluginGui"
pluginGui.ResetOnSpawn=false
pluginGui.IgnoreGuiInset=true
pluginGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
pluginGui.DisplayOrder=9998
pluginGui.Parent=pg
injectPlugin_buildUI()
local posX=getMaxX(tb)+16;makeSep(tb,posX-12)
makePartBtn(tb,posX,"Plugin",icoPlugin,function()
pluginVisible=not pluginVisible
if pl_MF then pl_MF.Visible=pluginVisible end
if pl_glowOuter then pl_glowOuter.Visible=pluginVisible end
end)
pluginDone=true
end
_SL.injectPlugin=injectPlugin
_SL.pluginDone=false
end
_sl_block2()

-- ══════════════════════════════════════════════════════════════
--  TOOLBOX BLOCK v3.0 — CREATOR STORE API  (seperti Studio PC)
--
--  ARSITEKTUR:
--  • Search  → HttpService:GetAsync("catalog.roblox.com/v1/search/items")
--              atau "apis.roblox.com/toolbox-service/v1/items"
--  • Detail  → "apis.roblox.com/toolbox-service/v1/items/details"
--  • Thumbnail→ rbxthumb://type=Asset&id=...&w=150&h=150   (langsung)
--  • Insert  → RemoteEvent "SL_InsertAsset" → Server pakai
--              InsertService:LoadAsset(assetId) → Parent=Workspace
--
--  FITUR:
--  • Search real-time (nama / ID) — query ke Creator Store API
--  • Filter kategori (24 kategori preset)
--  • Thumbnail asli dari Roblox CDN
--  • Drag & drop ke viewport (raycast posisi)
--  • Double-click langsung insert di depan kamera
--  • Status feedback: ⏳ / ✅ / ❌
--  • Input field Asset ID manual (ENTER = insert langsung)
--  • Tombol SEARCH: cari di Creator Store langsung
-- ══════════════════════════════════════════════════════════════
local function _sl_toolbox()
local LP2      = _SL.LP
local PFX2     = _SL.PFX
local drawSeg2 = _SL.drawSeg
local findTB2  = _SL.findToolbar
local getMaxX2 = _SL.getMaxX
local makeSep2 = _SL.makeSep
local makeBtn2 = _SL.makePartBtn
local CoreGui2 = _SL.CoreGui
local TwSvc2   = _SL.TweenSvc

local HttpSvc  = game:GetService("HttpService")
local RepStor  = game:GetService("ReplicatedStorage")
local UIS_TBX  = game:GetService("UserInputService")


-- ══════════════════════════════════════════════════════════════════════
--  INSERT ENGINE v4.0 — SINKRONISASI PENUH DENGAN STUDIO LITE
--
--  Hasil analisis CopyMap RBXL (reverse engineering Studio Lite):
--
--  ┌─────────────────────────────────────────────────────────────────┐
--  │  CARA KERJA STUDIO LITE TOOLBOX (nyata, bukan asumsi):         │
--  │                                                                 │
--  │  Di ReplicatedStorage → StudioLiteFolder terdapat:             │
--  │    • RemoteFunction "ServerFunctions"     (multi-purpose)      │
--  │    • RemoteFunction "LoadAssetModelToPlayerGuiServerFunction"   │
--  │    • RemoteFunction "ClearAssetModelToPlayerGuiServerFunction"  │
--  │                                                                 │
--  │  FLOW INSERT ASSET (dari ToolboxLocal + ModelAssetButtonLocal): │
--  │                                                                 │
--  │  [CLIENT] ServerFunctions:InvokeServer(                        │
--  │              "LoadAssetToPlayerGui", assetNameString)          │
--  │  [SERVER] InsertService:LoadAsset(numId)                       │
--  │           model.Name = assetNameString                         │
--  │           model.Parent = player.PlayerGui  ← simpan di sini   │
--  │  [CLIENT] PlayerGui:FindFirstChild(assetNameString)            │
--  │           → PivotTo(depan kamera) → Clone() ke Workspace      │
--  │  [CLIENT] ServerFunctions:InvokeServer(                        │
--  │              "ClearAssetFromPlayerGui", assetNameString)       │
--  │                                                                 │
--  │  POSITIONING ALGORITHM (persis Studio Lite):                   │
--  │    local x = math.floor((cam.X + lv.X*30)*2)/2               │
--  │    local z = math.floor((cam.Z + lv.Z*30)*2)/2               │
--  │    Raycast(Vector3(x,cam.Y,z), Vector3(0,-cam.Y,0)) → snap    │
--  │    model:PivotTo(CFrame.new(spawnVec) * bbCFrame.Rotation)    │
--  └─────────────────────────────────────────────────────────────────┘
-- ══════════════════════════════════════════════════════════════════════

local RepStor2 = game:GetService("ReplicatedStorage")
local WS2      = game:GetService("Workspace")

-- ── Discovery: temukan RemoteFunction/Event yang tersedia ──
local SLF         = nil  -- StudioLiteFolder
local SL_SF       = nil  -- ServerFunctions (pola utama Studio Lite)
local SL_LOAD_RF  = nil  -- LoadAssetModelToPlayerGuiServerFunction
local SL_CLEAR_RF = nil  -- ClearAssetModelToPlayerGuiServerFunction
local SL_OWN_RF   = nil  -- RemoteFunction fallback milik kita
local SL_RE2      = nil  -- RemoteEvent fallback terakhir

local function discoverSL()
    SLF = RepStor2:FindFirstChild("StudioLiteFolder")
    if SLF then
        SL_SF       = SLF:FindFirstChild("ServerFunctions")
        SL_LOAD_RF  = SLF:FindFirstChild("LoadAssetModelToPlayerGuiServerFunction")
        SL_CLEAR_RF = SLF:FindFirstChild("ClearAssetModelToPlayerGuiServerFunction")
    end
    SL_OWN_RF = RepStor2:FindFirstChild("SL_AssetLoader_RF")
    SL_RE2    = RepStor2:FindFirstChild("SL_InsertAsset")
    -- Debug
    local found = {}
    if SL_SF       then found[#found+1] = "SL_SF"       end
    if SL_LOAD_RF  then found[#found+1] = "SL_LOAD_RF"  end
    if SL_OWN_RF   then found[#found+1] = "SL_OWN_RF"   end
    if SL_RE2      then found[#found+1] = "SL_RE2"      end
    if #found > 0 then
    end
end

discoverSL()
task.spawn(function() task.wait(2); discoverSL() end)

-- ── Positioning: PERSIS algoritma Studio Lite ──
local function calcSpawnPos(bbSize, pivotOffY)
    local cam = WS2.CurrentCamera
    if not cam then return Vector3.new(0, 5, -20) end
    local cf  = cam.CFrame
    local lv  = cf.LookVector
    local szY = bbSize and bbSize.Y or 4
    local off = pivotOffY or 0

    local x = math.floor((cf.X + lv.X * 30) * 2) / 2
    local z = math.floor((cf.Z + lv.Z * 30) * 2) / 2
    local y = szY / 2 + off

    local ray = WS2:Raycast(Vector3.new(x, cf.Y, z), Vector3.new(0, -cf.Y, 0))
    if ray then
        y = ray.Instance.Position.Y + ray.Instance.Size.Y / 2 + szY / 2 + off
    end

    return Vector3.new(x, y, z)
end

-- ── Spawn dari PlayerGui (persis PlaceAssetInLocalWorkspace Studio Lite) ──
-- ════════════════════════════════════════════════════════
--  CLIENT-SIDE TEXTURE PRELOAD — v6.1 FIX ROOT CAUSE
--
--  TEMUAN PENTING dari analisis RBXL Studio Lite:
--  • ServerFunctions "LoadAssetToPlayerGui" hanya menerima NAME
--    string bukan assetId → error "found no such model: 47725..."
--    Solusi: SKIP m1, pakai m2 (LoadAssetModelToPlayerGuiServerFunction)
--
--  • ContentProvider:PreloadAsync harus di CLIENT (LocalScript)
--    Server preload cache ≠ client cache!
--    Texture putih = engine belum download ke client renderer
--
--  Cakupan instance lengkap untuk pohon PBR (SurfaceAppearance):
--  • SurfaceAppearance → ColorMap, NormalMap, MetalnessMap, RoughnessMap
--  • MeshPart          → mesh geometry + TextureID
--  • SpecialMesh       → TextureId, MeshId
--  • FileMesh          → TextureId, MeshId
--  • Decal / Texture   → Texture URL
--  • WrapLayer         → TextureId (layered clothing)
-- ════════════════════════════════════════════════════════
local ContentP2 = game:GetService("ContentProvider")

local function collectAllTextureInstances(root)
    local list = {}
    pcall(function()
        for _, d in ipairs(root:GetDescendants()) do
            local cn = d.ClassName
            if cn == "SurfaceAppearance"
            or cn == "MeshPart"
            or cn == "SpecialMesh"
            or cn == "FileMesh"
            or cn == "Decal"
            or cn == "Texture"
            or cn == "WrapLayer"
            or cn == "PartOperation"
            or cn == "UnionOperation"
            then
                list[#list+1] = d
            end
        end
    end)
    return list
end

-- Preload dengan timeout adaptif berdasarkan jumlah instance
-- Lebih banyak texture → timeout lebih panjang, max 6 detik
local function clientPreloadTextures(model)
    local instances = collectAllTextureInstances(model)
    if #instances == 0 then return end
    local timeout = math.min(2 + math.floor(#instances / 5) * 0.5, 6)
    local done = false
    task.spawn(function()
        pcall(function() ContentP2:PreloadAsync(instances) end)
        done = true
    end)
    local elapsed = 0
    while not done and elapsed < timeout do
        task.wait(0.1)
        elapsed += 0.1
    end
end

-- Post-spawn background preload: setelah model di workspace,
-- preload ulang untuk memastikan texture ter-refresh oleh renderer
local function postSpawnRefresh(spawnedModel)
    if not spawnedModel or not spawnedModel.Parent then return end
    task.spawn(function()
        local instances = collectAllTextureInstances(spawnedModel)
        if #instances == 0 then return end
        task.wait(0.3) -- beri waktu engine setup rendering
        pcall(function() ContentP2:PreloadAsync(instances) end)
    end)
end

local function spawnFromPlayerGui(assetKey, LP3)
    local pg = LP3 and LP3:FindFirstChild("PlayerGui")
    if not pg then return false end

    local obj = pg:FindFirstChild(tostring(assetKey))
    if not obj then
        local t = 0
        repeat task.wait(0.15); t += 0.15
            obj = pg:FindFirstChild(tostring(assetKey))
        until obj or t > 8
    end
    if not obj then return false end

    -- ── v6.1: CLIENT-SIDE PreloadAsync SEBELUM Clone ke Workspace ──
    -- Model masih di PlayerGui (belum di-render) → preload texture dulu
    -- Ini fix root cause texture putih yang Studio Lite tidak punya
    clientPreloadTextures(obj)

    -- Persis Studio Lite: bungkus jika bukan Model
    local inst, wrapped, tmpWrap
    if obj.ClassName == "Model" then
        inst = obj; wrapped = false
    else
        inst = Instance.new("Model")
        obj.Parent = inst
        tmpWrap = inst; wrapped = true
    end

    local bbCF, bbSz = inst:GetBoundingBox()
    local pivOff = (not wrapped and inst.PrimaryPart)
        and (inst.PrimaryPart.Position.Y - bbSz.Y / 2) or 0

    inst:PivotTo(CFrame.new(calcSpawnPos(bbSz, pivOff)) * bbCF.Rotation)

    local ok2 = false
    local spawnedRef = nil
    if wrapped then
        local ch = inst:GetChildren()
        if #ch > 0 then
            spawnedRef = ch[1]:Clone()
            spawnedRef.Parent = WS2
            ok2 = true
        end
        if tmpWrap then tmpWrap:Destroy() end
    else
        spawnedRef = inst:Clone()
        spawnedRef.Parent = WS2
        inst:Destroy()
        ok2 = true
    end

    -- Post-spawn background refresh untuk texture yang butuh renderer context
    if ok2 and spawnedRef then
        postSpawnRefresh(spawnedRef)
    end

    return ok2
end

-- ══════════════════════════════════════════════════════
--  METODE 1 — ServerFunctions Studio Lite
--  (ToolboxLocal.lua baris: v_u_2:InvokeServer("LoadAssetToPlayerGui", p13))
-- ══════════════════════════════════════════════════════
local function m1_SL_ServerFunctions(assetId, LP3)
    if not SL_SF then return false end
    local key = tostring(assetId)
    local ok = pcall(function()
        SL_SF:InvokeServer("LoadAssetToPlayerGui", key)
    end)
    if not ok then return false end
    local spawned = spawnFromPlayerGui(key, LP3)
    pcall(function() SL_SF:InvokeServer("ClearAssetFromPlayerGui", key) end)
    return spawned
end

-- ══════════════════════════════════════════════════════
--  METODE 2 — LoadAssetModelToPlayerGuiServerFunction
--  (ModelAssetButtonLocal.lua: v_u_2:InvokeServer(v10))
-- ══════════════════════════════════════════════════════
local function m2_SL_LoadRF(assetId, LP3)
    if not SL_LOAD_RF then return false end
    local key = tostring(assetId)

    local ok, result = pcall(function() return SL_LOAD_RF:InvokeServer(key) end)
    if not ok or not result then return false end

    -- ModelAssetButtonLocal: PlayerGui:WaitForChild(tostring(assetId)):Clone()
    local pg = LP3 and LP3:FindFirstChild("PlayerGui")
    if not pg then return false end

    local asset = pg:FindFirstChild(key)
    if not asset then
        local t = 0
        repeat task.wait(0.15); t += 0.15
            asset = pg:FindFirstChild(key)
        until asset or t > 8
    end
    if not asset then return false end

    -- v6.1 FIX: client-side preload sebelum clone ke workspace
    clientPreloadTextures(asset)

    -- Persis ModelAssetButtonLocal — iterasi children dari cloned asset
    local cloned = asset:Clone()
    local SVC = "Workspace Lighting MaterialService ReplicatedStorage ServerStorage ServerScriptService StarterGui StarterPack Teams SoundService StarterPlayer InsertService TextChatService"
    local spawnedAny = false

    for _, child in pairs(cloned:GetChildren()) do
        if child.ClassName == "Folder" and SVC:find(child.Name, 1, true) then
            child:Destroy() -- skip service folder
        elseif child:IsA("PostEffect") or child.ClassName == "Sky" then
            child.Parent = game.Lighting; spawnedAny = true
        else
            local inst, wrapped, tmp
            if child.ClassName == "Model" then
                inst = child; wrapped = false
            else
                inst = Instance.new("Model")
                child.Parent = inst; tmp = inst; wrapped = true
            end
            -- v6.1: client preload sebelum spawn
            clientPreloadTextures(inst)
            local bbCF, bbSz = inst:GetBoundingBox()
            local pivOff = (not wrapped and inst.PrimaryPart)
                and (inst.PrimaryPart.Position.Y - bbSz.Y / 2) or 0
            inst:PivotTo(CFrame.new(calcSpawnPos(bbSz, pivOff)) * bbCF.Rotation)
            if wrapped then
                local ch = inst:GetChildren()
                if #ch > 0 then
                    local sp = ch[1]:Clone(); sp.Parent = WS2
                    postSpawnRefresh(sp); spawnedAny = true
                end
                if tmp then tmp:Destroy() end
            else
                inst.Parent = WS2
                postSpawnRefresh(inst); spawnedAny = true
            end
        end
    end

    cloned:Destroy()
    if SL_CLEAR_RF then pcall(function() SL_CLEAR_RF:InvokeServer(key) end) end
    return spawnedAny
end

-- ══════════════════════════════════════════════════════
--  METODE 3 — RemoteFunction kita (SL_AssetLoader_RF)
--  Server v5.8 handle: "loadFast" → InsertService → PreloadAsync → PlayerGui
-- ══════════════════════════════════════════════════════
local function m3_OwnRF(assetId, LP3)
    SL_OWN_RF = SL_OWN_RF or RepStor2:FindFirstChild("SL_AssetLoader_RF")
    if not SL_OWN_RF then return false end
    local key = tostring(assetId)
    -- v6: Prioritas loadInstant (cepat, real-time) → loadFast (texture pasti ok) → load (basic compat)
    local ok, result = pcall(function() return SL_OWN_RF:InvokeServer("loadInstant", assetId) end)
    if not ok or not result then
        ok, result = pcall(function() return SL_OWN_RF:InvokeServer("loadFast", assetId) end)
    end
    if not ok or not result then
        ok, result = pcall(function() return SL_OWN_RF:InvokeServer("load", assetId) end)
        if not ok or not result then return false end
    end
    local spawned = spawnFromPlayerGui(key, LP3)
    pcall(function() SL_OWN_RF:InvokeServer("clear", key) end)
    return spawned
end

-- ══════════════════════════════════════════════════════
--  FALLBACK — RemoteEvent SL_InsertAsset (server spawn)
-- ══════════════════════════════════════════════════════
local function m4_RemoteEvent(assetId)
    SL_RE2 = SL_RE2 or RepStor2:FindFirstChild("SL_InsertAsset")
    if not SL_RE2 then return false end
    local cam = WS2.CurrentCamera
    local pos = cam and (cam.CFrame.Position + cam.CFrame.LookVector * 20)
        or Vector3.new(0, 5, -20)
    local done, resOk = false, false
    local conn = SL_RE2.OnClientEvent:Connect(function(rid, succ)
        if tostring(rid) == tostring(assetId) then resOk = succ; done = true end
    end)
    pcall(function() SL_RE2:FireServer(assetId, pos.X, pos.Y, pos.Z) end)
    local t = 0
    while not done and t < 12 do task.wait(0.2); t += 0.2 end
    conn:Disconnect()
    return resOk
end

-- ════════════════════════════════════════════════════════════════════════
--  insertAsset() — ENTRY POINT UTAMA
-- ════════════════════════════════════════════════════════════════════════

-- v5 FIX: TC palette didefinisikan DI SINI (sebelum insertAsset)
-- agar tidak ada error "attempt to index nil with 'grn'"
local TC={
    bg0=Color3.fromRGB(7,8,13),   bg1=Color3.fromRGB(12,14,20),
    bg2=Color3.fromRGB(18,20,30), bg3=Color3.fromRGB(25,28,42),
    bg4=Color3.fromRGB(33,37,55),
    acc=Color3.fromRGB(80,155,255), accB=Color3.fromRGB(50,115,235),
    accH=Color3.fromRGB(100,175,255),
    txt=Color3.fromRGB(228,233,255), txtS=Color3.fromRGB(148,165,205),
    bdr=Color3.fromRGB(35,42,62),  bdrA=Color3.fromRGB(55,105,195),
    red=Color3.fromRGB(225,60,60), grn=Color3.fromRGB(50,205,105),
    gold=Color3.fromRGB(255,205,55),
    orange=Color3.fromRGB(255,150,40),
}

local function insertAsset(idStr, name, btn, targetCF)
    local assetId = tonumber(idStr)
    if not assetId then
        warn("[Toolbox] ID tidak valid: " .. tostring(idStr))
        if btn and btn.Parent then
            btn.Text = "❌ ID?"; btn.BackgroundColor3 = TC.red
            task.delay(1.5, function()
                if btn and btn.Parent then
                    btn.Text = "INSERT ▶"; btn.BackgroundColor3 = TC.grn
                end
            end)
        end
        return
    end

    task.spawn(function()
        if btn and btn.Parent then
            btn.Text = "⏳ Loading…"; btn.BackgroundColor3 = Color3.fromRGB(55, 45, 10)
        end

        -- Refresh discovery jika belum ada
        if not SL_SF and not SL_LOAD_RF and not SL_OWN_RF and not SL_RE2 then
            discoverSL()
        end

        local LP3 = _SL and _SL.LP
        local ok, method = false, ""

        -- M1: Studio Lite ServerFunctions
        -- ⚠ SKIP untuk arbitrary numeric assetId!
        -- ServerFunctions "LoadAssetToPlayerGui" hanya menerima NAME string
        -- seperti "Door", "Window" — bukan assetId numerik!
        -- Kalau dikirim ID numerik → error "found no such model: 4772537309"
        -- if not ok and SL_SF then ... end  ← DISABLED

        -- M2: Studio Lite LoadAssetModelToPlayerGuiServerFunction (arbitrary ID ✓)
        if not ok and SL_LOAD_RF then
            ok = m2_SL_LoadRF(assetId, LP3)
            if ok then method = "SL-LoadAssetRF" end
        end

        -- M3: RemoteFunction kita sendiri (loadInstant → loadFast → load)
        if not ok then
            ok = m3_OwnRF(assetId, LP3)
            if ok then method = "OwnRF-Fast" end
        end

        -- M4: RemoteEvent fallback
        if not ok then
            ok = m4_RemoteEvent(assetId)
            if ok then method = "RemoteEvent" end
        end

        if ok then
        else
            warn(string.format("[Toolbox] ❌ Semua metode gagal: %s (%d)", name, assetId))
        end

        -- v5 FIX: tombol SELALU kembali ke INSERT (bukan tetap ✅)
        -- sehingga bisa di-klik lagi untuk insert ulang
        if btn and btn.Parent then
            if ok then
                btn.Text = "✅ Done!"; btn.BackgroundColor3 = TC.grn
            else
                btn.Text = "❌ Gagal"; btn.BackgroundColor3 = TC.red
            end
            task.wait(1.5)
        -- Kembalikan ke state semula agar bisa insert lagi
            if btn and btn.Parent then
                local origText = btn:GetAttribute("OrigText") or "INSERT ▶"
                btn.Text = origText
                btn.BackgroundColor3 = TC.accB
            end
        end
    end)
end

-- Export ke _SL agar bisa dipakai blok lain (Toolbox PC, dll)
_SL.insertAsset = insertAsset
_SL.discoverSL  = discoverSL

local ASSET_DB = {
  {cat="Topbar", items={
    {id="92368439343389", name="Asset 92368439343389"},
    {id="73265677878224", name="Asset 73265677878224"},
    {id="107549935218892", name="Asset 107549935218892"},
    {id="112399731456580", name="Asset 112399731456580"},
    {id="72704824200160", name="Asset 72704824200160"},
    {id="127468105296764", name="Asset 127468105296764"},
    {id="139548320698534", name="GIVE TITLE"},
    {id="73716335524617", name="Asset 73716335524617"},
    {id="82374805636764", name="JUMP SETTING"},
  }},
  {cat="FarmKit", items={
    {id="80214848382416", name="Asset 80214848382416"},
  }},
  {cat="Tangga", items={
    {id="14362545465", name="Asset 14362545465"},
    {id="14347242798", name="Asset 14347242798"},
    {id="3738426203", name="Asset 3738426203"},
    {id="4772537309", name="Asset 4772537309"},
  }},
  {cat="Dekorasi BC", items={
    {id="129302692785119", name="Asset 129302692785119"},
    {id="106992323601715", name="Asset 106992323601715"},
    {id="121796599121989", name="Asset 121796599121989"},
    {id="108123227593017", name="Asset 108123227593017"},
  }},
  {cat="Dekorasi Kerja", items={
    {id="4612737272", name="Asset 4612737272"},
    {id="15027027726", name="Asset 15027027726"},
    {id="461522270", name="Asset 461522270"},
    {id="11164686404", name="Asset 11164686404"},
    {id="9237294168", name="Asset 9237294168"},
    {id="4615944632", name="Asset 4615944632"},
    {id="8303460296", name="Asset 8303460296"},
    {id="110891706", name="Asset 110891706"},
    {id="17123727899", name="Asset 17123727899"},
    {id="9132307644", name="Asset 9132307644"},
  }},
  {cat="Ramadhan", items={
    {id="14102233829", name="Asset 14102233829"},
    {id="95948492965984", name="Asset 95948492965984"},
    {id="711679463", name="Asset 711679463"},
    {id="77456106674406", name="Asset 77456106674406"},
    {id="102688660438266", name="Asset 102688660438266"},
    {id="3930173534", name="Asset 3930173534"},
    {id="88864839919112", name="Asset 88864839919112"},
    {id="13148940416", name="Asset 13148940416"},
    {id="79379894220970", name="Asset 79379894220970"},
  }},
  {cat="Overhead", items={
    {id="117665471193932", name="Asset 117665471193932"},
    {id="119354057192079", name="Asset 119354057192079"},
    {id="94290143270105", name="Asset 94290143270105"},
    {id="122823956082359", name="Asset 122823956082359"},
    {id="90880825410537", name="Asset 90880825410537"},
    {id="86157872263431", name="Asset 86157872263431"},
    {id="107941368213316", name="Asset 107941368213316"},
    {id="137220620029853", name="Asset 137220620029853"},
    {id="15915220759", name="ampu disco"},
    {id="9618802405", name="ampu salon"},
    {id="390494046", name="private room club"},
    {id="107993049806532", name="spot foto"},
    {id="4593163056", name="balcon kaca cafe"},
    {id="2601742632", name="club superstarts"},
    {id="6939352201", name="ruang toilet"},
    {id="80365237076656", name="modern sofa"},
    {id="113035773832941", name="Asset 113035773832941"},
  }},
  {cat="Jembatan", items={
    {id="247257444", name="Model 1"},
    {id="14310166120", name="Model 2"},
    {id="14468269998", name="Model 3"},
    {id="7243311747", name="Model 4"},
    {id="11566851783", name="Model 5"},
    {id="8550093744", name="Model 6"},
    {id="15011654174", name="Model 7"},
  }},
  {cat="Club Hangout", items={
    {id="106402282101209", name="musik server"},
    {id="112601324505225", name="ive screen server"},
    {id="110725823947813", name="Donation board system"},
    {id="80632793381434", name="title editor system"},
  }},
  {cat="Summit & BC", items={
    {id="79190701594509", name="Asset 79190701594509"},
    {id="129894600163345", name="Lava"},
    {id="11552439884", name="Hujan"},
    {id="6775974997", name="Skop"},
    {id="14620548557", name="Pohon merah"},
    {id="2423548166", name="Kuburan"},
    {id="7848009983", name="Warung helowin"},
    {id="1567799120", name="Pohon kelapa"},
    {id="8660674388", name="Pohon kebakar"},
    {id="1141956697", name="Pohon Oren"},
    {id="1242076678", name="Pohon palem"},
    {id="9245233433", name="Pohon menyala"},
    {id="12969274054", name="Akar mati"},
    {id="286916452", name="Kupu² banyak"},
    {id="216385127", name="Kupu² pink"},
    {id="646309370", name="Kupu² Oren"},
    {id="9484402186", name="Rumah terbengkalai"},
    {id="91927589501855", name="Pos ronda"},
    {id="9107390688", name="Bendera indo"},
    {id="9944877977", name="Buaya"},
    {id="258166527", name="Kristal plus batu"},
    {id="8298628067", name="Lampu warna-warni"},
    {id="8147307625", name="Kristal menyala"},
    {id="11629238102", name="Blok nyala"},
    {id="16891619031", name="Curug"},
    {id="15139184956", name="Curug"},
    {id="15472204631", name="Lampu jalan"},
    {id="15568662079", name="Palem"},
    {id="14861633855", name="Coin"},
    {id="12441409535", name="Lampu bunga air"},
    {id="5338749534", name="Lampu love"},
    {id="416055326", name="Lampu lentera"},
    {id="4673993131", name="Lampu love"},
    {id="6481493978", name="Kursi camping"},
    {id="16984440679", name="Papan peta"},
    {id="5221805197", name="Tempat es batu"},
    {id="6235830734", name="Tenda"},
    {id="4905736671", name="Tenda jualan"},
    {id="11853786155", name="Tenda biasa"},
    {id="6883609157", name="Tenda militer"},
    {id="5161762082", name="Tenda cwe"},
    {id="9825536037", name="Pagar"},
    {id="9825672980", name="Batu alas"},
    {id="9825542614", name="Gerbang"},
    {id="12071076692", name="Sakura di bawah"},
    {id="4751140181", name="Pohon 1 map"},
    {id="175696937", name="Pizza hiasan"},
    {id="7860328354", name="Rumah pohon"},
    {id="3187463976", name="Rumput kecil"},
    {id="11284413839", name="Cristal"},
    {id="8236432063", name="Lampu hias"},
    {id="12664614988", name="Makanan"},
    {id="1087214998", name="Makanan"},
    {id="18965422551", name="Pohon sakura"},
    {id="18839533016", name="Asset 18839533016"},
    {id="104293683856098", name="Jembatan kinyis²"},
    {id="4607457995", name="Cuaca"},
    {id="10100805", name="rumput"},
    {id="5352156968", name="aderboard"},
    {id="339406852", name="cuaca Clasik"},
    {id="7108851308", name="cuaca sunset"},
    {id="10256505900", name="cuaca siang"},
    {id="6740491328", name="tangga kotak"},
    {id="591067775", name="cuaca blue"},
    {id="8613979186", name="ithing"},
    {id="11700708794", name="air"},
    {id="9217425479", name="batu"},
    {id="4038061999", name="batu putih"},
    {id="8106578167", name="bola putih"},
    {id="15457777509", name="salju"},
    {id="5888513160", name="siflock"},
    {id="4453595550", name="batu apung"},
    {id="12939630009", name="part lupis"},
    {id="13743873989", name="pohon bunga"},
    {id="6816823642", name="api unggun"},
    {id="172732271", name="khol admin"},
    {id="111601062284358", name="tangga"},
    {id="114225117903331", name="basecamp"},
    {id="14793284576", name="bby pink melayang"},
    {id="80562227580067", name="gapura"},
    {id="7038250261", name="monster respon"},
    {id="93500071913074", name="pohon ayunan"},
    {id="11690617408", name="sakuta"},
    {id="89593650473948", name="sky"},
    {id="383908847", name="sakuta base"},
    {id="81622588738894", name="vibe sakura"},
    {id="13420461284", name="kursi taman"},
    {id="13857748806", name="kursi"},
    {id="359265021", name="gapura CP"},
    {id="9878123233", name="huruf"},
    {id="9207804677", name="huruf"},
    {id="2235994611", name="boombox"},
    {id="6539459822", name="coil"},
    {id="81665561384544", name="speed glowstick"},
    {id="16017175741", name="biy cp"},
    {id="3458848317", name="rm sakita"},
    {id="9158829732", name="fives sakuta"},
    {id="103263551602681", name="sakura japanes"},
    {id="11164613720", name="sakura Islan"},
    {id="111719237381421", name="pot sakuta"},
    {id="86088146306366", name="sakura cp"},
    {id="16815196105", name="rumah sakuta"},
    {id="11997333520", name="sakura template"},
    {id="13876816234", name="plaza sakura"},
    {id="14898036372", name="teleport jatuh"},
    {id="10288498712", name="pedang sword"},
  }},
  {cat="Carry", items={
    {id="101371306323200", name="Asset 101371306323200"},
    {id="114141633540686", name="Asset 114141633540686"},
  }},
  {cat="Pager", items={
    {id="5266835627", name="Asset 5266835627"},
    {id="4461645364", name="Asset 4461645364"},
    {id="18606785413", name="Asset 18606785413"},
    {id="11720888076", name="Asset 11720888076"},
  }},
  {cat="Nales Collection", items={
    {id="11560481255", name="AIR MANCUR"},
    {id="9871169892", name="POHON SAKURA"},
    {id="12403904845", name="COIL"},
    {id="99649643872315", name="PAPAN PERINGKAT SUMMIT"},
    {id="11370125942", name="PAPAN DONATE"},
    {id="1867042729", name="CEK POINT"},
    {id="16360905300", name="PATUNG"},
    {id="12958677973", name="AURA JAM"},
    {id="106192507657319", name="AURA SERAM"},
    {id="10623199688", name="LAMPU"},
    {id="18967257395", name="PAGAR"},
    {id="1219296760", name="API UNGGUN"},
    {id="10923698441", name="GANTUNG"},
    {id="7115700428", name="AYUNAN"},
    {id="27761331834", name="KURSI"},
    {id="5453324157", name="AIR"},
    {id="381979745", name="LAVA"},
    {id="11686128281", name="TANGGA GOYANG"},
    {id="5413625310", name="ADMIN"},
    {id="857927023", name="KOTAK GOYANG GANTUNG"},
    {id="17164754671", name="LAMPU BULAT"},
    {id="12249938569", name="BENDERA"},
  }},
  {cat="Studio Lite", items={
    {id="5651915424", name="NALES X SKY COMUNITY"},
    {id="12859464471", name="Asset 12859464471"},
    {id="7211220687", name="Asset 7211220687"},
    {id="9389706223", name="Asset 9389706223"},
    {id="5687801047", name="Asset 5687801047"},
    {id="3615189602", name="Asset 3615189602"},
    {id="12137672809", name="Asset 12137672809"},
    {id="1431460278", name="Asset 1431460278"},
    {id="2589355179", name="Asset 2589355179"},
    {id="3290979424", name="Asset 3290979424"},
    {id="117493032353210", name="Asset 117493032353210"},
    {id="10757788438", name="Asset 10757788438"},
    {id="13857771964", name="Asset 13857771964"},
    {id="110827843", name="Asset 110827843"},
    {id="8747386278", name="Asset 8747386278"},
    {id="16021226229", name="Asset 16021226229"},
  }},
  {cat="Bunga", items={
    {id="109521917369585", name="Asset 109521917369585"},
    {id="16720795680", name="Asset 16720795680"},
    {id="1366291270", name="Asset 1366291270"},
    {id="138315532", name="Asset 138315532"},
    {id="13424815199", name="Asset 13424815199"},
    {id="753093093", name="Asset 753093093"},
    {id="7935190495", name="Asset 7935190495"},
    {id="10433501452", name="Asset 10433501452"},
    {id="873208477", name="Asset 873208477"},
    {id="123040811968208", name="Asset 123040811968208"},
    {id="11929960826", name="Asset 11929960826"},
  }},
  {cat="Sky", items={
    {id="127719608807122", name="Asset 127719608807122"},
    {id="18618130414", name="Asset 18618130414"},
    {id="16960211237", name="Asset 16960211237"},
    {id="16141881586", name="Asset 16141881586"},
    {id="16262385808", name="Asset 16262385808"},
    {id="18618032376", name="Asset 18618032376"},
    {id="14559810477", name="Asset 14559810477"},
    {id="15359965253", name="Asset 15359965253"},
    {id="45967921", name="Asset 45967921"},
    {id="12043758786", name="Asset 12043758786"},
    {id="11138556502", name="Asset 11138556502"},
    {id="11284918730", name="Asset 11284918730"},
    {id="12635340429", name="Asset 12635340429"},
    {id="15313376186", name="Asset 15313376186"},
    {id="72835926026092", name="Asset 72835926026092"},
    {id="10594723714", name="Asset 10594723714"},
    {id="8754255888", name="Asset 8754255888"},
    {id="8539737017", name="Asset 8539737017"},
    {id="672935236", name="Asset 672935236"},
    {id="5877137658", name="Asset 5877137658"},
    {id="8202961731", name="Asset 8202961731"},
    {id="83244547123697", name="Asset 83244547123697"},
    {id="9001527553", name="Asset 9001527553"},
    {id="15983996673", name="Asset 15983996673"},
    {id="13107361022", name="Asset 13107361022"},
    {id="18618101697", name="Asset 18618101697"},
    {id="136350850692118", name="Asset 136350850692118"},
  }},
  {cat="Rintangan Keren", items={
    {id="12062431565", name="Asset 12062431565"},
    {id="3472039219", name="Asset 3472039219"},
    {id="12062468989", name="Asset 12062468989"},
    {id="5152010037", name="Asset 5152010037"},
    {id="9597843378", name="Asset 9597843378"},
    {id="448118170", name="Asset 448118170"},
    {id="11567380118", name="Asset 11567380118"},
    {id="14795959834", name="Asset 14795959834"},
    {id="9807283714", name="Asset 9807283714"},
    {id="13945092488", name="Asset 13945092488"},
    {id="8191752568", name="Asset 8191752568"},
    {id="10807285484", name="Asset 10807285484"},
    {id="5013034413", name="Asset 5013034413"},
    {id="12067649229", name="Asset 12067649229"},
    {id="10112970453", name="Asset 10112970453"},
    {id="2533062557", name="Asset 2533062557"},
    {id="4835964895", name="Asset 4835964895"},
  }},
  {cat="Rintangan", items={
    {id="14796107102", name="Asset 14796107102"},
    {id="18471692316", name="Asset 18471692316"},
    {id="4814724245", name="Asset 4814724245"},
    {id="3236137475", name="Asset 3236137475"},
    {id="12132147781", name="Asset 12132147781"},
    {id="18696868777", name="Asset 18696868777"},
    {id="6177044989", name="Asset 6177044989"},
    {id="5224309321", name="Asset 5224309321"},
    {id="54958075", name="Asset 54958075"},
    {id="123422541930161", name="Asset 123422541930161"},
    {id="51201133", name="Asset 51201133"},
  }},
  {cat="Rumah China", items={
    {id="18965526235", name="Pohon Sakura v1"},
    {id="126979607184502", name="Model Sakura v2"},
    {id="96374489690825", name="Air Terjun"},
    {id="8628818048", name="Pintu v1"},
    {id="124462976311152", name="Rumah China Kecil"},
    {id="126531956486495", name="Rumah China Raja"},
    {id="13591070840", name="Rumah ke-2"},
    {id="13666298471", name="Rumah ke-3"},
    {id="17431079277", name="Rumah ke-4"},
    {id="9564792558634", name="Rumah ke-5"},
    {id="15824273388", name="Rumah ke-6"},
    {id="11993485405", name="Rumah ke-7"},
    {id="5073978825", name="Chines House"},
    {id="124067814839826", name="Rumah ke-8"},
    {id="130323581220611", name="Castle"},
    {id="6874993046", name="Japan House"},
    {id="129965145410020", name="Lampion"},
    {id="145245015", name="Lampion 2"},
    {id="173609604", name="Lampu Jalan Kuning"},
    {id="123793789173096", name="Asset 123793789173096"},
    {id="95362905543220", name="Asset 95362905543220"},
  }},
  {cat="Rumah Jepang", items={
    {id="10193175343", name="Asset 10193175343"},
    {id="116170833927728", name="Asset 116170833927728"},
    {id="126161552651684", name="Asset 126161552651684"},
    {id="340078036", name="Asset 340078036"},
    {id="340077841", name="Asset 340077841"},
    {id="95645593610037", name="Asset 95645593610037"},
    {id="85734296020492", name="Asset 85734296020492"},
    {id="13916966181", name="Asset 13916966181"},
    {id="106642854780538", name="Asset 106642854780538"},
    {id="85961646465993", name="Asset 85961646465993"},
    {id="9716544421", name="Asset 9716544421"},
    {id="100140895407697", name="Asset 100140895407697"},
    {id="834887908", name="Asset 834887908"},
    {id="87706378704742", name="Asset 87706378704742"},
    {id="9584954139", name="Asset 9584954139"},
    {id="4870129065", name="Asset 4870129065"},
    {id="120977297702853", name="Asset 120977297702853"},
    {id="126159115966250", name="Asset 126159115966250"},
    {id="82999565881514", name="Asset 82999565881514"},
    {id="122185232117323", name="Asset 122185232117323"},
    {id="109293673740485", name="Asset 109293673740485"},
    {id="86888005180663", name="Asset 86888005180663"},
    {id="4493890440", name="Asset 4493890440"},
    {id="107083217689333", name="Asset 107083217689333"},
    {id="99774552211130", name="Asset 99774552211130"},
    {id="90309034126740", name="Asset 90309034126740"},
    {id="12590109815", name="Asset 12590109815"},
    {id="74846930932508", name="Asset 74846930932508"},
    {id="99808919561383", name="Asset 99808919561383"},
    {id="10176352405", name="Asset 10176352405"},
  }},
  {cat="Sky Collection", items={
    {id="9021554656", name="Hello Neighbor Alpha 2 Sky"},
    {id="15502592084", name="Classical Sunset Sky"},
    {id="110637121152406", name="Sky"},
    {id="2716603671", name="Realistic Cloudy Sky"},
    {id="9758841183", name="City Sky at Night"},
    {id="11336743666", name="Space Sky"},
    {id="11460225580", name="Low Poly Sky"},
    {id="11675661848", name="Space Sky 2"},
    {id="10594745862", name="Cloudy Sky"},
    {id="6799834843", name="Anime Sky"},
    {id="10644495614", name="Paris Night Sky"},
    {id="18763720423", name="Cloudy Sunset Sky"},
    {id="116402178504134", name="Sky"},
    {id="3639917882", name="Night Sky Northern Lights"},
    {id="10087856569", name="Custom Anime Sky"},
    {id="101192864920805", name="Sky Aurora"},
    {id="5859135151", name="Blue Sky with Clouds"},
    {id="16648633697", name="My Summer Car Sky"},
    {id="8508116305", name="LUCID DREAMS SKY"},
  }},
  {cat="Ayunan", items={
    {id="11716773688", name="Pohon + Ayunan"},
    {id="5895047419", name="Ayunan Besi"},
    {id="10305255634", name="Ayunan"},
    {id="10671968695", name="Ayunan Putih"},
  }},
  {cat="SummitKit", items={
    {id="75231740485045", name="TERLA V4.15"},
    {id="98740941234157", name="CLAUSIOUS"},
    {id="86882457224634", name="SAI V2"},
    {id="105037264303345", name="TAMA V4"},
    {id="81134492053123", name="EHPYX"},
    {id="115449951242174", name="YAHAYUK"},
    {id="107187491889513", name="ASAHINA"},
    {id="73904471550547", name="RELISTIC"},
    {id="76606883237608", name="TAMA V3"},
    {id="91239689760309", name="RUEL V1"},
    {id="79636294915767", name="VALUABLE"},
    {id="136203652440287", name="ISHAK V2"},
    {id="137258936764105", name="TERLA V4"},
    {id="103127062697645", name="TERLA V3.2"},
    {id="113376399365887", name="KAII V1"},
    {id="70803779581858", name="KEONG V1.0"},
    {id="103220171626856", name="TERLA V2"},
    {id="77575188415516", name="SummitKit Ishak v2 Remake"},
    {id="97161925338687", name="SummitKit Ishak V2"},
    {id="75772964426357", name="SummitKit Terla Modif v1"},
    {id="136402898393983", name="SummitKit Terla Modif v2"},
  }},
  {cat="Tools & Plugin", items={
    {id="101030513241189", name="Music GUI"},
    {id="10153519664", name="Pagar"},
    {id="114692879068427", name="Tangga PC"},
    {id="115881095062069", name="Wings"},
    {id="136456917336346", name="Fish It"},
    {id="103932300220382", name="Angin"},
    {id="77664338236590", name="Cary"},
    {id="873248699", name="Tali Bisa Dipanjat"},
    {id="11423259371", name="Air Mancur 1"},
    {id="5498475416", name="Air Mancur 2"},
    {id="2101548957", name="Air Mancur 3"},
    {id="112761714251712", name="Glowstik"},
    {id="13901194357", name="Game Pase"},
    {id="5027967529", name="Speck"},
  }},
  {cat="Puncak", items={
    {id="15423999209", name="Puncak 1"},
    {id="1321666915", name="Puncak 2"},
    {id="18753107078", name="Puncak 3"},
    {id="5415756362", name="Puncak 4"},
    {id="18413049465", name="Puncak 5"},
    {id="18868654699", name="Puncak 6"},
    {id="15358158495", name="Puncak 7"},
    {id="10616837314", name="Puncak 8"},
    {id="10238181061", name="Puncak 9"},
    {id="15603344661", name="Puncak 10"},
    {id="9435521223", name="Puncak 11"},
    {id="2355104007", name="Puncak 12"},
    {id="5639658344", name="Puncak 13"},
    {id="18227651212", name="Puncak 14"},
  }},
  {cat="Admin", items={
    {id="134396078990063", name="HD Admin Classic"},
    {id="4936422471", name="Owner Admin Commands"},
    {id="6043699504", name="Admin HD Owner Thing"},
    {id="9277457280", name="Admin/Owner Tools Script"},
    {id="137255715446999", name="Admin Pads"},
    {id="3239236979", name="HD Admin Main Module"},
    {id="286670305", name="Admin Abuse Plugin"},
    {id="7599170832", name="Free Admin For All"},
    {id="97783893343419", name="Votly Admin Panel"},
    {id="7951771044", name="Khols Admin Infinityyy"},
    {id="10768057332", name="Admin Only Ban Hammer"},
    {id="8263958553", name="Admin Panel Kick Ban"},
  }},
  {cat="Kendaraan", items={
    {id="8684518373", name="Car 1"},
    {id="6810376207", name="Car 2"},
    {id="6527733561", name="Car 3"},
    {id="10017069212", name="Car 4"},
    {id="5621354543", name="Perahu 1"},
    {id="6985485718", name="Perahu 2"},
    {id="9617142471", name="Perahu 3"},
    {id="4921496603", name="Perahu 4"},
    {id="12020038826", name="Perahu 5"},
    {id="5431751036", name="Perahu 6"},
    {id="8829152798", name="Pesawat 1"},
    {id="6604297612", name="Pesawat 2"},
    {id="7458320941", name="Pesawat 3"},
    {id="6586274606", name="Pesawat 4"},
    {id="5342338698", name="Pesawat 5"},
    {id="8391320750", name="Pesawat 6"},
    {id="94946712911722", name="Helikopter 1"},
    {id="17797349765", name="Helikopter 2"},
    {id="91447141158904", name="Helikopter 3"},
    {id="8915950341", name="Helikopter 4"},
    {id="5758788772", name="Helikopter 5"},
    {id="1379706428", name="Tank 1"},
    {id="9870781001", name="Tank 2"},
    {id="10558420013", name="Pesawat Luar Angkasa 1"},
    {id="11134404981", name="Pesawat Luar Angkasa 2"},
    {id="4743247884", name="Pesawat Luar Angkasa 3"},
    {id="546187345", name="Kereta Api 1"},
    {id="9446069403", name="Kereta Api 2"},
    {id="2958951428", name="Kapal Selam 1"},
    {id="7635085756", name="Kapal Selam 2"},
    {id="5970069320", name="Kapal Selam 3"},
    {id="7235482311", name="Kapal Selam 4"},
  }},
  {cat="Warung & Cafe", items={
    {id="122876995697989", name="Warung"},
    {id="13565112176", name="Gerobak Mie Ayam"},
    {id="14548527819", name="Gerobak Mi Ayam 2"},
    {id="5179891665", name="Warung Nasi Goreng"},
    {id="10034446280", name="Mega Food Stand"},
    {id="93026842270551", name="Model 1"},
    {id="135799506657481", name="Model 2"},
    {id="126064922041513", name="Food Stand Working"},
    {id="6298121756", name="Cafe"},
    {id="570671329", name="Nasi Lemak Corner"},
    {id="2129168539", name="Popcorn Cart"},
  }},
  {cat="Lampu Disko", items={
    {id="73876921822286", name="Lampu Disko 1"},
    {id="9822475152", name="Lampu Disko 2"},
    {id="11721328449", name="Lampu Disko 3"},
    {id="85546094631855", name="Lampu Disko 5"},
    {id="117041509039446", name="Lampu Disko 5b"},
  }},
  {cat="Map Club", items={
    {id="133330170183296", name="Asset Map Club 1"},
    {id="140322734575781", name="Asset Map Club 2"},
    {id="91765439444689", name="Asset Map Club 3"},
    {id="107869028378386", name="Asset Map Club 4"},
    {id="130318941994038", name="Asset Map Club 5"},
    {id="94729328930734", name="Asset Map Club 6"},
  }},
  {cat="Tools Spesial", items={
    {id="99961136627124", name="Boombox Gendong Belakang"},
    {id="104023603397520", name="Tembus Badan"},
    {id="128088051536467", name="Fitur Balap Kit"},
    {id="79703067394973", name="Burung Puyuh Tools"},
    {id="127590403653428", name="Scissors Tools"},
    {id="77967795846149", name="Inferno Blade Coil"},
    {id="138952618614321", name="Glowstick v3"},
    {id="97460331120541", name="Topeng Ganti Avatar"},
    {id="76766224011944", name="Ava Clone"},
    {id="90340698294124", name="Button Change Sky"},
    {id="100693024012623", name="Cinematic Mode"},
    {id="136658754343824", name="Kulit Kerang Ajaib"},
    {id="126424241694724", name="Ganti Sky (Injek)"},
    {id="80184100982747", name="Teletubbies Hitam"},
    {id="134712858819749", name="Firework / Petasan"},
    {id="77122052440024", name="Hologram Susano"},
    {id="133198232732774", name="Layangan"},
    {id="119186808260024", name="Asset Bangunan"},
    {id="81476400180105", name="Aura Pack Premium"},
    {id="2090656802", name="Asset 2090656802"},
    {id="154577775", name="Asset 154577775"},
  }},
  {cat="Asset Misc", items={
    {id="74505531564518", name="Asset 74505531564518"},
    {id="18321988390", name="Asset 18321988390"},
    {id="122201658056588", name="Asset 122201658056588"},
  }},
  {cat="Creator Store Search", items={}},  -- tab khusus live search
}

-- TC palette sudah didefinisikan di atas (sebelum insertAsset)
-- Tidak perlu didefinisikan ulang di sini

-- ── Icon Toolbox (grid 3×3) ──
local function icoToolbox(p,S,T)
    local m=3; local g=2; local cz=math.floor((S-m*g-g)/m)
    for ro=0,m-1 do for co=0,m-1 do
        local x=g+(co*(cz+g)); local y=g+(ro*(cz+g))
        drawSeg2(p,x,y,x+cz,y,T,TC.acc,46); drawSeg2(p,x+cz,y,x+cz,y+cz,T,TC.acc,46)
        drawSeg2(p,x+cz,y+cz,x,y+cz,T,TC.acc,46); drawSeg2(p,x,y+cz,x,y,T,TC.acc,46)
    end end
end

-- ── UI Helpers ──
local function mkF(par,x,y,w,h,bg,r,zi)
    local f=Instance.new("Frame"); f.Parent=par
    f.Position=UDim2.new(0,x,0,y); f.Size=UDim2.new(0,w,0,h)
    f.BackgroundColor3=bg or TC.bg1; f.BorderSizePixel=0
    if r and r>0 then Instance.new("UICorner",f).CornerRadius=UDim.new(0,r) end
    if zi then f.ZIndex=zi end; return f
end
local function mkL(par,x,y,w,h,txt,col,sz,xa,zi)
    local l=Instance.new("TextLabel"); l.Parent=par
    l.Position=UDim2.new(0,x,0,y); l.Size=UDim2.new(0,w,0,h)
    l.BackgroundTransparency=1; l.Text=txt or ""
    l.TextColor3=col or TC.txt; l.TextSize=sz or 11
    l.Font=Enum.Font.Gotham; l.TextXAlignment=xa or Enum.TextXAlignment.Left
    l.TextTruncate=Enum.TextTruncate.AtEnd
    if zi then l.ZIndex=zi end; return l
end
local function mkB(par,x,y,w,h,txt,bg,col,sz,r,zi)
    local b=Instance.new("TextButton"); b.Parent=par
    b.Position=UDim2.new(0,x,0,y); b.Size=UDim2.new(0,w,0,h)
    b.BackgroundColor3=bg or TC.bg3; b.Text=txt or ""
    b.TextColor3=col or TC.txt; b.TextSize=sz or 11
    b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0
    if r and r>0 then Instance.new("UICorner",b).CornerRadius=UDim.new(0,r) end
    if zi then b.ZIndex=zi end; return b
end
local function mkTBX(par,x,y,w,h,ph,zi)
    local b=Instance.new("TextBox"); b.Parent=par
    b.Position=UDim2.new(0,x,0,y); b.Size=UDim2.new(0,w,0,h)
    b.BackgroundColor3=TC.bg3; b.Text=""
    b.PlaceholderText=ph or ""; b.PlaceholderColor3=TC.txtS
    b.TextColor3=TC.txt; b.TextSize=11; b.Font=Enum.Font.Gotham
    b.BorderSizePixel=0; b.ClearTextOnFocus=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    if zi then b.ZIndex=zi end; return b
end
local function mkStr(p,col,thick)
    local s=Instance.new("UIStroke",p)
    s.Color=col or TC.bdrA; s.Thickness=thick or 1; return s
end

-- ── Konstanta Layout — v6: Panel sedikit diperkecil, mirip Studio PC ──
local PW=360; local PH=580
local CARD_W=106; local CARD_H=138; local CARD_PAD=4
local COLS=3

-- ══════════════════════════════════════════════════════════════
--  CREATOR STORE API SEARCH
--  Endpoint: apis.roblox.com/toolbox-service/v1/items
--  Query: keyword, category=Model
--  Return: list {id, name, thumbnail}
-- ══════════════════════════════════════════════════════════════

local TOOLBOX_API = "https://apis.roblox.com/toolbox-service/v1/items"
local CATALOG_API = "https://catalog.roblox.com/v1/search/items"

-- State search online
local searchResults   = {}   -- {id, name} hasil dari API
local isSearching     = false
local searchPage      = 0
local searchCursor    = ""
local lastOnlineQuery = ""

local function searchCreatorStore(keyword, onResult, onError)
    if isSearching then return end
    isSearching = true

    task.spawn(function()
        local results = {}
        local ok, err = pcall(function()
            -- Endpoint utama: toolbox-service (persis yang dipakai Studio PC)
            local url = TOOLBOX_API ..
                "?category=Model" ..
                "&keyword=" .. HttpSvc:UrlEncode(keyword) ..
                "&limit=30" ..
                "&includeOnlyVerifiedCreators=false"

            local resp = HttpSvc:GetAsync(url, true)
            if not resp or resp == "" then
                error("Response kosong dari toolbox-service")
            end

            local data = HttpSvc:JSONDecode(resp)
            -- data.data = array of items
            if data and data.data then
                for _, item in ipairs(data.data) do
                    -- item.asset: {id, name, typeId}
                    -- item.creator: {name}
                    -- item.thumbnail: {url}  (bisa nil, pakai rbxthumb fallback)
                    local assetInfo = item.asset or item
                    local assetId   = assetInfo.id or assetInfo.assetId
                    local assetName = assetInfo.name or ("Asset " .. tostring(assetId))
                    if assetId then
                        results[#results+1] = {
                            id   = tostring(assetId),
                            name = assetName,
                        }
                    end
                end
            end

            -- Jika toolbox-service gagal / hasil 0, coba catalog API
            if #results == 0 then
                local url2 = CATALOG_API ..
                    "?category=3" ..  -- 3 = Models
                    "&keyword=" .. HttpSvc:UrlEncode(keyword) ..
                    "&limit=30" ..
                    "&salesTypeFilter=1"
                local resp2 = HttpSvc:GetAsync(url2, true)
                if resp2 and resp2 ~= "" then
                    local data2 = HttpSvc:JSONDecode(resp2)
                    if data2 and data2.data then
                        for _, item in ipairs(data2.data) do
                            local assetId   = item.id
                            local assetName = item.name or ("Asset " .. tostring(assetId))
                            if assetId then
                                results[#results+1] = {
                                    id   = tostring(assetId),
                                    name = assetName,
                                }
                            end
                        end
                    end
                end
            end
        end)

        isSearching = false

        if ok then
            if onResult then onResult(results) end
        else
            if onError then onError(tostring(err)) end
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
--  STATE PANEL
-- ══════════════════════════════════════════════════════════════
local tbxDone      = false
local tbxVisible   = false
local tbxPanel     = nil
local tbxGrid      = nil
local tbxSearchBox = nil
local tbxStatusLbl = nil
local tbxIdBox     = nil   -- manual ID input
local catBtns      = {}
local cardFrames   = {}
local activeCat    = nil   -- nil = tampilkan semua preset
local isOnlineMode = false -- true = tampilkan hasil search online
local lastQuery    = ""
local onlineItems  = {}    -- hasil search online

-- ── Flat list semua item preset ──
local ALL_ITEMS = {}
for _,catEntry in ipairs(ASSET_DB) do
    for _,item in ipairs(catEntry.items) do
        if item.id and item.id ~= "" then
            ALL_ITEMS[#ALL_ITEMS+1] = {
                id=item.id, name=item.name, cat=catEntry.cat
            }
        end
    end
end

-- ── Filter preset ──
local function filterItems(query, cat)
    local q = (query or ""):lower():gsub("%s+","")
    local result = {}
    for _,item in ipairs(ALL_ITEMS) do
        local matchCat = (cat == nil) or (item.cat == cat)
        local matchQ   = q=="" or item.name:lower():find(q,1,true)
                      or item.id:find(q,1,true)
        if matchCat and matchQ then result[#result+1]=item end
    end
    return result
end

-- ══════════════════════════════════════════════════════════════
--  BUILD CARD GRID — v5: thumbnail lebih besar, ID lebih jelas
--  INSERT button selalu bisa diklik ulang (tidak pakai checkmark permanent)
-- ══════════════════════════════════════════════════════════════
local function buildGrid(items, sourceLabel)
    for _,f in ipairs(cardFrames) do
        pcall(function() f:Destroy() end)
    end
    cardFrames = {}
    if not tbxGrid then return end
    tbxGrid.CanvasPosition = Vector2.new(0,0)

    if #items == 0 then
        local nl = Instance.new("TextLabel"); nl.Parent=tbxGrid
        nl.Size=UDim2.new(1,0,0,40); nl.Position=UDim2.new(0,0,0,16)
        nl.BackgroundTransparency=1
        nl.Text="Tidak ada hasil.\nCoba cari di Creator Store →"
        nl.TextColor3=TC.txtS; nl.TextSize=10; nl.Font=Enum.Font.Gotham
        nl.TextWrapped=true; nl.ZIndex=12
        cardFrames[1]=nl
        return
    end

    local col=0; local row=0
    for _,item in ipairs(items) do
        local x = CARD_PAD + col*(CARD_W+CARD_PAD)
        local y = CARD_PAD + row*(CARD_H+CARD_PAD)

        -- Kartu background
        local card = mkF(tbxGrid,x,y,CARD_W,CARD_H,TC.bg2,8,12)
        mkStr(card,TC.bdr,1)
        cardFrames[#cardFrames+1] = card

        -- v6: Thumbnail area (80px tinggi, full-width, tanpa emot ⏳)
        local THUMB_H = 80
        local thBg = mkF(card,2,2,CARD_W-4,THUMB_H,TC.bg3,6,12)
        local img  = Instance.new("ImageLabel"); img.Parent=thBg
        img.Size=UDim2.new(1,0,1,0); img.BackgroundTransparency=1
        img.ScaleType=Enum.ScaleType.Fit; img.ZIndex=13
        -- v6: 420x420 = ukuran valid rbxthumb terbesar untuk type=Asset
        img.Image = "rbxthumb://type=Asset&id="..item.id.."&w=420&h=420"

        -- v6: Loading indicator — kotak abu kecil di pojok (TIDAK pakai emot ⏳ di tengah)
        -- Akan hilang otomatis saat thumbnail selesai load
        local loadDot = Instance.new("Frame"); loadDot.Parent=thBg
        loadDot.Size=UDim2.new(0,6,0,6)
        loadDot.Position=UDim2.new(1,-10,1,-10)
        loadDot.BackgroundColor3=TC.txtS
        loadDot.BackgroundTransparency=0.3
        loadDot.BorderSizePixel=0; loadDot.ZIndex=14
        Instance.new("UICorner",loadDot).CornerRadius=UDim.new(1,0)
        img:GetPropertyChangedSignal("IsLoaded"):Connect(function()
            pcall(function() loadDot:Destroy() end)
        end)
        pcall(function()
            if img.IsLoaded then pcall(function() loadDot:Destroy() end) end
        end)

        -- v6: Nama asset (sampai 15 karakter)
        local nm = item.name
        if #nm > 15 then nm = nm:sub(1,13).."…" end
        local nmY = THUMB_H + 4
        mkL(card,2,nmY,CARD_W-4,14,nm,TC.txt,8,Enum.TextXAlignment.Center,12)

        -- v6: ID display — font monospace, lebih ringkas
        local idY = nmY + 15
        local fullId = tostring(item.id)
        local displayId = #fullId > 12 and (fullId:sub(1,4).."…"..fullId:sub(-5)) or fullId
        local idLbl = mkL(card,2,idY,CARD_W-4,10,displayId,TC.gold,7,Enum.TextXAlignment.Center,12)
        idLbl.Font = Enum.Font.Code

        -- v6: Tombol INSERT — compact, selalu bisa diklik ulang
        local btnY = idY + 12
        local getBtn = mkB(card,3,btnY,CARD_W-6,17,"INSERT ▶",TC.accB,TC.txt,8,5,13)
        getBtn:SetAttribute("OrigText", "INSERT ▶")
        local capId=item.id; local capNm=item.name

        getBtn.MouseButton1Click:Connect(function()
            insertAsset(capId, capNm, getBtn)
        end)

        -- ── DRAG KE VIEWPORT ──
        local lastClick = 0
        local dragActive = false
        local ghost = nil

        thBg.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                local now = tick()
                -- Double-click = insert langsung
                if now - lastClick < 0.4 then
                    insertAsset(capId, capNm, getBtn)
                end
                lastClick = now
                dragActive = true

                -- Ghost label ikuti mouse saat drag
                if not ghost then
                    local pg2 = LP2:FindFirstChild("PlayerGui") or LP2:WaitForChild("PlayerGui",10)
                    if pg2 then
                        local ghostGui = pg2:FindFirstChild(PFX2.."GhostGui")
                        if not ghostGui then
                            ghostGui = Instance.new("ScreenGui")
                            ghostGui.Name = PFX2.."GhostGui"
                            ghostGui.ResetOnSpawn = false
                            ghostGui.IgnoreGuiInset = true
                            ghostGui.DisplayOrder = 10000
                            ghostGui.ZIndex = 20
                            ghostGui.Parent = pg2
                        end
                        ghost = Instance.new("TextLabel")
                        ghost.Parent = ghostGui
                        ghost.Size = UDim2.new(0,110,0,28)
                        ghost.BackgroundColor3 = TC.accB
                        ghost.BackgroundTransparency = 0.1
                        ghost.Text = "📦 "..capNm:sub(1,14)
                        ghost.TextColor3 = TC.txt; ghost.TextSize=9
                        ghost.Font = Enum.Font.GothamBold
                        ghost.BorderSizePixel = 0; ghost.ZIndex = 20
                        Instance.new("UICorner",ghost).CornerRadius = UDim.new(0,7)
                        local mp = UIS_TBX:GetMouseLocation()
                        ghost.Position = UDim2.new(0,mp.X+10,0,mp.Y-14)
                    end
                end
            end
        end)

        UIS_TBX.InputChanged:Connect(function(inp)
            if dragActive and ghost and inp.UserInputType==Enum.UserInputType.MouseMovement then
                local mp = inp.Position
                ghost.Position = UDim2.new(0,mp.X+10,0,mp.Y-14)
            end
        end)

        UIS_TBX.InputEnded:Connect(function(inp)
            if dragActive and inp.UserInputType==Enum.UserInputType.MouseButton1 then
                dragActive = false
                if ghost then
                    pcall(function() ghost.Parent:Destroy() end); ghost=nil
                end
                -- Drop ke viewport?
                local mp = inp.Position
                local panelPos = tbxPanel and tbxPanel.AbsolutePosition or Vector2.new(0,0)
                local panelSz  = tbxPanel and tbxPanel.AbsoluteSize    or Vector2.new(0,0)
                local inPanel  = (mp.X>=panelPos.X and mp.X<=panelPos.X+panelSz.X
                               and mp.Y>=panelPos.Y and mp.Y<=panelPos.Y+panelSz.Y)
                if not inPanel then
                    local targetCF = nil
                    pcall(function()
                        local cam = game:GetService("Workspace").CurrentCamera
                        if cam then
                            local ray = cam:ScreenPointToRay(mp.X, mp.Y)
                            local rcP = RaycastParams.new()
                            rcP.FilterType = Enum.RaycastFilterType.Exclude
                            local result = game:GetService("Workspace"):Raycast(
                                ray.Origin, ray.Direction*2000, rcP)
                            if result then
                                targetCF = CFrame.new(result.Position + result.Normal*2)
                            end
                        end
                    end)
                    insertAsset(capId, capNm, getBtn, targetCF)
                end
            end
        end)

        -- Hover effect
        card.MouseEnter:Connect(function()
            TwSvc2:Create(card,TweenInfo.new(0.1),{BackgroundColor3=TC.bg3}):Play()
            mkStr(card, TC.accB, 1.5)
        end)
        card.MouseLeave:Connect(function()
            TwSvc2:Create(card,TweenInfo.new(0.1),{BackgroundColor3=TC.bg2}):Play()
            local s = card:FindFirstChildOfClass("UIStroke")
            if s then s.Color = TC.bdr; s.Thickness = 1 end
        end)

        col=col+1
        if col>=COLS then col=0; row=row+1 end
    end

    -- Update canvas
    local rows  = math.ceil(math.max(#items,1)/COLS)
    local totalH = CARD_PAD + rows*(CARD_H+CARD_PAD) + CARD_PAD
    tbxGrid.CanvasSize = UDim2.new(0,0,0,math.max(totalH,20))

    if tbxStatusLbl then
        local src = sourceLabel or "preset"
        tbxStatusLbl.Text = "✅ "..#items.." aset ["..src.."]"
    end
end

-- ── Refresh tampilan ──
local function refresh()
    if isOnlineMode then
        buildGrid(onlineItems, "🌐 Creator Store")
    else
        local items = filterItems(lastQuery, activeCat)
        buildGrid(items, activeCat or "semua")
    end
end

-- ── Handler tombol SEARCH ONLINE ──
local function doOnlineSearch(query)
    if not query or query == "" then return end
    isOnlineMode = true
    onlineItems  = {}
    if tbxStatusLbl then tbxStatusLbl.Text = "🔍 Mencari di Creator Store…" end
    buildGrid({}, "")

    searchCreatorStore(query,
        function(results)
            onlineItems = results
            -- Tampilkan di grid
            buildGrid(onlineItems, "🌐 Creator Store")
        end,
        function(errMsg)
            if tbxStatusLbl then
                tbxStatusLbl.Text = "❌ Gagal: "..tostring(errMsg):sub(1,40)
            end
            -- Fallback ke preset search
            isOnlineMode = false
            refresh()
            warn("[Toolbox] API Error: "..tostring(errMsg))
        end
    )
end

-- ══════════════════════════════════════════════════════════════
--  BUILD UI PANEL UTAMA
-- ══════════════════════════════════════════════════════════════
local function buildToolboxUI()
    local old = CoreGui2:FindFirstChild(PFX2.."ToolboxGui")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = PFX2.."ToolboxGui"; gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=true; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder=9997; gui.Parent=CoreGui2

    -- Panel
    local panel = mkF(gui,120,55,PW,PH,TC.bg0,10,10)
    mkStr(panel,TC.bdrA,1.5)
    Instance.new("UIGradient",panel).Color=ColorSequence.new(TC.bg0,TC.bg1)
    panel.Visible=false
    tbxPanel=panel

    -- ── HEADER ──
    local hdr = mkF(panel,0,0,PW,46,TC.bg1,0,11)
    hdr.Size = UDim2.new(1,0,0,46)
    Instance.new("UIGradient",hdr).Color=ColorSequence.new(Color3.fromRGB(6,16,40),TC.bg1)

    mkL(hdr,12,4,240,18,"🧱  TOOLBOX v6.0",TC.acc,14,Enum.TextXAlignment.Left,12)
    mkL(hdr,12,24,260,12,"// Creator Store API  •  Studio PC Mode  •  v6",TC.txtS,8,Enum.TextXAlignment.Left,12)

    local xBtn = mkB(hdr,PW-34,8,26,26,"✕",Color3.fromRGB(75,12,12),TC.red,14,6,13)
    xBtn.MouseButton1Click:Connect(function()
        tbxVisible=false; panel.Visible=false
    end)

    -- ── DRAG ──
    do
        local dragging=false; local dragStart=nil; local startPos=nil
        hdr.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1
            or input.UserInputType==Enum.UserInputType.Touch then
                dragging=true; dragStart=input.Position; startPos=panel.Position
                input.Changed:Connect(function()
                    if input.UserInputState==Enum.UserInputState.End then dragging=false end
                end)
            end
        end)
        hdr.InputChanged:Connect(function(input)
            if (input.UserInputType==Enum.UserInputType.MouseMovement
            or  input.UserInputType==Enum.UserInputType.Touch)
            and dragging and dragStart and startPos then
                local d = input.Position - dragStart
                panel.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset+d.X,
                    startPos.Y.Scale, startPos.Y.Offset+d.Y)
            end
        end)
    end

    -- ══════════════════════════════════════════════
    --  SECTION 1: CREATOR STORE SEARCH (seperti Studio PC)
    --  Baris atas: search bar + tombol "CARI ONLINE"
    -- ══════════════════════════════════════════════
    local Y = 50

    -- Label section
    local secLbl = mkF(panel,4,Y,PW-8,16,TC.bg3,4,11)
    mkL(secLbl,6,1,PW-20,14,"🌐  CREATOR STORE SEARCH",TC.gold,9,Enum.TextXAlignment.Left,12)
    Y = Y + 19

    -- Search input
    local sBg = mkF(panel,4,Y,PW-8,30,TC.bg2,6,11)
    mkStr(sBg,TC.bdr,1)
    tbxSearchBox = mkTBX(sBg,6,5,PW-100,20,"Cari nama asset di Creator Store…",12)
    tbxSearchBox.Size = UDim2.new(1,-82,0,20)
    tbxSearchBox.Position = UDim2.new(0,6,0,5)

    local srOnlineBtn = mkB(sBg,PW-74,4,68,22,"🔍 CARI",TC.orange,TC.txt,9,5,12)
    srOnlineBtn.MouseButton1Click:Connect(function()
        doOnlineSearch(tbxSearchBox.Text)
    end)
    tbxSearchBox.FocusLost:Connect(function(enter)
        if enter then doOnlineSearch(tbxSearchBox.Text) end
    end)
    Y = Y + 34

    -- ── MANUAL ASSET ID INPUT ──
    local idBg = mkF(panel,4,Y,PW-8,30,TC.bg2,6,11)
    mkStr(idBg,TC.bdrA,1)
    mkL(idBg,6,8,36,14,"🆔",TC.txtS,10,Enum.TextXAlignment.Left,12)
    tbxIdBox = mkTBX(idBg,30,5,PW-130,20,"Masukkan Asset ID…",12)
    tbxIdBox.Size = UDim2.new(1,-108,0,20)
    tbxIdBox.Position = UDim2.new(0,30,0,5)

    -- Tombol INSERT langsung dari ID — v5: selalu bisa diklik ulang
    local idInsBtn = mkB(idBg,PW-96,4,90,22,"INSERT ▶",TC.grn,TC.txt,9,5,12)
    idInsBtn:SetAttribute("OrigText", "INSERT ▶")
    idInsBtn.MouseButton1Click:Connect(function()
        local idStr = tbxIdBox.Text:gsub("%s","")
        if idStr ~= "" then
            insertAsset(idStr, "ID:"..idStr, idInsBtn)
        end
    end)
    tbxIdBox.FocusLost:Connect(function(enter)
        if enter then
            local idStr = tbxIdBox.Text:gsub("%s","")
            if idStr ~= "" then
                insertAsset(idStr, "ID:"..idStr, idInsBtn)
            end
        end
    end)
    Y = Y + 34

    -- ── STATUS BAR ──
    local stBg = mkF(panel,4,Y,PW-8,18,TC.bg1,3,11)
    tbxStatusLbl = mkL(stBg,6,2,PW-90,14,
        "📦 "..(#ALL_ITEMS).." asset preset  |  Ketik & CARI untuk live search",
        TC.txtS,8,Enum.TextXAlignment.Left,12)
    -- Tombol kembali ke preset
    local presetBtn = mkB(stBg,PW-82,1,76,16,"📋 Preset",TC.bg3,TC.acc,8,4,11)
    presetBtn.MouseButton1Click:Connect(function()
        isOnlineMode = false
        activeCat = nil
        for _,cb in ipairs(catBtns) do
            cb.btn.BackgroundColor3=TC.bg2; cb.btn.TextColor3=TC.txtS
        end
        refresh()
    end)
    Y = Y + 22

    -- ── KATEGORI PRESET (tab scroll horizontal) ──
    local catSF = Instance.new("ScrollingFrame"); catSF.Parent=panel
    catSF.Position=UDim2.new(0,4,0,Y)
    catSF.Size=UDim2.new(1,-8,0,26)
    catSF.BackgroundTransparency=1; catSF.BorderSizePixel=0
    catSF.ScrollBarThickness=2; catSF.ScrollBarImageColor3=TC.accB
    catSF.CanvasSize=UDim2.new(0,0,0,0); catSF.ZIndex=11
    catSF.ScrollingDirection=Enum.ScrollingDirection.X

    local catX=0
    for i,catEntry in ipairs(ASSET_DB) do
        if catEntry.cat ~= "Creator Store Search" and #catEntry.items > 0 then
            local catName = catEntry.cat
            local btnW = math.max(#catName*6+16, 56)
            local cb = mkB(catSF,catX,2,btnW,22,catName,TC.bg2,TC.txtS,8,5,12)
            catBtns[#catBtns+1] = {btn=cb, cat=catName}
            catX = catX + btnW + 4

            cb.MouseButton1Click:Connect(function()
                isOnlineMode = false
                activeCat = catName
                for _,c in ipairs(catBtns) do
                    c.btn.BackgroundColor3=(c.cat==catName) and TC.accB or TC.bg2
                    c.btn.TextColor3=(c.cat==catName) and TC.txt or TC.txtS
                end
                refresh()
            end)
        end
    end
    catSF.CanvasSize = UDim2.new(0,catX+4,0,0)
    Y = Y + 30

    -- ── GRID ScrollingFrame ──
    local gH = PH - Y - 6
    tbxGrid = Instance.new("ScrollingFrame"); tbxGrid.Parent=panel
    tbxGrid.Position=UDim2.new(0,4,0,Y)
    tbxGrid.Size=UDim2.new(1,-8,0,gH)
    tbxGrid.BackgroundColor3=TC.bg1; tbxGrid.BorderSizePixel=0
    tbxGrid.ScrollBarThickness=3; tbxGrid.ScrollBarImageColor3=TC.accB
    tbxGrid.CanvasSize=UDim2.new(0,0,0,0); tbxGrid.ZIndex=11
    Instance.new("UICorner",tbxGrid).CornerRadius=UDim.new(0,6)

    -- Tampilkan semua preset di awal
    refresh()

end

-- ── Inject tombol ke toolbar ──
local tbxDoneFlag = false
local function injectToolbox()
    if tbxDoneFlag then return end
    local tb=findTB2(); if not tb then return end
    if tb:FindFirstChild(PFX2.."Btn_Toolbox") then tbxDoneFlag=true; return end

    local posX=getMaxX2(tb)+16; makeSep2(tb,posX-12)
    makeBtn2(tb,posX,"Toolbox",icoToolbox,function()
        if not tbxPanel then pcall(buildToolboxUI) end
        tbxVisible = not tbxVisible
        if tbxPanel then tbxPanel.Visible=tbxVisible end
    end)

    task.spawn(function()
        local ok,err=pcall(buildToolboxUI)
        if not ok then warn("[Toolbox] buildUI error: "..tostring(err)) end
    end)

    tbxDoneFlag=true
end

_SL.injectToolbox=injectToolbox
end
_sl_toolbox()

_sl_toolbox()

-- ══════════════════════════════════════════════════════════════
--  TOOLBOX PC BLOCK v2.0 — Panel terintegrasi dengan insert engine
--  Tombol toolbar "Toolbox PC" toggle panel CreatorPanel v5.0
--  Insert menggunakan insertAsset() dari Toolbox lama (M2→M3→M4)
-- ══════════════════════════════════════════════════════════════
local function _sl_toolboxPC()

local PFX3     = _SL.PFX
local drawSeg3 = _SL.drawSeg
local findTB3  = _SL.findToolbar
local getMaxX3 = _SL.getMaxX
local makeSep3 = _SL.makeSep
local makeBtn3 = _SL.makePartBtn
local CoreGui3 = _SL.CoreGui

-- ── Warna ikon ──
local ACC3 = Color3.fromRGB(80, 140, 255)
local OK3  = Color3.fromRGB(60, 200, 100)

-- ── Referensi insert engine dari Toolbox lama ──
-- Dipanggil setelah discoverSL() sudah jalan, jadi pasti tersedia
local function doInsert(idStr, name, btn)
    local fn = _SL.insertAsset
    if fn then
        fn(idStr, name, btn)
    else
        -- fallback langsung InsertService jika _SL.insertAsset belum siap
        local id = tonumber(idStr)
        if not id then return end
        task.spawn(function()
            if btn then btn.Text = "..."; btn.BackgroundColor3 = Color3.fromRGB(60,60,60) end
            local ok, model = pcall(function()
                return game:GetService("InsertService"):LoadAsset(id)
            end)
            if ok and model then
                model.Parent = workspace
                if btn then btn.Text = "✓ OK"; btn.BackgroundColor3 = Color3.fromRGB(40,160,80) end
            else
                if btn then btn.Text = "✗"; btn.BackgroundColor3 = Color3.fromRGB(180,50,50) end
                warn("[ToolboxPC] Insert gagal: " .. tostring(model))
            end
            task.wait(2)
            if btn then btn.Text = "Insert"; btn.BackgroundColor3 = Color3.fromRGB(0,120,212) end
        end)
    end
end

-- ══════════════════════════════════════════════════════════════
-- SEARCH ENGINE — InsertService built-in (no HTTP, no API key)
-- ══════════════════════════════════════════════════════════════
local IS3 = game:GetService("InsertService")

local function searchModels3(keyword, page)
    page = tonumber(page) or 0
    local ok, raw = pcall(function() return IS3:GetFreeModels(keyword, page) end)
    if not ok then return { success=false, error=tostring(raw) } end
    local bucket = raw and raw[1]
    if not bucket then return { success=true, items={}, hasMore=false, nextPage=page+1 } end
    local results = bucket.Results or {}
    local items = {}
    for _, r in ipairs(results) do
        local aid = tonumber(r.AssetId) or 0
        if aid > 0 then
            table.insert(items, {
                id=aid, name=tostring(r.Name or "Unknown"),
                assetType="Model",
                creatorName=tostring(r.Creator or r.CreatorName or "Unknown"),
            })
        end
    end
    local total   = tonumber(bucket.TotalCount) or #items
    local fetched = page*21 + #items
    return { success=true, items=items, total=total,
             hasMore=(#items>=21 or (total>0 and fetched<total)),
             nextPage=page+1 }
end

local function searchDecals3(keyword, page)
    page = tonumber(page) or 0
    local ok, raw = pcall(function() return IS3:GetFreeDecals(keyword, page) end)
    if not ok then return { success=false, error=tostring(raw) } end
    local bucket = raw and raw[1]
    if not bucket then return { success=true, items={}, hasMore=false, nextPage=page+1 } end
    local results = bucket.Results or {}
    local items = {}
    for _, r in ipairs(results) do
        local aid = tonumber(r.AssetId) or 0
        if aid > 0 then
            table.insert(items, {
                id=aid, name=tostring(r.Name or "Unknown"),
                assetType="Decal",
                creatorName=tostring(r.Creator or r.CreatorName or "Unknown"),
            })
        end
    end
    local total   = tonumber(bucket.TotalCount) or #items
    local fetched = page*21 + #items
    return { success=true, items=items, total=total,
             hasMore=(#items>=21 or (total>0 and fetched<total)),
             nextPage=page+1 }
end

local function doSearch3(mode, keyword, page)
    if mode == "Model" then return searchModels3(keyword, page)
    elseif mode == "Decal" then return searchDecals3(keyword, page)
    else return { success=false, error="Audio: masukkan ID manual", isAudioMode=true } end
end

-- ══════════════════════════════════════════════════════════════
-- BUILD PANEL UI
-- ══════════════════════════════════════════════════════════════
local tbxPCPanel   = nil
local tbxPCVisible = false

local function buildToolboxPCPanel()
    -- Hapus panel lama
    local old = CoreGui3:FindFirstChild(PFX3.."ToolboxPCGui")
    if old then old:Destroy() end

    local Gui = Instance.new("ScreenGui")
    Gui.Name           = PFX3.."ToolboxPCGui"
    Gui.ResetOnSpawn   = false
    Gui.DisplayOrder   = 9996
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.IgnoreGuiInset = true
    Gui.Parent         = CoreGui3

    local PANEL_W = 260  -- HTML --panel-width-r: 260px
    local PANEL_H = 530
    local PAD     = 8

    -- Root Panel  → HTML #left-panel bg1 + border
    local Panel = Instance.new("Frame", Gui)
    Panel.Name              = "Panel"
    Panel.Size              = UDim2.new(0, PANEL_W, 0, PANEL_H)
    Panel.Position          = UDim2.new(0, 12, 0, 60)
    Panel.BackgroundColor3  = Color3.fromRGB(36, 36, 36)    -- #242424 bg1
    Panel.BorderSizePixel   = 0
    Panel.ClipsDescendants  = true
    Panel.Visible           = false
    Panel.ZIndex            = 10
    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 6)
    local panelStroke = Instance.new("UIStroke", Panel)
    panelStroke.Color     = Color3.fromRGB(64, 64, 64)      -- #404040 border
    panelStroke.Thickness = 1

    -- Simpan referensi panel ke _SL dan variabel lokal
    tbxPCPanel        = Panel
    _SL.toolboxPCPanel = Panel

    -- ── TitleBar  → HTML .panel-tabs bg:#1a1a1a border-bottom:#404040 ──
    local TitleBar = Instance.new("Frame", Panel)
    TitleBar.Name             = "TitleBar"
    TitleBar.Size             = UDim2.new(1, 0, 0, 36)
    TitleBar.Position         = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Color3.fromRGB(26, 26, 26)   -- #1a1a1a bg0
    TitleBar.BorderSizePixel  = 0
    TitleBar.ZIndex           = 11

    -- Accent dot  → HTML .panel-tab.active accent #00a2ff
    local TitleDot = Instance.new("Frame", TitleBar)
    TitleDot.Size             = UDim2.new(0, 3, 1, -10)
    TitleDot.Position         = UDim2.new(0, 0, 0, 5)
    TitleDot.BackgroundColor3 = Color3.fromRGB(0, 162, 255)  -- #00a2ff accent
    TitleDot.BorderSizePixel  = 0
    TitleDot.ZIndex           = 12
    Instance.new("UICorner", TitleDot).CornerRadius = UDim.new(0, 2)

    -- Title text  → HTML .panel-tab.active color:accent, font-size:11px
    local HTitle = Instance.new("TextLabel", TitleBar)
    HTitle.Size                   = UDim2.new(1, -70, 1, 0)
    HTitle.Position               = UDim2.new(0, PAD+8, 0, 0)
    HTitle.BackgroundTransparency = 1
    HTitle.Text                   = "Toolbox"
    HTitle.TextColor3             = Color3.fromRGB(0, 162, 255)  -- accent active tab
    HTitle.TextSize               = 11
    HTitle.Font                   = Enum.Font.GothamBold
    HTitle.TextXAlignment         = Enum.TextXAlignment.Left
    HTitle.ZIndex                 = 12

    -- Close/collapse  → HTML .panel-close-x
    local CollapseBtn = Instance.new("TextButton", TitleBar)
    CollapseBtn.Size             = UDim2.new(0, 20, 0, 20)
    CollapseBtn.Position         = UDim2.new(1, -(PAD+20), 0.5, -10)
    CollapseBtn.BackgroundColor3 = Color3.fromRGB(54, 54, 54)  -- #363636 bg3
    CollapseBtn.Text             = "✕"
    CollapseBtn.TextColor3       = Color3.fromRGB(138, 138, 138)  -- text2
    CollapseBtn.TextSize         = 10
    CollapseBtn.Font             = Enum.Font.GothamBold
    CollapseBtn.ZIndex           = 13
    Instance.new("UICorner", CollapseBtn).CornerRadius = UDim.new(0, 3)

    -- Title border-bottom  → HTML border-bottom:1px solid #404040
    local TitleLine = Instance.new("Frame", Panel)
    TitleLine.Size             = UDim2.new(1, 0, 0, 1)
    TitleLine.Position         = UDim2.new(0, 0, 0, 36)
    TitleLine.BackgroundColor3 = Color3.fromRGB(64, 64, 64)   -- #404040 border
    TitleLine.BorderSizePixel  = 0
    TitleLine.ZIndex           = 11

    -- ── Search Bar  → struktur flat seperti V4 (tanpa SearchInner) ──
    local SearchBar = Instance.new("Frame", Panel)
    SearchBar.Name             = "SearchBar"
    SearchBar.Size             = UDim2.new(1, -(PAD*2), 0, 30)
    SearchBar.Position         = UDim2.new(0, PAD, 0, 43)
    SearchBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SearchBar.BorderSizePixel  = 0
    SearchBar.ZIndex           = 11
    Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 6)
    local sbStroke = Instance.new("UIStroke", SearchBar)
    sbStroke.Color = Color3.fromRGB(80, 80, 80); sbStroke.Thickness = 1

    local SearchIcon = Instance.new("TextLabel", SearchBar)
    SearchIcon.Size                   = UDim2.new(0, 26, 1, 0)
    SearchIcon.Position               = UDim2.new(0, 5, 0, 0)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Text                   = "🔍"
    SearchIcon.TextSize               = 12
    SearchIcon.Font                   = Enum.Font.Gotham
    SearchIcon.ZIndex                 = 12

    -- SearchBox langsung child SearchBar (flat, tidak ada SearchInner)
    local SearchBox = Instance.new("TextBox", SearchBar)
    SearchBox.Name              = "SearchBox"
    SearchBox.Size              = UDim2.new(1, -58, 1, 0)
    SearchBox.Position          = UDim2.new(0, 30, 0, 0)
    SearchBox.BackgroundTransparency = 1
    SearchBox.PlaceholderText   = "Search toolbox..."
    SearchBox.PlaceholderColor3 = Color3.fromRGB(138,138,138)
    SearchBox.Text              = ""
    SearchBox.TextColor3        = Color3.fromRGB(232,232,232)
    SearchBox.TextSize          = 11
    SearchBox.Font              = Enum.Font.Gotham
    SearchBox.TextXAlignment    = Enum.TextXAlignment.Left
    SearchBox.ClearTextOnFocus  = false
    SearchBox.ZIndex            = 13

    -- SearchBtn langsung child SearchBar, tidak overlap SearchBox
    local SearchBtn = Instance.new("TextButton", SearchBar)
    SearchBtn.Size             = UDim2.new(0, 24, 0, 22)
    SearchBtn.Position         = UDim2.new(1, -28, 0.5, -11)
    SearchBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    SearchBtn.Text             = "→"
    SearchBtn.TextColor3       = Color3.new(1,1,1)
    SearchBtn.TextSize         = 12
    SearchBtn.Font             = Enum.Font.GothamBold
    SearchBtn.ZIndex           = 13
    Instance.new("UICorner", SearchBtn).CornerRadius = UDim.new(0, 4)

    -- ── Category Bar ──
    local CatBar = Instance.new("Frame", Panel)
    CatBar.Name             = "CatBar"
    CatBar.Size             = UDim2.new(1, -(PAD*2), 0, 28)
    CatBar.Position         = UDim2.new(0, PAD, 0, 79)
    CatBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CatBar.BorderSizePixel  = 0
    CatBar.ZIndex           = 11
    Instance.new("UICorner", CatBar).CornerRadius = UDim.new(0, 6)
    local catLayout = Instance.new("UIListLayout", CatBar)
    catLayout.FillDirection       = Enum.FillDirection.Horizontal
    catLayout.Padding             = UDim.new(0, 2)
    catLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    catLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
    local catPad = Instance.new("UIPadding", CatBar)
    catPad.PaddingLeft   = UDim.new(0,3); catPad.PaddingRight  = UDim.new(0,3)
    catPad.PaddingTop    = UDim.new(0,3); catPad.PaddingBottom = UDim.new(0,3)

    -- ── Content Area ──
    local CONTENT_TOP = 111
    local STATUS_H    = 20

    local Content = Instance.new("ScrollingFrame", Panel)
    Content.Name                   = "Content"
    Content.Size                   = UDim2.new(1, 0, 1, -(CONTENT_TOP+STATUS_H))
    Content.Position               = UDim2.new(0, 0, 0, CONTENT_TOP)
    Content.BackgroundColor3       = Color3.fromRGB(36, 36, 36)   -- #242424 bg1
    Content.BackgroundTransparency = 0
    Content.BorderSizePixel        = 0
    Content.CanvasSize             = UDim2.new(0,0,0,0)
    Content.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    Content.ScrollBarThickness     = 5                             -- HTML 5px scrollbar
    Content.ScrollBarImageColor3   = Color3.fromRGB(64, 64, 64)   -- bg4 #404040
    Content.ScrollingDirection     = Enum.ScrollingDirection.Y
    Content.ZIndex                 = 11
    local cPad = Instance.new("UIPadding", Content)
    cPad.PaddingLeft   = UDim.new(0,PAD); cPad.PaddingRight  = UDim.new(0,PAD)
    cPad.PaddingTop    = UDim.new(0,6);   cPad.PaddingBottom = UDim.new(0,6)
    local cLayout = Instance.new("UIListLayout", Content)
    cLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cLayout.Padding   = UDim.new(0, 4)

    -- ── Status Bar ──
    local StatusBar = Instance.new("Frame", Panel)
    StatusBar.Size             = UDim2.new(1, 0, 0, STATUS_H)
    StatusBar.Position         = UDim2.new(0, 0, 1, -STATUS_H)
    StatusBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    StatusBar.BorderSizePixel  = 0
    StatusBar.ZIndex           = 12
    local StatusLbl = Instance.new("TextLabel", StatusBar)
    StatusLbl.Size                   = UDim2.new(1, -(PAD*2), 1, 0)
    StatusLbl.Position               = UDim2.new(0, PAD, 0, 0)
    StatusLbl.BackgroundTransparency = 1
    StatusLbl.Text                   = "● Ready"
    StatusLbl.TextColor3             = Color3.fromRGB(130,130,130)
    StatusLbl.TextSize               = 9
    StatusLbl.Font                   = Enum.Font.Code
    StatusLbl.TextXAlignment         = Enum.TextXAlignment.Left
    StatusLbl.ZIndex                 = 13

    -- ── Helpers ──
    local C_WHITE  = Color3.fromRGB(230,230,230)
    local C_DIM    = Color3.fromRGB(150,150,155)
    local C_GREEN  = Color3.fromRGB(80,200,100)
    local C_BLUE   = Color3.fromRGB(0,162,255)
    local C_YELLOW = Color3.fromRGB(240,190,60)
    local C_BG2    = Color3.fromRGB(42,42,42)

    local function setStatus(msg, col)
        StatusLbl.Text       = "● " .. tostring(msg)
        StatusLbl.TextColor3 = col or Color3.fromRGB(160,160,160)
    end

    local function clearCards()
        for _, v in ipairs(Content:GetChildren()) do
            if v:IsA("GuiObject") then v:Destroy() end
        end
    end

    -- ── Result Card ──
    local function resultCard(item, lo)
        local card = Instance.new("Frame", Content)
        card.Name             = "Card"
        card.Size             = UDim2.new(1, 0, 0, 72)
        card.BackgroundColor3 = C_BG2
        card.BorderSizePixel  = 0
        card.LayoutOrder      = lo or 0
        card.ZIndex           = 12
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Color = Color3.fromRGB(64,64,64); cardStroke.Thickness = 1  -- #404040 border

        -- Thumbnail
        local thumbBox = Instance.new("Frame", card)
        thumbBox.Size             = UDim2.new(0, 60, 0, 60)
        thumbBox.Position         = UDim2.new(0, 6, 0.5, -30)
        thumbBox.BackgroundColor3 = Color3.fromRGB(52,52,52)
        thumbBox.BorderSizePixel  = 0
        thumbBox.ZIndex           = 13
        Instance.new("UICorner", thumbBox).CornerRadius = UDim.new(0, 5)
        local thumbPlaceholder = Instance.new("TextLabel", thumbBox)
        thumbPlaceholder.Size                   = UDim2.new(1,0,1,0)
        thumbPlaceholder.BackgroundTransparency = 1
        thumbPlaceholder.Text                   = item.assetType=="Model" and "📦" or "🖼"
        thumbPlaceholder.TextColor3             = Color3.fromRGB(120,120,120)
        thumbPlaceholder.TextSize               = 20
        thumbPlaceholder.Font                   = Enum.Font.Gotham
        thumbPlaceholder.ZIndex                 = 14
        local thumbImg = Instance.new("ImageLabel", thumbBox)
        thumbImg.Size                   = UDim2.new(1,0,1,0)
        thumbImg.BackgroundTransparency = 1
        thumbImg.Image                  = ""
        thumbImg.ScaleType              = Enum.ScaleType.Fit
        thumbImg.ZIndex                 = 15
        Instance.new("UICorner", thumbImg).CornerRadius = UDim.new(0, 5)
        task.spawn(function()
            local ok = pcall(function()
                thumbImg.Image = "rbxthumb://type=Asset&id="..tostring(item.id).."&w=150&h=150"
            end)
            if ok and thumbImg.Image ~= "" then thumbPlaceholder.Visible = false end
        end)

        -- Info
        local nameLbl = Instance.new("TextLabel", card)
        nameLbl.Size                   = UDim2.new(1,-140,0,16)
        nameLbl.Position               = UDim2.new(0,74,0,8)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text                   = tostring(item.name or "Unknown")
        nameLbl.TextColor3             = C_WHITE
        nameLbl.TextSize               = 11
        nameLbl.Font                   = Enum.Font.GothamBold
        nameLbl.TextXAlignment         = Enum.TextXAlignment.Left
        nameLbl.TextTruncate           = Enum.TextTruncate.AtEnd
        nameLbl.ZIndex                 = 13

        local creatorLbl = Instance.new("TextLabel", card)
        creatorLbl.Size                   = UDim2.new(1,-140,0,12)
        creatorLbl.Position               = UDim2.new(0,74,0,26)
        creatorLbl.BackgroundTransparency = 1
        creatorLbl.Text                   = "by "..tostring(item.creatorName or "Unknown")
        creatorLbl.TextColor3             = C_DIM
        creatorLbl.TextSize               = 9
        creatorLbl.Font                   = Enum.Font.Gotham
        creatorLbl.TextXAlignment         = Enum.TextXAlignment.Left
        creatorLbl.TextTruncate           = Enum.TextTruncate.AtEnd
        creatorLbl.ZIndex                 = 13

        local idLbl = Instance.new("TextLabel", card)
        idLbl.Size                   = UDim2.new(1,-140,0,11)
        idLbl.Position               = UDim2.new(0,74,0,40)
        idLbl.BackgroundTransparency = 1
        idLbl.Text                   = "ID: "..tostring(item.id or "?")
        idLbl.TextColor3             = Color3.fromRGB(120,120,130)
        idLbl.TextSize               = 9
        idLbl.Font                   = Enum.Font.Code
        idLbl.TextXAlignment         = Enum.TextXAlignment.Left
        idLbl.ZIndex                 = 13

        -- Tombol Copy ID  → HTML .out-filter-btn bg3:#363636
        local copyB = Instance.new("TextButton", card)
        copyB.Size             = UDim2.new(0, 52, 0, 22)
        copyB.Position         = UDim2.new(1, -58, 0, 6)
        copyB.BackgroundColor3 = Color3.fromRGB(54, 54, 54)       -- #363636 bg3
        copyB.Text             = "ID ⧉"
        copyB.TextColor3       = Color3.fromRGB(192, 192, 192)     -- text1 #c0c0c0
        copyB.TextSize         = 9
        copyB.Font             = Enum.Font.GothamBold
        copyB.ZIndex           = 14
        Instance.new("UICorner", copyB).CornerRadius = UDim.new(0, 3)

        -- Tombol Insert  → HTML .tb-btn.active bg accent2:#0075cc border accent
        local insertB = Instance.new("TextButton", card)
        insertB.Name             = "InsertBtn"
        insertB.Size             = UDim2.new(0, 52, 0, 22)
        insertB.Position         = UDim2.new(1, -58, 0, 34)
        insertB.BackgroundColor3 = Color3.fromRGB(0, 117, 204)     -- #0075cc accent2
        insertB.Text             = "Insert"
        insertB.TextColor3       = Color3.new(1,1,1)
        insertB.TextSize         = 9
        insertB.Font             = Enum.Font.GothamBold
        insertB.ZIndex           = 14
        insertB:SetAttribute("OrigText", "Insert")
        Instance.new("UICorner", insertB).CornerRadius = UDim.new(0, 3)

        card.MouseEnter:Connect(function()
            card.BackgroundColor3 = Color3.fromRGB(54,54,54)           -- #363636 bg3 hover
            cardStroke.Color = Color3.fromRGB(0,162,255)               -- #00a2ff accent
        end)
        card.MouseLeave:Connect(function()
            card.BackgroundColor3 = C_BG2
            cardStroke.Color = Color3.fromRGB(64,64,64)                -- #404040 border
        end)

        copyB.MouseButton1Click:Connect(function()
            copyB.Text = "✓"; copyB.TextColor3 = C_GREEN
            setStatus("ID: "..tostring(item.id).." → Output", C_GREEN)
            task.delay(1.5, function() copyB.Text="ID ⧉"; copyB.TextColor3=Color3.fromRGB(180,180,180) end)
        end)

        insertB.MouseButton1Click:Connect(function()
            setStatus("Inserting "..tostring(item.name or "?").."...", C_BLUE)
            -- Gunakan insertAsset dari Toolbox lama (M2→M3→M4 fallback chain)
            doInsert(tostring(item.id), tostring(item.name or "?"), insertB)
        end)

        return card
    end

    -- ── Category buttons ──
    -- label = teks tampil, mode = nilai untuk doSearch3
    local catDefs = {
        {label="Model", mode="Model"},
        {label="Decal", mode="Decal"},
        {label="Audio", mode="Audio"},
    }
    local catBtns = {}
    local selMode = "Model"
    for i, def in ipairs(catDefs) do
        local cb = Instance.new("TextButton", CatBar)
        cb.Size             = UDim2.new(0, 0, 1, 0)
        cb.AutomaticSize    = Enum.AutomaticSize.X
        cb.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
        cb.Text             = def.label
        cb.TextColor3       = Color3.fromRGB(138, 138, 138)
        cb.TextSize         = 10
        cb.Font             = Enum.Font.GothamBold
        cb.ZIndex           = 12
        cb.LayoutOrder      = i
        local cbPad = Instance.new("UIPadding", cb)
        cbPad.PaddingLeft=UDim.new(0,10); cbPad.PaddingRight=UDim.new(0,10)
        Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 12)
        catBtns[def.mode] = cb
    end

    local function selectCat(m)
        selMode = m
        for k, b in pairs(catBtns) do
            if k == m then
                b.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
                b.TextColor3       = Color3.new(1,1,1)
            else
                b.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
                b.TextColor3       = Color3.fromRGB(138, 138, 138)
            end
        end
    end
    selectCat("Model")

    -- Audio panel (input ID manual)
    local audioPanel = Instance.new("Frame", Content)
    audioPanel.Size             = UDim2.new(1, 0, 0, 56)
    audioPanel.BackgroundColor3 = Color3.fromRGB(44,44,44)
    audioPanel.BorderSizePixel  = 0
    audioPanel.LayoutOrder      = 1
    audioPanel.Visible          = false
    audioPanel.ZIndex           = 12
    Instance.new("UICorner", audioPanel).CornerRadius = UDim.new(0, 6)
    local apPad = Instance.new("UIPadding", audioPanel)
    apPad.PaddingLeft=UDim.new(0,8); apPad.PaddingTop=UDim.new(0,6)
    local apLayout = Instance.new("UIListLayout", audioPanel)
    apLayout.Padding = UDim.new(0,3)

    local audioHint = Instance.new("TextLabel", audioPanel)
    audioHint.Size                   = UDim2.new(1,-10,0,14)
    audioHint.BackgroundTransparency = 1
    audioHint.Text                   = "🎵 Masukkan Asset ID audio lalu INSERT:"
    audioHint.TextColor3             = Color3.fromRGB(200,200,200)
    audioHint.TextSize               = 9
    audioHint.Font                   = Enum.Font.Gotham
    audioHint.TextXAlignment         = Enum.TextXAlignment.Left
    audioHint.ZIndex                 = 13

    local audioRow = Instance.new("Frame", audioPanel)
    audioRow.Size             = UDim2.new(1,-10,0,24)
    audioRow.BackgroundColor3 = Color3.fromRGB(55,55,55)
    audioRow.BorderSizePixel  = 0
    audioRow.ZIndex           = 13
    Instance.new("UICorner", audioRow).CornerRadius = UDim.new(0,4)

    local audioIdBox = Instance.new("TextBox", audioRow)
    audioIdBox.Size                   = UDim2.new(0.68,0,1,0)
    audioIdBox.Position               = UDim2.new(0,6,0,0)
    audioIdBox.BackgroundTransparency = 1
    audioIdBox.PlaceholderText        = "Contoh: 142376088"
    audioIdBox.PlaceholderColor3      = Color3.fromRGB(120,120,120)
    audioIdBox.Text                   = ""
    audioIdBox.TextColor3             = C_WHITE
    audioIdBox.TextSize               = 10
    audioIdBox.Font                   = Enum.Font.Code
    audioIdBox.ZIndex                 = 14
    audioIdBox.ClearTextOnFocus       = false

    local audioInsBtn = Instance.new("TextButton", audioRow)
    audioInsBtn.Size             = UDim2.new(0.28,0,1,-2)
    audioInsBtn.Position         = UDim2.new(0.71,0,0,1)
    audioInsBtn.BackgroundColor3 = Color3.fromRGB(0,120,212)
    audioInsBtn.Text             = "Insert"
    audioInsBtn.TextColor3       = Color3.new(1,1,1)
    audioInsBtn.TextSize         = 9
    audioInsBtn.Font             = Enum.Font.GothamBold
    audioInsBtn.ZIndex           = 14
    Instance.new("UICorner", audioInsBtn).CornerRadius = UDim.new(0,4)

    audioInsBtn.MouseButton1Click:Connect(function()
        local idStr = audioIdBox.Text:gsub("%s","")
        if idStr == "" then setStatus("ID tidak valid", C_YELLOW); return end
        setStatus("Inserting audio "..idStr.."...", C_BLUE)
        doInsert(idStr, "Audio:"..idStr, audioInsBtn)
    end)
    audioIdBox.FocusLost:Connect(function(enter)
        if enter then
            local idStr = audioIdBox.Text:gsub("%s","")
            if idStr ~= "" then
                setStatus("Inserting audio "..idStr.."...", C_BLUE)
                doInsert(idStr, "Audio:"..idStr, audioInsBtn)
            end
        end
    end)

    -- Status label
    local searchStatus = Instance.new("TextLabel", Content)
    searchStatus.Size                   = UDim2.new(1,0,0,14)
    searchStatus.BackgroundTransparency = 1
    searchStatus.Text                   = "✦ Featured — ketik untuk search"
    searchStatus.TextColor3             = Color3.fromRGB(160,160,160)
    searchStatus.TextSize               = 9
    searchStatus.Font                   = Enum.Font.Gotham
    searchStatus.TextXAlignment         = Enum.TextXAlignment.Center
    searchStatus.LayoutOrder            = 2
    searchStatus.ZIndex                 = 12

    -- Featured
    local FEATURED = {
        { id=130733795, name="Low Poly Tree",  creatorName="Roblox", assetType="Model" },
        { id=1090261,   name="Starter House",  creatorName="Roblox", assetType="Model" },
        { id=31292970,  name="Sword Fight IV", creatorName="Roblox", assetType="Model" },
        { id=174067585, name="TNT",            creatorName="Roblox", assetType="Model" },
    }
    local FEATURED_DECALS = {
        { id=36281116, name="Smile",         creatorName="Roblox", assetType="Decal" },
        { id=68411614, name="Stone Texture", creatorName="Roblox", assetType="Decal" },
    }

    local function clearCards()
        for _, v in ipairs(Content:GetChildren()) do
            if v.Name=="Card" or v.Name=="LoadMore" then v:Destroy() end
        end
    end

    local function showFeatured(mode)
        clearCards()
        local list = (mode=="Decal") and FEATURED_DECALS or FEATURED
        searchStatus.Text       = "✦ Featured — ketik untuk search"
        searchStatus.TextColor3 = Color3.fromRGB(160,160,160)
        local co = 10
        for _, item in ipairs(list) do resultCard(item, co); co=co+1 end
    end

    local function renderResults(items, hasMore, nextPage, keyword)
        clearCards()
        if #items == 0 then
            searchStatus.Text       = "Tidak ada hasil: "..tostring(keyword)
            searchStatus.TextColor3 = C_YELLOW; return
        end
        searchStatus.Text       = tostring(#items).." hasil:"
        searchStatus.TextColor3 = Color3.fromRGB(160,160,160)
        local co = 10
        for _, item in ipairs(items) do resultCard(item, co); co=co+1 end
        if hasMore then
            local lmBtn = Instance.new("TextButton", Content)
            lmBtn.Name             = "LoadMore"
            lmBtn.Size             = UDim2.new(1,0,0,28)
            lmBtn.BackgroundColor3 = Color3.fromRGB(48,48,48)
            lmBtn.Text             = "Load more..."
            lmBtn.TextColor3       = C_BLUE
            lmBtn.TextSize         = 10
            lmBtn.Font             = Enum.Font.GothamBold
            lmBtn.ZIndex           = 12
            lmBtn.LayoutOrder      = co+1
            Instance.new("UICorner", lmBtn).CornerRadius = UDim.new(0,6)
            lmBtn.MouseButton1Click:Connect(function()
                lmBtn:Destroy()
                setStatus("Loading page "..tostring(nextPage).."...", C_BLUE)
                task.spawn(function()
                    local r = doSearch3(selMode, keyword, nextPage)
                    if r.success then renderResults(r.items, r.hasMore, r.nextPage, keyword)
                    else setStatus("Error: "..tostring(r.error), C_YELLOW) end
                end)
            end)
        end
    end

    local function doSearch()
        local kw = SearchBox.Text:match("^%s*(.-)%s*$")
        clearCards()
        audioPanel.Visible    = (selMode=="Audio")
        audioPanel.LayoutOrder = 3
        if selMode == "Audio" then
            searchStatus.Text       = "🎵 Masukkan Asset ID audio di bawah"
            searchStatus.TextColor3 = Color3.fromRGB(160,160,160)
            setStatus("Mode Audio: input ID manual", C_YELLOW); return
        end
        if kw == "" then showFeatured(selMode); return end
        searchStatus.Text       = "⏳ Searching "..selMode..": "..kw.."..."
        searchStatus.TextColor3 = C_BLUE
        setStatus("Searching...", C_BLUE)
        task.spawn(function()
            local r = doSearch3(selMode, kw, 0)
            if r.success then
                renderResults(r.items, r.hasMore, r.nextPage, kw)
                setStatus(#r.items.." "..selMode.." results", C_GREEN)
            else
                searchStatus.Text       = "❌ "..tostring(r.error)
                searchStatus.TextColor3 = C_YELLOW
                setStatus("Error: "..tostring(r.error), C_YELLOW)
            end
        end)
    end

    SearchBtn.MouseButton1Click:Connect(doSearch)
    SearchBox.FocusLost:Connect(function(enter) if enter then doSearch() end end)
    for m, cb in pairs(catBtns) do
        cb.MouseButton1Click:Connect(function() selectCat(m); doSearch() end)
    end

    task.defer(function() showFeatured("Model") end)

    -- ── Collapse / Expand ──
    local collapsed = false
    local function toggleCollapse()
        collapsed = not collapsed
        if collapsed then
            Content.Visible=false; SearchBar.Visible=false; CatBar.Visible=false
            TitleLine.Visible=false; StatusBar.Visible=false
            Panel.Size=UDim2.new(0,PANEL_W,0,36); CollapseBtn.Text="▼"
        else
            Content.Visible=true; SearchBar.Visible=true; CatBar.Visible=true
            TitleLine.Visible=true; StatusBar.Visible=true
            Panel.Size=UDim2.new(0,PANEL_W,0,PANEL_H); CollapseBtn.Text="▲"
        end
    end
    CollapseBtn.MouseButton1Click:Connect(toggleCollapse)

    -- ── Drag ──
    local dragging,dragStart,panelStartX,panelStartY=false,Vector2.new(0,0),0,0
    TitleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType~=Enum.UserInputType.MouseButton1
            and inp.UserInputType~=Enum.UserInputType.Touch then return end
        dragging=true; dragStart=Vector2.new(inp.Position.X,inp.Position.Y)
        Panel.AnchorPoint=Vector2.new(0,0)
        -- Pakai offset dari Position langsung, bukan AbsolutePosition
        -- AbsolutePosition menyertakan GUI inset sehingga panel melompat saat drag
        panelStartX=Panel.Position.X.Offset; panelStartY=Panel.Position.Y.Offset
    end)
    TitleBar.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType~=Enum.UserInputType.MouseMovement
            and inp.UserInputType~=Enum.UserInputType.Touch then return end
        local vx,vy=workspace.CurrentCamera.ViewportSize.X,workspace.CurrentCamera.ViewportSize.Y
        local nx=math.clamp(panelStartX+(inp.Position.X-dragStart.X),0,vx-PANEL_W)
        local ny=math.clamp(panelStartY+(inp.Position.Y-dragStart.Y),0,vy-40)
        Panel.Position=UDim2.new(0,nx,0,ny)
    end)
    TitleBar.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1
            or inp.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)

    setStatus("Ready — Toolbox PC aktif ✓")
end

-- ── Icon tombol (grid 3×3 + titik tengah hijau) ──
local ACC3B = Color3.fromRGB(80, 140, 255)
local OK3B  = Color3.fromRGB(60, 200, 100)
local function icoToolboxPC(p,S,T)
    local m=3; local g=2; local cz=math.floor((S-m*g-g)/m)
    for ro=0,m-1 do for co=0,m-1 do
        local x=g+(co*(cz+g)); local y=g+(ro*(cz+g))
        drawSeg3(p,x,y,x+cz,y,T,ACC3B,46)
        drawSeg3(p,x+cz,y,x+cz,y+cz,T,ACC3B,46)
        drawSeg3(p,x+cz,y+cz,x,y+cz,T,ACC3B,46)
        drawSeg3(p,x,y+cz,x,y,T,ACC3B,46)
        local mx=x+math.floor(cz/2); local my=y+math.floor(cz/2)
        drawSeg3(p,mx,my,mx,my,T,OK3B,49)
    end end
end

-- ── Inject tombol ke toolbar ──
local tbxPCDoneFlag = false
local function injectToolboxPC()
    if tbxPCDoneFlag then return end
    local tb=findTB3(); if not tb then return end
    if tb:FindFirstChild(PFX3.."Btn_ToolboxPC") then tbxPCDoneFlag=true; return end

    local posX=getMaxX3(tb)+16; makeSep3(tb,posX-12)
    makeBtn3(tb,posX,"Toolbox PC",icoToolboxPC,function()
        local panel = _SL.toolboxPCPanel
        if not panel then
            -- Panel belum dibangun, build sekarang
            pcall(buildToolboxPCPanel)
            panel = _SL.toolboxPCPanel
        end
        if panel then
            tbxPCVisible = not tbxPCVisible
            panel.Visible = tbxPCVisible
        end
    end)

    -- Build panel di background tapi langsung hidden
    task.spawn(function()
        local ok, err = pcall(buildToolboxPCPanel)
        if not ok then warn("[ToolboxPC] buildPanel error: "..tostring(err)) end
    end)

    tbxPCDoneFlag=true
end

_SL.injectToolboxPC=injectToolboxPC
end -- end _sl_toolboxPC

_sl_toolboxPC()


local function _sl_block3()
local injectTerrain,injectPlugin,injectToolbox=_SL.injectTerrain,_SL.injectPlugin,_SL.injectToolbox
local injectToolboxPC=_SL.injectToolboxPC
local injectNativeReplace=_SL.injectNativeReplace
local terrainDone,pluginDone,toolboxDone=false,false,false
local toolboxPCDone=false
local voiceDone=false
local LP,StudioGui,Workspace,applyHover,applyHoverAll,decoratePanels,injectParts,insertPart,partDone,startThemeWatcher,styleScrollbars,themeAll,themeObj=_SL.LP,_SL.StudioGui,_SL.Workspace,_SL.applyHover,_SL.applyHoverAll,_SL.decoratePanels,_SL.injectParts,_SL.insertPart,_SL.partDone,_SL.startThemeWatcher,_SL.styleScrollbars,_SL.themeAll,_SL.themeObj
local startSnapPopupWatcher=_SL.startSnapPopupWatcher
local RunService=game:GetService("RunService")
-- ══════════════════════════════════════════════
--  WATCHER & KEEPALIVE
-- ══════════════════════════════════════════════
local USER_PANELS={
    output=true,outputpanel=true,explorer=true,explorerpanel=true,
    properties=true,propertiespanel=true,
    dockbottom=true,dockleft=true,dockright=true
}
local function keepAlive() pcall(function() StudioGui.Enabled=true end) end
local function watchChild(obj)
    pcall(function()
        if obj:IsA("ScreenGui") and not USER_PANELS[obj.Name:lower()] then
            obj:GetPropertyChangedSignal("Enabled"):Connect(function()
                if not obj.Enabled then
                    task.defer(function() pcall(function() obj.Enabled=true end) end)
                end
            end)
        end
    end)
end
local function startWatcher()
    for _,obj in ipairs(StudioGui:GetChildren()) do pcall(watchChild,obj) end
    StudioGui.ChildAdded:Connect(function(ch)
        task.defer(function() pcall(watchChild,ch) end)
    end)
    task.spawn(function()
        while true do
            task.wait(8)
            pcall(keepAlive); pcall(decoratePanels); pcall(styleScrollbars)
            pcall(injectNativeReplace) -- pastikan icon tetap terjaga
            pcall(injectMenubarTakeover) -- retry menubar kalau load terlambat
        end
    end)
end
local function startPeriodicRefresh()
    task.spawn(function()
        while true do
            task.wait(4)
            pcall(themeAll); pcall(decoratePanels)
            pcall(applyHoverAll); pcall(styleScrollbars)
        end
    end)
end

-- ══════════════════════════════════════════════
--  OPEN/SAVE PREMIUM PANEL v4.0
--  Menerima items = tabel frame "Game1","Game2"
--  yang sudah diisi server dari OSF asli.
-- ══════════════════════════════════════════════
local _osPanelSG = nil


-- ══════════════════════════════════════════════════════════════════════════
--  SL_doSavePanel — Replikasi penuh SaveDetailsClickLocal dari CopyMap
--  Dipanggil saat user klik Save (slot) atau Save As New dari OSPanel
--
--  KENAPA ini diperlukan:
--  SaveDetailsClickLocal.v_u_8 = require(script.Parent.Parent.Parent
--      .CloneLocalWorkspaceToReplicatedStorageModule)
--  → Dijalankan saat GAME START, saat SaveDetailsFrame masih di Game10
--  → script.Parent.Parent.Parent = OpenSamplesMenu (BUKAN StudioGui)
--  → require(nil) → v_u_8 = nil → SaveButton selalu gagal silent
--
--  SOLUSI: V5 require module sendiri via StudioGui (path benar),
--  tampilkan form premium, dan handle InvokeServer("Save",...) sendiri.
--
--  slotNum = "" (Save As New) atau "5" (overwrite slot 5)
--  initName, initDesc, initPublished = data dari slot yang dipilih
-- ══════════════════════════════════════════════════════════════════════════
local _savePanelSG = nil
local _saveInProgress = false


-- ══════════════════════════════════════════════════════════════════════════
--  SL_doPublishPanel — Panel Publish Premium V5
--  Dipanggil setelah save berhasil dengan isPub=true
--
--  Replikasi PublishFrame bawaan CopyMap:
--  • Dropdown "Publish to": Your Profile / Group / Private
--  • Replace: pilih game dari list (GetPlacesServerFunction)
--  • ApiKey: input teks
--  • Tombol Publish → InvokeServer("Publish","use saved table",name,desc,isPub,uid,pid,key)
--
--  v28 = apiKey (string dari server, bisa nil)
--  v29 = {data=[{name,description,id,rootPlace={id}},...]} (bisa nil)
-- ══════════════════════════════════════════════════════════════════════════
local _publishPanelSG = nil


-- ══════════════════════════════════════════════════════════════════════════
--  SL_addDrag — Tambahkan drag support ke panel via header
--  Dipanggil setelah panel dan header dibuat
--  header = Frame yang jadi handle drag
--  panel  = Frame yang digeser
-- ══════════════════════════════════════════════════════════════════════════
local function SL_addDrag(header, panel)
    local UIS2 = game:GetService("UserInputService")
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = inp.Position
            startPos  = panel.Position
        end
    end)
    header.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS2.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or
                         inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - dragStart
            panel.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    -- Cursor hint
    header.MouseEnter:Connect(function()
        pcall(function() header.Cursor = "sizeall" end)
    end)
end

-- ══════════════════════════════════════════════════════════════════════════
--  SL_doVoicePanel — Voice Chat Toggle Panel v2.0
--  ✦ Auto-load API Key dari /storage/emulated/0/Delta/Workspace/apy key.txt
--  ✦ Tampilan rapi, API key tidak overflow keluar panel
--  ✦ Pengecekan akurat ON/OFF via Open Cloud v2
--  ✦ Enable + Disable voice support
--  ✦ Ukuran: 310×370, drag support, pakai palette C V5
-- ══════════════════════════════════════════════════════════════════════════
local _voicePanelSG = nil

local function SL_doVoicePanel()
    if _voicePanelSG then pcall(function() _voicePanelSG:Destroy() end) end
    _voicePanelSG = nil

    local LP      = game:GetService("Players").LocalPlayer
    local HttpSvc = game:GetService("HttpService")
    local RepStor = game:GetService("ReplicatedStorage")

    local slFolder   = RepStor:FindFirstChild("StudioLiteFolder")
    local GetPlaceRF = slFolder and slFolder:FindFirstChild("GetPlacesServerFunction")

    local st = {
        loading      = false,
        voiceEnabled = nil,
        apiKey       = "",
        universeId   = "",
        placeId      = "",
    }

    local function httpReq(opts)
        local method  = opts.Method or "GET"
        local headers = opts.Headers or {}
        local body    = (opts.Body ~= nil and tostring(opts.Body) ~= "") and tostring(opts.Body) or nil
        if syn and syn.request then
            local payload = {Url=opts.Url, Method=method, Headers=headers, Body=body or ""}
            local ok, r = pcall(syn.request, payload)
            if ok and r then return r end
        end
        if http and http.request then
            local payload = {Url=opts.Url, Method=method, Headers=headers, Body=body or ""}
            local ok, r = pcall(http.request, payload)
            if ok and r then return r end
        end
        if request then
            local payload = {Url=opts.Url, Method=method, Headers=headers, Body=body or ""}
            local ok, r = pcall(request, payload)
            if ok and r then return r end
        end
        local ok, r = pcall(function()
            local payload = {Url=opts.Url, Method=method, Headers=headers}
            if body then payload.Body = body end
            return HttpSvc:RequestAsync(payload)
        end)
        return ok and r or {StatusCode=0, Body=tostring(r)}
    end

    local function injectVoiceServerHandler()
        local slFolder2 = RepStor:FindFirstChild("StudioLiteFolder")
        if not slFolder2 then return false end
        local SF = slFolder2:FindFirstChild("ServerFunctions")
        if not SF then return false end
        local injected = false
        pcall(function()
            local SSS = game:GetService("ServerScriptService")
            if SSS:FindFirstChild("SL_VoiceHandler") then injected = true; return end
            local sc = Instance.new("Script")
            sc.Name = "SL_VoiceHandler"
            sc.Source = [[
local RS = game:GetService("ReplicatedStorage")
local SF = RS:WaitForChild("StudioLiteFolder",10):WaitForChild("ServerFunctions",10)
local Http = game:GetService("HttpService")
task.wait(0.5)
local _orig = SF.OnServerInvoke
SF.OnServerInvoke = function(player, cmd, ...)
    if cmd == "VoiceToggle" then
        local apiKey, uId, pId, enable = ...
        local boolStr = enable and "true" or "false"
        local hdrs = {["x-api-key"]=apiKey,["Content-Type"]="application/json",["Accept"]="application/json"}
        local okB, rB = false, {StatusCode=0}
        if pId and pId ~= "" then
            local urlPl  = ("https://apis.roblox.com/cloud/v2/universes/%s/places/%s?updateMask=voiceChatEnabled"):format(uId, pId)
            local bodyPl = ('{"voiceChatEnabled":%s}'):format(boolStr)
            local ok1, r1 = pcall(function() return Http:RequestAsync({Url=urlPl, Method="PATCH", Headers=hdrs, Body=bodyPl}) end)
            if ok1 and r1 and (r1.StatusCode==200 or r1.StatusCode==204) then
                okB = true; rB = r1
            else
                local urlPl2  = ("https://apis.roblox.com/cloud/v2/universes/%s/places/%s?updateMask=spatialVoiceEnabled"):format(uId, pId)
                local bodyPl2 = ('{"spatialVoiceEnabled":%s}'):format(boolStr)
                local ok2, r2 = pcall(function() return Http:RequestAsync({Url=urlPl2, Method="PATCH", Headers=hdrs, Body=bodyPl2}) end)
                if ok2 and r2 then okB = (r2.StatusCode==200 or r2.StatusCode==204); rB = r2 end
            end
        end
        local okA, rA = false, {StatusCode=0}
        local urlUni  = ("https://apis.roblox.com/cloud/v2/universes/%s?updateMask=spatialVoiceEnabled"):format(uId)
        local bodyUni = ('{"spatialVoiceEnabled":%s}'):format(boolStr)
        local ok3, r3 = pcall(function() return Http:RequestAsync({Url=urlUni, Method="PATCH", Headers=hdrs, Body=bodyUni}) end)
        if ok3 and r3 and (r3.StatusCode==200 or r3.StatusCode==204) then
            okA = true; rA = r3
        else
            local urlUni2  = ("https://apis.roblox.com/cloud/v2/universes/%s?updateMask=voiceChatEnabled"):format(uId)
            local bodyUni2 = ('{"voiceChatEnabled":%s}'):format(boolStr)
            local ok4, r4 = pcall(function() return Http:RequestAsync({Url=urlUni2, Method="PATCH", Headers=hdrs, Body=bodyUni2}) end)
            if ok4 and r4 then okA = (r4.StatusCode==200 or r4.StatusCode==204); rA = r4 end
        end
        return (rA and rA.StatusCode or 0), (rB and rB.StatusCode or 0)
    end
    if type(_orig)=="function" then return _orig(player, cmd, ...) end
end]]
            sc.Parent = SSS
            injected = true
        end)
        return injected
    end

    local function decodeErr(r)
        if not r then return "no response" end
        local b = tostring(r.Body or ""):sub(1,80)
        local ok, d = pcall(HttpSvc.JSONDecode, HttpSvc, r.Body or "")
        if ok and type(d)=="table" then
            return d.message or d.error or (d.errors and d.errors[1] and d.errors[1].message) or b
        end
        return b
    end

    local function getVoiceStatus(apiKey, uId, pId)
        local getHeaders = {["x-api-key"]=apiKey, ["Accept"]="application/json"}
        local function doGet(url)
            local fn = (syn and syn.request) or (http and http.request) or (type(request)=="function" and request) or nil
            if fn then
                local ok, r = pcall(fn, {Url=url, Method="GET", Headers=getHeaders})
                if ok and r and r.StatusCode == 200 then return r end
            end
            local ok2, r2 = pcall(function() return HttpSvc:RequestAsync({Url=url, Method="GET", Headers=getHeaders}) end)
            if ok2 and r2 then return r2 end
            return {StatusCode=0, Body=""}
        end
        if pId and pId ~= "" then
            local urlP = ("https://apis.roblox.com/cloud/v2/universes/%s/places/%s"):format(uId, pId)
            local rP = doGet(urlP)
            if rP.StatusCode == 200 then
                local ok, d = pcall(HttpSvc.JSONDecode, HttpSvc, rP.Body)
                if ok and d then return true, d.voiceChatEnabled == true, d end
            end
        end
        local url = ("https://apis.roblox.com/cloud/v2/universes/%s"):format(uId)
        local r = doGet(url)
        if r.StatusCode == 200 then
            local ok, d = pcall(HttpSvc.JSONDecode, HttpSvc, r.Body)
            if ok and d then return true, d.spatialVoiceEnabled == true or d.voiceChatEnabled == true, d end
        end
        return false, false, ("HTTP %d: %s"):format(r.StatusCode, decodeErr(r))
    end

    local function doPatch(url, body, hdrs)
        local fn = (syn and syn.request) or (http and http.request) or (type(request)=="function" and request) or nil
        if fn then
            local ok, r = pcall(fn, {Url=url, Method="PATCH", Headers=hdrs, Body=body})
            if ok and r and (r.StatusCode==200 or r.StatusCode==204) then return true, r end
        end
        local ok2, r2 = pcall(function() return HttpSvc:RequestAsync({Url=url, Method="PATCH", Headers=hdrs, Body=body}) end)
        if ok2 and r2 then return (r2.StatusCode==200 or r2.StatusCode==204), r2 end
        return false, {StatusCode=0, Body="HttpService gagal"}
    end

    local function setVoice(apiKey, uId, pId, enable)
        local boolStr = enable and "true" or "false"
        local hdrs = {["x-api-key"]=apiKey, ["Content-Type"]="application/json", ["Accept"]="application/json"}
        local okA, rA = false, {StatusCode=0}
        local okB, rB = false, {StatusCode=0}
        if pId and pId ~= "" then
            local urlPl  = ("https://apis.roblox.com/cloud/v2/universes/%s/places/%s?updateMask=voiceChatEnabled"):format(uId, pId)
            local bodyPl = ('{"voiceChatEnabled":%s}'):format(boolStr)
            okB, rB = doPatch(urlPl, bodyPl, hdrs)
            if not okB then
                local urlPl2  = ("https://apis.roblox.com/cloud/v2/universes/%s/places/%s?updateMask=spatialVoiceEnabled"):format(uId, pId)
                local bodyPl2 = ('{"spatialVoiceEnabled":%s}'):format(boolStr)
                okB, rB = doPatch(urlPl2, bodyPl2, hdrs)
            end
        end
        local urlUni  = ("https://apis.roblox.com/cloud/v2/universes/%s?updateMask=spatialVoiceEnabled"):format(uId)
        local bodyUni = ('{"spatialVoiceEnabled":%s}'):format(boolStr)
        okA, rA = doPatch(urlUni, bodyUni, hdrs)
        if not okA then
            local urlUni2  = ("https://apis.roblox.com/cloud/v2/universes/%s?updateMask=voiceChatEnabled"):format(uId)
            local bodyUni2 = ('{"voiceChatEnabled":%s}'):format(boolStr)
            okA, rA = doPatch(urlUni2, bodyUni2, hdrs)
        end
        if not okB and not okA then
            local slF2 = RepStor:FindFirstChild("StudioLiteFolder")
            local SF = slF2 and slF2:FindFirstChild("ServerFunctions")
            if SF then
                injectVoiceServerHandler()
                task.wait(0.3)
                pcall(function() SF:InvokeServer("VoiceToggle", apiKey, uId, pId, enable) end)
            end
        end
        if okB then return true end
        if okA then return true end
        local errDetail = (rB and rB.StatusCode ~= 0 and ("Place HTTP "..rB.StatusCode..": "..decodeErr(rB)))
                       or (rA and rA.StatusCode ~= 0 and ("Universe HTTP "..rA.StatusCode..": "..decodeErr(rA)))
                       or "Semua metode PATCH gagal — cek API Key dan Universe/Place ID"
        return false, errDetail
    end

    local function slWarn(msg, dur)
        pcall(function()
            local wt = LP.PlayerGui:WaitForChild("StudioGui",3):FindFirstChild("WarningText")
            if wt then wt.Text=msg; wt.Visible=true
                if dur then task.delay(dur, function() wt.Visible=false end) end
            end
        end)
    end

    local DELTA_API_PATHS = {
        "/storage/emulated/0/Delta/Workspace/apy key.txt",
        "/storage/emulated/0/Delta/Workspace/api key.txt",
        "/storage/emulated/0/Delta/Workspace/apikey.txt",
        "/storage/emulated/0/Delta/Workspace/API KEY VOICE/apy key.txt",
        "/storage/emulated/0/Delta/Workspace/API KEY VOICE/api key.txt",
    }
    local function readDeltaApiKey()
        if type(readfile) == "function" then
            for _, path in ipairs(DELTA_API_PATHS) do
                local ok, content = pcall(readfile, path)
                if ok and content and #content > 10 then
                    local key = content:match("^%s*(.-)%s*$")
                    if key and #key > 10 then return key, path end
                end
            end
        end
        if type(isfile) == "function" and type(readfile) == "function" then
            for _, path in ipairs(DELTA_API_PATHS) do
                local ok1, exists = pcall(isfile, path)
                if ok1 and exists then
                    local ok2, content = pcall(readfile, path)
                    if ok2 and content and #content > 10 then
                        local key = content:match("^%s*(.-)%s*$")
                        if key and #key > 10 then return key, path end
                    end
                end
            end
        end
        return nil, nil
    end

    -- ── BUILD UI ──────────────────────────────────────────────────────────
    local sg = Instance.new("ScreenGui")
    sg.Name = PFX.."VoicePanel"; sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 230; sg.Enabled = true
    sg.Parent = LP:WaitForChild("PlayerGui")
    _voicePanelSG = sg

    local PW5, PH5 = 300, 394
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, PW5, 0, PH5)
    panel.Position = UDim2.new(0.5, -PW5/2, 0.5, -PH5/2)
    panel.BackgroundColor3 = C.bg1; panel.BorderSizePixel = 0
    panel.ZIndex = 11; panel.ClipsDescendants = true; panel.Parent = sg
    do
        local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0,12); u.Parent = panel
        local s = Instance.new("UIStroke"); s.Color = C.accB; s.Thickness = 1.5; s.Parent = panel
    end

    -- ─── Vector icon helpers ──────────────────────────────────────────────
    local function mkIcoMic(parent, cx, cy, S, Z)
        local body = Instance.new("Frame")
        body.Size = UDim2.new(0, S*0.44, 0, S*0.54)
        body.Position = UDim2.new(0, cx - S*0.22, 0, cy - S*0.34)
        body.BackgroundColor3 = C.accA; body.BorderSizePixel = 0; body.ZIndex = Z or 14
        body.Parent = parent
        do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0.5, 0); u.Parent = body end
        local arc = Instance.new("Frame")
        arc.Size = UDim2.new(0, S*0.62, 0, S*0.34)
        arc.Position = UDim2.new(0, cx - S*0.31, 0, cy - S*0.06)
        arc.BackgroundColor3 = Color3.new(0,0,0); arc.BackgroundTransparency = 1
        arc.BorderSizePixel = 0; arc.ZIndex = (Z or 14)+1; arc.Parent = parent
        do
            local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0.5, 0); u.Parent = arc
            local s = Instance.new("UIStroke"); s.Color = C.accA; s.Thickness = 2; s.Parent = arc
        end
        local stand = Instance.new("Frame")
        stand.Size = UDim2.new(0, 2, 0, S*0.18)
        stand.Position = UDim2.new(0, cx - 1, 0, cy + S*0.26)
        stand.BackgroundColor3 = C.accA; stand.BorderSizePixel = 0; stand.ZIndex = Z or 14
        stand.Parent = parent
        local base = Instance.new("Frame")
        base.Size = UDim2.new(0, S*0.40, 0, 2)
        base.Position = UDim2.new(0, cx - S*0.20, 0, cy + S*0.42)
        base.BackgroundColor3 = C.accA; base.BorderSizePixel = 0; base.ZIndex = Z or 14
        base.Parent = parent
        do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = base end
    end

    local function mkIcoCheck(parent, cx, cy, S, col, Z)
        local function seg(x1,y1,w,h,rot)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(0, w, 0, h)
            f.Position = UDim2.new(0, x1, 0, y1)
            f.BackgroundColor3 = col or C.green; f.BorderSizePixel = 0; f.Rotation = rot or 0
            f.ZIndex = Z or 14; f.Parent = parent
            do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = f end
        end
        seg(cx - S*0.28, cy + S*0.02, 2, S*0.22, 45)
        seg(cx - S*0.12, cy + S*0.14, 2, S*0.38, -45)
    end

    local function mkIcoX(parent, cx, cy, S, col, Z)
        local function seg(rot)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(0, 2, 0, S*0.50)
            f.Position = UDim2.new(0, cx - 1, 0, cy - S*0.25)
            f.BackgroundColor3 = col or C.red; f.BorderSizePixel = 0; f.Rotation = rot
            f.ZIndex = Z or 14; f.Parent = parent
            do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = f end
        end
        seg(45); seg(-45)
    end

    local function mkIcoWifi(parent, cx, cy, S, col, Z)
        for i = 1, 3 do
            local r = S * (0.12 + i*0.13)
            local arc2 = Instance.new("Frame")
            arc2.Size = UDim2.new(0, r*2, 0, r*2)
            arc2.Position = UDim2.new(0, cx - r, 0, cy - r*0.2)
            arc2.BackgroundColor3 = Color3.new(0,0,0); arc2.BackgroundTransparency = 1
            arc2.BorderSizePixel = 0; arc2.ZIndex = (Z or 14)+i; arc2.ClipsDescendants = false
            arc2.Parent = parent
            do
                local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0.5,0); u.Parent = arc2
                local st2 = Instance.new("UIStroke"); st2.Color = col or C.accA; st2.Thickness = 2; st2.Parent = arc2
            end
            local mask = Instance.new("Frame")
            mask.Size = UDim2.new(1, 4, 0.55, 2); mask.Position = UDim2.new(-0.02, 0, 0.48, 0)
            mask.BackgroundColor3 = C.bg1; mask.BorderSizePixel = 0; mask.ZIndex = (Z or 14)+i+1
            mask.Parent = arc2
        end
        local dot2 = Instance.new("Frame")
        dot2.Size = UDim2.new(0, 4, 0, 4); dot2.Position = UDim2.new(0, cx - 2, 0, cy + S*0.22)
        dot2.BackgroundColor3 = col or C.accA; dot2.BorderSizePixel = 0; dot2.ZIndex = (Z or 14)+4
        dot2.Parent = parent
        do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = dot2 end
    end

    local function mkIcoSearch(parent, cx, cy, S, col, Z)
        local circ = Instance.new("Frame")
        circ.Size = UDim2.new(0, S*0.44, 0, S*0.44)
        circ.Position = UDim2.new(0, cx - S*0.28, 0, cy - S*0.26)
        circ.BackgroundColor3 = Color3.new(0,0,0); circ.BackgroundTransparency = 1
        circ.BorderSizePixel = 0; circ.ZIndex = Z or 14; circ.Parent = parent
        do
            local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0.5,0); u.Parent = circ
            local st2 = Instance.new("UIStroke"); st2.Color = col or C.txtP; st2.Thickness = 2; st2.Parent = circ
        end
        local handle = Instance.new("Frame")
        handle.Size = UDim2.new(0, 2, 0, S*0.28)
        handle.Position = UDim2.new(0, cx + S*0.10, 0, cy + S*0.02)
        handle.BackgroundColor3 = col or C.txtP; handle.BorderSizePixel = 0
        handle.Rotation = -45; handle.ZIndex = (Z or 14)+1; handle.Parent = parent
        do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = handle end
    end

    -- ─── HEADER ──────────────────────────────────────────────────────────
    local hdr = Instance.new("Frame")
    hdr.Size = UDim2.new(1,0,0,44); hdr.BackgroundColor3 = C.bg0
    hdr.BorderSizePixel = 0; hdr.ZIndex = 12; hdr.Active = true; hdr.Parent = panel
    do
        local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0,12); u.Parent = hdr
        local ac = Instance.new("Frame"); ac.Size = UDim2.new(1,0,0,2); ac.Position = UDim2.new(0,0,1,-2)
        ac.BackgroundColor3 = C.accB; ac.BorderSizePixel = 0; ac.ZIndex = 13; ac.Parent = hdr
    end
    local hIcoF = Instance.new("Frame")
    hIcoF.Size = UDim2.new(0,26,0,26); hIcoF.Position = UDim2.new(0,10,0.5,-13)
    hIcoF.BackgroundTransparency = 1; hIcoF.ZIndex = 13; hIcoF.Parent = hdr
    mkIcoMic(hIcoF, 13, 12, 26, 14)
    local hTxt = Instance.new("TextLabel")
    hTxt.Size = UDim2.new(1,-90,1,0); hTxt.Position = UDim2.new(0,42,0,0)
    hTxt.BackgroundTransparency = 1; hTxt.Text = "Voice Chat Toggle"
    hTxt.TextColor3 = C.txtP; hTxt.Font = Enum.Font.GothamBold; hTxt.TextSize = 13
    hTxt.TextXAlignment = Enum.TextXAlignment.Left
    hTxt.TextYAlignment = Enum.TextYAlignment.Center; hTxt.ZIndex = 14; hTxt.Parent = hdr
    local badge = Instance.new("Frame")
    badge.Size = UDim2.new(0,22,0,14); badge.Position = UDim2.new(1,-60,0.5,-7)
    badge.BackgroundColor3 = C.accB; badge.BorderSizePixel = 0; badge.ZIndex = 14; badge.Parent = hdr
    do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0,3); u.Parent = badge end
    local badgeTxt = Instance.new("TextLabel")
    badgeTxt.Size = UDim2.new(1,0,1,0); badgeTxt.BackgroundTransparency = 1; badgeTxt.Text = "SL"
    badgeTxt.TextColor3 = Color3.new(1,1,1); badgeTxt.Font = Enum.Font.GothamBold
    badgeTxt.TextSize = 9; badgeTxt.ZIndex = 15; badgeTxt.Parent = badge
    local xBtn = Instance.new("TextButton")
    xBtn.Size = UDim2.new(0,28,0,26); xBtn.Position = UDim2.new(1,-34,0.5,-13)
    xBtn.BackgroundColor3 = C.red; xBtn.BackgroundTransparency = 0.2
    xBtn.BorderSizePixel = 0; xBtn.Text = ""; xBtn.AutoButtonColor = false; xBtn.ZIndex = 14; xBtn.Parent = hdr
    do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0,5); u.Parent = xBtn end
    mkIcoX(xBtn, 14, 13, 22, Color3.new(1,1,1), 15)
    SL_addDrag(hdr, panel)
    local function closeVP() pcall(function() sg:Destroy() end); _voicePanelSG = nil end
    xBtn.MouseButton1Click:Connect(closeVP)
    xBtn.MouseEnter:Connect(function() xBtn.BackgroundTransparency = 0 end)
    xBtn.MouseLeave:Connect(function() xBtn.BackgroundTransparency = 0.2 end)

    -- ─── SCROLL CONTENT ───────────────────────────────────────────────────
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,0,1,-44); scroll.Position = UDim2.new(0,0,0,44)
    scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = C.accB
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.ZIndex = 12; scroll.Parent = panel

    local CY = 10

    -- ─── API KEY STATUS BAR (tersembunyi) ────────────────────────────────
    local keyBar = Instance.new("Frame")
    keyBar.Size = UDim2.new(1,-20,0,34); keyBar.Position = UDim2.new(0,10,0,CY)
    keyBar.BackgroundColor3 = C.bg2; keyBar.BackgroundTransparency = 0
    keyBar.BorderSizePixel = 0; keyBar.ZIndex = 13; keyBar.Visible = false; keyBar.Parent = scroll
    do
        local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0,7); u.Parent = keyBar
        local s = Instance.new("UIStroke"); s.Color = C.bdrB; s.Thickness = 1; s.Transparency = 0.5; s.Parent = keyBar
    end
    local lockF = Instance.new("Frame")
    lockF.Size = UDim2.new(0,20,1,0); lockF.Position = UDim2.new(0,8,0,0)
    lockF.BackgroundTransparency = 1; lockF.ZIndex = 14; lockF.Parent = keyBar
    do
        local shk = Instance.new("Frame")
        shk.Size = UDim2.new(0,12,0,10); shk.Position = UDim2.new(0,4,0,3)
        shk.BackgroundTransparency = 1; shk.BorderSizePixel = 0; shk.ZIndex = 15; shk.Parent = lockF
        do
            local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0.5,0); u.Parent = shk
            local s = Instance.new("UIStroke"); s.Color = C.txtS; s.Thickness = 2; s.Parent = shk
        end
        local shkMask = Instance.new("Frame")
        shkMask.Size = UDim2.new(1,0,0.5,0); shkMask.Position = UDim2.new(0,0,0.5,0)
        shkMask.BackgroundColor3 = C.bg2; shkMask.BorderSizePixel = 0; shkMask.ZIndex = 16; shkMask.Parent = shk
        local body2 = Instance.new("Frame")
        body2.Size = UDim2.new(0,14,0,12); body2.Position = UDim2.new(0,3,0,10)
        body2.BackgroundColor3 = C.txtS; body2.BorderSizePixel = 0; body2.ZIndex = 15; body2.Parent = lockF
        do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0,3); u.Parent = body2 end
    end
    local keyStatusLbl = Instance.new("TextLabel")
    keyStatusLbl.Size = UDim2.new(1,-80,1,0); keyStatusLbl.Position = UDim2.new(0,32,0,0)
    keyStatusLbl.BackgroundTransparency = 1; keyStatusLbl.Text = "API KEY"
    keyStatusLbl.TextColor3 = C.txtS; keyStatusLbl.Font = Enum.Font.GothamBold; keyStatusLbl.TextSize = 10
    keyStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
    keyStatusLbl.TextYAlignment = Enum.TextYAlignment.Center; keyStatusLbl.ZIndex = 14; keyStatusLbl.Parent = keyBar
    local keyStatusRight = Instance.new("Frame")
    keyStatusRight.Size = UDim2.new(0,106,1,0); keyStatusRight.Position = UDim2.new(1,-108,0,0)
    keyStatusRight.BackgroundTransparency = 1; keyStatusRight.ZIndex = 14; keyStatusRight.Parent = keyBar
    local keyPill = Instance.new("Frame")
    keyPill.Size = UDim2.new(1,-4,0,22); keyPill.Position = UDim2.new(0,2,0.5,-11)
    keyPill.BackgroundColor3 = C.bg3; keyPill.BackgroundTransparency = 0.2
    keyPill.BorderSizePixel = 0; keyPill.ZIndex = 14; keyPill.Parent = keyStatusRight
    do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = keyPill end
    local keyIconF = Instance.new("Frame")
    keyIconF.Size = UDim2.new(0,16,0,16); keyIconF.Position = UDim2.new(0,6,0.5,-8)
    keyIconF.BackgroundTransparency = 1; keyIconF.ZIndex = 15; keyIconF.Parent = keyPill
    local keyIconCheck = Instance.new("Frame"); keyIconCheck.Size = UDim2.new(1,0,1,0)
    keyIconCheck.BackgroundTransparency = 1; keyIconCheck.ZIndex = 15; keyIconCheck.Visible = false; keyIconCheck.Parent = keyIconF
    mkIcoCheck(keyIconCheck, 8, 8, 16, C.green, 16)
    local keyIconX = Instance.new("Frame"); keyIconX.Size = UDim2.new(1,0,1,0)
    keyIconX.BackgroundTransparency = 1; keyIconX.ZIndex = 15; keyIconX.Parent = keyIconF
    mkIcoX(keyIconX, 8, 8, 14, C.txtD, 16)
    local keySrcTxt = Instance.new("TextLabel")
    keySrcTxt.Size = UDim2.new(1,-28,1,0); keySrcTxt.Position = UDim2.new(0,26,0,0)
    keySrcTxt.BackgroundTransparency = 1; keySrcTxt.Text = "Belum dimuat"
    keySrcTxt.TextColor3 = C.txtD; keySrcTxt.Font = Enum.Font.GothamBold; keySrcTxt.TextSize = 9
    keySrcTxt.TextXAlignment = Enum.TextXAlignment.Left
    keySrcTxt.TextYAlignment = Enum.TextYAlignment.Center; keySrcTxt.ZIndex = 15; keySrcTxt.Parent = keyPill
    local tbApiKey = Instance.new("TextBox")
    tbApiKey.Size = UDim2.new(0,1,0,1); tbApiKey.Position = UDim2.new(0,0,0,0)
    tbApiKey.BackgroundTransparency = 1; tbApiKey.TextTransparency = 1; tbApiKey.Text = ""
    tbApiKey.ZIndex = 1; tbApiKey.Visible = false; tbApiKey.Parent = scroll

    -- ─── UNIVERSE ID + PLACE ID (tersembunyi) ─────────────────────────────
    local lblRow = Instance.new("Frame")
    lblRow.Size = UDim2.new(1,-20,0,0); lblRow.Position = UDim2.new(0,10,0,CY)
    lblRow.BackgroundTransparency = 1; lblRow.ZIndex = 13; lblRow.Visible = false; lblRow.Parent = scroll

    local function mkIdBox(xPct, xOff, placeholder)
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(0.5,-14,0,0); bg.Position = UDim2.new(xPct, xOff, 0, CY)
        bg.BackgroundColor3 = C.bg3; bg.BorderSizePixel = 0; bg.ClipsDescendants = true
        bg.ZIndex = 13; bg.Visible = false; bg.Parent = scroll
        local tb = Instance.new("TextBox", bg)
        tb.Size = UDim2.new(1,-8,1,0); tb.Position = UDim2.new(0,4,0,0)
        tb.BackgroundTransparency = 1; tb.Text = ""; tb.PlaceholderText = placeholder
        tb.PlaceholderColor3 = C.txtD; tb.TextColor3 = C.txtP; tb.Font = Enum.Font.Code; tb.TextSize = 10
        tb.ClearTextOnFocus = false; tb.TextTruncate = Enum.TextTruncate.AtEnd; tb.ZIndex = 14
        return tb
    end
    local tbUni = mkIdBox(0, 10, "Universe ID")
    local tbPl  = mkIdBox(0.5, 4, "Place ID")

    -- ─── TOGGLE SLIDER BESAR ─────────────────────────────────────────────
    local isVoiceOn = false
    local togContainer = Instance.new("Frame")
    togContainer.Size = UDim2.new(1,-20,0,64); togContainer.Position = UDim2.new(0,10,0,CY)
    togContainer.BackgroundColor3 = C.bg2; togContainer.BackgroundTransparency = 0
    togContainer.BorderSizePixel = 0; togContainer.ZIndex = 13; togContainer.Parent = scroll
    do
        local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0,10); u.Parent = togContainer
        local s = Instance.new("UIStroke"); s.Color = C.bdrB; s.Thickness = 1; s.Transparency = 0.3; s.Parent = togContainer
    end
    local togLabel = Instance.new("TextLabel")
    togLabel.Size = UDim2.new(1,-80,1,0); togLabel.Position = UDim2.new(0,16,0,0)
    togLabel.BackgroundTransparency = 1; togLabel.Text = "Voice Chat"
    togLabel.TextColor3 = C.txtP; togLabel.Font = Enum.Font.GothamBold; togLabel.TextSize = 14
    togLabel.TextXAlignment = Enum.TextXAlignment.Left
    togLabel.TextYAlignment = Enum.TextYAlignment.Center; togLabel.ZIndex = 14; togLabel.Parent = togContainer
    local togSub = Instance.new("TextLabel")
    togSub.Size = UDim2.new(1,-80,0,13); togSub.Position = UDim2.new(0,16,1,-20)
    togSub.BackgroundTransparency = 1; togSub.Text = "Memuat..."
    togSub.TextColor3 = C.txtD; togSub.Font = Enum.Font.Gotham; togSub.TextSize = 9
    togSub.TextXAlignment = Enum.TextXAlignment.Left; togSub.ZIndex = 14; togSub.Parent = togContainer
    local togBg = Instance.new("Frame")
    togBg.Size = UDim2.new(0,58,0,30); togBg.Position = UDim2.new(1,-70,0.5,-15)
    togBg.BackgroundColor3 = C.bg4; togBg.BorderSizePixel = 0; togBg.ZIndex = 14; togBg.Parent = togContainer
    do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = togBg end
    local togKnob = Instance.new("Frame")
    togKnob.Size = UDim2.new(0,22,0,22); togKnob.Position = UDim2.new(0,4,0.5,-11)
    togKnob.BackgroundColor3 = Color3.new(1,1,1); togKnob.BorderSizePixel = 0; togKnob.ZIndex = 15; togKnob.Parent = togBg
    do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = togKnob end
    local togHit = Instance.new("TextButton")
    togHit.Size = UDim2.new(1,0,1,0); togHit.BackgroundTransparency = 1; togHit.Text = ""
    togHit.AutoButtonColor = false; togHit.ZIndex = 16; togHit.Parent = togBg
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0,8,0,8); dot.Position = UDim2.new(0,4,0.5,-4)
    dot.BackgroundColor3 = C.txtD; dot.BorderSizePixel = 0; dot.ZIndex = 14; dot.Parent = togContainer
    do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = dot end
    CY = CY + 74

    -- ─── TOMBOL CHECK ─────────────────────────────────────────────────────
    local checkBtn = Instance.new("TextButton")
    checkBtn.Size = UDim2.new(1,-20,0,32); checkBtn.Position = UDim2.new(0,10,0,CY)
    checkBtn.BackgroundColor3 = C.bg3; checkBtn.BackgroundTransparency = 0
    checkBtn.BorderSizePixel = 0; checkBtn.Text = ""; checkBtn.AutoButtonColor = false
    checkBtn.ZIndex = 13; checkBtn.Parent = scroll
    do
        local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0,7); u.Parent = checkBtn
        local s = Instance.new("UIStroke"); s.Color = C.bdrB; s.Thickness = 1; s.Transparency = 0.35; s.Parent = checkBtn
    end
    local chkIcoF = Instance.new("Frame")
    chkIcoF.Size = UDim2.new(0,20,0,20); chkIcoF.Position = UDim2.new(0,10,0.5,-10)
    chkIcoF.BackgroundTransparency = 1; chkIcoF.ZIndex = 14; chkIcoF.Parent = checkBtn
    mkIcoSearch(chkIcoF, 10, 10, 20, C.txtP, 14)
    local chkLbl = Instance.new("TextLabel")
    chkLbl.Size = UDim2.new(1,-36,1,0); chkLbl.Position = UDim2.new(0,34,0,0)
    chkLbl.BackgroundTransparency = 1; chkLbl.Text = "Cek Status Voice"
    chkLbl.TextColor3 = C.txtP; chkLbl.Font = Enum.Font.GothamBold; chkLbl.TextSize = 11
    chkLbl.TextXAlignment = Enum.TextXAlignment.Left
    chkLbl.TextYAlignment = Enum.TextYAlignment.Center; chkLbl.ZIndex = 14; chkLbl.Parent = checkBtn
    CY = CY + 38

    -- ─── DUA TOMBOL AKSI: ENABLE + DISABLE ──────────────────────────────
    local BHalf = (PW5 - 28) / 2
    local enBtn = Instance.new("TextButton")
    enBtn.Size = UDim2.new(0, BHalf, 0, 58); enBtn.Position = UDim2.new(0, 10, 0, CY)
    enBtn.BackgroundColor3 = C.bg2; enBtn.BackgroundTransparency = 0
    enBtn.BorderSizePixel = 0; enBtn.Text = ""; enBtn.AutoButtonColor = false; enBtn.ZIndex = 13; enBtn.Parent = scroll
    do
        local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0,10); u.Parent = enBtn
        local s = Instance.new("UIStroke"); s.Color = C.bdrB; s.Thickness = 1; s.Transparency = 0.4; s.Parent = enBtn
    end
    local enLbl2 = Instance.new("TextLabel")
    enLbl2.Size = UDim2.new(1,0,0,18); enLbl2.Position = UDim2.new(0,0,0,6)
    enLbl2.BackgroundTransparency = 1; enLbl2.Text = "Enable"
    enLbl2.TextColor3 = C.txtS; enLbl2.Font = Enum.Font.GothamBold; enLbl2.TextSize = 11
    enLbl2.TextXAlignment = Enum.TextXAlignment.Center; enLbl2.ZIndex = 14; enLbl2.Parent = enBtn
    local enTrack = Instance.new("Frame")
    enTrack.Size = UDim2.new(0,48,0,24); enTrack.Position = UDim2.new(0.5,-24,0,28)
    enTrack.BackgroundColor3 = C.bg4; enTrack.BorderSizePixel = 0; enTrack.ZIndex = 14; enTrack.Parent = enBtn
    do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = enTrack end
    local enKnob = Instance.new("Frame")
    enKnob.Size = UDim2.new(0,18,0,18); enKnob.BorderSizePixel = 0; enKnob.ZIndex = 15
    enKnob.BackgroundColor3 = Color3.new(1,1,1)
    enKnob.Position = UDim2.new(0,3,0.5,-9); enKnob.Parent = enTrack
    do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = enKnob end
    local disBtn = Instance.new("TextButton")
    disBtn.Size = UDim2.new(0, BHalf, 0, 58); disBtn.Position = UDim2.new(0, 14 + BHalf, 0, CY)
    disBtn.BackgroundColor3 = C.bg2; disBtn.BackgroundTransparency = 0
    disBtn.BorderSizePixel = 0; disBtn.Text = ""; disBtn.AutoButtonColor = false; disBtn.ZIndex = 13; disBtn.Parent = scroll
    do
        local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0,10); u.Parent = disBtn
        local s = Instance.new("UIStroke"); s.Color = C.bdrB; s.Thickness = 1; s.Transparency = 0.4; s.Parent = disBtn
    end
    local disLbl2 = Instance.new("TextLabel")
    disLbl2.Size = UDim2.new(1,0,0,18); disLbl2.Position = UDim2.new(0,0,0,6)
    disLbl2.BackgroundTransparency = 1; disLbl2.Text = "Disable"
    disLbl2.TextColor3 = C.txtS; disLbl2.Font = Enum.Font.GothamBold; disLbl2.TextSize = 11
    disLbl2.TextXAlignment = Enum.TextXAlignment.Center; disLbl2.ZIndex = 14; disLbl2.Parent = disBtn
    local disTrack = Instance.new("Frame")
    disTrack.Size = UDim2.new(0,48,0,24); disTrack.Position = UDim2.new(0.5,-24,0,28)
    disTrack.BackgroundColor3 = C.bg4; disTrack.BorderSizePixel = 0; disTrack.ZIndex = 14; disTrack.Parent = disBtn
    do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = disTrack end
    local disKnob = Instance.new("Frame")
    disKnob.Size = UDim2.new(0,18,0,18); disKnob.BorderSizePixel = 0; disKnob.ZIndex = 15
    disKnob.BackgroundColor3 = Color3.new(1,1,1)
    disKnob.Position = UDim2.new(0,3,0.5,-9); disKnob.Parent = disTrack
    do local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(1,0); u.Parent = disKnob end

    local function updateSliderUI(voiceOn)
        if voiceOn then
            enTrack.BackgroundColor3 = C.green; tw(enKnob, FAST, {Position = UDim2.new(1,-21,0.5,-9)})
            enLbl2.TextColor3 = C.green; enBtn.BackgroundColor3 = C.bg3
            local s = enBtn:FindFirstChildOfClass("UIStroke"); if s then s.Color = C.green; s.Transparency = 0.2 end
            disTrack.BackgroundColor3 = C.bg4; tw(disKnob, FAST, {Position = UDim2.new(0,3,0.5,-9)})
            disLbl2.TextColor3 = C.txtS; disBtn.BackgroundColor3 = C.bg2
            local s2 = disBtn:FindFirstChildOfClass("UIStroke"); if s2 then s2.Color = C.bdrB; s2.Transparency = 0.4 end
        else
            enTrack.BackgroundColor3 = C.bg4; tw(enKnob, FAST, {Position = UDim2.new(0,3,0.5,-9)})
            enLbl2.TextColor3 = C.txtS; enBtn.BackgroundColor3 = C.bg2
            local s = enBtn:FindFirstChildOfClass("UIStroke"); if s then s.Color = C.bdrB; s.Transparency = 0.4 end
            disTrack.BackgroundColor3 = C.red; tw(disKnob, FAST, {Position = UDim2.new(1,-21,0.5,-9)})
            disLbl2.TextColor3 = C.red; disBtn.BackgroundColor3 = C.bg3
            local s2 = disBtn:FindFirstChildOfClass("UIStroke"); if s2 then s2.Color = C.red; s2.Transparency = 0.2 end
        end
    end
    CY = CY + 66

    -- ─── LOG BOX ──────────────────────────────────────────────────────────
    local logBox = Instance.new("Frame")
    logBox.Size = UDim2.new(1,-20,0,64); logBox.Position = UDim2.new(0,10,0,CY)
    logBox.BackgroundColor3 = C.bg0; logBox.BackgroundTransparency = 0.1
    logBox.BorderSizePixel = 0; logBox.ClipsDescendants = true; logBox.ZIndex = 13; logBox.Parent = scroll
    do
        local u = Instance.new("UICorner"); u.CornerRadius = UDim.new(0,6); u.Parent = logBox
        local s = Instance.new("UIStroke"); s.Color = C.bdrB; s.Thickness = 1; s.Transparency = 0.4; s.Parent = logBox
    end
    local wifiF = Instance.new("Frame")
    wifiF.Size = UDim2.new(0,14,0,14); wifiF.Position = UDim2.new(0,5,0,4)
    wifiF.BackgroundTransparency = 1; wifiF.ZIndex = 14; wifiF.Parent = logBox
    mkIcoWifi(wifiF, 7, 7, 14, C.txtD, 14)
    local logTxt = Instance.new("TextLabel")
    logTxt.Size = UDim2.new(1,-24,1,-6); logTxt.Position = UDim2.new(0,20,0,3)
    logTxt.BackgroundTransparency = 1; logTxt.Text = "[ siap ]"
    logTxt.TextColor3 = C.txtD; logTxt.Font = Enum.Font.Code; logTxt.TextSize = 9
    logTxt.TextXAlignment = Enum.TextXAlignment.Left; logTxt.TextYAlignment = Enum.TextYAlignment.Top
    logTxt.TextWrapped = true; logTxt.ZIndex = 14; logTxt.Parent = logBox
    CY = CY + 70

    -- ─── Footer ───────────────────────────────────────────────────────────
    local ftxt = Instance.new("TextLabel")
    ftxt.Size = UDim2.new(1,-20,0,12); ftxt.Position = UDim2.new(0,10,0,CY)
    ftxt.BackgroundTransparency = 1; ftxt.Text = "Auto-load: Delta › Workspace › apy key.txt"
    ftxt.TextColor3 = C.txtD; ftxt.Font = Enum.Font.Gotham; ftxt.TextSize = 8
    ftxt.TextXAlignment = Enum.TextXAlignment.Center; ftxt.ZIndex = 13; ftxt.Parent = scroll

    -- ══════════════════════════════════════════════════════════════════════
    -- ── UI LOGIC ─────────────────────────────────────────────────────────
    local logLines = {}
    local function logMsg(msg, col)
        table.insert(logLines, 1, msg)
        if #logLines > 5 then table.remove(logLines) end
        logTxt.Text = table.concat(logLines, "\n")
        logTxt.TextColor3 = col or C.txtD
    end

    local function updateStatusUI(enabled)
        st.voiceEnabled = enabled; isVoiceOn = enabled
        pcall(function() updateSliderUI(enabled) end)
        if enabled then
            dot.BackgroundColor3 = C.green; togBg.BackgroundColor3 = C.green
            tw(togKnob, FAST, {Position = UDim2.new(1,-26,0.5,-11)})
            togLabel.Text = "Voice Chat"; togLabel.TextColor3 = C.txtP
            togSub.Text = "Aktif ✓"; togSub.TextColor3 = C.green
        else
            dot.BackgroundColor3 = C.red; togBg.BackgroundColor3 = C.bg4
            tw(togKnob, FAST, {Position = UDim2.new(0,4,0.5,-11)})
            togLabel.Text = "Voice Chat"; togLabel.TextColor3 = C.txtP
            togSub.Text = "Nonaktif"; togSub.TextColor3 = C.txtD
        end
    end

    local function setLoading(on, msg)
        st.loading = on
        checkBtn.BackgroundColor3 = on and C.bg4 or C.bg3
        chkLbl.TextColor3 = on and C.txtD or C.txtP
        pcall(function()
            enTrack.BackgroundColor3 = on and C.bg4 or C.bg4
            disTrack.BackgroundColor3 = on and C.bg4 or C.bg4
        end)
        togBg.BackgroundColor3 = on and C.bg4 or (isVoiceOn and C.green or C.bg4)
        if on and msg then togSub.Text = msg; togSub.TextColor3 = C.accA end
    end

    local function updateKeyStatus(loaded, srcName)
        if loaded then
            keyIconCheck.Visible = true; keyIconX.Visible = false
            keyPill.BackgroundColor3 = C.green; keyPill.BackgroundTransparency = 0.65
            keySrcTxt.Text = srcName or "Loaded"; keySrcTxt.TextColor3 = C.green
            local sBorder = keyBar:FindFirstChildOfClass("UIStroke")
            if sBorder then sBorder.Color = C.green; sBorder.Transparency = 0.3 end
        else
            keyIconCheck.Visible = false; keyIconX.Visible = true
            keyPill.BackgroundColor3 = C.bg3; keyPill.BackgroundTransparency = 0.2
            keySrcTxt.Text = "Belum dimuat"; keySrcTxt.TextColor3 = C.txtD
        end
    end

    checkBtn.MouseButton1Click:Connect(function()
        if st.loading then return end
        local key = tbApiKey.Text:match("^%s*(.-)%s*$")
        local uid = tbUni.Text:match("^%s*(.-)%s*$")
        local pid = tbPl.Text:match("^%s*(.-)%s*$")
        if #key < 10 then logMsg("! API Key belum dimuat", C.red); return end
        if uid == "" then logMsg("! Universe ID wajib", C.red); return end
        if pid == "" then logMsg("! Place ID wajib", C.red); return end
        st.apiKey = key; st.universeId = uid; st.placeId = pid
        setLoading(true, "Menghubungi Open Cloud...")
        logMsg("> Cek status voice...", C.accA)
        task.spawn(function()
            local ok, enabled, extra = getVoiceStatus(key, uid, pid)
            setLoading(false)
            if ok then
                updateStatusUI(enabled)
                logMsg("> Voice: " .. (enabled and "AKTIF" or "NONAKTIF") .. " (via API)", C.green)
                slWarn("Voice: " .. (enabled and "AKTIF" or "NONAKTIF"), 2)
            else
                dot.BackgroundColor3 = C.accA
                togSub.Text = "Gagal cek API"; togSub.TextColor3 = C.red
                logMsg("! " .. tostring(extra or ""):sub(1,55), C.red)
            end
        end)
    end)

    local function doSetVoice(target)
        if st.loading then return end
        local key = tbApiKey.Text:match("^%s*(.-)%s*$")
        local uid = tbUni.Text:match("^%s*(.-)%s*$")
        local pid = tbPl.Text:match("^%s*(.-)%s*$")
        if #key < 10 then key = st.apiKey or "" end
        if uid == "" then uid = st.universeId or "" end
        if pid == "" then pid = st.placeId or "" end
        if #key < 10 then key = (_SL and _SL.publishApiKey) or "" end
        if uid == "" then uid = (_SL and _SL.publishUniverseId) or "" end
        if pid == "" then pid = (_SL and _SL.publishPlaceId) or "" end
        if #key < 10 then logMsg("! API Key belum dimuat", C.red); return end
        if uid == "" or pid == "" then logMsg("! Universe ID / Place ID belum terisi", C.red); return end
        st.apiKey = key; st.universeId = uid; st.placeId = pid
        if tbApiKey.Text == "" then tbApiKey.Text = key end
        if tbUni.Text == "" then tbUni.Text = uid end
        if tbPl.Text == "" then tbPl.Text = pid end
        st.loading = true
        local actionMsg = target and "Mengaktifkan voice..." or "Menonaktifkan voice..."
        setLoading(true, actionMsg); logMsg("> " .. actionMsg, C.accA); slWarn(actionMsg)
        task.spawn(function()
            local ok2, errMsg2 = setVoice(key, uid, pid, target)
            setLoading(false); st.loading = false
            if ok2 then
                updateStatusUI(target)
                logMsg("> Universe + Place: " .. (target and "ENABLED" or "DISABLED"), C.green)
                if target then logMsg("> Masuk game: ikon voice muncul", C.accA) end
                slWarn(target and "Voice Chat AKTIF!" or "Voice Chat NONAKTIF!", 3)
            else
                togSub.Text = "Gagal"; togSub.TextColor3 = C.red
                logMsg("! " .. tostring(errMsg2 or "error"):sub(1,55), C.red)
            end
        end)
    end

    togHit.MouseButton1Click:Connect(function() if st.loading then return end; doSetVoice(not isVoiceOn) end)
    checkBtn.MouseEnter:Connect(function() if not st.loading then tw(checkBtn,FAST,{BackgroundColor3=C.bg4}) end end)
    checkBtn.MouseLeave:Connect(function() if not st.loading then tw(checkBtn,FAST,{BackgroundColor3=C.bg3}) end end)
    togHit.MouseEnter:Connect(function() if not st.loading then tw(togBg,FAST,{BackgroundColor3=isVoiceOn and Color3.fromRGB(90,200,100) or C.bg5}) end end)
    togHit.MouseLeave:Connect(function() if not st.loading then tw(togBg,FAST,{BackgroundColor3=isVoiceOn and C.green or C.bg4}) end end)
    enBtn.MouseEnter:Connect(function() if not st.loading then tw(enBtn,FAST,{BackgroundColor3=C.bg3}) end end)
    enBtn.MouseLeave:Connect(function() if not st.loading then tw(enBtn,FAST,{BackgroundColor3=isVoiceOn and C.bg3 or C.bg2}) end end)
    disBtn.MouseEnter:Connect(function() if not st.loading then tw(disBtn,FAST,{BackgroundColor3=C.bg3}) end end)
    disBtn.MouseLeave:Connect(function() if not st.loading then tw(disBtn,FAST,{BackgroundColor3=(not isVoiceOn) and C.bg3 or C.bg2}) end end)
    enBtn.MouseButton1Click:Connect(function() if st.loading then return end; doSetVoice(true) end)
    disBtn.MouseButton1Click:Connect(function() if st.loading then return end; doSetVoice(false) end)

    -- ── AUTO-POPULATE SAAT PANEL DIBUKA ──────────────────────────────────
    task.spawn(function()
        local autoFilled = false
        task.spawn(function()
            local deltaKey, deltaPath = readDeltaApiKey()
            if deltaKey then
                tbApiKey.Text = deltaKey; st.apiKey = deltaKey
                local fname = deltaPath:match("([^/]+)$") or "apy key.txt"
                updateKeyStatus(true, fname); logMsg("> API Key: " .. fname, C.green)
                autoFilled = true
                if GetPlaceRF then
                    local ok, _, places = pcall(function() return GetPlaceRF:InvokeServer() end)
                    if ok and places and places.data and #places.data > 0 then
                        local first = places.data[1]
                        if first and first.id then tbUni.Text = tostring(first.id); st.universeId = tostring(first.id) end
                        if first and first.rootPlace and first.rootPlace.id then
                            tbPl.Text = tostring(first.rootPlace.id); st.placeId = tostring(first.rootPlace.id)
                        end
                        logMsg("> Universe/Place: GetPlaces OK", C.green)
                    end
                end
            end
        end)
        task.wait(0.35)
        if not autoFilled then
            pcall(function()
                local k = _SL and _SL.publishApiKey or ""
                if k and #k > 10 then
                    tbApiKey.Text = k; st.apiKey = k
                    updateKeyStatus(true, "Publish Panel"); logMsg("> API Key: Publish Panel", C.green)
                    autoFilled = true
                end
            end)
        end
        if not autoFilled then
            pcall(function()
                local sg2 = LP.PlayerGui:WaitForChild("StudioGui",5)
                local apiK = sg2:WaitForChild("TopBar",3)
                    :WaitForChild("SaveDetailsFrame",3):WaitForChild("PublishFrame",3)
                    :WaitForChild("ApiKeyScrollingFrame",3):WaitForChild("ApiKeyTextBox",3).Text
                if apiK and #apiK > 10 then
                    tbApiKey.Text = apiK; st.apiKey = apiK; _SL.publishApiKey = apiK
                    updateKeyStatus(true, "Studio GUI"); logMsg("> API Key: Studio Lite GUI", C.green)
                    autoFilled = true
                end
            end)
        end
        if not autoFilled then updateKeyStatus(false, nil); logMsg("[ Isi Universe ID dan Place ID ]", C.txtD) end
        pcall(function()
            if tbUni.Text == "" then
                local uid = _SL and _SL.publishUniverseId or ""
                if uid and #uid > 2 then tbUni.Text = uid; st.universeId = uid end
            end
            if tbPl.Text == "" then
                local pid = _SL and _SL.publishPlaceId or ""
                if pid and #pid > 2 then tbPl.Text = pid; st.placeId = pid end
            end
        end)
        task.wait(0.5)
        pcall(function()
            local key = st.apiKey or tbApiKey.Text:match("^%s*(.-)%s*$") or ""
            local uid = st.universeId or tbUni.Text:match("^%s*(.-)%s*$") or ""
            local pid = st.placeId or tbPl.Text:match("^%s*(.-)%s*$") or ""
            if #key < 10 or uid == "" or pid == "" then return end
            logMsg("> Mengecek status voice...", C.accA)
            togSub.Text = "Mengecek..."; togSub.TextColor3 = C.accA
            local ok, enabled = getVoiceStatus(key, uid, pid)
            if ok then
                updateStatusUI(enabled)
                logMsg("> Voice place ini: " .. (enabled and "AKTIF" or "NONAKTIF"), enabled and C.green or C.red)
                togSub.TextColor3 = enabled and C.green or C.red
                togSub.Text = enabled and "Aktif ✓ — tekan Disable utk nonaktifkan" or "Nonaktif — tekan Enable utk aktifkan"
            else
                logMsg("> Gagal cek otomatis (tekan Cek Status)", C.txtD)
                togSub.Text = "Belum dicek"; togSub.TextColor3 = C.txtD
            end
        end)
    end)
end


-- ══════════════════════════════════════════════════════════════════════════
--  SL_doFriendsPanel — Panel daftar teman untuk Share project
--  Replikasi CopyMap ShareClickLocal (GetFriendsAsync + GetFriendsOnline)
--  slotNum    = string slot ("1","2",...)
--  shareBtn   = tombol Share di row (untuk update text setelah share)
--  dateLbl    = label tanggal di row (untuk update status)
--  origDate   = teks tanggal asli (untuk restore)
-- ══════════════════════════════════════════════════════════════════════════
local _friendsPanelSG = nil

local function SL_doFriendsPanel(slotNum, shareBtn, dateLbl, origDate)
    if _friendsPanelSG then pcall(function() _friendsPanelSG:Destroy() end) end
    _friendsPanelSG = nil

    local LP      = game:GetService("Players").LocalPlayer
    local Players = game:GetService("Players")
    local RepStor = game:GetService("ReplicatedStorage")
    local SF = RepStor:WaitForChild("StudioLiteFolder",9)
               and RepStor.StudioLiteFolder:FindFirstChild("ServerFunctions")

    -- ── UI ──────────────────────────────────────────────────────────────
    local sg = Instance.new("ScreenGui")
    sg.Name = PFX.."FriendsPanel"; sg.ResetOnSpawn=false
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder=220; sg.Enabled=true
    sg.Parent = LP:WaitForChild("PlayerGui")
    _friendsPanelSG = sg

    local PW4,PH4 = 300,300
    local panel=Instance.new("Frame")
    panel.Size=UDim2.new(0,PW4,0,PH4)
    panel.Position=UDim2.new(0.5,-PW4/2,0.5,-PH4/2)
    panel.BackgroundColor3=C.bg1;panel.BorderSizePixel=0
    panel.ZIndex=11;panel.ClipsDescendants=false;panel.Parent=sg
    do
        local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,10);u.Parent=panel
        local s=Instance.new("UIStroke");s.Color=C.accB;s.Thickness=1.5;s.Parent=panel
    end

    -- Header
    local hdr=Instance.new("Frame")
    hdr.Size=UDim2.new(1,0,0,42);hdr.BackgroundColor3=C.bg0
    hdr.BorderSizePixel=0;hdr.ZIndex=12;hdr.Parent=panel;hdr.Active=true
    do
        local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,10);u.Parent=hdr
        local ac=Instance.new("Frame");ac.Size=UDim2.new(1,0,0,2)
        ac.Position=UDim2.new(0,0,1,-2);ac.BackgroundColor3=C.accB
        ac.BorderSizePixel=0;ac.ZIndex=13;ac.Parent=hdr
    end
    local hIco=Instance.new("TextLabel");hIco.Size=UDim2.new(0,28,1,0)
    hIco.Position=UDim2.new(0,10,0,0);hIco.BackgroundTransparency=1
    hIco.Text="→";hIco.TextSize=20;hIco.Font=Enum.Font.GothamBold
    hIco.TextColor3=C.accA;hIco.TextYAlignment=Enum.TextYAlignment.Center
    hIco.ZIndex=14;hIco.Parent=hdr
    local hTxt=Instance.new("TextLabel");hTxt.Size=UDim2.new(1,-80,1,0)
    hTxt.Position=UDim2.new(0,44,0,0);hTxt.BackgroundTransparency=1
    hTxt.Text="Choose friend to share"
    hTxt.TextColor3=C.txtP;hTxt.Font=Enum.Font.GothamBold;hTxt.TextSize=13
    hTxt.TextXAlignment=Enum.TextXAlignment.Left
    hTxt.TextYAlignment=Enum.TextYAlignment.Center;hTxt.ZIndex=14;hTxt.Parent=hdr
    SL_addDrag(hdr, panel)

    local xBtn=Instance.new("TextButton")
    xBtn.Size=UDim2.new(0,28,0,26);xBtn.Position=UDim2.new(1,-34,0.5,-13)
    xBtn.BackgroundColor3=C.red;xBtn.BackgroundTransparency=0.2
    xBtn.BorderSizePixel=0;xBtn.Text="✕";xBtn.TextColor3=C.txtP
    xBtn.Font=Enum.Font.GothamBold;xBtn.TextSize=13
    xBtn.AutoButtonColor=false;xBtn.ZIndex=14;xBtn.Parent=hdr
    do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,5);u.Parent=xBtn end

    local function closeFP()
        pcall(function() sg:Destroy() end); _friendsPanelSG=nil
    end
    xBtn.MouseButton1Click:Connect(closeFP)

    -- Status / loading label
    local stLbl=Instance.new("TextLabel");stLbl.Size=UDim2.new(1,-20,0,18)
    stLbl.Position=UDim2.new(0,10,0,46);stLbl.BackgroundTransparency=1
    stLbl.Text="Loading friends...";stLbl.TextColor3=C.txtD
    stLbl.Font=Enum.Font.Gotham;stLbl.TextSize=11
    stLbl.TextXAlignment=Enum.TextXAlignment.Left;stLbl.ZIndex=12;stLbl.Parent=panel

    -- ScrollingFrame daftar teman
    local scroll2=Instance.new("ScrollingFrame")
    scroll2.Size=UDim2.new(1,-10,1,-66);scroll2.Position=UDim2.new(0,5,0,62)
    scroll2.BackgroundTransparency=1;scroll2.BorderSizePixel=0
    scroll2.ScrollBarThickness=3;scroll2.ScrollBarImageColor3=C.accB
    scroll2.CanvasSize=UDim2.new(0,0,0,0);scroll2.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll2.ZIndex=12;scroll2.Parent=panel
    do
        local ll=Instance.new("UIListLayout");ll.SortOrder=Enum.SortOrder.Name
        ll.Padding=UDim.new(0,2);ll.Parent=scroll2
    end

    -- ── Load friends async ──────────────────────────────────────────────
    task.spawn(function()
        -- CopyMap ShareClickLocal:
        -- v28[friendId] = 1 jika online
        -- text = isOnline and " 🌐 " .. username or "" .. username
        local userId = LP.UserId
        if userId < 0 then userId = 1121973131 end  -- test account fallback

        -- Teman online (GetFriendsOnline tidak tersedia di semua platform, pcall strict)
        local onlineSet = {}
        local ok2, onlineList = pcall(function()
            return LP:GetFriendsOnline(200)
        end)
        if ok2 and type(onlineList) == "table" then
            for _, v in ipairs(onlineList) do
                if v and v.VisitorId then
                    onlineSet[v.VisitorId] = true
                end
            end
        end

        -- Semua teman via GetFriendsAsync
        local ok3, pages = pcall(function()
            return Players:GetFriendsAsync(userId)
        end)
        if not ok3 or not pages then
            stLbl.Text = "Could not load friends."; return
        end

        local friendCount = 0
        while true do
            local ok4, page = pcall(function() return pages:GetCurrentPage() end)
            if not ok4 or not page then break end
            for _, friend in ipairs(page) do
                if not friend then continue end
                friendCount = friendCount + 1
                local isOnline = onlineSet[friend.Id] and true or false
                -- Format: "🌐 DisplayName@Username" jika online, "DisplayName@Username" jika offline
                local prefix = isOnline and "🌐 " or ""
                local displayText
                if friend.Username == friend.DisplayName then
                    displayText = prefix.."@"..friend.Username
                else
                    displayText = prefix..friend.DisplayName.."  @"..friend.Username
                end

                local btn=Instance.new("TextButton")
                -- Sort: online dulu (sortName pakai prefix)
                local sortKey = isOnline and "0_"..friend.DisplayName:upper() or "1_"..friend.DisplayName:upper()
                btn.Name = sortKey
                btn.Size=UDim2.new(1,0,0,34);btn.BackgroundColor3=C.bg2
                btn.BackgroundTransparency=0.3;btn.BorderSizePixel=0
                btn.Text="  "..displayText;btn.TextColor3=isOnline and C.accA or C.txtP
                btn.Font=Enum.Font.Gotham;btn.TextSize=11
                btn.TextXAlignment=Enum.TextXAlignment.Left
                btn.AutoButtonColor=false;btn.ZIndex=13;btn.Parent=scroll2
                do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,4);u.Parent=btn end
                do
                    local s=Instance.new("UIStroke");s.Color=C.bdrB
                    s.Thickness=1;s.Transparency=0.7;s.Parent=btn
                end
                -- Online badge
                if isOnline then
                    local dot=Instance.new("Frame");dot.Size=UDim2.new(0,6,0,6)
                    dot.Position=UDim2.new(1,-10,0.5,-3);dot.BackgroundColor3=C.green
                    dot.BorderSizePixel=0;dot.ZIndex=14;dot.Parent=btn
                    do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,3);u.Parent=dot end
                end

                btn.MouseEnter:Connect(function()
                    btn.BackgroundColor3=C.accB;btn.BackgroundTransparency=0.1
                end)
                btn.MouseLeave:Connect(function()
                    btn.BackgroundColor3=C.bg2;btn.BackgroundTransparency=0.3
                end)

                -- Klik teman → share
                local capturedFriend = friend
                btn.MouseButton1Click:Connect(function()
                    closeFP()
                    if not SF then return end
                    -- Persis CopyMap ShareClickLocal:
                    -- InvokeServer("ShareWith", friendId, slotNum)
                    -- shareBtn.Text = "Unshare"
                    -- dateLbl.Text = "Shared with " .. displayText
                    shareBtn.Visible = false
                    if dateLbl then dateLbl.Text = "Sharing..." end
                    task.spawn(function()
                        local ok5,err5 = pcall(function()
                            SF:InvokeServer("ShareWith", capturedFriend.Id,
                                tonumber(slotNum) or slotNum)
                        end)
                        if ok5 then
                            shareBtn.Text = "Unshare"
                            if dateLbl then
                                dateLbl.Text = "Shared with "..displayText
                            end
                        else
                            if dateLbl then dateLbl.Text = origDate end
                            warn("[SL] ShareWith failed:", err5)
                        end
                        shareBtn.Visible = true
                    end)
                end)
            end
            if pages.IsFinished then break end
            task.wait()
            local advOk = pcall(function() pages:AdvanceToNextPageAsync() end)
            if not advOk then break end
        end

        if friendCount == 0 then
            stLbl.Text = "No friends found."
        else
            stLbl.Text = friendCount.." friends"
        end
    end)
end

local function SL_doPublishPanel(gameName, desc, isPublished, v28, v29, SF, wt)
    if _publishPanelSG then pcall(function() _publishPanelSG:Destroy() end) end
    _publishPanelSG = nil

    local LP = game:GetService("Players").LocalPlayer

    -- ── Build UI ──────────────────────────────────────────────────────────
    local sg = Instance.new("ScreenGui")
    sg.Name = PFX.."PublishPanel"; sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 210; sg.Enabled = true
    sg.Parent = LP:WaitForChild("PlayerGui")
    _publishPanelSG = sg

    -- Panel tengah — lebar 300, tinggi 390 agar semua row tidak tumpang tindih
    local PW3,PH3 = 300,390
    local panel=Instance.new("Frame")
    panel.Size=UDim2.new(0,PW3,0,PH3)
    panel.Position=UDim2.new(0.5,-PW3/2,0.5,-PH3/2)
    panel.BackgroundColor3=C.bg1; panel.BorderSizePixel=0
    panel.ZIndex=11; panel.ClipsDescendants=false; panel.Parent=sg
    do
        local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,10);u.Parent=panel
        local s=Instance.new("UIStroke");s.Color=C.accB;s.Thickness=1.5;s.Parent=panel
    end

    -- Header (juga jadi handle drag)
    local hdr=Instance.new("Frame")
    hdr.Size=UDim2.new(1,0,0,42); hdr.BackgroundColor3=C.bg0
    hdr.BorderSizePixel=0; hdr.ZIndex=12; hdr.Parent=panel
    hdr.Active=true  -- penting untuk drag
    do
        local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,10);u.Parent=hdr
        local ac=Instance.new("Frame");ac.Size=UDim2.new(1,0,0,2)
        ac.Position=UDim2.new(0,0,1,-2);ac.BackgroundColor3=C.accB
        ac.BorderSizePixel=0;ac.ZIndex=13;ac.Parent=hdr
    end
    local hIco=Instance.new("TextLabel");hIco.Size=UDim2.new(0,28,1,0)
    hIco.Position=UDim2.new(0,10,0,0);hIco.BackgroundTransparency=1
    hIco.Text="↑";hIco.TextSize=20;hIco.Font=Enum.Font.GothamBold
    hIco.TextColor3=C.accA
    hIco.TextYAlignment=Enum.TextYAlignment.Center;hIco.ZIndex=14;hIco.Parent=hdr
    local hTxt=Instance.new("TextLabel");hTxt.Size=UDim2.new(1,-80,1,0)
    hTxt.Position=UDim2.new(0,44,0,0);hTxt.BackgroundTransparency=1
    hTxt.Text="Publish to Roblox"
    hTxt.TextColor3=C.txtP;hTxt.Font=Enum.Font.GothamBold;hTxt.TextSize=13
    hTxt.TextXAlignment=Enum.TextXAlignment.Left
    hTxt.TextYAlignment=Enum.TextYAlignment.Center;hTxt.ZIndex=14;hTxt.Parent=hdr
    SL_addDrag(hdr, panel)

    -- Close button
    local xBtn=Instance.new("TextButton")
    xBtn.Size=UDim2.new(0,28,0,26);xBtn.Position=UDim2.new(1,-34,0.5,-13)
    xBtn.BackgroundColor3=C.red;xBtn.BackgroundTransparency=0.2
    xBtn.BorderSizePixel=0;xBtn.Text="✕";xBtn.TextColor3=C.txtP
    xBtn.Font=Enum.Font.GothamBold;xBtn.TextSize=13
    xBtn.AutoButtonColor=false;xBtn.ZIndex=14;xBtn.Parent=hdr
    do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,5);u.Parent=xBtn end

    local function closePubPanel()
        pcall(function() sg:Destroy() end); _publishPanelSG=nil
        if wt then wt.Visible=false end
    end
    xBtn.MouseButton1Click:Connect(closePubPanel)

    -- ── Helper UI builders ────────────────────────────────────────────────
    local function mkLbl(y, txt)
        local l=Instance.new("TextLabel");l.Size=UDim2.new(1,-20,0,13)
        l.Position=UDim2.new(0,10,0,y);l.BackgroundTransparency=1
        l.Text=txt;l.TextColor3=C.txtD;l.Font=Enum.Font.GothamBold;l.TextSize=9
        l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=12;l.Parent=panel
    end
    local function mkTextBox(y, h, placeholder, initText)
        local bg=Instance.new("Frame");bg.Size=UDim2.new(1,-20,0,h)
        bg.Position=UDim2.new(0,10,0,y);bg.BackgroundColor3=C.bg3
        bg.BorderSizePixel=0;bg.ZIndex=12;bg.Parent=panel
        do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,5);u.Parent=bg end
        do local s=Instance.new("UIStroke");s.Color=C.bdrB;s.Thickness=1;s.Transparency=0.5;s.Parent=bg end
        local tb=Instance.new("TextBox");tb.Size=UDim2.new(1,-12,1,0)
        tb.Position=UDim2.new(0,6,0,0);tb.BackgroundTransparency=1
        tb.Text=initText or "";tb.PlaceholderText=placeholder;tb.PlaceholderColor3=C.txtD
        tb.TextColor3=C.txtP;tb.Font=Enum.Font.Code;tb.TextSize=10
        tb.TextXAlignment=Enum.TextXAlignment.Left;tb.TextYAlignment=Enum.TextYAlignment.Center
        tb.ClearTextOnFocus=false;tb.TextWrapped=true;tb.MultiLine=(h>30)
        tb.ZIndex=13;tb.Parent=bg
        return tb
    end
    local function mkDropBtn(y, label)
        local b=Instance.new("TextButton");b.Size=UDim2.new(1,-20,0,28)
        b.Position=UDim2.new(0,10,0,y);b.BackgroundColor3=C.bg3
        b.BorderSizePixel=0;b.Text=label;b.TextColor3=C.txtP
        b.Font=Enum.Font.Gotham;b.TextSize=11
        b.TextXAlignment=Enum.TextXAlignment.Left;b.AutoButtonColor=false;b.ZIndex=12;b.Parent=panel
        do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,5);u.Parent=b end
        do local s=Instance.new("UIStroke");s.Color=C.bdrB;s.Thickness=1;s.Transparency=0.5;s.Parent=b end
        -- Arrow
        local arr=Instance.new("TextLabel");arr.Size=UDim2.new(0,20,1,0)
        arr.Position=UDim2.new(1,-22,0,0);arr.BackgroundTransparency=1
        arr.Text="▾";arr.TextColor3=C.txtD;arr.Font=Enum.Font.GothamBold;arr.TextSize=12
        arr.ZIndex=13;arr.Parent=b
        return b
    end

    -- ── Row 1: Publish to ────────────────────────────────────────────────
    mkLbl(52, "PUBLISH TO")
    local pubToBtn = mkDropBtn(65, "   Your Roblox profile.")

    -- Dropdown choices (Your Profile / Group / Private)
    local pubToDD = Instance.new("Frame")
    pubToDD.Size=UDim2.new(1,-20,0,0);pubToDD.Position=UDim2.new(0,10,0,93)
    pubToDD.BackgroundColor3=C.bg2;pubToDD.BorderSizePixel=0
    pubToDD.ClipsDescendants=true;pubToDD.ZIndex=20;pubToDD.Visible=false;pubToDD.Parent=panel
    do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,5);u.Parent=pubToDD end
    do local s=Instance.new("UIStroke");s.Color=C.bdrB;s.Thickness=1;s.Transparency=0.4;s.Parent=pubToDD end
    do local ll=Instance.new("UIListLayout");ll.SortOrder=Enum.SortOrder.LayoutOrder;ll.Parent=pubToDD end

    local pubToChoices = {"   Your Roblox profile.", "   Your Group.", "   Private."}
    local selectedPubTo = pubToChoices[1]

    local function closePubToDD()
        pubToDD.Visible=false; pubToDD.Size=UDim2.new(1,-20,0,0)
    end
    local function openPubToDD()
        pubToDD.Visible=true
        pubToDD.Size=UDim2.new(1,-20,0,#pubToChoices*26)
    end

    for i, choice in ipairs(pubToChoices) do
        local cb=Instance.new("TextButton");cb.Size=UDim2.new(1,0,0,26)
        cb.BackgroundTransparency=1;cb.Text=choice;cb.TextColor3=C.txtP
        cb.Font=Enum.Font.Gotham;cb.TextSize=11
        cb.TextXAlignment=Enum.TextXAlignment.Left;cb.LayoutOrder=i
        cb.AutoButtonColor=false;cb.ZIndex=21;cb.Parent=pubToDD
        do local p=Instance.new("UIPadding");p.PaddingLeft=UDim.new(0,8);p.Parent=cb end
        cb.MouseEnter:Connect(function() cb.BackgroundTransparency=0.7; cb.BackgroundColor3=C.bg4 end)
        cb.MouseLeave:Connect(function() cb.BackgroundTransparency=1 end)
        cb.MouseButton1Click:Connect(function()
            selectedPubTo=choice
            pubToBtn.Text=choice
            closePubToDD()
        end)
    end

    pubToBtn.MouseButton1Click:Connect(function()
        if pubToDD.Visible then closePubToDD() else openPubToDD() end
    end)

    -- ── Row 2: Replace (game dari list) ──────────────────────────────────
    mkLbl(103, "REPLACE")
    -- Populate dari v29 (list places dari GetPlacesServerFunction)
    local selUniverseId = ""
    local selPlaceId    = ""
    local initReplaceText = "   (no published games found)"
    local placesList = {}

    if v29 and v29.data then
        for _, pl in ipairs(v29.data) do
            local displayName = pl.name
            if pl.description and pl.description ~= "" then
                local suffix = " - "..pl.description
                displayName = displayName..suffix:sub(1, math.clamp(50-#pl.name,0,50))
            end
            table.insert(placesList, {
                display    = "   "..displayName,
                universeId = tostring(pl.id or ""),
                placeId    = tostring((pl.rootPlace and pl.rootPlace.id) or ""),
            })
        end
    end
    if #placesList > 0 then
        initReplaceText   = placesList[1].display
        selUniverseId     = placesList[1].universeId
        selPlaceId        = placesList[1].placeId
    end

    local replaceBtn = mkDropBtn(116, initReplaceText)

    -- Dropdown places list
    local replaceDD = Instance.new("ScrollingFrame")
    replaceDD.Size=UDim2.new(1,-20,0,0);replaceDD.Position=UDim2.new(0,10,0,144)
    replaceDD.BackgroundColor3=C.bg2;replaceDD.BorderSizePixel=0
    replaceDD.ClipsDescendants=true;replaceDD.ZIndex=20;replaceDD.Visible=false
    replaceDD.ScrollBarThickness=3;replaceDD.ScrollBarImageColor3=C.accB
    replaceDD.CanvasSize=UDim2.new(0,0,0,0);replaceDD.AutomaticCanvasSize=Enum.AutomaticSize.Y
    replaceDD.Parent=panel
    do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,5);u.Parent=replaceDD end
    do local s=Instance.new("UIStroke");s.Color=C.bdrB;s.Thickness=1;s.Transparency=0.4;s.Parent=replaceDD end
    do local ll=Instance.new("UIListLayout");ll.SortOrder=Enum.SortOrder.LayoutOrder;ll.Parent=replaceDD end

    local function closeReplaceDD() replaceDD.Visible=false; replaceDD.Size=UDim2.new(1,-20,0,0) end
    local function openReplaceDD()
        replaceDD.Visible=true
        replaceDD.Size=UDim2.new(1,-20,0,math.min(#placesList*26,104))
    end

    for i, pl in ipairs(placesList) do
        local rb=Instance.new("TextButton");rb.Size=UDim2.new(1,0,0,26)
        rb.BackgroundTransparency=1;rb.Text=pl.display;rb.TextColor3=C.txtP
        rb.Font=Enum.Font.Gotham;rb.TextSize=11;rb.LayoutOrder=i
        rb.TextXAlignment=Enum.TextXAlignment.Left;rb.AutoButtonColor=false;rb.ZIndex=21;rb.Parent=replaceDD
        do local p=Instance.new("UIPadding");p.PaddingLeft=UDim.new(0,8);p.Parent=rb end
        rb.MouseEnter:Connect(function() rb.BackgroundTransparency=0.7; rb.BackgroundColor3=C.bg4 end)
        rb.MouseLeave:Connect(function() rb.BackgroundTransparency=1 end)
        local plCap = pl
        rb.MouseButton1Click:Connect(function()
            replaceBtn.Text    = plCap.display
            selUniverseId      = plCap.universeId
            selPlaceId         = plCap.placeId
            closeReplaceDD()
        end)
    end

    if #placesList == 0 then
        local noGame=Instance.new("TextLabel");noGame.Size=UDim2.new(1,0,0,26)
        noGame.BackgroundTransparency=1;noGame.Text="   Make your game public first."
        noGame.TextColor3=C.txtD;noGame.Font=Enum.Font.Gotham;noGame.TextSize=10
        noGame.TextXAlignment=Enum.TextXAlignment.Left;noGame.ZIndex=21;noGame.Parent=replaceDD
    end

    replaceBtn.MouseButton1Click:Connect(function()
        if replaceDD.Visible then closeReplaceDD() else openReplaceDD() end
    end)

    -- ── Row 3: API Key ────────────────────────────────────────────────────
    mkLbl(154, "API-KEY")
    local apiBox = mkTextBox(166, 46, "Paste your Roblox Open Cloud API key here...", v28 or "")
    -- apiBox size already set

    -- ── Status label ──────────────────────────────────────────────────────
    local pubStLbl=Instance.new("TextLabel");pubStLbl.Size=UDim2.new(1,-20,0,14)
    pubStLbl.Position=UDim2.new(0,10,0,220);pubStLbl.BackgroundTransparency=1
    pubStLbl.Text="";pubStLbl.TextColor3=C.accA;pubStLbl.Font=Enum.Font.Gotham;pubStLbl.TextSize=10
    pubStLbl.TextXAlignment=Enum.TextXAlignment.Left;pubStLbl.ZIndex=12;pubStLbl.Parent=panel

    -- ── Private mode fields (tersembunyi, muncul jika pilih Private) ──────
    local privUnivBox, privPlaceBox
    local privRow = Instance.new("Frame")
    privRow.Size=UDim2.new(1,0,0,0);privRow.Position=UDim2.new(0,0,0,238)
    privRow.BackgroundTransparency=1;privRow.ClipsDescendants=true;privRow.Visible=false
    privRow.ZIndex=12;privRow.Parent=panel

    -- Watch pubTo selection untuk tampilkan private fields
    -- (Private mode: ReplaceButton hidden, PrivateUniverseIdTextBox + PrivatePlaceIdTextBox visible)
    local isPrivateMode = false

    -- Observer untuk selectedPubTo → update private mode
    local function updatePubToMode()
        isPrivateMode = (selectedPubTo == "   Private.")
        if isPrivateMode then
            replaceBtn.Visible = false
            privRow.Visible    = true
            privRow.Size       = UDim2.new(1,0,0,50)
        else
            replaceBtn.Visible = true
            privRow.Visible    = false
        end
    end
    -- Re-wire pubTo buttons to also call updatePubToMode
    for _, cb in ipairs(pubToDD:GetChildren()) do
        if cb:IsA("TextButton") then
            cb.MouseButton1Click:Connect(updatePubToMode)
        end
    end

    -- Private: universe & place ID inputs
    mkLbl(238, "UNIVERSE ID")
    privUnivBox = mkTextBox(251, 24, "Universe ID...", "")
    mkLbl(282, "PLACE ID")
    privPlaceBox = mkTextBox(295, 24, "Place ID...", "")

    -- ── Tombol Cancel & Publish ───────────────────────────────────────────
    local function mkActionBtn(x, w, label, col)
        local b=Instance.new("TextButton");b.Size=UDim2.new(0,w,0,30)
        b.Position=UDim2.new(0,x,0,354);b.BackgroundColor3=col
        b.BorderSizePixel=0;b.Text=label;b.TextColor3=C.txtP
        b.Font=Enum.Font.GothamBold;b.TextSize=13
        b.AutoButtonColor=false;b.ZIndex=12;b.Parent=panel
        do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,6);u.Parent=b end
        return b
    end
    local pubCancelBtn = mkActionBtn(10, 90, "Cancel", C.bg3)
    do
        local s=Instance.new("UIStroke");s.Color=C.bdrB;s.Thickness=1;s.Transparency=0.6;s.Parent=pubCancelBtn
    end
    local pubDoBtn = mkActionBtn(110, PW3-120, "Publish", C.accB)
    pubDoBtn.MouseEnter:Connect(function() pcall(function() tw(pubDoBtn,FAST,{BackgroundColor3=C.accA}) end) end)
    pubDoBtn.MouseLeave:Connect(function() pcall(function() tw(pubDoBtn,FAST,{BackgroundColor3=C.accB}) end) end)

    pubCancelBtn.MouseButton1Click:Connect(closePubPanel)

    -- ── Handler Publish ───────────────────────────────────────────────────
    -- Replikasi persis PublishButton.MouseButton1Click di SaveDetailsClickLocal:
    --   v40 = universeId (atau PrivateUniverseIdTextBox)
    --   v41 = placeId    (atau PrivatePlaceIdTextBox)
    --   v42 = apiKey
    --   Validasi: #v40>3, #v41>3, #v42>18, no space
    --   InvokeServer("Publish","use saved table",gameName,desc,isPub,v40,v41,v42)
    local pubInProgress = false

    pubDoBtn.MouseButton1Click:Connect(function()
        if pubInProgress then return end

        -- Tutup semua dropdown dulu
        closePubToDD(); closeReplaceDD()

        -- v40, v41 persis SaveDetailsClickLocal
        local v40, v41
        if isPrivateMode then
            v40 = privUnivBox and privUnivBox.Text or ""
            v41 = privPlaceBox and privPlaceBox.Text or ""
        else
            v40 = selUniverseId
            v41 = selPlaceId
        end
        local v42 = apiBox.Text

        -- Validasi persis CopyMap:
        -- v40 and v41 and v42 and #v40>3 and #v41>3 and #v42>18 and not v42:find(" ")
        if not (v40 and v41 and v42
            and #v40>3 and #v41>3 and #v42>18
            and not v42:find(" ", 1, true)) then
            pubStLbl.Text="⚠ Incomplete. Check all fields."
            pubStLbl.TextColor3=C.red
            return
        end

        pubInProgress   = true
        pubDoBtn.Text   = "Publishing..."
        pubDoBtn.BackgroundColor3 = C.bg3
        pubStLbl.Text   = "Publishing "..gameName.."..."
        pubStLbl.TextColor3 = C.accA
        if wt then wt.Text="Publishing..."; wt.Visible=true end

        task.spawn(function()
            local ok, err = pcall(function()
                SF:InvokeServer("Publish","use saved table",
                    gameName, desc, isPublished, v40, v41, v42)
            end)
            if ok then
                pubStLbl.Text="✓ Published!"; pubStLbl.TextColor3=C.green
                if wt then wt.Text="Published!"; wt.Visible=true end
                            task.wait(1.5)
                closePubPanel()
            else
                pubStLbl.Text="❌ Publish failed: "..tostring(err):sub(1,40)
                pubStLbl.TextColor3=C.red
                warn("[SL] Publish failed:", err)
                if wt then wt.Visible=false end
                pubInProgress=false
                pubDoBtn.Text="Publish"; pubDoBtn.BackgroundColor3=C.accB
            end
        end)
    end)
end

local function SL_doSavePanel(slotNum, initName, initPublished, initDesc)
    -- Tutup panel save sebelumnya kalau ada
    if _savePanelSG then pcall(function() _savePanelSG:Destroy() end) end
    _savePanelSG = nil
    _saveInProgress = false

    -- Dapatkan referensi penting
    local LP         = game:GetService("Players").LocalPlayer
    local RepStor    = game:GetService("ReplicatedStorage")
    local HttpSvc    = game:GetService("HttpService")
    local slFolder   = RepStor:WaitForChild("StudioLiteFolder", 9)
    if not slFolder then warn("[SL] SL_doSavePanel: StudioLiteFolder not found"); return end

    -- RemoteFunctions persis seperti SaveDetailsClickLocal
    local SF         = slFolder:WaitForChild("ServerFunctions", 9)
    local FilterRF   = slFolder:FindFirstChild("FilterStringServerFunction")
    local MainConv   = require(slFolder:WaitForChild("MainConvertModule", 9))

    -- CloneLocalWorkspaceToReplicatedStorageModule:
    -- SaveDetailsClickLocal pakai: script.Parent.Parent.Parent.Clone... (= StudioGui.Clone...)
    -- Kita cari di StudioGui (recursive=true) karena path runtime-nya di sana
    local studioGui  = LP:WaitForChild("PlayerGui"):WaitForChild("StudioGui", 9)
    local CloneLocal = studioGui and studioGui:FindFirstChild(
                           "CloneLocalWorkspaceToReplicatedStorageModule", true)
    if CloneLocal then CloneLocal = require(CloneLocal) end

    -- WarningText (v_u_11 di SaveDetailsClickLocal)
    local wt = studioGui and studioGui:FindFirstChild("WarningText")

    -- Convert options persis SaveDetailsClickLocal v_u_1
    local convertOpts = {
        PrintCompletionTime          = false,
        PrintObjectVariableErrors    = false,
        PrintDataStoreApproximateSize = true,
        ExcludedProperties           = {"BrickColor"},
        ShowHTTPWarning              = false,
    }

    -- ── Build UI Form Premium ────────────────────────────────────────────
    local sg = Instance.new("ScreenGui")
    sg.Name = PFX.."SavePanel"; sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 200; sg.Enabled = true
    sg.Parent = LP:WaitForChild("PlayerGui")
    _savePanelSG = sg

    -- Panel tengah — ukuran seragam 280×310
    local PW2,PH2 = 300,300
    local panel = Instance.new("Frame")
    panel.Size=UDim2.new(0,PW2,0,PH2)
    panel.Position=UDim2.new(0.5,-PW2/2,0.5,-PH2/2)
    panel.BackgroundColor3=C.bg1; panel.BorderSizePixel=0
    panel.ZIndex=11; panel.ClipsDescendants=false; panel.Parent=sg
    do
        local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,10);u.Parent=panel
        local s=Instance.new("UIStroke");s.Color=C.accB;s.Thickness=1.5;s.Parent=panel
    end

    -- Header (drag handle)
    local hdr=Instance.new("Frame")
    hdr.Size=UDim2.new(1,0,0,42); hdr.BackgroundColor3=C.bg0
    hdr.BorderSizePixel=0; hdr.ZIndex=12; hdr.Parent=panel
    hdr.Active=true
    do
        local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,10);u.Parent=hdr
        local ac=Instance.new("Frame");ac.Size=UDim2.new(1,0,0,2)
        ac.Position=UDim2.new(0,0,1,-2);ac.BackgroundColor3=C.accB
        ac.BorderSizePixel=0;ac.ZIndex=13;ac.Parent=hdr
    end
    local hIco=Instance.new("TextLabel");hIco.Size=UDim2.new(0,28,1,0)
    hIco.Position=UDim2.new(0,10,0,0);hIco.BackgroundTransparency=1
    -- ↓ untuk Save slot, + untuk Save As New
    hIco.Text = (slotNum=="" and "+" or "↓")
    hIco.TextSize=20;hIco.Font=Enum.Font.GothamBold
    hIco.TextColor3=C.accA
    hIco.TextYAlignment=Enum.TextYAlignment.Center;hIco.ZIndex=14;hIco.Parent=hdr
    local hTxt=Instance.new("TextLabel");hTxt.Size=UDim2.new(1,-90,1,0)
    hTxt.Position=UDim2.new(0,44,0,0);hTxt.BackgroundTransparency=1
    hTxt.Text = (slotNum=="" and "Save As New" or "Save Place")
    hTxt.TextColor3=C.txtP;hTxt.Font=Enum.Font.GothamBold;hTxt.TextSize=13
    hTxt.TextXAlignment=Enum.TextXAlignment.Left
    hTxt.TextYAlignment=Enum.TextYAlignment.Center;hTxt.ZIndex=14;hTxt.Parent=hdr
    SL_addDrag(hdr, panel)

    -- Close button di header
    local xBtn=Instance.new("TextButton")
    xBtn.Size=UDim2.new(0,28,0,26);xBtn.Position=UDim2.new(1,-34,0.5,-13)
    xBtn.BackgroundColor3=C.red;xBtn.BackgroundTransparency=0.2
    xBtn.BorderSizePixel=0;xBtn.Text="✕";xBtn.TextColor3=C.txtP
    xBtn.Font=Enum.Font.GothamBold;xBtn.TextSize=13
    xBtn.AutoButtonColor=false;xBtn.ZIndex=14;xBtn.Parent=hdr
    do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,5);u.Parent=xBtn end

    local function closeSavePanel()
        pcall(function() sg:Destroy() end); _savePanelSG=nil
    end
    xBtn.MouseButton1Click:Connect(closeSavePanel)

    -- ── Field: Game Name ────────────────────────────────────────────────
    local function mkLabel(parent, y, txt)
        local l=Instance.new("TextLabel");l.Size=UDim2.new(1,-20,0,14)
        l.Position=UDim2.new(0,10,0,y);l.BackgroundTransparency=1
        l.Text=txt;l.TextColor3=C.txtD;l.Font=Enum.Font.GothamBold;l.TextSize=10
        l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=12;l.Parent=parent
        return l
    end
    local function mkBox(parent, y, h, placeholder)
        local bg=Instance.new("Frame");bg.Size=UDim2.new(1,-20,0,h)
        bg.Position=UDim2.new(0,10,0,y);bg.BackgroundColor3=C.bg3
        bg.BorderSizePixel=0;bg.ZIndex=12;bg.Parent=parent
        do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,5);u.Parent=bg end
        do local s=Instance.new("UIStroke");s.Color=C.bdrB;s.Thickness=1;s.Transparency=0.5;s.Parent=bg end
        local tb=Instance.new("TextBox");tb.Size=UDim2.new(1,-12,1,0)
        tb.Position=UDim2.new(0,6,0,0);tb.BackgroundTransparency=1
        tb.Text="";tb.PlaceholderText=placeholder;tb.PlaceholderColor3=C.txtD
        tb.TextColor3=C.txtP;tb.Font=Enum.Font.Gotham;tb.TextSize=12
        tb.TextXAlignment=Enum.TextXAlignment.Left
        tb.TextYAlignment=Enum.TextYAlignment.Top;tb.TextWrapped=true
        tb.ClearTextOnFocus=false;tb.ZIndex=13;tb.Parent=bg
        return tb, bg
    end

    mkLabel(panel, 52, "GAME NAME")
    local nameBox, nameBg = mkBox(panel, 64, 28, "Type here...")
    nameBox.Text = initName or ""

    mkLabel(panel, 98, "DESCRIPTION (optional)")
    local descBox, _ = mkBox(panel, 112, 56, "Type description here...")
    descBox.Text = initDesc or ""
    descBox.MultiLine = true

    -- ── Publish Toggle ──────────────────────────────────────────────────
    local pubRow=Instance.new("Frame");pubRow.Size=UDim2.new(1,-20,0,26)
    pubRow.Position=UDim2.new(0,10,0,176);pubRow.BackgroundTransparency=1;pubRow.ZIndex=12
    pubRow.Parent=panel

    local isPub = initPublished or false
    local IMG_CHECKED   = "http://www.roblox.com/asset/?id=48138491"
    local IMG_UNCHECKED = "http://www.roblox.com/asset/?id=48138474"

    local pubChk=Instance.new("ImageButton");pubChk.Size=UDim2.new(0,20,0,20)
    pubChk.Position=UDim2.new(0,0,0.5,-10);pubChk.BackgroundColor3=C.bg3
    pubChk.BorderSizePixel=0;pubChk.ZIndex=13;pubChk.Parent=pubRow
    pubChk.Image = isPub and IMG_CHECKED or IMG_UNCHECKED
    do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,4);u.Parent=pubChk end

    local pubLbl=Instance.new("TextLabel");pubLbl.Size=UDim2.new(1,-28,1,0)
    pubLbl.Position=UDim2.new(0,26,0,0);pubLbl.BackgroundTransparency=1
    pubLbl.Text = isPub and "(Everyone can play it together.)" or "(Save for later.)"
    pubLbl.TextColor3=C.txtS;pubLbl.Font=Enum.Font.Gotham;pubLbl.TextSize=11
    pubLbl.TextXAlignment=Enum.TextXAlignment.Left;pubLbl.ZIndex=13;pubLbl.Parent=pubRow

    pubChk.MouseButton1Click:Connect(function()
        isPub = not isPub
        pubChk.Image = isPub and IMG_CHECKED or IMG_UNCHECKED
        pubLbl.Text  = isPub and "(Everyone can play it together.)" or "(Save for later.)"
    end)

    -- Status label
    local stLbl=Instance.new("TextLabel");stLbl.Size=UDim2.new(1,-20,0,16)
    stLbl.Position=UDim2.new(0,10,0,208);stLbl.BackgroundTransparency=1
    stLbl.Text="";stLbl.TextColor3=C.accA;stLbl.Font=Enum.Font.Gotham;stLbl.TextSize=11
    stLbl.TextXAlignment=Enum.TextXAlignment.Left;stLbl.ZIndex=12;stLbl.Parent=panel

    -- ── Tombol Save & Cancel ────────────────────────────────────────────
    local function mkBtn(x, w, label, col)
        local b=Instance.new("TextButton");b.Size=UDim2.new(0,w,0,30)
        b.Position=UDim2.new(0,x,0,258);b.BackgroundColor3=col
        b.BorderSizePixel=0;b.Text=label;b.TextColor3=C.txtP
        b.Font=Enum.Font.GothamBold;b.TextSize=13
        b.AutoButtonColor=false;b.ZIndex=12;b.Parent=panel
        do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,6);u.Parent=b end
        return b
    end
    local cancelBtn = mkBtn(10,        90, "Cancel", C.bg3)
    local saveBtn   = mkBtn(110, PW2-120, "Save",   C.accB)
    do
        local s=Instance.new("UIStroke");s.Color=C.bdrB;s.Thickness=1;s.Transparency=0.6;s.Parent=cancelBtn
    end

    cancelBtn.MouseButton1Click:Connect(closeSavePanel)
    saveBtn.MouseEnter:Connect(function() pcall(function() tw(saveBtn,FAST,{BackgroundColor3=C.accA}) end) end)
    saveBtn.MouseLeave:Connect(function() pcall(function() tw(saveBtn,FAST,{BackgroundColor3=C.accB}) end) end)

    -- ── Handler Save ────────────────────────────────────────────────────
    -- Replikasi PENUH SaveDetailsClickLocal.SaveButton.MouseButton1Click
    -- Menggunakan modul dan RemoteFunctions yang sama persis
    saveBtn.MouseButton1Click:Connect(function()
        if _saveInProgress then return end

        -- v_u_12 di SaveDetailsClickLocal = GameNameTextBox.Text (trim)
        local v_u_12 = nameBox.Text:gsub("^%s*",""):gsub("%s*$",""):gsub("	"," ")
        nameBox.Text = v_u_12

        if v_u_12 == "" then
            stLbl.Text = "⚠ Ketik nama game dulu!"
            stLbl.TextColor3 = C.red
            return
        end

        _saveInProgress = true
        saveBtn.Text = "Saving..."
        saveBtn.BackgroundColor3 = C.bg3
        stLbl.Text = "Saving "..v_u_12.."..."
        stLbl.TextColor3 = C.accA

        if wt then wt.Text="Saving "..v_u_12.."..."; wt.Visible=true end

        task.spawn(function()
            -- v_u_13 = isPublished (bool)
            local v_u_13 = isPub
            -- v_u_14 = desc (trim)
            local v_u_14 = descBox.Text:gsub("^%s*",""):gsub("%s*$",""):gsub("	"," ")
            -- v18 = GameNumberValue.Value di SaveDetailsClickLocal
            local v18 = slotNum  -- STRING: "" (baru) atau "5" (overwrite)

            -- Filter string jika publish (persis SaveDetailsClickLocal)
            local v15_ok = true
            if v_u_13 and FilterRF then
                local ok16,v16 = pcall(function() return FilterRF:InvokeServer(v_u_12) end)
                if ok16 and v16 ~= v_u_12 then
                    nameBox.Text = v16; v_u_12 = v16
                    stLbl.Text="⚠ Nama difilter server"; stLbl.TextColor3=C.red
                    v15_ok = false
                end
                local ok17,v17 = pcall(function() return FilterRF:InvokeServer(v_u_14) end)
                if ok17 and v17 ~= v_u_14 then
                    descBox.Text = v17; v_u_14 = v17
                    stLbl.Text="⚠ Deskripsi difilter server"; stLbl.TextColor3=C.red
                    v15_ok = false
                end
            end

            if not v15_ok then
                -- Moderated
                _saveInProgress = false
                saveBtn.Text="Save"; saveBtn.BackgroundColor3=C.accB
                if wt then task.wait(3); wt.Visible=false end
                return
            end

            -- CloneLocal & Convert (persis SaveDetailsClickLocal v_u_8, v_u_5)
            if not CloneLocal then
                -- Coba sekali lagi cari module saat ini
                local sg2 = LP:FindFirstChild("PlayerGui") and
                            LP.PlayerGui:FindFirstChild("StudioGui")
                local m = sg2 and sg2:FindFirstChild(
                    "CloneLocalWorkspaceToReplicatedStorageModule", true)
                if m then CloneLocal = require(m) end
            end
            if not CloneLocal then
                stLbl.Text="❌ Module tidak ditemukan"; stLbl.TextColor3=C.red
                warn("[SL] CloneLocalWorkspaceToReplicatedStorageModule not found!")
                _saveInProgress=false
                if wt then task.wait(2); wt.Visible=false end
                return
            end

            -- v19 = CloneLocal workspace, v20 = Convert result, v22 = JSON
            local v19 = CloneLocal:CloneLocal(v_u_12)
            local v20 = MainConv:Convert(v19, convertOpts)
            local v22 = tostring(HttpSvc:JSONEncode(v20))

            -- InvokeServer("Save", ...) persis SaveDetailsClickLocal
            local v23, v24
            if #v22 > 3400000 then
                -- Chunked save
                SF:InvokeServer("Save","start")
                for i=1,10 do
                    local chunk = v22:sub((i-1)*3400000+1, i*3400000)
                    if not chunk or #chunk<=0 then break end
                    SF:InvokeServer("Save", chunk)
                    task.wait()
                end
                v23,v24 = SF:InvokeServer("Save","end", v18, v_u_14, v_u_13)
            else
                v23,v24 = SF:InvokeServer("Save", v20, v18, v_u_14, v_u_13)
            end

            v19:Destroy()

            if v23 then
                            if not v_u_13 then
                    -- ── Save biasa (tidak publish) ──
                    stLbl.Text="✓ Saved!"; stLbl.TextColor3=C.green
                    if wt then wt.Text="Saved!"; wt.Visible=true end
                    task.wait(1.2)
                    closeSavePanel()
                    if wt then task.wait(0.5); wt.Visible=false end
                else
                    -- ── Publish mode: lanjut ke panel publish ──
                    -- Persis CopyMap: v28=apiKey, v29={data=[places]}
                    stLbl.Text="Fetching places..."; stLbl.TextColor3=C.accA
                    if wt then wt.Text="Publish..."; wt.Visible=true end
                    local GetPlacesRF = slFolder:FindFirstChild("GetPlacesServerFunction")
                    local v28, v29 = nil, nil
                    if GetPlacesRF then
                        local ok_gp, r1, r2 = pcall(function()
                            return GetPlacesRF:InvokeServer()
                        end)
                        if ok_gp then v28=r1; v29=r2 end
                    end
                    -- Sembunyikan savePanel, tampilkan publishPanel
                    closeSavePanel()
                    if wt then wt.Visible=false end
                    SL_doPublishPanel(v_u_12, v_u_14, v_u_13, v28, v29, SF, wt)
                end
            else
                local msg = tostring(v24 or "unknown error")
                stLbl.Text="❌ Save Failed: "..msg:sub(1,40)
                stLbl.TextColor3=C.red
                warn("[SL] Save failed:", v24)
                if wt then wt.Text="Save Failed"; wt.Visible=true end
                task.wait(4)
                _saveInProgress=false
                saveBtn.Text="Save"; saveBtn.BackgroundColor3=C.accB
                if wt then wt.Visible=false end
            end
        end)
    end)
end

local function showOSPanel(mode, items, osf)
    if _osPanelSG then pcall(function() _osPanelSG:Destroy() end) end
    _osPanelSG = nil

    local sg = Instance.new("ScreenGui")
    sg.Name = PFX.."OSPanel"; sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 180; sg.Enabled = true; sg.Parent = PlayerGui
    _osPanelSG = sg



    -- Panel TENGAH layar — ukuran seragam 280×480
    local PW=300
    local panel=Instance.new("Frame")
    panel.Name=PFX.."OSpanel"; panel.Size=UDim2.new(0,PW,0,300)
    panel.Position=UDim2.new(0.5,-PW/2,0.5,-150); panel.BackgroundColor3=C.bg0
    panel.BorderSizePixel=0; panel.ZIndex=11; panel.ClipsDescendants=true
    panel.Parent=sg
    do
        local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,8);u.Parent=panel
        local s=Instance.new("UIStroke");s.Color=C.accB;s.Thickness=1.5;s.Parent=panel
    end

    -- HEADER
    local hdr=Instance.new("Frame");hdr.Size=UDim2.new(1,0,0,44)
    hdr.BackgroundColor3=C.bg1;hdr.BorderSizePixel=0;hdr.ZIndex=12;hdr.Parent=panel
    do
        local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,8);u.Parent=hdr
        local g=Instance.new("UIGradient")
        g.Color=ColorSequence.new(Color3.fromRGB(50,50,50),Color3.fromRGB(24,24,24))
        g.Rotation=90;g.Parent=hdr
        local ac=Instance.new("Frame");ac.Size=UDim2.new(1,0,0,2)
        ac.Position=UDim2.new(0,0,1,-2);ac.BackgroundColor3=C.accB
        ac.BorderSizePixel=0;ac.ZIndex=13;ac.Parent=hdr
    end

    local hIco=Instance.new("TextLabel");hIco.Size=UDim2.new(0,26,1,0)
    hIco.Position=UDim2.new(0,10,0,0);hIco.BackgroundTransparency=1
    hIco.Text=mode=="Save" and "↓" or "←";hIco.TextSize=20;hIco.Font=Enum.Font.GothamBold
    hIco.TextColor3=C.accA
    hIco.TextYAlignment=Enum.TextYAlignment.Center;hIco.ZIndex=14;hIco.Parent=hdr

    local hTxt=Instance.new("TextLabel");hTxt.Size=UDim2.new(1,-90,1,0)
    hTxt.Position=UDim2.new(0,42,0,0);hTxt.BackgroundTransparency=1
    hTxt.Text=mode=="Save" and "Save Place" or "Open Place"
    hTxt.TextColor3=C.txtP;hTxt.Font=Enum.Font.GothamBold;hTxt.TextSize=14
    hTxt.TextXAlignment=Enum.TextXAlignment.Left;hTxt.TextYAlignment=Enum.TextYAlignment.Center
    hTxt.ZIndex=14;hTxt.Parent=hdr
    hdr.Active=true
    SL_addDrag(hdr, panel)

    local bdg=Instance.new("Frame");bdg.Size=UDim2.new(0,24,0,18)
    bdg.Position=UDim2.new(1,-64,0.5,-9);bdg.BackgroundColor3=C.bg4
    bdg.BorderSizePixel=0;bdg.ZIndex=14;bdg.Parent=hdr
    do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,9);u.Parent=bdg end
    local bdgL=Instance.new("TextLabel");bdgL.Size=UDim2.new(1,0,1,0)
    bdgL.BackgroundTransparency=1;bdgL.Text=tostring(#items)
    bdgL.TextColor3=C.txtS;bdgL.Font=Enum.Font.GothamBold;bdgL.TextSize=10
    bdgL.ZIndex=15;bdgL.Parent=bdg

    local closeBtn=Instance.new("TextButton")
    closeBtn.Size=UDim2.new(0,28,0,26);closeBtn.Position=UDim2.new(1,-34,0.5,-13)
    closeBtn.BackgroundColor3=C.red;closeBtn.BackgroundTransparency=0.2
    closeBtn.BorderSizePixel=0;closeBtn.Text="✕";closeBtn.TextColor3=C.txtP
    closeBtn.Font=Enum.Font.GothamBold;closeBtn.TextSize=13
    closeBtn.AutoButtonColor=false;closeBtn.ZIndex=14;closeBtn.Parent=hdr
    do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,5);u.Parent=closeBtn end

    local function closePanel()
        pcall(function() sg:Destroy() end); _osPanelSG=nil
    end
    closeBtn.MouseEnter:Connect(function() pcall(function() tw(closeBtn,FAST,{BackgroundTransparency=0}) end) end)
    closeBtn.MouseLeave:Connect(function() pcall(function() tw(closeBtn,FAST,{BackgroundTransparency=0.2}) end) end)
    closeBtn.MouseButton1Click:Connect(closePanel)

    -- SAVE AS NEW
    local cY=46
    if mode=="Save" then
        local saBtn=Instance.new("TextButton")
        saBtn.Size=UDim2.new(1,-14,0,32);saBtn.Position=UDim2.new(0,7,0,cY)
        saBtn.BackgroundColor3=C.accB;saBtn.BackgroundTransparency=0
        saBtn.BorderSizePixel=0;saBtn.Text="＋   Save As New"
        saBtn.TextColor3=C.txtP;saBtn.Font=Enum.Font.GothamBold;saBtn.TextSize=13
        saBtn.AutoButtonColor=false;saBtn.ZIndex=12;saBtn.Parent=panel
        do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,6);u.Parent=saBtn end
        saBtn.MouseEnter:Connect(function() pcall(function() tw(saBtn,FAST,{BackgroundColor3=C.accA}) end) end)
        saBtn.MouseLeave:Connect(function() pcall(function() tw(saBtn,FAST,{BackgroundColor3=C.accB}) end) end)
        saBtn.MouseButton1Click:Connect(function()
            closePanel()
            -- ══════════════════════════════════════════════════════════════
            -- Save As New: slot baru (slotNum = "")
            -- V5 handle save sendiri — tidak bergantung SaveDetailsClickLocal
            -- karena SaveDetailsClickLocal.v_u_8 = nil saat game start
            -- (SaveDetailsFrame masih di Game10, bukan di StudioGui)
            -- ══════════════════════════════════════════════════════════════
            SL_doSavePanel("", "", false, "")
        end)
        cY=cY+38
    end

    -- Sub-header
    local subH=Instance.new("TextLabel");subH.Size=UDim2.new(1,-16,0,14)
    subH.Position=UDim2.new(0,8,0,cY+2);subH.BackgroundTransparency=1
    subH.Text="SAVED PLACES";subH.TextColor3=C.txtD
    subH.Font=Enum.Font.GothamBold;subH.TextSize=9
    subH.TextXAlignment=Enum.TextXAlignment.Left;subH.ZIndex=12;subH.Parent=panel
    local dvL=Instance.new("Frame");dvL.Size=UDim2.new(1,-16,0,1)
    dvL.Position=UDim2.new(0,8,0,cY+16);dvL.BackgroundColor3=C.bdrB
    dvL.BackgroundTransparency=0.5;dvL.BorderSizePixel=0;dvL.ZIndex=12;dvL.Parent=panel
    cY=cY+20

    -- SCROLL — isi sisa ruang panel
    local scroll=Instance.new("ScrollingFrame")
    scroll.Size=UDim2.new(1,-6,1,-(cY+6));scroll.Position=UDim2.new(0,3,0,cY+4)
    scroll.BackgroundTransparency=1;scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=4;scroll.ScrollBarImageColor3=C.accB
    scroll.CanvasSize=UDim2.new(0,0,0,0);scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll.ZIndex=12;scroll.Parent=panel
    do
        local ll=Instance.new("UIListLayout");ll.SortOrder=Enum.SortOrder.LayoutOrder
        ll.Padding=UDim.new(0,4);ll.Parent=scroll
        local lp=Instance.new("UIPadding");lp.PaddingTop=UDim.new(0,4)
        lp.PaddingBottom=UDim.new(0,6);lp.PaddingLeft=UDim.new(0,4)
        lp.PaddingRight=UDim.new(0,4);lp.Parent=scroll
    end

    -- ROWS
    if #items==0 then
        local em=Instance.new("TextLabel");em.Size=UDim2.new(1,-8,0,50)
        em.BackgroundTransparency=1;em.Text="Belum ada place tersimpan"
        em.TextColor3=C.txtD;em.Font=Enum.Font.Gotham;em.TextSize=12
        em.TextXAlignment=Enum.TextXAlignment.Center;em.ZIndex=13;em.Parent=scroll
    else
        for idx,gameFrame in ipairs(items) do
            local gameName="Unnamed"; local saveDate=""; local slotNum=idx

            -- Baca data persis seperti OpenSaveButtonClickLocal baca:
            -- p5 = gameFrame (frame "Game1" dst)
            -- v6 = p5:WaitForChild("Frame1"):WaitForChild("GameTitleTextLabel")
            local f1=gameFrame:FindFirstChild("Frame1")
            if f1 then
                local t=f1:FindFirstChild("GameTitleTextLabel")
                if t and t.Text~="" and t.Text~="GameTitle" then gameName=t.Text end
            end
            local f3=gameFrame:FindFirstChild("Frame3")
            if f3 then
                local d=f3:FindFirstChild("DescriptionTextLabel")
                if d and d.Text~="" then saveDate=d.Text end
            end
            -- Slot string dari nama: "Game5" → "5" (HARUS string, bukan number)
            -- CopyMap: v21 = v_u_2.Name:match("(%a+)(%d.*)") → string, lalu InvokeServer(..., v21)
            local _alpha, slotStr = gameFrame.Name:match("(%a+)(%d.*)")
            if slotStr then
                slotNum = slotStr  -- STRING "5", sama persis dengan CopyMap asli
            else
                slotNum = tostring(idx)  -- fallback tetap string
            end

            -- Cari OpenSaveButton yang punya LocalScript di dalamnya
            local nBtn=f1 and f1:FindFirstChild("OpenSaveButton")

            -- ══════════════════════════════════════════════════════
            -- ROW CARD — AutomaticSize Y agar expand dalam row sendiri
            -- Struktur: row (AutomaticSize) berisi:
            --   topPart (62px): badge + nama + Open btn + More btn
            --   expandPart (visible=false): tanggal + Share + Delete
            -- ══════════════════════════════════════════════════════
            local row=Instance.new("Frame");row.Name=PFX.."Row"..idx
            row.Size=UDim2.new(1,-2,0,0)  -- tinggi auto
            row.AutomaticSize=Enum.AutomaticSize.Y
            row.BackgroundColor3=C.bg2
            row.BackgroundTransparency=0;row.BorderSizePixel=0
            row.LayoutOrder=idx*2;row.ZIndex=13;row.ClipsDescendants=false
            row.Parent=scroll
            do
                local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,7);u.Parent=row
                local s=Instance.new("UIStroke");s.Color=C.bdrB;s.Thickness=1
                s.Transparency=0.5;s.Parent=row
                -- UIListLayout vertikal di dalam row
                local ll=Instance.new("UIListLayout");ll.SortOrder=Enum.SortOrder.LayoutOrder
                ll.Padding=UDim.new(0,0);ll.Parent=row
            end

            -- ── TOP PART (selalu terlihat, 62px) ──────────────────
            local topPart=Instance.new("Frame");topPart.Name="TopPart"
            topPart.Size=UDim2.new(1,0,0,62);topPart.BackgroundTransparency=1
            topPart.BorderSizePixel=0;topPart.LayoutOrder=1;topPart.ZIndex=13
            topPart.Parent=row

            -- Aksen kiri biru
            local acL=Instance.new("Frame");acL.Size=UDim2.new(0,3,0,44)
            acL.Position=UDim2.new(0,0,0,9);acL.BackgroundColor3=C.accB
            acL.BackgroundTransparency=0.3;acL.BorderSizePixel=0;acL.ZIndex=14;acL.Parent=topPart
            do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,2);u.Parent=acL end

            -- Badge nomor
            local nb=Instance.new("Frame");nb.Size=UDim2.new(0,26,0,26)
            nb.Position=UDim2.new(0,10,0,18);nb.BackgroundColor3=C.accB
            nb.BorderSizePixel=0;nb.ZIndex=14;nb.Parent=topPart
            do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,13);u.Parent=nb end
            local nbL=Instance.new("TextLabel");nbL.Size=UDim2.new(1,0,1,0)
            nbL.BackgroundTransparency=1;nbL.Text=tostring(slotNum)
            nbL.TextColor3=C.txtP;nbL.Font=Enum.Font.GothamBold;nbL.TextSize=12
            nbL.ZIndex=15;nbL.Parent=nb

            -- Nama game
            local nL=Instance.new("TextLabel");nL.Size=UDim2.new(1,-100,0,20)
            nL.Position=UDim2.new(0,44,0,10);nL.BackgroundTransparency=1
            nL.Text=gameName;nL.TextColor3=C.txtP;nL.Font=Enum.Font.GothamBold
            nL.TextSize=13;nL.TextXAlignment=Enum.TextXAlignment.Left
            nL.TextTruncate=Enum.TextTruncate.AtEnd;nL.ZIndex=14;nL.Parent=topPart

            -- More/Less button — di bawah nama, kiri
            local moreBtn=Instance.new("TextButton")
            moreBtn.Size=UDim2.new(0,48,0,16);moreBtn.Position=UDim2.new(0,44,0,32)
            moreBtn.BackgroundColor3=C.bg4;moreBtn.BackgroundTransparency=0.2
            moreBtn.BorderSizePixel=0;moreBtn.Text="More…";moreBtn.TextColor3=C.accA
            moreBtn.Font=Enum.Font.GothamBold;moreBtn.TextSize=9
            moreBtn.AutoButtonColor=false;moreBtn.ZIndex=14;moreBtn.Parent=topPart
            do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,4);u.Parent=moreBtn end

            -- Tombol Open/Save — kanan atas
            local actBtn=Instance.new("TextButton")
            actBtn.Size=UDim2.new(0,68,0,26);actBtn.Position=UDim2.new(1,-74,0,18)
            actBtn.BackgroundColor3=C.accB;actBtn.BackgroundTransparency=0
            actBtn.BorderSizePixel=0;actBtn.Text=mode;actBtn.TextColor3=C.txtP
            actBtn.Font=Enum.Font.GothamBold;actBtn.TextSize=12
            actBtn.AutoButtonColor=false;actBtn.ZIndex=14;actBtn.Parent=topPart
            do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,5);u.Parent=actBtn end

            actBtn.MouseEnter:Connect(function()
                pcall(function() tw(actBtn,FAST,{BackgroundColor3=C.accA}) end)
            end)
            actBtn.MouseLeave:Connect(function()
                pcall(function() tw(actBtn,FAST,{BackgroundColor3=C.accB}) end)
            end)
            actBtn.MouseButton1Click:Connect(function()
                closePanel()
                if mode=="Open" then
                    -- ══════════════════════════════════════════════════════
                    -- SYNC 100% dengan CopyMap OpenSaveButtonClickLocal:
                    --   LoadGame(p4, p5)
                    --   p4 = string "5" dari match("(%a+)(%d.*)")  → slotNum sudah string
                    --   p5 = gameFrame (Frame "Game5")
                    --   v6 = p5.Frame1.GameTitleTextLabel
                    --   InvokeServer("LoadDbGameToPlayerGui", p4)
                    --   v8:ClearWorkspace()
                    --   v9:Load(PlayerGui:FindFirstChild(v6.Text))  ← cari by GAME TITLE TEXT
                    --   v10:Edit()
                    --   InvokeServer("ClearGameFromPlayerGui")
                    -- ══════════════════════════════════════════════════════
                    task.spawn(function()
                        local ok,err = pcall(function()
                            local pg  = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
                            local sg2 = pg:WaitForChild("StudioGui", 9)
                            if not sg2 then return end
                            local sf  = game:GetService("ReplicatedStorage")
                                :WaitForChild("StudioLiteFolder")
                                :WaitForChild("ServerFunctions")
                            -- v6.Text = GameTitleTextLabel.Text (sama persis CopyMap)
                            local titleText = (f1 and f1:FindFirstChild("GameTitleTextLabel")
                                and f1.GameTitleTextLabel.Text ~= ""
                                and f1.GameTitleTextLabel.Text)
                                or ("Game"..tostring(slotNum))
                            -- WarningText (v11 di CopyMap)
                            local wt = sg2:FindFirstChild("WarningText")
                            -- CopyMap: v7.OpenSaveFrame.Visible = false
                            local osf2 = sg2:FindFirstChild("OpenSaveFrame")
                            if osf2 then osf2.Visible = false end
                            if wt then wt.Text = "Loading "..titleText.."..."; wt.Visible = true end
                            -- CopyMap: v_u_3:InvokeServer("LoadDbGameToPlayerGui", p4)
                            -- p4 = slotNum = STRING "5" (sudah difix di Bug #1)
                            sf:InvokeServer("LoadDbGameToPlayerGui", slotNum)
                            -- CopyMap: v8:ClearWorkspace()
                            local cwm = sg2:WaitForChild("ClearClientWorkspaceModule", 9)
                            if cwm then require(cwm):ClearWorkspace() end
                            -- CopyMap: v9:Load(PlayerGui:FindFirstChild(v6.Text))
                            -- PENTING: dicari berdasarkan GameTitleTextLabel.Text bukan "Game5"
                            local loadedGame = pg:FindFirstChild(titleText)
                            local cpg = sg2:WaitForChild("ClonePathGameToLocalWorkspaceModule", 9)
                            if cpg and loadedGame then
                                require(cpg):Load(loadedGame)
                            end
                            -- CopyMap: v10:Edit()
                            local cse = sg2:WaitForChild("CloneStarterGuiForEditOrPlayModule", 9)
                            if cse then require(cse):Edit() end
                            -- CopyMap: v11.Text = "Ready"
                            if wt then wt.Text = "Ready" end
                            -- CopyMap: InvokeServer("ClearGameFromPlayerGui")
                            sf:InvokeServer("ClearGameFromPlayerGui")
                            task.wait(1)
                            if wt then wt.Visible = false end
                        end)
                        if not ok then warn("[Plugin] LoadGame error:", err) end
                    end)
                elseif mode=="Save" then
                    -- ══════════════════════════════════════════════════════════════
                    -- Save slot existing: V5 handle sendiri tanpa SaveDetailsClickLocal
                    -- Ambil data dari gameFrame → tampilkan panel form V5 → submit
                    -- ══════════════════════════════════════════════════════════════
                    local v14 = gameFrame:FindFirstChild("Frame1") and
                                gameFrame.Frame1:FindFirstChild("GameTitleTextLabel")
                    local v15 = gameFrame:FindFirstChild("Frame3") and
                                gameFrame.Frame3:FindFirstChild("DescriptionTextLabel")
                    local v16 = gameFrame:FindFirstChild("Frame3") and
                                gameFrame.Frame3:FindFirstChild("PublishedTFValue")
                    local v17 = gameFrame:FindFirstChild("Frame4") and
                                gameFrame.Frame4:FindFirstChild("ShareFromOwnerStringValue")
                    local initName    = v14 and v14.Text or ""
                    local initDesc    = v15 and v15.Text or ""
                    local initPub     = v16 and v16.Value or false
                    local initOwner   = v17 and v17.Value or ""
                    SL_doSavePanel(tostring(slotNum), initName, initPub, initDesc)
                end
            end)

            -- ── Expand section (di dalam row, LayoutOrder=2) ─────────────
            -- Saat expanded=true: muncul di bawah topPart dalam row yang sama
            local expanded = false

            -- expandPart: frame di dalam row, awalnya hidden
            -- Berisi: tanggal (kiri) + Share btn + Delete btn
            local expandPart=Instance.new("Frame");expandPart.Name="ExpandPart"
            expandPart.Size=UDim2.new(1,0,0,36);expandPart.BackgroundColor3=C.bg3
            expandPart.BackgroundTransparency=0.5;expandPart.BorderSizePixel=0
            expandPart.LayoutOrder=2;expandPart.Visible=false;expandPart.ZIndex=13
            expandPart.Parent=row
            do
                -- Garis pemisah atas
                local divLine=Instance.new("Frame");divLine.Size=UDim2.new(1,-12,0,1)
                divLine.Position=UDim2.new(0,6,0,0);divLine.BackgroundColor3=C.bdrB
                divLine.BackgroundTransparency=0.4;divLine.BorderSizePixel=0
                divLine.ZIndex=14;divLine.Parent=expandPart
            end

            -- Tanggal save di expand
            local exDate=Instance.new("TextLabel")
            exDate.Size=UDim2.new(0.45,0,1,-2);exDate.Position=UDim2.new(0,10,0,1)
            exDate.BackgroundTransparency=1
            exDate.Text=saveDate;exDate.TextColor3=C.txtD;exDate.Font=Enum.Font.Gotham
            exDate.TextSize=9;exDate.TextXAlignment=Enum.TextXAlignment.Left
            exDate.TextYAlignment=Enum.TextYAlignment.Center;exDate.ZIndex=14
            exDate.TextTruncate=Enum.TextTruncate.AtEnd;exDate.Parent=expandPart

            -- Tombol Share
            local shareBtn=Instance.new("TextButton")
            shareBtn.Size=UDim2.new(0,58,0,24);shareBtn.Position=UDim2.new(0.45,4,0.5,-12)
            shareBtn.BackgroundColor3=C.accB;shareBtn.BackgroundTransparency=0
            shareBtn.BorderSizePixel=0;shareBtn.Text="Share";shareBtn.TextColor3=C.txtP
            shareBtn.Font=Enum.Font.GothamBold;shareBtn.TextSize=11
            shareBtn.AutoButtonColor=false;shareBtn.ZIndex=14;shareBtn.Parent=expandPart
            do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,5);u.Parent=shareBtn end

            -- Tombol Delete
            local delBtn=Instance.new("TextButton")
            delBtn.Size=UDim2.new(0,58,0,24);delBtn.Position=UDim2.new(1,-64,0.5,-12)
            delBtn.BackgroundColor3=C.red;delBtn.BackgroundTransparency=0.15
            delBtn.BorderSizePixel=0;delBtn.Text="Delete";delBtn.TextColor3=C.txtP
            delBtn.Font=Enum.Font.GothamBold;delBtn.TextSize=11
            delBtn.AutoButtonColor=false;delBtn.ZIndex=14;delBtn.Parent=expandPart
            do local u=Instance.new("UICorner");u.CornerRadius=UDim.new(0,5);u.Parent=delBtn end

            -- More/Less toggle: show/hide expandPart di dalam row
            moreBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                expandPart.Visible = expanded
                moreBtn.Text = expanded and "Less…" or "More…"
                moreBtn.TextColor3 = expanded and C.txtS or C.accA
            end)

            -- Share logic: persis CopyMap ShareClickLocal
            -- InvokeServer("ShareWith", friendId, slotNum) / "Unshare"
            shareBtn.MouseButton1Click:Connect(function()
                if shareBtn.Text == "Unshare" then
                    shareBtn.Text="…"; exDate.Text="Unsharing..."
                    local SF2=game:GetService("ReplicatedStorage")
                        :WaitForChild("StudioLiteFolder"):WaitForChild("ServerFunctions")
                    pcall(function() SF2:InvokeServer("Unshare", slotNum) end)
                    shareBtn.Text="Share"; exDate.Text=saveDate
                    return
                end
                -- Tampilkan panel teman
                SL_doFriendsPanel(slotNum, shareBtn, exDate, saveDate)
            end)

            -- Delete logic: persis CopyMap DeleteClickLocal
            -- Confirm via _G.DialogAnswer → InvokeServer("Delete", slotNum)
            delBtn.MouseButton1Click:Connect(function()
                task.spawn(function()
                    -- Confirm dialog seperti CopyMap
                    _G.DialogAnswer = "?"
                    local dlg=game:GetService("Players").LocalPlayer
                        :WaitForChild("PlayerGui")
                        :WaitForChild("StudioGui",9)
                        :WaitForChild("DialogYesNoFrame")
                    if dlg then
                        dlg:WaitForChild("YesNoTextLabel").Text =
                            "Delete [" .. gameName .. "]? This cannot be undone."
                        dlg.Visible = true
                        while _G.DialogAnswer == "?" do task.wait(0.2) end
                        if _G.DialogAnswer == "Yes" then
                            exDate.Text="Deleting..."
                            delBtn.Visible=false; shareBtn.Visible=false
                            local SF2=game:GetService("ReplicatedStorage")
                                :WaitForChild("StudioLiteFolder"):WaitForChild("ServerFunctions")
                            pcall(function() SF2:InvokeServer("Delete", tonumber(slotNum)) end)
                            task.wait(1.5)
                            row:Destroy()
                        end
                    end
                end)
            end)

            -- Hover hitbox (di topPart)
            local hbx=Instance.new("TextButton");hbx.Size=UDim2.new(1,-80,1,0)
            hbx.Position=UDim2.new(0,0,0,0);hbx.BackgroundTransparency=1
            hbx.Text="";hbx.AutoButtonColor=false;hbx.ZIndex=13;hbx.Parent=topPart
            hbx.MouseEnter:Connect(function() pcall(function() tw(topPart,FAST,{BackgroundColor3=C.bg3}) end) end)
            hbx.MouseLeave:Connect(function() pcall(function() tw(topPart,FAST,{BackgroundColor3=C.bg2}) end) end)
        end
    end
end

-- ══════════════════════════════════════════════
--  MENUBAR TAKEOVER v1.0
--  • Nonaktifkan tombol FILE, SPLASH, "Back to Growing Up"
--  • Buat tombol custom NEW, OPEN, SAVE di posisinya
--  • Tombol custom memanggil klik bawaan Studio Lite yg sesuai
-- ══════════════════════════════════════════════
local menubarDone = false

local function findMenubar()
    -- Path tepat dari analisis RBXL CopyMap:
    --   StudioGui → TopBar (Frame) → File (TextButton) + FileMenu (Frame)
    -- Prioritas 1: nama persis "TopBar" langsung di bawah StudioGui
    local topBar = StudioGui:FindFirstChild("TopBar")
    if topBar and topBar:IsA("Frame") and topBar:FindFirstChild("FileMenu") then
        return topBar
    end
    -- Prioritas 2: scan GetChildren() langsung (1 level)
    for _, obj in ipairs(StudioGui:GetChildren()) do
        if not isOwn(obj) and obj:IsA("Frame") then
            if obj:FindFirstChild("File") and obj:FindFirstChild("FileMenu") then
                return obj
            end
        end
    end
    -- Prioritas 3: scan lebih dalam
    for _, obj in ipairs(StudioGui:GetDescendants()) do
        if not isOwn(obj) and obj:IsA("Frame") then
            if obj:FindFirstChild("File") and obj:FindFirstChild("FileMenu") then
                return obj
            end
        end
    end
    return nil
end

local function injectMenubarTakeover()
    if menubarDone then return end
    local mb = findMenubar()
    if not mb then return end
    -- Toolbar (MainBar) referensi untuk trigger tombol bawaan
    local tb = _SL.findToolbar and _SL.findToolbar()

    -- ── ① HIDE SEMUA anak menubar bawaan (FILE, SPLASH, Back to Growing Up, dst) ──
    for _, ch in ipairs(mb:GetChildren()) do
        if not isOwn(ch) then
            pcall(function()
                ch.Visible = false
                ch:GetPropertyChangedSignal("Visible"):Connect(function()
                    task.defer(function()
                        pcall(function() if ch.Visible and not isOwn(ch) then ch.Visible = false end end)
                    end)
                end)
            end)
        end
    end
    mb.ChildAdded:Connect(function(ch)
        task.defer(function()
            if not isOwn(ch) then
                pcall(function() ch.Visible = false end)
            end
        end)
    end)

    -- ── ② Trigger New/Open/Save — jalankan logic FileMenuClickLocal langsung ──
    --
    -- PENTING: MouseButton1Click:Fire() dari LocalScript TIDAK bisa mentrigger
    -- listener LocalScript lain. Fire() hanya bekerja dari server Script.
    --
    -- Solusi: Replikasi logic FileMenuClickLocal bawaan Studio Lite secara langsung.
    -- Berdasarkan analisis source FileMenuClickLocal di RBXL CopyMap:
    --
    --   New  → set _G.DialogAnswer="?", tampilkan DialogYesNoFrame
    --   Open → ServerFunctions:InvokeServer("OpenMenu", timezone_offset)
    --   Save → ServerFunctions:InvokeServer("SaveMenu", timezone_offset)
    --
    -- ServerFunctions = ReplicatedStorage.StudioLiteFolder.ServerFunctions (RemoteFunction)
    -- Setelah InvokeServer, server akan populate OpenSaveFrame lalu set Visible=true.

    -- Helper: cari TopBar dari StudioGui
    local function getSLTopBar()
        local t = StudioGui:FindFirstChild("TopBar")
        if t and t:IsA("Frame") then return t end
        for _, obj in ipairs(StudioGui:GetChildren()) do
            if not isOwn(obj) and obj:IsA("Frame") and obj:FindFirstChild("FileMenu") then
                return obj
            end
        end
        return nil
    end

    -- Helper: sembunyikan semua frame popup (sama seperti FileClickLocal bawaan)
    local function closeAllPopups()
        local topBar = getSLTopBar()
        local function hide(parent, name2)
            if not parent then return end
            local f = parent:FindFirstChild(name2)
            if f then pcall(function() f.Visible = false end) end
        end
        hide(StudioGui, "SplashFrame")
        hide(StudioGui, "OpenSaveFrame")
        hide(StudioGui, "ViewScriptFrame")
        hide(StudioGui, "ToolboxFrame")
        hide(StudioGui, "InsertScriptFrame")
        hide(StudioGui, "InsertLocalScriptFrame")
        local mainBar = StudioGui:FindFirstChild("MainBar")
        if mainBar then hide(mainBar, "sel") end
        if topBar then
            hide(topBar, "FileMenu")
            hide(topBar, "OpenSamplesMenu")
            hide(topBar, "SaveDetailsFrame")
        end
    end

    -- Helper: dapatkan ServerFunctions RemoteFunction
    local function getServerFunctions()
        local rs = game:GetService("ReplicatedStorage")
        local slFolder = rs:FindFirstChild("StudioLiteFolder")
        if not slFolder then return nil end
        return slFolder:FindFirstChild("ServerFunctions")
    end

    -- Helper: timezone offset (sama seperti FileMenuClickLocal bawaan)
    local function getTZ()
        return os.time(os.date("*t")) - os.time(os.date("!*t"))
    end

    local function triggerNative(name)
        task.spawn(function()
            closeAllPopups()
            task.wait(0.05)

            if name == "New" then
                pcall(function()
                    _G.DialogAnswer = "?"
                    local dlg = StudioGui:WaitForChild("DialogYesNoFrame", 5)
                    if dlg then
                        local lbl = dlg:FindFirstChild("YesNoTextLabel")
                        if lbl then lbl.Text = "Clear workspace and restart with a fresh baseplate?" end
                        dlg.Visible = true
                    end
                end)

            elseif name == "Open" or name == "Save" then
                -- ════════════════════════════════════════════════════════
                -- TEMUAN DARI ANALISIS RBXL + GUICOPY (100% akurat):
                --
                -- main.lua startup:
                --   local v_u_204 = v202.Parent:WaitForChild("OpenSaveFrame")
                --   → referensi disimpan di startup, server populate v_u_204 ini
                --
                -- FileMenuClickLocal:
                --   local v_u_3 = script.Parent.Parent.Parent:WaitForChild("OpenSaveFrame")
                --   → juga cache ke frame ASLI di startup
                --   → InvokeServer("OpenMenu") → server populate & set Visible=true
                --
                -- Server (Roblox live) saat terima "OpenMenu"/"SaveMenu":
                --   1. Clone OpenSaveTemplate dalam ScrollingFrame
                --   2. Rename clone jadi "Game1","Game2" dst
                --   3. Set Frame1.GameTitleTextLabel.Text = nama game
                --   4. Set Frame3.DescriptionTextLabel.Text = tanggal
                --   5. Set OpenSaveFrame.Visible = true  ← SINYAL KITA
                --
                -- STRATEGI: Click tombol ASLI (File→Open/Save) agar server
                -- populate frame asli. Watch Visible=true lalu intercept.
                -- ════════════════════════════════════════════════════════

                -- ① Cari OpenSaveFrame ASLI di StudioGui
                local osf = StudioGui:FindFirstChild("OpenSaveFrame")
                if not osf then
                    -- Fallback: scan descendants
                    for _, d in ipairs(StudioGui:GetDescendants()) do
                        if d.Name == "OpenSaveFrame" and d:IsA("Frame") then
                            osf = d; break
                        end
                    end
                end
                if not osf then
                    warn("[SL] OpenSaveFrame tidak ditemukan di StudioGui")
                    return
                end

                -- ② Pasang watcher SEBELUM trigger server
                --    Server akan set osf.Visible = true SETELAH data diisi
                local triggered = false
                local conn
                conn = osf:GetPropertyChangedSignal("Visible"):Connect(function()
                    if osf.Visible and not triggered then
                        triggered = true
                        conn:Disconnect()
                        task.defer(function()
                            -- Server sudah set Visible=true → data sudah ada di ScrollingFrame
                            osf.Visible = false  -- sembunyikan frame asli secepatnya
                            -- Kunci agar tidak muncul lagi
                            osf:GetPropertyChangedSignal("Visible"):Connect(function()
                                if osf.Visible then
                                    task.defer(function() pcall(function() osf.Visible = false end) end)
                                end
                            end)
                            -- Baca data dari ScrollingFrame yang sudah diisi server
                            local scroll = osf:FindFirstChild("ScrollingFrame")
                            local items = {}
                            if scroll then
                                for _, ch in ipairs(scroll:GetChildren()) do
                                    -- Server rename clone jadi "Game1","Game2" dll
                                    -- OpenSaveTemplate asli tetap ada tapi Visible=false
                                    if ch:IsA("Frame") and ch.Name ~= "OpenSaveTemplate"
                                       and ch.Name:match("^%a") then
                                        local f1 = ch:FindFirstChild("Frame1")
                                        if f1 and f1:FindFirstChild("GameTitleTextLabel") then
                                            items[#items+1] = ch
                                        end
                                    end
                                end
                            end
                                        -- Render panel premium
                            showOSPanel(name, items, osf)
                        end)
                    end
                end)

                -- ③ Timeout safety: kalau 10 detik tidak ada response
                task.delay(10, function()
                    if not triggered then
                        triggered = true
                        pcall(function() conn:Disconnect() end)
                        warn("[SL] Timeout menunggu OpenSaveFrame visible")
                    end
                end)

                -- ④ Trigger server dengan cara PERSIS seperti FileMenuClickLocal:
                --    Klik tombol File (toggle FileMenu) lalu klik Open/Save
                --    ATAU langsung InvokeServer (cara lebih bersih)
                local sf = getServerFunctions()
                if sf then
                    local tz = getTZ()
                    if name == "Save" then
                        sf:InvokeServer("SaveMenu", tz)
                                        else
                        sf:InvokeServer("OpenMenu", tz)
                                        end
                else
                    triggered = true
                    pcall(function() conn:Disconnect() end)
                    warn("[SL] ServerFunctions tidak ditemukan")
                end

            else
                warn("[SL v5.0] triggerNative: nama tidak dikenal: "..tostring(name))
            end
        end)
    end

    -- ── ③ Inject tombol NEW, OPEN, SAVE ke MENUBAR (atas, bukan toolbar) ──────
    -- Ukuran mengikuti tinggi menubar
    local MH = mb.AbsoluteSize.Y
    if MH < 6 then MH = 24 end

    local BH  = math.min(MH - 4, 22)
    local MENU_BTNS = {
        { label = "New",  key = "new",  name = "New",  col = C.txtP },
        { label = "Open", key = "open", name = "Open", col = C.txtP },
        { label = "Save", key = "save", name = "Save", col = C.accA },
    }

    -- Ukuran tombol — sesuaikan dengan tinggi menubar
    local BW  = 44
    local GAP = 2
    local startX = 4
    local curX = startX

    for _, def in ipairs(MENU_BTNS) do
        local existName = PFX.."MB_"..def.key
        local old = mb:FindFirstChild(existName)
        if old then old:Destroy() end

        local cont = Instance.new("Frame")
        cont.Name               = existName
        cont.Size               = UDim2.new(0, BW, 0, BH)
        cont.Position           = UDim2.new(0, curX, 0.5, -math.floor(BH/2))
        cont.BackgroundColor3   = C.bg3
        cont.BackgroundTransparency = 0.1
        cont.BorderSizePixel    = 0
        cont.ZIndex             = 8
        cont.Parent             = mb
        corner(cont, 4)

        -- Garis bawah dekoratif untuk Save (accent biru)
        if def.key == "save" then
            local line = Instance.new("Frame")
            line.Name = PFX.."Line"
            line.Size = UDim2.new(1, 0, 0, 2)
            line.Position = UDim2.new(0, 0, 1, -2)
            line.BackgroundColor3 = C.accA
            line.BackgroundTransparency = 0
            line.BorderSizePixel = 0
            line.ZIndex = 9
            line.Parent = cont
        end

        local lbl = Instance.new("TextLabel")
        lbl.Name                = PFX.."Lbl"
        lbl.Size                = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text                = def.label
        lbl.TextColor3          = def.col
        lbl.Font                = Enum.Font.GothamBold
        lbl.TextSize            = 11
        lbl.TextXAlignment      = Enum.TextXAlignment.Center
        lbl.TextYAlignment      = Enum.TextYAlignment.Center
        lbl.ZIndex              = 9
        lbl.Parent              = cont

        local btn = Instance.new("TextButton")
        btn.Name                = PFX.."Click"
        btn.Size                = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text                = ""
        btn.ZIndex              = 10
        btn.AutoButtonColor     = false
        btn.Parent              = cont

        local nativeName = def.name
        btn.MouseEnter:Connect(function()
            pcall(function()
                cont.BackgroundColor3     = C.accB
                cont.BackgroundTransparency = 0
                lbl.TextColor3 = C.txtP
            end)
        end)
        btn.MouseLeave:Connect(function()
            pcall(function()
                cont.BackgroundColor3     = C.bg3
                cont.BackgroundTransparency = 0.1
                lbl.TextColor3 = def.col
            end)
        end)
        btn.MouseButton1Down:Connect(function()
            pcall(function()
                cont.BackgroundColor3 = C.accC
                cont.BackgroundTransparency = 0
            end)
        end)
        btn.MouseButton1Click:Connect(function()
            pcall(function()
                cont.BackgroundColor3 = C.bg3
                cont.BackgroundTransparency = 0.1
            end)
            triggerNative(nativeName)
        end)

        curX = curX + BW + GAP
    end

    menubarDone = true
end

local function injectVoice()
    if voiceDone then return end
    local tb = _SL.findToolbar and _SL.findToolbar()
    if not tb then return end
    if tb:FindFirstChild(PFX.."Btn_Voice") then voiceDone=true; return end
    local curX = getMaxX(tb) + 16
    makeSep(tb, curX - 12)
    local function icoVoice(p,S,T)
        local cx = S/2
        drawSeg(p,cx-S*.12,S*.12, cx+S*.12,S*.12, T,C.accA,46)
        drawSeg(p,cx+S*.12,S*.12, cx+S*.12,S*.62, T,C.accA,46)
        drawSeg(p,cx+S*.12,S*.62, cx-S*.12,S*.62, T,C.accA,46)
        drawSeg(p,cx-S*.12,S*.62, cx-S*.12,S*.12, T,C.accA,46)
        for i=0,5 do
            local a1=(i/6)*math.pi; local a2=((i+1)/6)*math.pi
            local r=S*.22
            drawSeg(p, cx+math.cos(math.pi-a1)*r, S*.62+math.sin(math.pi-a1)*r*0.6,
                       cx+math.cos(math.pi-a2)*r, S*.62+math.sin(math.pi-a2)*r*0.6,
                       T, C.glow, 47)
        end
        drawSeg(p, cx,S*.82, cx,S*.92, T,C.accA,46)
        drawSeg(p, cx-S*.16,S*.92, cx+S*.16,S*.92, T,C.accA,46)
    end
    makePartBtn(tb, curX, "Voice", icoVoice, function()
        SL_doVoicePanel()
    end)
    voiceDone = true
end

-- ══════════════════════════════════════════════
--  STARTUP
-- ══════════════════════════════════════════════

task.spawn(function()
    themeAll(); styleScrollbars(); decoratePanels(); applyHoverAll()

    -- ── INJECT SEQUENTIAL: semua tombol masuk toolbar sama, satu per satu ──
    -- Urutan: native replace dulu → parts → terrain → plugin → toolbox → toolboxPC
    -- task.wait(0.05) antar step agar AbsoluteSize dan getMaxX selalu fresh
    pcall(injectNativeReplace)   -- takeover select/move/scale/rotate/play/toolbox bawaan
    task.wait(0.05)
    pcall(injectParts)           -- Balok/Bola/Silinder/Wedge/Corner
    task.wait(0.05)
    pcall(injectTerrain)         -- Terrain
    task.wait(0.05)
    pcall(injectPlugin)          -- Plugin (tools panel)
    task.wait(0.05)
    pcall(injectToolbox)         -- Toolbox (asset store)
    task.wait(0.05)
    pcall(injectToolboxPC)       -- Toolbox PC (creator panel)
    task.wait(0.05)
    pcall(injectVoice)           -- Voice Chat Toggle button

    task.wait(0.5)
    themeAll(); decoratePanels(); styleScrollbars()
    pcall(injectNativeReplace)   -- retry native (tombol yang load terlambat)

    -- ── RETRY sequential: cek via FindFirstChild agar akurat ──
    task.wait(0.5)
    pcall(injectNativeReplace)
    task.wait(0.05)
    local tb = _SL.findToolbar and _SL.findToolbar()
    if tb then
        if not tb:FindFirstChild(PFX.."Btn_Balok")    then pcall(injectParts)     end; task.wait(0.05)
        if not tb:FindFirstChild(PFX.."Btn_Terrain")  then pcall(injectTerrain)   end; task.wait(0.05)
        if not tb:FindFirstChild(PFX.."Btn_Plugin")   then pcall(injectPlugin)    end; task.wait(0.05)
        if not tb:FindFirstChild(PFX.."Btn_Toolbox")  then pcall(injectToolbox)   end; task.wait(0.05)
        if not tb:FindFirstChild(PFX.."Btn_ToolboxPC") then pcall(injectToolboxPC) end; task.wait(0.05)
        if not tb:FindFirstChild(PFX.."Btn_Voice")     then pcall(injectVoice)     end
    end

    task.wait(0.3)
    themeAll(); decoratePanels()

    keepAlive()
    startThemeWatcher()
    startWatcher()
    startPeriodicRefresh()
    pcall(startSnapPopupWatcher)  -- theme popup angka snap bawaan Studio Lite
    pcall(injectMenubarTakeover)  -- hide FILE/SPLASH/Back, inject NEW/OPEN/SAVE custom

    StudioGui.DescendantAdded:Connect(function(obj)
        task.defer(function()
            pcall(applyHover,obj)
            pcall(themeObj,  obj)
        end)
    end)

end)


end
_sl_block3()
