LOGS_RECV = 1    -- general purpose logger
CLIENT_RECV = 10 -- all clients receive messages on this channel
SERVER_RECV = 20 -- server receives messages on this channel
EXIT_COMMAND = "exit" -- shared exit command where clients do not respond

local modem = nil
local peripherals = peripheral.getNames()
for name = 1, #peripherals, 1 do
    if (peripheral.getType(peripherals[name]) == "modem") then
        modem = peripheral.wrap(peripherals[name])
        break
    end
end

if (modem == nil) then
    error("Error, this program requires a Modem!")
end

modem.open(SERVER_RECV)

repeat
    write("Enter the target channel or press enter to broadcast: ")
    local target = tonumber(io.read())
    local channel = target or CLIENT_RECV
    local log = target and "sending to " .. channel or "broadcasting to all clients"
    print(log)
    modem.transmit(LOGS_RECV, SERVER_RECV, log)
    write("Enter a command or type 'exit' to quit: ")
    local command = io.read()
    modem.transmit(channel, SERVER_RECV, command)
    if command ~= EXIT_COMMAND then
        local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
        log = message .. " from " .. replyChannel .. " at distance " .. senderDistance
        print(log)
        modem.transmit(LOGS_RECV, SERVER_RECV, log)
    end
until command == EXIT_COMMAND

modem.close(SERVER_RECV)
