
# allows to use dots instead of [] in Ruby code, like is done in Liquid
# this is very convenient for HAML when accessing site.*/page.*/layout.* variables
require 'hash_dot'
Hash.use_dot_syntax = true
Hash.hash_dot_use_default = true

