
local mime = require("mime")
local json = require("json")
local headers = require("headers")
local mustache = require("mustache")
local boilerplate = require("boilerplate")

local view = { }

if mg.request_info.path_info then
	headers.send(headers.NOTFOUND)
	view.lang    = "en"
	view.title   = "404 Not Found"
	view.favicon = "error"
	view.content = '<h1 class="w3-container">404 Not Found</h1>'
	mg.write(boilerplate.render(view))
	return
end

local applist = { }
for file in lfs.dir("www") do
	if file ~= "." and file ~= ".." then
		local mode = lfs.attributes("www/" .. file, "mode")
		if mode == "directory" then
			local n = string.format("www/%s/info.json", file)
			local m = lfs.attributes(n, "modification")
			if m then
				local f, e = io.open(n)
				if f then
					local buf = f:read("*a")
					f:close()
					local app = json.decode(buf)
					app.href = file
					table.insert(applist, app)
				end
			end
		end
	end
end

table.sort(applist, function (a, b) return a.name < b.name end)

headers.send(headers.OK)
view.lang    = "pt-br"
view.title   = "Lista de aplicativos"
view.favicon = "application_view_list"
view.body    = "w3-light-grey w3-padding-64"
view.style   = "span[id] { display: block; margin-top: -64px; padding-top: 64px; }"
view.content = mustache.render([[
	<nav class="w3-card w3-top w3-white w3-center" style="overflow: auto; white-space: nowrap;">
	{{#.}}
		<a href="/{{href}}" class="w3-button w3-hover-blue">
			<img src="/fatcow/32/{{icon}}.png" width="32" height="32" alt="Ícone">
		</a>
	{{/.}}
	</nav>

	<div class="w3-card w3-content w3-white w3-center">
		<h3>Lista de aplicativos</h3>
	</div>
	{{#.}}

	<span id="{{href}}"></span>
	<div class="w3-card w3-content w3-white">
		<h4><a href="/{{href}}" class="w3-button w3-border-blue w3-border-bottom w3-hover-blue w3-block w3-left-align">
			<img src="/fatcow/32/{{icon}}.png" width="32" height="32" alt="Ícone">
			{{name}}
		</a></h4>
		<div class="w3-container w3-padding">
			{{description}}
		</div>
	</div>
	{{/.}}
]], applist)
mg.write(boilerplate.render(view))
