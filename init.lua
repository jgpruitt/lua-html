local modname = ...
local M = {}
_G[modname] = M
package.loaded[modname] = M

local is_void_tag = { 
	["area"   ] = true
,	["base"   ] = true
,	["br"     ] = true
,	["col"    ] = true
,	["hr"     ] = true
,	["img"    ] = true
,	["input"  ] = true
,	["link"   ] = true
,	["meta"   ] = true
,	["param"  ] = true
,	["command"] = true
,	["keygen" ] = true
,	["source" ] = true
}

local function render_attribute(name, value)
	if type(value) == "table" then
		return string.format(" %s=\"%s\"", name, table.concat(value, " "))
	else
		return string.format(" %s=\"%s\"", name, tostring(value))
	end 
end

local function render_attributes(buf, attributes)
	if not attributes or #attributes == 0 then
		return
	end

	for name, value in pairs(attributes) do
		buf[#buf + 1] = render_attribute(name, value) 
	end
end

local function render_start_tag(buf, tag, attributes)
	buf[#buf + 1] = string.format("<%s%s>", tag, render_attributes(attributes))
end

local function render_end_tag(buf, tag)
	buf[#buf + 1] = string.format("</%s>", tag)
end

local function render_children(buf, children)
	local t = type(children)
	if t == nil then
		return
	elseif  t == "string" then
		buf[#buf + 1] = children
	elseif t == "function" then
		buf[#buf + 1] = tostring(children())
	elseif t == "table" then
		for _, child in ipairs(children) do
			buf[#buf + 1] = render_children(buf, child)
		end
	else
		buf[#buf + 1] = tostring(children)
	end
end

local function render_element(tag, attributes, children)
    local buf = {}
	if is_void_tag[tag] then
		render_start_tag(buf, tag, attributes)
	else
		render_start_tag(buf, tag, attributes)
        render_children(buf, children)
		render_end_tag(buf, tag)
	end
    return table.concat(buf)
end

local function split(args)
    local attributes = {}
    local children = {}
    for k, v in pairs(args) do
        if type(k) == "number" then
            children[#children + 1] = v
        else
            attributes[#attributes + 1] = v
        end
    end
    return attributes, children
end

local tags = {
  "a"
, "abbr"
, "address"
, "area"
, "article"
, "aside"
, "audio"
, "b"
, "base"
, "bdi"
, "bdo"
, "blockquote"
, "body"
, "br"
, "button"
, "canvas"
, "caption"
, "cite"
, "code"
, "col"
, "colgroup"
, "datalist"
, "dd"
, "del"
, "details"
, "dfn"
, "dialog"
, "div"
, "dl"
, "dt"
, "em"
, "embed"
, "fieldset"
, "figcaption"
, "figure"
, "footer"
, "form"
, "h1"
, "h2"
, "h3"
, "h4"
, "h5"
, "h6"
, "head"
, "header"
, "hr"
, "html"
, "i"
, "iframe"
, "img"
, "input"
, "ins"
, "kbd"
, "keygen"
, "label"
, "legend"
, "li"
, "link"
, "main"
, "map"
, "mark"
, "menu"
, "menuitem"
, "meter"
, "nav"
, "noscript"
, "object"
, "ol"
, "optgroup"
, "option"
, "output"
, "p"
, "param"
, "pre"
, "progress"
, "q"
, "rp"
, "rt"
, "ruby"
, "s"
, "samp"
, "script"
, "section"
, "select"
, "span"
, "strong"
, "style"
, "sub"
, "summary"
, "sub"
, "table"
, "tbody"
, "td"
, "textarea"
, "tfoot"
, "th"
, "thead"
, "time"
, "title"
, "tr"
, "track"
, "u"
, "ul"
, "var"
, "video"
, "wbr"
}

for _, tag in ipairs(tags) do
    M[tag] = function(args)
        local attributes, children = split(args)
        return render_element(tag, attributes, children)
    end
end

M.comment = function(comment)
    assert(type(comment) == "string", "The comment tag only supports a single string argument!")
    return string.format("<!-- %s -->", args)
end

M.doctype = function()
    return "<!DOCTYPE html>"
end

M.render = function(elements)
    local buf = {}
    for _, element in ipairs(elements) do
        buf[#buf + 1] = tostring(element)
    end
    return table.concat(buf)
end

M.import = function(env)
    for k, v in pairs(exports) do
        if k ~= "import" then
            env[k] = v
        end
    end
end

return M