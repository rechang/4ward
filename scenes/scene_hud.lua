---------------------------------------------------------------------------------
-- HUD LUA
-- Scene notes go here
---------------------------------------------------------------------------------
 
local globals = require("classes.globals") 
local score = require("classes.score")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
 
-- Clear previous scene
storyboard.removeAll()
 
-- local forward references should go here --
 
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
  local group = self.view

    currencyText = globals.currency.init({
    fontSize = 20,
    font = "Helvetica",
    x = -84,
    y = -14,
    maxDigits = 7,
    leadingZeros = false,
    filename = "currencyfile.txt",
    })
  currencyText:setFillColor( black )
  group:insert(currencyText)

  -- SCORE --
  scoreGradient = display.newImage("images/scoreGradient2.png")
  scoreGradient.x = 15
  scoreGradient.y = display.contentHeight-5
  group:insert(scoreGradient)

  score = display.newText( "Score:", 30, display.contentHeight-15, globals.IMPRIMA, 18 )
  score:setFillColor(1,1,1)
  group:insert(score)

  scoreText = display.newText( globals.score, 70, display.contentHeight-15, globals.IMPRIMA, 20 )
  scoreText:setFillColor(1,1,1)
  group:insert(scoreText)

-- NUMBER OF LIVES
  hearts = display.newImage("images/lives.png")
  hearts.width = 50
  hearts.height = 25
  hearts.x = 30
  hearts.y = 15
  group:insert(hearts)

  numLives = display.newText( globals.lives, 40, 15, globals.LOBSTERTWO, 20)
  numLives:setFillColor(1,1,1)
  group:insert(numLives)

-- PAUSE BUTTON
  pauseGradient = display.newImage("images/scoreGradient2.png")
  pauseGradient.x = 515
  pauseGradient.y = 6
  group:insert(pauseGradient)

  local pauseButton = display.newImage("images/Pause.png")
  pauseButton.x = 475
  pauseButton.y = 24
  pauseButton.width = 8
  pauseButton.height = 8
  group:insert(pauseButton)

    -- MULTIPLIER --
  globals.multiplierText = display.newText( globals.multiplier, 460, 12, globals.LOBSTERTWO, 24 )
  globals.multiplierText:setFillColor(1,1,1)
  group:insert(globals.multiplierText)

--PLAYERS CURRENCY
--[[
  money = display.newImage("images/money.png")
  money.width = 58
  money.height = 28
  money.x = 85
  money.y = 14  
  group:insert(money)
]]--

-- PLAYERS ITEM BELT
  itemBelt = {}

  itemBelt[0] = display.newImage("images/itemHolder.png")
  itemBelt[0].width = 40
  itemBelt[0].height = 40
  itemBelt[0].x = 250
  itemBelt[0].y = 20
  group:insert(itemBelt[0])

  itemBelt[0] = display.newImage("images/itemHolder.png")
  itemBelt[0].width = 40
  itemBelt[0].height = 40
  itemBelt[0].x = 200
  itemBelt[0].y = 20
  group:insert(itemBelt[0])

  itemBelt[0] = display.newImage("images/itemHolder.png")
  itemBelt[0].width = 40
  itemBelt[0].height = 40
  itemBelt[0].x = 300
  itemBelt[0].y = 20
  group:insert(itemBelt[0])
  
  local gameItems = {}
  local itemSpace = 200
  for i = 0,table.maxn( myItems ) do
    if ( myItems[i] ~= nil )then
      gameItems[i] = display.newImage(myItems[i].image)
      passValuesToNewItem (gameItems[i], myItems[i])
      gameItems[i].width = 25
      gameItems[i].height = 25
      gameItems[i].x = itemSpace
      gameItems[i].y = 20
      gameItems[i].myItemRef = i
      if ( gameItems[i].itemType == "foodType" or gameItems[i].itemType == "trash") then
      gameItems[i]:addEventListener( "touch", itemFoodDrag ) 
      elseif ( gameItems[i].itemType == "break" ) then
      gameItems[i]:addEventListener( "tap", itemTap ) 
	    elseif ( gameItems[i].itemType == "swap" ) then
      gameItems[i]:addEventListener( "tap", itemTap ) 
      elseif ( gameItems[i].itemType == "boost" ) then
      gameItems[i]:addEventListener( "touch", dragToHero ) 
      end
      group:insert(gameItems[i])
    end
    itemSpace = itemSpace+50
  end

 local function onTapPause( event )
    storyboard.showOverlay("scenes.scene_pause", {effect = "slideDown", time=500})
    timer.pause(attackTimer)
    timer.pause(spawnEneTimer)
    if ( antagonistTimer ~= nil) then
     timer.cancel(antagonistTimer)
     end
    for n=0, 2, 1 do
      globals.belts[n]:pause()
  end
    if (globals.bullet ~= nil and globals.bullet_array ~= nil) then
      for i=0, #globals.bullet_array, 1 do
        if (globals.bullet_array[i] ~= nil) then
          globals.bullet_array[i]:pause()
        end
      end
    end
    transition.pause("animation")
  end

  pauseGradient:addEventListener( "tap", onTapPause )
end
 
-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
  local group = self.view
  local prevCurrency = globals.currency.load()
  if prevCurrency then
    globals.currency.set(prevCurrency)
  end
 
end
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view
 
end
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
  local group = self.view
  scoreText:removeSelf()
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