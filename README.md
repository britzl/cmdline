cmdline
=======
A simple command line argument parser for Lua. The command line parser supports both long options (--foobar) and short options (-f).

long options
------------
Strings of form '--OPTION=VALUE' are parsed to { OPTION = 'VALUE' }.
Strings of form '--OPTION' are parsed to { OPTION = true }.
Multiple '--OPTION=VALUE' are merged into { OPTION = { 'VALUE', 'VALUE', ... } }.

short options
-------------
Strings of form '-O=VALUE' are parsed to { O = 'VALUE' }.
Strings of form '-O' are parsed to { O = true }.
Multiple '-O=VALUE' are merged into { O = { 'VALUE', 'VALUE', ... } }.

argument termination
--------------------
The argument '--' terminates all options; any following arguments are treated as non-option arguments, even if they begin with a hyphen.

usage
=====
```
local cmdline = require("cmdline")

local options, arguments = cmdline.parse(...)
```

acknowledgement
===============
Based on the [luvit-cmdline parser](https://github.com/dvv/luvit-cmdline)
