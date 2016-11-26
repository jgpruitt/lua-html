#!/bin/usr/env lua

local out

do
    local mod = require("luahtml")
    mod.import(_ENV)

    out = render {
        doctype(),
        comment "this is a comment!",
        html{
            head{
                title{ "Hello World!" }
            },
            body{
                h1{ "A Header!" },
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

assert(out == [[<!DOCTYPE html><!-- this is a comment! --><html><head><title>Hello World!</title></head><body><h1>A Header!</h1><p>This is a paragraph!</p><p>This is another paragraph!</p><ol><li>one</li><li>two</li><li>three</li></ol></body></html>]])

print(out)