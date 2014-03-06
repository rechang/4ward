---------------------------------------------------------------------------------
-- SCENE NAME
-- Scene notes go here
---------------------------------------------------------------------------------
 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local globals = require("classes.globals")
require("classes.levelUnlocking")
 
-- Clear previous scene
storyboard.removeAll()
 
-- local forward references should go here --
 
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
  local group = self.view
  local levelList = {}

  local bkg = display.newImage( "images/mockback1.png", centerX, centerY, true )
  bkg.height=display.contentHeight; bkg.width=display.contentWidth
  group:insert (bkg)

  local mapTitle = display.newText( "Challenge 1:", 0, 0, globals.LOBSTERTWO, 48 )
  mapTitle:setFillColor(black)
  mapTitle.x = display.contentCenterX
  mapTitle.y = 40
  group:insert( mapTitle )

  local mapTitle2 = display.newText( "The Basics", 0, 0, globals.IMPRIMA, 18 )
  mapTitle2:setFillColor(black)
  mapTitle2.x = display.contentCenterX
  mapTitle2.y = 80
  group:insert( mapTitle2 )
 
  local function onTapLevel( event )
    storyboard.removeScene( scene )
    storyboard.gotoScene( "scenes.scene_ingame",{ effect = "fade", time = 500, params = {level = event.target.id, world = 1}})
  end
  
  -- LEVEL NAMES --    
  levelList[1] = display.newText( "Step 1: Can you... Cook?", 0, 0, globals.IMPRIMA, 24 )
  levelList[2] = display.newText( "Step 2: Cake and Bake", 0, 0, globals.IMPRIMA, 24 )
  levelList[3] = display.newText( "Step 3: Food Suprise", 0, 0, globals.IMPRIMA, 24 )
  levelList[4] = display.newText( "Step 4: Certi-fried Chef", 0, 0, globals.IMPRIMA, 24 )

  for i = 1, LevelList.getNumOfLevels(1), 1 do
	if LevelList.isLevelUnlocked(1,i) == true then
		levelList[i]:setFillColor(black)
		levelList[i]:addEventListener( "tap", onTapLevel )
	else
		levelList[i]:setFillColor(1,.2,.2)
	end
	levelList[i].x = display.contentCenterX
	levelList[i].y = mapTitle.y + 40 + (30 * i)
	levelList[i].id = i
	group:insert( levelList[i])
  end


  local rightArrow = display.newImageRect( "images/rightArrow.png", 50, 50 )
  rightArrow.x = 455
  rightArrow.y = 153
  group:insert(rightArrow)

  if LevelList.worldUnlocked(2) ~= true then
     local lock = display.newImageRect( "images/lock.png", 50, 50 )
     lock.x = 455
     lock.y = 153
     group:insert(lock)
   end

  local bookIcon = display.newText( "Recipe Book", 80, 290, globals.LOBSTERTWO, 30 )
  bookIcon: setFillColor (black)
  group:insert(bookIcon)

  local storeButton = display.newText("Item Store", 410, 290, globals.LOBSTERTWO, 30)
  storeButton: setFillColor(black)
  group:insert(storeButton)

  local function onTapRightArrow( event )
    if LevelList.worldUnlocked(2) == true then
		storyboard.removeScene( scene )
		storyboard.gotoScene( "scenes.scene_worldmap2", {effect = "slideLeft", time = 500})
	end
  end
  -- to get to recipe book.
  local function onTapBookIcon( event )
    storyboard.removeScene( scene )
    storyboard.gotoScene( "scenes.scene_book", {effect = "fade", time = 500})
    storyboard.showOverlay("scenes.overlay_backButton", {effect = "fade", time = 500})
  end

  -- to get to the store
  local function onTapStoreButton( event )
    storyboard.removeScene( scene )
    storyboard.gotoScene( "scenes.scene_store", {effect = "fade", time = 500})
    storyboard.showOverlay("scenes.overlay_backButton", {effect = "fade", time = 500})
  end

  rightArrow:addEventListener("tap", onTapRightArrow)
  bookIcon:addEventListener("tap", onTapBookIcon)
  storeButton:addEventListener("tap", onTapStoreButton)

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