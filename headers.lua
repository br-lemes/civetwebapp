
local mime = require("mime")

local OK         = 200
local NOTFOUND   = 404
local NOTALLOWED = 405
local ERROR      = 500

local STATUS       = { }
STATUS[OK]         = "HTTP/1.0 200 OK"
STATUS[NOTFOUND]   = "HTTP/1.0 404 Not Found"
STATUS[NOTALLOWED] = "HTTP/1.0 405 Method Not Allowed"
STATUS[ERROR]      = "HTTP/1.0 500 Internal Server Error"

local date         = os.date("! %a, %d %b %Y %H:%M:%S GMT")
local connection   = "close"
local contenttype  = mime.html
local cachecontrol = "no-cache"

local function send(status)
	mg.write(string.format(
		"%s\r\nDate: %s\r\nConnection: %s\r\nContent-Type: %s\r\nCache-Control: %s\r\n\r\n",
		STATUS[status or OK], date, connection, contenttype, cachecontrol))
end

return {
	OK           = OK,
	NOTFOUND     = NOTFOUND,
	NOTALLOWED   = NOTALLOWED,
	ERROR        = ERROR,
	date         = date,
	connection   = connection,
	contenttype  = contenttype,
	cachecontrol = cachecontrol,
	send         = send,
}
