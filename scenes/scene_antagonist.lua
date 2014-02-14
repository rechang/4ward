---------------------------------------------------------------------------------
-- PAUSE SCENE
-- Scene notes go here

---------------------------------------------------------------------------------
require("classes.items")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local globals= require ("classes.globals") 

local antagonistAbility = math.random(1,2)
-- Clear previous scene
storyboard.removeAll()
 
-- local forward references should go here --
 
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
storyboard.showOverlay("scenes.scene_hud")
  local group = self.view
  local antagonist = display.newImage( "images/antag_Coat.png", 400, centerY+40, true )
  antagonist.height = 250
  antagonist.width = 190
  group:insert(antagonist)
  local textBox = display.newRect( antagonist.x-120, antagonist.y-100, 130, 75 )
  group:insert(textBox)
  
  local speech = display.newText( "", 0, 0, globals.IMPRIMA, 36 )
  if ( antagonistAbility == 1 ) then
	speech.text = "COMBO!"
  elseif ( antagonistAbility == 2 ) then
    speech.text = "SWAP!"
  end
  
  speech:setFillColor(black)
  speech.x = textBox.x
  speech.y = textBox.y
  group:insert( speech )
  local function resume()
	storyboard.hideOverlay( "slideRight", 800 )
  end
  
  timer.performWithDelay( 2000, resume )
  --startButton:addEventListener( "tap", onTap )
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
  if ( antagonistAbility == 1 ) then
	  if ( table.maxn( allEne ) > 0 ) then
		  local numFoodItems
		  for i = 1, table.maxn( items ) do
			if(items[i].itemType ~= "foodType") then break end
			numFoodItems = i
		  end
		  local randomEnemy = math.random(1, table.maxn( allEne ))
		  local randomFoodItem = math.random(1, numFoodItems)
		  local smoke = display.newImage( "images/smoke.png", allEne[randomEnemy].x, allEne[randomEnemy].y, true )
		  transition.to( smoke, { time=1500, alpha=0, onComplete=function() smoke:removeSelf()end } )
		  itemCombo(items[randomFoodItem], allEne[randomEnemy], false)
		  
		end
	elseif ( antagonistAbility == 2 ) then
		producerSwap()
	end
	
	storyboard.showOverlay("scenes.scene_hud")
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