--[[
    My Love Game

    Pong Remake
    SalimPasha 2024

    Author : Anthony Salim JOLY
    el.salim.salim@gmail.com
    @SalimBXL

    Background Image by rawpixel.com on Freepik
    https://www.freepik.com/free-vector/neon-grid-background_4394259.htm#query=gaming%20background&position=21&from_view=keyword&track=ais&uuid=c36cd1f8-ba77-4f1f-be03-90d0a836e160
]]

function love.load()
    
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

    -- Paddle
    paddle = {}
    paddle.image = sprites.paddle
    paddle.score = 0
    paddle.size = paddle.image:getWidth()
    paddle.x = love.graphics.getWidth() / 2 --initial position in the middle of the window
    paddle.y = love.graphics.getHeight() - background.marge - paddle.size / 2
    paddle.speed = 1200
    
    -- Ball
    ball = {}
    ball.image = sprites.ball
    ball.score = 0
    ball.x = love.graphics.getWidth() / 2
    ball.y = love.graphics.getHeight() / 10
    ball.size = ball.image:getWidth()
    ball.speed = 600
    ball.isFalling = true

    -- Sounds
    audioTouch = love.audio.newSource(_touch, "static")
    audioStartEnd = love.audio.newSource(_startEnd, "static")
    audioBreak = love.audio.newSource(_break, "static")

    -- Game State
    --  Start   : menu
    --  play    : in game
    gameState = "start"
end


function love.update(dt)

    -- paddle movements from keyboard
    if love.keyboard.isDown("left") then
        paddle.x = math.max(background.marge/2 + paddle.size/2, paddle.x + -paddle.speed * dt)
    elseif love.keyboard.isDown("right") then
        paddle.x = math.min(love.graphics.getWidth() - background.marge/2 - paddle.size/2, paddle.x + paddle.speed * dt)
    end

    -- Ball movements
    if gameState == "play" then
        local angle = math.pi / 2
        ball.x = ball.x + ball.speed * math.cos(angle) * dt
        if ball.isFalling then
            ball.y = math.min((ball.y + ball.speed * math.sin(angle) * dt), love.graphics.getHeight() - ball.image:getHeight() / 2)
        else
            ball.y = math.max((ball.y - ball.speed * math.sin(angle) * dt), 0)
        end
    end

    --Ball Touch Paddle
    if isBallTouchingThePaddle() then
        audioTouch:play()
        paddle.image = sprites.paddleTouched
        -- next the ball rebounce...
        ball.isFalling = false
    else
        paddle.image = sprites.paddle
    end

    --Ball Touch the roof
    if isBallTouchingTheRoof() then
        audioBreak:play()
        -- ball rebounce
        ball.isFalling = true
    end

    -- Ball is outside teh window
    if isBallOutside() then
        audioStartEnd:play()
        gameState = "start"
        ball.x = love.graphics.getWidth() / 2
        ball.y = love.graphics.getHeight() / 10
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
        local _score = paddle.score .. " : " .. ball.score
        love.graphics.setFont(scoreFont)
        love.graphics.printf(_score, 0, (love.graphics.getHeight()/2)-(scoreFontSize/2), love.graphics.getWidth(), "center")
    end
    
    -- paddle
    love.graphics.draw(paddle.image, paddle.x, love.graphics.getHeight()-(background.marge*1.5), nil, nil, nil, paddle.size/2)

    -- Ball
    love.graphics.draw(ball.image, ball.x, ball.y, nil, nil, nil, ball.size / 2 , ball.size / 2)
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
    local paddleTop = love.graphics.getHeight() - background.marge - paddle.image:getHeight()/2
    local paddleLeft = paddle.x - paddle.size / 2
    local paddleRight = paddle.x + paddle.size / 2
    local ballBottom = ball.y + ball.size / 2
    local ballLeft = ball.x - ball.size / 2
    local ballRight = ball.x + ball.size / 2    
    return (ballBottom >= paddleTop and ballRight >= paddleLeft and ballLeft <= paddleRight)
end

function isBallTouchingTheRoof()
    return ball.y <= ball.size / 2
end

function isBallTouchingTheFloor()
    return ball.y >= love.graphics.getHeight() - ball.size / 2
end

function isBallOutside()
    return ball.x <= 0 or ball.x >= love.graphics.getWidth() or ball.y >= love.graphics.getHeight() - background.marge
end