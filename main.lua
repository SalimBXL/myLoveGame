--[[
    SalimPasha 2024
    My Love Game

    Author : Anthony Salim JOLY
    el.salim.salim@gmail.com
    @SalimBXL

    Pong Remake
]]

function love.load()
    -- https://www.freepik.com/free-vector/neon-grid-background_4394259.htm#query=gaming%20background&position=21&from_view=keyword&track=ais&uuid=c36cd1f8-ba77-4f1f-be03-90d0a836e160
    -- Image by rawpixel.com on Freepik
    local _BACKGROUND_IMAGE = "sprites/4394259_91657.jpg"

    --https://www.freepik.com/free-vector/magic-ball-with-electric-lightning-inside-realistic_6055215.htm#fromView=search&page=1&position=16&uuid=e9bad309-48f9-4c3a-83ed-82de82729f2d
    --Image by upklyak on Freepik
    local _BALL_IMAGE = "sprites/207.png"
    

    -- Random Seed
    math.randomseed(os.time())

    -- Fonts
    scoreFontSize = 80
    menuFontSize = 30
    scoreFont = love.graphics.newFont(scoreFontSize)
    menuFont = love.graphics.newFont(menuFontSize)

    -- Sprites
    sprites = {}
    sprites.background = love.graphics.newImage(_BACKGROUND_IMAGE)
    sprites.ball = love.graphics.newImage(_BALL_IMAGE)

    -- Background
    background = {}
    background.image = sprites.background
    background.width = love.graphics.getWidth() / background.image:getWidth()
    background.height = love.graphics.getHeight() / background.image:getHeight()
    background.marge = 32

    -- Player
    player = {}
    player.score = 0
    player.location = love.graphics.getWidth() / 2
    player.padSize = 100
    player.speed = 1000
    
    -- Ball
    ball = {}
    ball.image = sprites.ball
    ball.size = 50
    ball.speed = 200
    ball.score = 0
    ball.x = love.graphics.getWidth() / 2
    ball.y = love.graphics.getHeight() / 2
    ball.directionX = math.random(love.graphics.getWidth()-ball.size)
    ball.directionY = love.graphics.getHeight() - player.padSize + 12.5

    -- Game State
    gameState = "start"
end


function love.update(dt)

    -- Player movements from keyboard
    if love.keyboard.isDown("left") then
        player.location = math.max(background.marge/2 + player.padSize/2, player.location + -player.speed * dt)
    elseif love.keyboard.isDown("right") then
        player.location = math.min(love.graphics.getWidth() - background.marge/2 - player.padSize/2, player.location + player.speed * dt)
    end

    -- Ball movements
    if gameState == "play" then
        --ball.x = ball.x - ball.speed * dt
        ball.y = math.min(ball.directionY, ball.y + ball.speed * dt)
        if ball.x < 0 + ball.size / 2 then
            ball.x = 0 + ball.size / 2 
        elseif ball.x > love.graphics.getWidth() - ball.size / 2 then 
            ball.x = love.graphics.getWidth() - ball.size / 2
        end
        print("Ball x: " .. ball.x .. " y: " .. ball.y .. "    Direction  x: " .. ball.directionX .. " y: " .. ball.directionY)
    end
end


function love.draw()
    -- Background
    love.graphics.draw(background.image, 0, 0, nil, background.width, background.height)

    -- Start Menu
    if gameState == "start" then
        love.graphics.setFont(menuFont)
        love.graphics.printf("Press Any Key To Start The Game", 0, (love.graphics.getHeight()/3)-(scoreFontSize/2), love.graphics.getWidth(), "center")
    end

    -- Scores
    if gameState ~= "start" then
        local _score = player.score .. " : " .. ball.score
        love.graphics.setFont(scoreFont)
        love.graphics.printf(_score, 0, (love.graphics.getHeight()/2)-(scoreFontSize/2), love.graphics.getWidth(), "center")
    end
    
    -- Player
    love.graphics.rectangle("fill", (player.location - player.padSize/2), love.graphics.getHeight()-(background.marge*1.5), player.padSize, background.marge)

    -- Ball
    love.graphics.draw(ball.image, ball.x, ball.y, nil, nil,nil, ball.size/2)
end


-- Escape function / Quit the game
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end