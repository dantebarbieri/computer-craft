CLIENT_MODEM_SIDE = "left" -- side of the modem on the client
LOGS_RECV = 1                        -- general purpose logger
CLIENT_RECV = 10                     -- all clients receive messages on this channel
MY_RECV = math.random(300, 900) * 10 -- this client receives messages on this channel
EXIT_COMMAND = "exit" -- shared exit command where clients do not respond

local modem = peripheral.wrap(SERVER_MODEM_SIDE)
modem.open(CLIENT_RECV)
modem.open(MY_RECV)

repeat
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    local response = "ack: " .. message .. " from " .. replyChannel
    modem.transmit(replyChannel, MY_RECV, response)
    modem.transmit(LOGS_RECV, MY_RECV, response)

    local log = nil
    if message == "forward" then
        log = turtle.forward() and "moved forward" or "could not move forward"
    elseif message == "back" then
        log = turtle.back() and "moved back" or "could not move back"
    elseif message == "up" then
        log = turtle.up() and "moved up" or "could not move up"
    elseif message == "down" then
        log = turtle.down() and "moved down" or "could not move down"
    elseif message == "left" then
        log = turtle.turnLeft() and "turned left" or "could not turn left"
    elseif message == "right" then
        log = turtle.turnRight() and "turned right" or "could not turn right"
    end

    if log then
        modem.transmit(LOGS_RECV, MY_RECV, log)
    end

until message == EXIT_COMMAND

modem.close(MY_RECV)
modem.close(CLIENT_RECV)
