--- A simple command line arguments parser
-- The command line parser supports both long options (--foobar) and short
-- options (-f)
--
-- Strings of form '--OPTION=VALUE' are parsed to { OPTION = 'VALUE' }.
-- Strings of form '--OPTION' are parsed to { OPTION = true }.
-- Multiple '--OPTION=VALUE' are merged into { OPTION = { 'VALUE', 'VALUE', ... } }.
--
-- Strings of form '-O=VALUE' are parsed to { O = 'VALUE' }.
-- Strings of form '-O' are parsed to { O = true }.
-- Multiple '-O=VALUE' are merged into { O = { 'VALUE', 'VALUE', ... } }.
--
-- The argument '--' terminates all options; any following arguments are treated
-- as non-option arguments, even if they begin with a hyphen.
--
-- Based on the luvit-cmdline parser from https://github.com/dvv/luvit-cmdline
-- Modifications by Björn Ritzl, https://github.com/britzl/cmdline
-- @module cmdline
local M = {}

--- Parse command line arguments string
-- @param argv Command line arguments to parse
-- @return opts Options (ie anything)
-- @return args Arguments
function M.parse(argv)
	local opts = { }
	local args = { }
	if not argv then
		return opts, args
	end
	for i, arg in ipairs(argv) do
		-- option?
		local opt = arg:match("^%-%-(.*)") or arg:match("^%-(.)")
		if opt then
			-- extract option name and value
			local key, value = opt:match("([a-z_%-]*)=(.*)")
			-- value provided?
			if value then
				-- option seen once?
				if type(opts[key]) == 'string' then
					-- transform option to array of values
					opts[key] = { opts[key], value }
				-- options seen many times?
				elseif type(opts[key]) == 'table' then
					-- append value
					table.insert(opts[key], value)
				-- options was not seen
				else
					-- assign value
					opts[key] = value
				end
			-- no value provided. just set option to true
			elseif opt ~= '' then
				opts[opt] = true
			-- options stop
			else
				-- copy left arguments
				for i = i + 1, #argv do
					table.insert(args, argv[i])
				end
				break
			end
		-- argument
		else
			table.insert(args, arg)
		end
	end
	return opts, args
end

return M
