---------------------------------------------------------------------------------
-- PAUSE SCENE
-- Scene notes go here

---------------------------------------------------------------------------------
 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require("classes.level")
local globals = require ("classes.globals")
local levelNumber
-- Clear previous scene
storyboard.removeAll()
 
-- local forward references should go here --
 
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
local function antagonistShow()
	storyboard.showOverlay("scenes.scene_antagonist", {effect = "slideLeft", time=500})
end
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
  local group = self.view
  local options = {
   effect = "fade",
   time = 500
}
  local bkg = display.newRect( centerX, centerY, display.contentWidth, display.contentHeight )
  bkg:setFillColor( gray )
  bkg.alpha = .5
  group:insert (bkg)

  local vicCond = event.params.vic
  levelNumber = event.params.levelNumber
  local globals = require("classes.globals")

 
  local function makeText()
	local title = display.newText( "Objectives:", display.contentWidth/2, (display.contentHeight/2) - 125, globals.LOBSTERTWO, 48 )
	group:insert (title)
  end
  --bkg:addEventListener("touch", function() return true end)
  --bkg:addEventListener("tap", function() return true end)

  local objBack = display.newRect( display.contentWidth/2, 170, 300, 200 )
  group:insert(objBack)

  local back = display.newRect( display.contentWidth/2, 290, 90, 30 )

  local function onTapBack( event )
    storyboard.hideOverlay( "slideUp", 500 )
    storyboard.showOverlay("scenes.scene_hud", {effect = "fade", time = 500})
    timer.resume(attackTimer)
    timer.resume(spawnEneTimer)
    for n=0, 2, 1 do
      globals.belts[n]:play()
  end
    transition.resume()
  end
  group:insert( back )
  back:addEventListener( "tap", onTapBack )

  local readyText= display.newText( "Ready!", display.contentWidth/2, 290, globals.LOBSTERTWO, 25 )
  readyText:setFillColor(black)
  group:insert(readyText)
  
  local function resume()
    storyboard.hideOverlay( "slideUp", 500 )
    storyboard.showOverlay("scenes.scene_hud", {effect = "fade", time = 500})
    timer.resume(attackTimer)
    timer.resume(spawnEneTimer)
    for n=0, 2, 1 do
      globals.belts[n]:play()
  end
    transition.resume()
  end
  timer.performWithDelay( 1000, makeText )
  --timer.performWithDelay( 5000, resume )

  --startButton:addEventListener( "tap", onTap )
  --standard objective: survive!
  local standardObj = display.newText("Survive!", display.contentWidth/2, (display.contentHeight/2) - 60, globals.IMPRIMA, 24)
  standardObj: setFillColor(black)
  group: insert(standardObj)

   -- checks for and prints a second condition
  if (vicCond ~= false) then
    -- print second condition here.
    local secObj = display.newText("Make " .. vicCond.amount .. " " .. vicCond.enemy.name.. ".", display.contentWidth/2, (display.contentHeight/2) - 30, globals.IMPRIMA, 20)
    if (vicCond.amount ~= 1) then
      secObj:removeSelf()
      secObj = display.newText("Make " .. vicCond.amount .. " " .. vicCond.enemy.name .. "s.", display.contentWidth/2, (display.contentHeight/2) - 30, globals.IMPRIMA, 20)
    end

    secObj: setFillColor(black)
    group: insert(secObj)
    --print("Make " .. vicCond.amount .. " " .. vicCond.enemy.name)
  end

end
-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
  local group = self.view
 
end
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view
 
end
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
  local group = self.view
  antagonistRandom = math.random(0, levelNumber)
  local antTime = math.random(5000, 15000)
  print (antagonistRandom)
  if(antagonistRandom~=0)then
	antagonistTimer = timer.performWithDelay ( antTime, antagonistShow )
  end
end
 
-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
  local group = self.view
 
end
 
-- Called prior to the removal of scene's "view" (display view)
function scene:destroyScene( event )
  local group = self.view
 
end
 
-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
  local group = self.view
  local overlay_name = event.sceneName  -- name of the overlay scene
 
end
 
-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
  local group = self.view
  local overlay_name = event.sceneName  -- name of the overlay scene
 
end
 
---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )
 
-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )
 
-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )
 
-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )
 
-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )
 
-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )
 
-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )
 
-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )
 
---------------------------------------------------------------------------------
 
return scene