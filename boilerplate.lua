
local mustache = require("mustache")

local template = [[
<!DOCTYPE html>
<html{{#lang}} lang="{{lang}}"{{/lang}}>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<link href="/w3.css" rel="stylesheet">
	{{#favicon}}<link rel="icon" href="/fatcow/16/{{favicon}}.png">
	{{/favicon}}<title>{{title}}</title>
{{#style}}
	<style>
{{{style}}}
	</style>
{{/style}}
{{#script}}
	<script>
{{{script}}}
	</script>
{{/script}}
</head>
<body{{#body}} class="{{body}}"{{/body}}>
{{{content}}}
</body>
</html>
]]

local function render(view)
	return mustache.render(template, view)
end

return { render = render }
