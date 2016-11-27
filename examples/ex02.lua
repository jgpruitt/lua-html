#!/bin/usr/env lua
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
local luahtml = require("luahtml")

local function view(model)
    local _ENV = luahtml.import()

    return render{

        doctype{},
        html{
            head{
                title{model.title}
            },
            body{
                h1{id = "header1", "A Header for ", model.h1},
                p{id = "p1", class="para", "This is a paragraph!"},
                p{id = "p2", class="para", "This is another paragraph!"},
                ol{
                    li{"one"},
                    li{"two"},
                    li{"three"}
                }
            }
        }

    }
end

local out = view{
    title = "Example 02",
    h1 = "Example 02",
}

print(out)