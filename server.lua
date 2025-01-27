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
    write("broadcast: ")
    local input = io.read()
    local target = tonumber(input)
    local channel = target or CLIENT_RECV
    if target then
        write("command: ")
    end
    local command = target and io.read() or input
    local log = target and "sending " .. command .. " to " .. channel or "broadcasting " .. command .. " to all clients"
    print(log)
    modem.transmit(LOGS_RECV, SERVER_RECV, log)
    modem.transmit(channel, SERVER_RECV, command)
until command == EXIT_COMMAND

modem.close(SERVER_RECV)
