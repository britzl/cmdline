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
-- @return options Options (ie anything)
-- @return args Arguments
function M.parse(argv)
	local options = { }
	local arguments = { }
	if not argv then
		return options, arguments
	end
	for i,arg in ipairs(argv) do
		local long_opt = arg:match("^%-%-(.*)")
		local short_opt = arg:match("^%-(.*)")
		if long_opt or short_opt then
			local key, value
			if long_opt then
				key, value = long_opt:match("([a-z_%-]*)=(.*)")
			else
				key, value = short_opt:match("([a-z_])=(.*)")
			end

			if value then
				-- option seen once? transform option to array of values
				if type(options[key]) == 'string' then
					options[key] = { options[key], value }
				-- options seen many times? append value
				elseif type(options[key]) == 'table' then
					table.insert(options[key], value)
				-- options was not seen. assign value
				else
					options[key] = value
				end
			-- no value provided. just set option to true
			elseif key and key ~= "" then
				options[key] = true
			-- options stop. copy left arguments
			elseif long_opt then
				for i = i + 1, #argv do
					table.insert(arguments, argv[i])
				end
				break
			end
		else
			table.insert(arguments, arg)
		end
	end
	return options, arguments
end

return M
