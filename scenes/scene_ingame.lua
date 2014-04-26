---------------------------------------------------------------------------------
-- SCENE NAME
-- Scene notes go here
---------------------------------------------------------------------------------
 
local storyboard = require( "storyboard" )
local globals = require("classes.globals")
local scene = storyboard.newScene()
local loadsave = require("classes.loadsave")
local thisLevel 
local world
local eneInHold = nil
globals.spot = nil
local levelEnded = false
-- Array to store heroes
hero = {}

-- Lanes y positions
lane1 = 80
lane2 = 160
lane3 = 240

--Enemy varis
allEne = {} 
--allEnemHealth = {}

--conveyor belts locals
local sheetSettings
local sheet
local sequenceData
--breakfast chef locals
local breakfastspriteSettings
local breakfastspritesheet
local breakfastspriteequenceData
local breakfastanimation
local deathPoof

local eneAndBar = {}
local group 

local move = require("classes.move")
require("classes.heroes")
require("classes.enemies")
require("classes.collision")
require("classes.level")
require("classes.combo")
require("classes.items")
require("classes.recipes")
require("classes.basics")
require("classes.servingButtons")
require("classes.beltsAnimation")

globals.currency = require( "classes.score" )
require("classes.timeLine")

local currencyText
 
--sprite.xScale, sprite.yScale = 3,3 --The image is a little small so we scale it up

-- Clear previous scene
storyboard.removeAll()
 
-- local forward references should go here --
 
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- function to create conveyor belts
--NEW CONVEYOR BELT CODE
function scene:createConveyorBelts()
	for n=0, 2, 1 do
  		if (n==0) then
  			globals.belts[n] = display.newSprite(breakfastsheet,breakfastsequenceData)
			globals.belts[n].y = lane1+20
			globals.belts[n].id = n
			globals.belts[n]:setSequence( "breakfast_normal" )
			globals.belts[n]:play()
			globals.belts[n]:addEventListener( "touch", ability )

		end
		if (n==1) then
			globals.belts[n] = display.newSprite(dinnersheet,dinnersequenceData)
			globals.belts[n].y = lane2+20
			globals.belts[n].id = n
			globals.belts[n]:setSequence( "dinner_normal" )
			globals.belts[n]:play()
			globals.belts[n]:addEventListener( "touch", ability )
		end
		if (n==2) then
			globals.belts[n] = display.newSprite(dessertsheet,dessertsequenceData)
			globals.belts[n].y = lane3+20
			globals.belts[n].id = n
			globals.belts[n]:setSequence( "dessert_normal" )
			globals.belts[n]:play()
			globals.belts[n]:addEventListener( "touch", ability )
		end
		globals.belts[n].x = 278
		group:insert(globals.belts[n])
	end
	eggsheetSettings =
  	{
  	 width = 60,
  	 height = 20,
 	 numFrames = 3,
 	 sheetContentWidth=60,
	 sheetContentHeight=60,
	}
	eggsheet = graphics.newImageSheet("images/egg_sheet.png",eggsheetSettings)
	eggsequenceData = {
	--higher the time, slower it goes
   { name = "normal", start=2,  count=1 },
   { name = "slow", start=1,  count=1 },   
   { name = "fast", start=3,  count=1 }
	}

	fishsheetSettings =
  	{
  	 width = 48,
  	 height = 16,
 	 numFrames = 3,
 	 sheetContentWidth=48,
	 sheetContentHeight=48,
	}
	fishsheet = graphics.newImageSheet("images/fish_sheet.png",fishsheetSettings)
	fishsequenceData = {
	--higher the time, slower it goes
   { name = "normal", start=2,  count=1 },
   { name = "slow", start=1,  count=1 },   
   { name = "fast", start=3,  count=1 }
	}

	macaronsheetSettings =
  	{
  	 width = 60,
  	 height = 20,
 	 numFrames = 3,
 	 sheetContentWidth=60,
	 sheetContentHeight=60,
	}
	macaronsheet = graphics.newImageSheet("images/macaron_sheet.png",macaronsheetSettings)
	macaronsequenceData = {
	--higher the time, slower it goes
   { name = "normal", start=2,  count=1 },
   { name = "slow", start=1,  count=1 },   
   { name = "fast", start=3,  count=1 }
	}


	for n=0, 2, 1 do
  		--globals.levers[n] = display.newSprite(leversheet,leversequenceData)
  		--globals.levers[n].x = 73
  		if (n==0) then
  			globals.levers[n] = display.newSprite(eggsheet,eggsequenceData)
  		globals.levers[n].x = display.contentWidth/3
			globals.levers[n].y = lane1+39
		end
		if (n==1) then
			globals.levers[n] = display.newSprite(fishsheet,fishsequenceData)
  			globals.levers[n].x = display.contentWidth/3
			globals.levers[n].y = lane2+39
		end
		if (n==2) then
			globals.levers[n] = display.newSprite(macaronsheet,macaronsequenceData)
  			globals.levers[n].x = display.contentWidth/3
			globals.levers[n].y = lane3+38
		end
		globals.levers[n]:setSequence( "normal" )
		globals.levers[n]:play()
		group:insert(globals.levers[n])
	end
	
end  

function throwAbility( event )
	local targetHero = event.target
	local heroX = event.x
	local phase = event.phase
	local stage = display.getCurrentStage()
	local markY = targetHero.y
	
	if event.phase == "began" then
		stage:setFocus( targetHero, event.id )
		targetHero.isFocus = true
		--checks if the touch didn't move from original position. Meaning that it was a tap
			if (event.x - event.xStart == 0) then
				--useItem(targetHero)
				if (globals.attack) then
					if (targetHero.num == 0) then
						if (globals.attack_bkft==false) then
							group:insert(make_bullet_pins(targetHero))
						elseif (globals.attack_bkft) then
							--do nothing 
						end
					elseif (targetHero.num == 1) then
						if(globals.attack_dnr==false) then
							group:insert(make_bullet_spatula(targetHero))
						elseif(globals.attack_dnr) then
							--do nothing
						end
					elseif (targetHero.num == 2) then
						if (globals.attack_dst == false) then
							group:insert(make_bullet_whisk(targetHero))
						elseif(globals.attack_dst) then
							--do nothing
						end
					end
				end
			end
	elseif targetHero.isFocus then
		if "ended" == phase or "cancelled" == phase then
			stage:setFocus( targetHero, nil )
			targetHero.isFocus = false
		end
	end
end

-- function to 
function scene:createHeroes()
  for n=0, 2, 1 do
    hero[n] = myHeroes[n]
    hero[n] = display.newImage( hero[n].image )
    hero[n] = makeHero ( hero[n], myHeroes[n] )
    hero[n].x =50
    if (n == 0) then hero[n].y = lane1
    elseif (n == 1) then hero[n].y = lane2
    elseif (n == 2) then hero[n].y = lane3
    --elseif (n == 3) then hero[n].y = lane4
    end
    hero[n].height = 70; hero[n].width = 70
	--hero[n]:addEventListener( "touch", throwAbility )
  end
end  

--CREATING AN ANIMATED OVERLAY TO THE TRANSPARENT PLACEHOLDER IN HEROES.LUA--
function scene:createBreakfastChef()
	breakfastspriteSettings =
  	{
  	 width = 70,
  	 height = 70,
 	 numFrames = 4,
 	 sheetContentWidth=280,
	 sheetContentHeight=70,
	}
	breakfastspritesheet = graphics.newImageSheet("images/breakfast_sheet.png",breakfastspriteSettings)
	breakfastspriteequenceData = {
	--higher the time, slower it goes
   		{ name = "idle", frames={1, 2, 3, 4, 3, 2}, time=1000, loopCount=0 }
	}
	globals.breakfastanimation = display.newSprite(breakfastspritesheet,breakfastspriteequenceData)
    globals.breakfastanimation.x =50
    globals.breakfastanimation.y = lane1    
    globals.breakfastanimation.height = 70; globals.breakfastanimation.width = 70
    globals.breakfastanimation:setSequence( "idle" )
	globals.breakfastanimation:play()
	--globals.breakfastanimation:addEventListener( "touch", throwAbility )
	group:insert(globals.breakfastanimation)
end 

function makeHoldEne()
	local eneToMake
	local isCombo = false
	print ( eneInHold )
	for n = 0,table.maxn( myEnemies ) do
		if( myEnemies[n].type == eneInHold )then
			eneToMake = n
		end
	end
	for n = 0,table.maxn( comboEnemies ) do
		if( comboEnemies[n].type == eneInHold )then
			eneToMake = n
			isCombo = true
		end
	end
	incrementEnemy(currentLevel)
	eneAndBar = scene:createEne(eneToMake, isCombo, globals.hold.eneX, globals.hold.eneY)
	group:insert(eneAndBar[0])
	--group:insert(eneAndBar[1])
	removeHold()
end
--The function to move something into the hold
function moveToHold( event )
	local enemyTapped = event.target
	local eneIndex
	local eneX = enemyTapped.x
	local eneY = enemyTapped.y
	for i = 0,table.maxn( allEne ) do
		if ( allEne[i] == enemyTapped ) then
			eneIndex = i
		end
	end
	allEne[eneIndex]:removeSelf()
	table.remove(allEne, eneIndex)
	--allEnemHealth[eneIndex]:removeSelf()
	--table.remove(allEnemHealth, eneIndex)
	decrementEnemy(currentLevel)
	if ( globals.hold ~= nil ) then
		makeHoldEne()
	end
	eneInHold = enemyTapped.type
	makeHold(eneInHold, eneX, eneY)
	---VERY TEMPORARY WILL REMOVE
	if(globals.spot ~= nil) then 
		globals.spot:removeSelf() 
		globals.spot = nil
	end
	globals.spot = display.newRect( eneX, eneY, 30, 30 )
	group:insert(globals.spot)
	if ((currentLevel.totalNumberOfEnemies == 0 and #allEne == 0) or levelEnded == true) then
		if(currentLevel.victoryCondition~=false or levelEnded == true) then
			if(currentLevel.victoryCondition.conditionMet==true)then
				LevelList.unlockLevel(world, thisLevel+1)
				endLevel(currentLevel, true)
				storyboard.showOverlay( "scenes.scene_victory",{ effect = "fade", time = 500, params = {level = thisLevel, world = world}})
			else 
				endLevel(currentLevel, false)
				storyboard.showOverlay( "scenes.scene_loss",{ effect = "fade", time = 500, params = {level = thisLevel, world = world, condition = true}})
			end
		else	
		LevelList.unlockLevel(world, thisLevel+1)
		endLevel(currentLevel, true)
		storyboard.showOverlay( "scenes.scene_victory",{ effect = "fade", time = 500, params = {level = thisLevel, world = world}})
		end
	end

end

function tutorial()
	storyboard.showOverlay( "scenes.scene_tutorial",{ effect = "fade", time = 500, params = {level = thisLevel, world = world}})
	timer.pause(spawnEneTimer)
	if (globals.breakfastButton~=nil) then
		globals.breakfastButton:pause()
	end
		if (globals.dinnerButton~=nil) then
		globals.dinnerButton:pause()
	end
		if (globals.dessertButton~=nil) then
		globals.dessertButton:pause()
	end

	globals.breakfastanimation:pause()
	for n=0, 2, 1 do
	globals.belts[n]:pause()
	end
	transition.pause("animation")
end

function tutorialCombo()
	storyboard.showOverlay( "scenes.scene_tutorialCombo",{ effect = "fade", time = 500, params = {level = thisLevel, world = world}})
	timer.pause(spawnEneTimer)
	if (globals.breakfastButton~=nil) then
		globals.breakfastButton:pause()
	end
		if (globals.dinnerButton~=nil) then
		globals.dinnerButton:pause()
	end
		if (globals.dessertButton~=nil) then
		globals.dessertButton:pause()
	end

	globals.breakfastanimation:pause()
	for n=0, 2, 1 do
	globals.belts[n]:pause()
	end
	transition.pause("animation")
end

function scene:createEne(enemyID, isCombo, x, lane)
	--local eneAndBar = {}
	--set the lane it will spawn in
	local tutorialCounter = 1
	if ( lane == nil ) then
		local randomPos
		if #allEne == 0 then 
			randomPos = math.random(1, 3)
		else
			local rightmostEnemy = allEne[1]
			for i = 2,table.maxn( allEne ) do
				if allEne[i].x > rightmostEnemy.x then
					rightmostEnemy = allEne[i]
				end
			end
			if rightmostEnemy.y == lane1 then randomPos = 1
			elseif rightmostEnemy.y == lane2 then randomPos = 2
			elseif rightmostEnemy.y == lane3 then randomPos = 3
			end
			randomPos = randomPos + math.random(1, 2)
			if randomPos > 3 then randomPos = randomPos - 3 end
		end
		
		if ( thisLevel == 1 and world == 1 ) then
			if (#allEne == 0) then
				randomPos = 1
			else
				randomPos = 2
				timer.performWithDelay(800, tutorial )
			end
		end
		if (randomPos == 1) then lane = lane1
		elseif (randomPos == 2) then lane = lane2
		elseif (randomPos == 3) then lane = lane3
		end
	end
	
	if ( isCombo == false ) then
		-- check to unlock basic enemies:
		unlockBasicCheck(enemyID)
		--local randomEne = math.random(0, 1)
		allEne[#allEne + 1] = myEnemies[enemyID]
	else 
		allEne[#allEne + 1] = comboEnemies[enemyID]
	end
	allEne[#allEne] = display.newImage(allEne[#allEne].image)
	allEne[#allEne] = passValuesToNewEne(allEne[#allEne], myEnemies[enemyID])

	-- add health bars to enemies.
	--allEnemHealth[#allEne] = #allEne
	--allEnemHealth[#allEne] = display.newImage( "images/enemhealth.jpg" )
	--allEnemHealth[#allEne].height = 10 
	--allEnemHealth[#allEne].width = allEne[#allEne].health/allEne[#allEne].maxHealth * 50
	--allEnemHealth[#allEne].x = x; allEnemHealth[#allEne].y = lane - 25
	--end health bar.

	--define the enemy
	allEne[#allEne].height = 50; allEne[#allEne].width = 50
	allEne[#allEne].x = x; allEne[#allEne].y = lane

	--set the move speedallEne
	transition.to( allEne[#allEne], { time=(moveSpeed(allEne[#allEne].x, allEne[#allEne].speed, allEne[#allEne].y)), x=(50) ,tag="animation"}  )
	allEne[#allEne]:addEventListener( "touch", teleport ) 
	--allEne[#allEne]:addEventListener( "tap", moveToHold ) 
	eneAndBar[0]=allEne[#allEne]
	--eneAndBar[1]=allEnemHealth[#allEne]
	return eneAndBar
end

function itemCombo( item , enemy, fromFoodItem )
	for j = 0,table.maxn( comboEnemies ) do
		if (comboEnemies[j].type == replaceEnemy(item, enemy)) then
		------DO  A BREAK
			print ("item: " .. item.name .. " enemy: " .. enemy.name)
			print ("my new food: " .. comboEnemies[j].type)
			
			if (fromFoodItem) then
				item: removeSelf()
				myItems[item.myItemRef] = nil
			end
			
			allEne[#allEne + 1] = comboEnemies[j]
			allEne[#allEne] = display.newImage(allEne[#allEne].image)

			allEne[#allEne] = passValuesToNewEne(allEne[#allEne], comboEnemies[j])
			-- Check for Secondary Win condition
			
			--if(currentLevel.victoryCondition~=false) then
			--	if(currentLevel.victoryCondition.enemy.name==allEne[#allEne].name)then
			--		currentLevel.victoryCondition.amount = currentLevel.victoryCondition.amount-1
			--		print(currentLevel.victoryCondition.enemy.name .. "left: " .. currentLevel.victoryCondition.amount)
			--		if (currentLevel.victoryCondition.amount == 0) then
			--		print("Condition Met")
			--		currentLevel.victoryCondition.conditionMet = true
			--		end
			--	end
			--end

			-- add health bars to enemies.
			--allEnemHealth[#allEne] = #allEne
			--allEnemHealth[#allEne] = display.newImage( "images/enemhealth.jpg" )
			--allEnemHealth[#allEne].height = 10 
			-- creates a new health.
			--allEnemHealth[#allEne].health = newHealth(n,i)
			--allEnemHealth[#allEne].width = allEne[#allEne].health/allEne[#allEne].maxHealth * 50
			--allEnemHealth[#allEne].x = enemy.x; allEnemHealth[#allEne].y = enemy.y
			--end health bar.

			--define the enemy
			allEne[#allEne].height = 50; allEne[#allEne].width = 50
			allEne[#allEne].x = enemy.x; allEne[#allEne].y = enemy.y

			--set the move speedallEne
			transition.to( allEne[#allEne], { time=(moveSpeed(allEne[#allEne].x, allEne[#allEne].speed, allEne[#allEne].y)), x=(50), tag="animation" } )
			allEne[#allEne]:addEventListener( "touch", teleport ) 
			--allEne[#allEne]:addEventListener( "tap", moveToHold )
			eneAndBar[0]=allEne[#allEne]
			--eneAndBar[1]=allEnemHealth[#allEne]
			group:insert(eneAndBar[0])
			--group:insert(eneAndBar[1])
			
			for n = 0,table.maxn( allEne ) do
				if( allEne[n] == enemy ) then
					allEne[n]: removeSelf()
					table.remove(allEne, n)
					--allEnemHealth[n]:removeSelf()
					--table.remove(allEnemHealth, n)
				end
			end
		end
	end
	return eneAndBar[0]
end

function checkEnemy()

	-- turns score condition success true/false.
	if (currentLevel.scoreCondition~=false) then
	if (currentLevel.scoreCondition.score-1 < globals.score) then
		currentLevel.scoreCondition.success = true
		end
	end

if ((currentLevel.totalNumberOfEnemies == 0 and #allEne == 0) or levelEnded == true) then
    globals.attack = false

    local totalCond = 0

    --[[-- accounts for two conditions now.
    if (currentLevel.victoryCondition~=false) then
    	if(currentLevel.victoryCondition.conditionMet==true)then
    		totalCond = totalCond + 1
    	end
    end
    if (currentLevel.categoryCondition~=false) then
    	if(currentLevel.categoryCondition.success==true)then
    		totalCond = totalCond + 1
    	end
    end
    if (currentLevel.scoreCondition~=false) then
    	if(currentLevel.scoreCondition.success==true)then
    		totalCond = totalCond + 1
    	end
    end
    -- end account check
    ]]--

    -- NOW YOU WIN WIN WIN (Unless your score is negative.)

    if (globals.score > 0) then
    	LevelList.unlockLevel(world, thisLevel+1)
        endLevel(currentLevel, true)
        storyboard.showOverlay( "scenes.scene_victory",{ effect = "fade", time = 500, params = {level = thisLevel, world = world}})
    else
    	endLevel(currentLevel, false)
        storyboard.showOverlay( "scenes.scene_loss",{ effect = "fade", time = 500, params = {level = thisLevel, world = world, condition = true}})
    end

    --[[
    OLD CONDITION CHECK
    if(currentLevel.victoryCondition~=false) then
      if(currentLevel.victoryCondition.conditionMet==true)then
        LevelList.unlockLevel(world, thisLevel+1)
        endLevel(currentLevel, true)
        storyboard.showOverlay( "scenes.scene_victory",{ effect = "fade", time = 500, params = {level = thisLevel, world = world}})
      else 
        endLevel(currentLevel, false)
        storyboard.showOverlay( "scenes.scene_loss",{ effect = "fade", time = 500, params = {level = thisLevel, world = world, condition = true}})
      end
    else  
      LevelList.unlockLevel(world, thisLevel+1)
      endLevel(currentLevel, true)
      storyboard.showOverlay( "scenes.scene_victory",{ effect = "fade", time = 500, params = {level = thisLevel, world = world}})
    end
    ]]--

  end
end

function makeDeathPoof(allEne)
	-- add visual poof of death.
	deathPoof = display.newImage( "images/death.png", allEne.x, allEne.y, true )
	deathPoof.width = deathPoof.width/9
	deathPoof.height = deathPoof.height/9
	group:insert(deathPoof)
	table.insert( globals.deathPoofArray, deathPoof)
	transition.to( deathPoof, { time=1200, alpha=0, onComplete=
		function() 
			if (deathPoof~= nil) then 
				local index = table.indexOf( globals.deathPoofArray, deathPoof )
				table.remove( globals.deathPoofArray, index )
			end 
		end, 
		tag="animation" } )
	--end visual poof of death.
end

function validCombosRemaining()
    if ( #(currentLevel.enemyIDQueue)~= currentLevel.spawnCounter ) then
        return true
    end
    
    for i = 1,table.maxn( allEne ) do
        local basicItemFlag = false
        for j = 0,table.maxn( myEnemies ) do
            if allEne[i].type == myEnemies[j].type then
            basicItemFlag = true
            break
            end
        end
        if basicItemFlag == false then
            if allEne[i].type ~= "bad" then
                return true
            end
        end
    end
    
    for i = 1,table.maxn( allEne ) do
        for j = i+1,table.maxn( allEne ) do
            if foodgroup[allEne[i].type][allEne[j].type] ~= "bad" then
                return true
            end
        end
    end
    
	
    for i = 0, 2 do
        if myItems[i] ~= nil and myItems[i].itemType == "foodType" then
            for j = 1, table.maxn( allEne ) do
                if foodgroup[myItems[i].type][allEne[j].type] ~= "bad" then
                    return true
                end
            end
        end
    end
    
    for i = 0, 2 do
        if myItems[i] ~= nil and myItems[i].itemType == "foodType" then
            for j = 1, table.maxn( allEne ) do
                if foodgroup[myItems[i].type][allEne[j].type] ~= "bad" then
                    return true
                end
            end
        end
    end
    return false
    
end

local function gameLoop( event )
	globals.multiplier = getMultiplier()
	globals.multiplierText.text = (globals.multiplier)
        
        if validCombosRemaining() == false then
			levelEnded = true
			--print("LEVEL ENDED!!!!!!!!!!!!!!")
                        --checkEnemy()
        end

	-- CHECKS FOR OBJECTIVES (visual representations) HERE --
	if currentLevel.victoryCondition ~=false then
		globals.objectiveText.text = getObjectiveProgress()
	end

	if (currentLevel.categoryCondition ~= false) then
		globals.categoryText.text = getCatNumbers()
	end

	if  (currentLevel.scoreCondition ~= false) then
		globals.scoreObjText.text = getScoreNumbers()
	end
	-- end objectives text. 

	if ( globals.notDurningAntagonist ) then
		for i = 0,table.maxn( allEne ) do
			for n = 0,table.maxn( hero ) do
				if ( hasCollidedCircle( hero[n], allEne[i]) ) then
					allEne[i]:removeSelf()
					table.remove(allEne, i)
					--allEnemHealth[i]:removeSelf()
					--table.remove(allEnemHealth, i)

					-- hero damage effect here.
					local screenEffect = display.newRect( display.contentWidth/2, hero[n].y, display.contentWidth, hero[n].height)
					local loseLife= display.newText( "-10 SCORE", hero[n].x+45, hero[n].y-20, globals.IMPRIMA, 18 )
					globals.score = globals.score - 10
					globals.scoreText.text = (globals.score)
					--local screenEffect = display.newCircle( 40, 0, 80)
					screenEffect:setFillColor(246,235,133)
					loseLife:setFillColor(black)
					transition.to( screenEffect, { time= 400, alpha=0, onComplete=function() screenEffect:removeSelf() end } )
					transition.to( loseLife, { time= 800, alpha=0, onComplete=function() loseLife:removeSelf() end } )


					--globals.lives = globals.lives - 1
					--globals.numLives.text = (globals.lives)

					--[[if globals.lives <= 0 then
						endLevel(currentLevel, false)
						globals.attack = false
						storyboard.showOverlay( "scenes.scene_loss",{ effect = "fade", time = 500, params = {level = thisLevel, world = world}})

					end]]
					decrementEnemy(currentLevel)
                                        
                                        if validCombosRemaining() == false then
                                            levelEnded = true
                                            print("LEVEL ENDED")
                                        end
					checkEnemy()
				end
			end
		end

		-- this is the code for collision checking, and combining to make new enemies
                local foundComboFlag = false
                --when this flag is true it will break all for loops so no other enemies combine
		for i = 1,table.maxn( allEne ) do
                        if foundComboFlag == true then break end
			for n = 1,table.maxn( allEne ) do
                                if foundComboFlag == true then break end
				if (i == n) then --"colliding with itself, ignore when this happens"
				elseif(combination(allEne[i], allEne[n])) then
					-- create a new emeny at the end of the list
					for j = 0,table.maxn( comboEnemies ) do
						if (comboEnemies[j].type == replaceEnemy(allEne[i], allEne[n])) then

							allEne[#allEne + 1] = comboEnemies[j]

							local comboPoof = display.newImage( "images/comboPoof.png", allEne[i].x, allEne[i].y, true )
							comboPoof.width = comboPoof.width/3
							comboPoof.height = comboPoof.height/3
							transition.to( comboPoof, { time=1500, alpha=0, onComplete=function() comboPoof:removeSelf() end } )

							allEne[#allEne] = display.newImage(allEne[#allEne].image)
							allEne[#allEne] = passValuesToNewEne(allEne[#allEne], comboEnemies[j])
							unlockCheck(j)
							-- Check for Secondary Win condition
							--if(currentLevel.victoryCondition~=false) then
							--	if(currentLevel.victoryCondition.enemy.name==allEne[#allEne].name)then
							--		currentLevel.victoryCondition.amount = currentLevel.victoryCondition.amount-1
							--		print(currentLevel.victoryCondition.enemy.name .. "left: " .. currentLevel.victoryCondition.amount)
							--		if (currentLevel.victoryCondition.amount == 0) then
							--			print("Condition Met")
							--			currentLevel.victoryCondition.conditionMet = true
							--		end
							--	end
							--end
							
							-- add health bars to enemies.
							--allEnemHealth[#allEne] = #allEne
							--allEnemHealth[#allEne] = display.newImage( "images/enemhealth.jpg" )
							--allEnemHealth[#allEne].height = 10 
							-- creates a new health.
							--allEnemHealth[#allEne].health = newHealth(n,i)
							--allEnemHealth[#allEne].width = allEne[#allEne].health/allEne[#allEne].maxHealth * 50
							--allEnemHealth[#allEne].x = allEnemHealth[n].x; allEnemHealth[#allEne].y = allEnemHealth[n].y
							--end health bar.

							--define the enemy
							allEne[#allEne].height = 50; allEne[#allEne].width = 50
							allEne[#allEne].x = allEne[n].x; allEne[#allEne].y = allEne[n].y

							--set the move speedallEne
							transition.to( allEne[#allEne], { time=(moveSpeed(allEne[#allEne].x, allEne[#allEne].speed, allEne[#allEne].y)), x=(50), tag="animation" } )
							allEne[#allEne]:addEventListener( "touch", teleport ) 
							--allEne[#allEne]:addEventListener( "tap", moveToHold )
							eneAndBar[0]=allEne[#allEne]
							--eneAndBar[1]=allEnemHealth[#allEne]
							group:insert(eneAndBar[0])
							--group:insert(eneAndBar[1])

							--remove the second enemy we want to replace
							allEne[n]: removeSelf()
							table.remove(allEne, n)
							--allEnemHealth[n]:removeSelf()
							--table.remove(allEnemHealth, n)

							if (n > i) then -- removes teleported enemy 
								-- if i is less than n in the enemy list, remove i since i is not effect when n was removed
								allEne[i]:removeSelf()
								table.remove(allEne, i)
								--allEnemHealth[i]:removeSelf()
								--table.remove(allEnemHealth, i)
								decrementEnemy(currentLevel)
							else
								-- if i is greater than n, need to remove the enemy 1 less than where i orginally was before removing n since the whole list shifted
								allEne[i-1]:removeSelf()
								table.remove(allEne, i-1)
								--allEnemHealth[i-1]:removeSelf()
								--table.remove(allEnemHealth, i-1)
								decrementEnemy(currentLevel)
							end
                                                        foundComboFlag = true
                                                        break
						end
					end
				end
			end
		end
		--CHECKS IF COMBO ENEMIES ARE IN THE CORRECT LANE--
		for i = 1,table.maxn( allEne ) do
			if (allEne[i].y == lane1) then
				if (allEne[i].category == "breakfast") then
					globals.breakfastServe = true
					servingButtons()
					if (globals.breakfastServe and globals.breakfastButton~=nil) then
						group:insert( globals.breakfastButton )
					end
				end
				-- elseif (globals.breakfastServe and allEne[i].category ~= "breakfast") then
				-- 	--if (allEne[i].category ~= "breakfast") then
				-- 		print("i'm here")
				-- 		if(globals.breakfastButton ~= nil) then
				-- 			globals.breakfastButton:removeSelf()
				-- 			--globals.breakfastButton = nil
				-- 		end
				-- 	--end
				-- end
			elseif (allEne[i].y == lane2) then
				if (allEne[i].category == "dinner") then
					globals.dinnerServe = true
					servingButtons()
					if (globals.dinnerServe) then
						group:insert( globals.dinnerButton )
					end
				end
			elseif (allEne[i].y == lane3) then
				if (allEne[i].category == "dessert") then
					globals.dessertServe = true
					servingButtons()
					if (globals.dessertServe) then
						group:insert( globals.dessertButton )
					end
					checkEnemy()
				end
			end
		end
	end

	-- updateEnemyHealth()



   return true
end

function replayLevel()
	timer.pause(spawnEneTimer)
	if (globals.breakfastButton~=nil) then
		globals.breakfastButton:pause()
	end
		if (globals.dinnerButton~=nil) then
		globals.dinnerButton:pause()
	end
		if (globals.dessertButton~=nil) then
		globals.dessertButton:pause()
	end

	globals.breakfastanimation:pause()
	if ( antagonistTimer ~= nil) then
		timer.cancel(antagonistTimer)
	end
	for n=0, 2, 1 do
		globals.belts[n]:pause()
	end
	transition.pause("animation")
	storyboard.removeScene(scene)
	storyboard.gotoScene( "scenes.scene_inBetween",{ effect = "fade", time = 500, params = {level = thisLevel, world = world}})

end

local function goToIntro(vicCond, id, catCond, scoreCond)
	storyboard.showOverlay("scenes.scene_intro", {effect = "slideDown", time=500, params = {vic= vicCond, levelNumber=id, cat=catCond, scr = scoreCond}})
	--timer.pause(attackTimer)
	timer.pause(spawnEneTimer)
	if (globals.breakfastButton~=nil) then
		globals.breakfastButton:pause()
	end
		if (globals.dinnerButton~=nil) then
		globals.dinnerButton:pause()
	end
		if (globals.dessertButton~=nil) then
		globals.dessertButton:pause()
	end

	globals.breakfastanimation:pause()
	for n=0, 2, 1 do
		globals.belts[n]:pause()
	end
	transition.pause("animation")
end




-- Called when the scene's view does not exist:
function scene:createScene( event )
	
  --Create the group that hold all the objects in the scene
  group = self.view
  local params = event.params
  thisLevel = params.level
  world = params.world
  
  globals.hold = nil
  
  local options = {
    effect = "slideDown",
    time = 500
  }
  globals.attack = true

  --create enemies and add them and their healthbar to the group
  function spawnEne(enemyID)
  	eneAndBar = scene:createEne(enemyID, false, 430, nil)
    group:insert(eneAndBar[0])
	--group:insert(eneAndBar[1])
  end
 --  local function createBullet(hero)
	-- group:insert(make_bullet(hero))
 --  end
 --  local function heroNormalAttacks()
 --    group:insert(make_bullet_pins(hero[0]))
	-- group:insert(make_bullet_spatula(hero[1]))
	-- group:insert(make_bullet_whisk(hero[2]))
 --   end
  local bkg = display.newImage( "images/mockback2.png", centerX, centerY, true )
  bkg.height=display.contentHeight; bkg.width=display.contentWidth
  group:insert(bkg)
  
  function getxy( event )
	--print("x: "..event.x)
	--print("y: "..event.y)
  end
  
  bkg:addEventListener( "touch", getxy )
  
  --create the heroes
  scene:createBreakfastChef()
  scene.createHeroes()
  for n=0,2,1 do
    group:insert(hero[n])
  end
  --adding the conveyor belts to the screen
scene.createConveyorBelts()

  currentLevel = Level.load(world, thisLevel)
 
 local numCond = 0 -- temporary, counts number of conditions in the level (later there will alawys be 2.)

  --initialize the current level's secondary objectives and print them
  if(currentLevel.victoryCondition~=false)then
	currentLevel.victoryCondition.amount = currentLevel.victoryCondition.memAmount
	currentLevel.victoryCondition.conditionMet = false
	numCond = numCond +1 
	print("Make " .. currentLevel.victoryCondition.amount .. " " .. currentLevel.victoryCondition.enemy.name)
else
	print ("No Second Condition")
  end

 if(currentLevel.categoryCondition~=false)then
	currentLevel.categoryCondition.amount = currentLevel.categoryCondition.memAmount
	currentLevel.categoryCondition.success = false
	numCond = numCond +1 
	print("Make " .. currentLevel.categoryCondition.amount .. " " .. currentLevel.categoryCondition.type .. " item(s).")
else
	print ("No Category Condition")
  end

--minimum score
if(currentLevel.scoreCondition~=false)then
	currentLevel.scoreCondition.score = currentLevel.scoreCondition.memScore
	currentLevel.scoreCondition.success = false
	numCond = numCond +1 
	print("Reach " .. currentLevel.scoreCondition.score .. " points.")
else
	print ("No Score Condition")
  end


  group:insert(currentLevel)
  
  timeLine = TimeLine.create(currentLevel.enemyIDQueue, currentLevel.timeBetweenEachSpawn)
  for i = 1, #timeLine.enemyQueue, 1 do
	group:insert(timeLine.enemyQueue[i])
	--transition.to( timeLine.enemyQueue[i], {x=((240-timeLineWidth/2)-timeLine.enemyQueue[i].x)/2, time=timeLine.spawnTimes[i] * 2, tag="animation"} )
	transition.to( timeLine.enemyQueue[i], {x=(240-timeLineWidth/2)-enemySize/2, time=timeLine.spawnTimes[i], tag="animation"} )
  end
  
  
  
  bar = TimeLine.createTimeLineBar()
  group:insert(bar[1])
  group:insert(bar[2])
  group:insert(bar[3])
  
  startLevel(currentLevel)
  
	-- parameters for ---------------------> make_bullet (x,y, hero attack)
	--attackTimer = timer.performWithDelay( 2000, heroNormalAttacks, 0)
	--Runtime:addEventListener( "enterFrame", updateEnemyHealth )
	Runtime:addEventListener( "enterFrame", gameLoop )

	-- scene.overlay hud
	storyboard.showOverlay("scenes.scene_hud")
	goToIntro(currentLevel.victoryCondition, currentLevel.levelID, currentLevel.categoryCondition, currentLevel.scoreCondition)
end
 
-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
  local group = self.view
  globals.score = 0
  --globals.lives = 3
  globals.multiplier = resetMultiplier()
end
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view 
end
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
  local group = self.view
  globals.currency.add(globals.score)
  globals.currency.save()
  --saving high score
	if (globals.score > gameSettings[world][thisLevel][1]) then
		gameSettings[world][thisLevel][1] = globals.score
		loadsave.saveTable(gameSettings , "gamesettings.json")
		print("new high score: " .. gameSettings[world][thisLevel][1])
	end
	print("saved score: " .. gameSettings[world][thisLevel][1])
  --Runtime:removeEventListener( "enterFrame", updateEnemyHealth )
  Runtime:removeEventListener( "enterFrame", gameLoop )
  --timer.cancel(attackTimer)
  timer.cancel(spawnEneTimer)
  if ( antagonistTimer ~= nil) then
	timer.cancel(antagonistTimer)
  end

  deathPoof = nil
	if (globals.breakfastButton~= nil) then
		globals.breakfastButton:removeSelf()
		globals.breakfastButton = nil
	end
	if (globals.dinnerButton~= nil) then
		globals.dinnerButton:removeSelf()
		globals.dinnerButton = nil
	end
	if (globals.dessertButton~= nil) then
		globals.dessertButton:removeSelf()
		globals.dessertButton = nil
	end
	if(globals.score > 0) then
		levels[world][thisLevel].stars=1
		globals.stars[world][thisLevel] = 1
		if (currentLevel.victoryCondition~= false) then
			if(currentLevel.victoryCondition.conditionMet==true) then
				levels[world][thisLevel].stars=2
				globals.stars[world][thisLevel] = 2
				if (globals.score > 100) then
					levels[world][thisLevel].stars=3
					globals.stars[world][thisLevel] = 3
				end
			end
		end
		--saving stars of the level
		if (globals.stars[world][thisLevel] > gameSettings[world][thisLevel][2]) then
			gameSettings[world][thisLevel][2] = globals.stars[world][thisLevel]
			loadsave.saveTable(gameSettings , "gamesettings.json")
		end
	end
	
	print ("Stars: " .. levels[world][thisLevel].stars)
	local stars = 0
	for i = 0,table.maxn( levels[world] ) do
		if ( levels[world][thisLevel].stars ~= nil ) then	
			stars = stars + levels[world][thisLevel].stars
		end
	end
	print (stars)
	if(stars>0) then
		LevelList.unlockLevel(world, 5)
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