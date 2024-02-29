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
    --https://www.freepik.com/free-vector/magic-ball-with-electric-lightning-inside-realistic_6055215.htm#fromView=search&page=1&position=16&uuid=e9bad309-48f9-4c3a-83ed-82de82729f2d
    --Image by upklyak on Freepik
    local _BACKGROUND_IMAGE = "sprites/4394259_91657.jpg"
    local _BALL_IMAGE = "sprites/ballBlue.png"
    local _PADDLE_1 = "sprites/paddleBlu.png"
    local _PADDLE_2 = "sprites/paddleRed.png"
    local _startEnd = "audio/lowDown.ogg"
    local _break = "audio/lowThreeTone.ogg"
    local _touch = "audio/lowRandom.ogg"

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
    sprites.paddle = love.graphics.newImage(_PADDLE_1)
    sprites.paddleTouched = love.graphics.newImage(_PADDLE_2)

    -- Background
    background = {}
    background.image = sprites.background
    background.width = love.graphics.getWidth() / background.image:getWidth()
    background.height = love.graphics.getHeight() / background.image:getHeight()
    background.marge = 32

    -- Player
    player = {}
    player.image = sprites.paddle
    player.score = 0
    player.location = love.graphics.getWidth() / 2
    player.padSize = 100
    player.speed = 1200
    
    -- Ball
    ball = {}
    ball.image = sprites.ball
    ball.size = 50
    ball.speed = 600
    ball.score = 0
    ball.x = love.graphics.getWidth() / 2
    ball.y = love.graphics.getHeight() / 10
    ball.directionX = math.random(love.graphics.getWidth()-ball.size)
    ball.isFalling = true
    ball.limitLow = love.graphics.getHeight() - background.marge - player.image:getHeight() * 1.5

    -- Sounds
    audioTouch = love.audio.newSource(_touch, "static")
    audioStartEnd = love.audio.newSource(_startEnd, "static")
    audioBreak = love.audio.newSource(_break, "static")

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
        local angle = 0
        if isFalling then
            angle = math.atan2(ball.limitLow - ball.y, ball.directionX - ball.x)
        else
            angle = math.atan2(ball.limitLow + ball.y, ball.directionX + ball.x)
        end

        ball.x = ball.x + ball.speed * math.cos(angle) * dt
        if ball.isFalling then
            ball.y = math.min((ball.y + ball.speed * math.sin(angle) * dt), (ball.limitLow))
        else
            ball.y = math.max((ball.y - ball.speed * math.sin(angle) * dt), 0)
        end

        --Ball Touch Paddle
        if isBallTouchingThePaddle() then
            audioTouch:play()
            player.image = sprites.paddleTouched
            -- next the ball rebounce...
            ball.isFalling = false
        else
            player.image = sprites.paddle
        end

        -- Ball Fall beyond the paddle
        if ball.isFalling and ball.y >= ball.limitLow then
            audioStartEnd:play()
            gameState = "start"
            print("GAME OVER")
        end

        --Ball Touch the roof
        if isBallTouchingTheRoof() then
            audioBreak:play()
            -- ball rebounce
            ball.isFalling = true
        end
    end
end


function love.draw()
    -- Background
    love.graphics.draw(background.image, 0, 0, nil, background.width, background.height)

    if gameState == "start" then
        -- Start Menu
        love.graphics.setFont(menuFont)
        love.graphics.printf("Press Space To Start The Game", 0, (love.graphics.getHeight()/3)-(scoreFontSize/2), love.graphics.getWidth(), "center")
        -- Scores
        local _score = player.score .. " : " .. ball.score
        love.graphics.setFont(scoreFont)
        love.graphics.printf(_score, 0, (love.graphics.getHeight()/2)-(scoreFontSize/2), love.graphics.getWidth(), "center")
    end
    
    -- Player
    love.graphics.draw(player.image, player.location, love.graphics.getHeight()-(background.marge*1.5), nil, nil, nil, player.padSize/2)

    -- Ball
    love.graphics.draw(ball.image, ball.x, ball.y, nil, nil,nil, ball.size/2)
end


-- Escape function / Quit the game
-- Start Game
function love.keypressed(key)
    if key == 'space' then
        if gameState == 'start' then
            audioStartEnd:play()
            gameState = 'play'
        end
    elseif key == 'escape' then
        if gameState == 'start' then
            love.event.quit()
        else
            audioStartEnd:play()
            gameState = 'start'
        end
    end
end

function isBallTouchingThePaddle()
    return ball.y >= ball.limitLow and ball.x <= player.location + player.image:getWidth() and ball.x >= player.location 
end

function isBallTouchingTheRoof()
    return ball.y <= 0
end