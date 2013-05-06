#!/usr/bin/ruby -w

require 'plock'
p { 1 + 2 }

a = []
b = 1
c = 2
d = 3
p { a << b << c << d }
p { a }
