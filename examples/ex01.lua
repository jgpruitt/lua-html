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

local function view()
    --import the module's members directly into the function's _ENV
    local _ENV = luahtml.import()

    return render{

        doctype{},
        comment "this is a comment!",
        html{
            head{
                title{"Hello World!"}
            },
            body{
                h1{"A Header!"},
                p{"This is a paragraph!"},
                p{"This is another paragraph!"},
                ol{
                    li{"one"},
                    li{"two"},
                    li{"three"}
                }
            }
        }

    }
end

local out = view()

assert(out == [[<!DOCTYPE html><!-- this is a comment! --><html><head><title>Hello World!</title></head><body><h1>A Header!</h1><p>This is a paragraph!</p><p>This is another paragraph!</p><ol><li>one</li><li>two</li><li>three</li></ol></body></html>]])

print(out)