LOGGER_MODEM_SIDE = "back" -- side of the modem on the logger
LOGS_RECV = 1                        -- general purpose logger

local modem = peripheral.wrap(LOGGER_MODEM_SIDE)
modem.open(LOGS_RECV)

while true do
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    local log = replyChannel .. ": " .. message .. " (" .. senderDistance .. " m)"
    local color = math.floor(replyChannel / 10)
    term.setTextColor(color)
    print(log)
end

modem.close(LOGS_RECV)
