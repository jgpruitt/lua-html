--[[
MIT License

Copyright (c) 2016 John Pruitt <jgpruitt@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local modname = ...
local M = {}
_G[modname] = M
package.loaded[modname] = M

--[[
void tags may have attributes but they are not allowed to have children or
a closing tag
--]]
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
    assert(type(name) == "string", "name must be a string")
    local format = " %s=\"%s\""
	local t = type(value)
    if t == "table" then
		return string.format(format, name, table.concat(value, " "))
    elseif t == "function" then
        return string.format(format, name, tostring(value()))
	elseif t == "boolean" or t == "number" then
		return string.format(format, name, tostring(value))
    elseif t == "string" then
		return string.format(format, name, value)
    else -- nil, thread, or userdata
        return ""
	end 
end

local function render_child(child)
	local t = type(child)
	if t == "string" then
		return child
	elseif t == "function" then
		return tostring(child())
	elseif t == "table" then
        local buf = {}
		for _, v in ipairs(child) do
			buf[#buf + 1] = render_child(v)
		end
        return table.concat(buf)
	elseif t == "boolean" or t == "number" then
		return tostring(children)
    else -- nil, thread, or userdata 
        return ""
	end
end

local function render(tag, args)
    assert(type(tag) == "string", "tag must be a string")

    local is_void = is_void_tag[tag]

    local attributes = {}
    local children = {}
    for k, v in pairs(args) do
        if type(k) == "number" then
            if not is_void then
                children[#children + 1] = render_child(v)
            end
        else
            attributes[#attributes + 1] = render_attribute(k, v)
        end
    end
    
    attributes = table.concat(attributes)
    children = table.concat(children)

    local buf = {}
    buf[#buf + 1] = string.format("<%s%s>", tag, attributes)
    if not is_void then
        buf[#buf + 1] = children
        buf[#buf + 1] = string.format("</%s>", tag)
    end
    return table.concat(buf)
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
--, "table" a bit dangerous due to the "table" package in std lib. see "tbl" below 
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
        return render(tag, args)
    end
end

M.tbl = function(args)
    return render("table", args)
end

M.comment = function(comment)
    assert(type(comment) == "string", "The comment tag only supports a single string argument!")
    return string.format("<!-- %s -->", comment)
end


M.document = function(elements)
    local buf = {"<!DOCTYPE html>"}

    --[[
    in all likelyhood there will only be one element at the root level in the
    document: the "html" element. however, there could be any number of comments
    before or after the html element.
    --]]
    for _, element in ipairs(elements) do
        buf[#buf + 1] = tostring(element)
    end
    return table.concat(buf)
end

--[[
if you'd like the tag functions in the root of your environment for convenience
sake, call import(_ENV) and they will be injected directly into it
--]]
M.import = function(env)
    for k, v in pairs(M) do
        if k ~= "import" then
            env[k] = v
        end
    end
end

return M