-- copied from: https://en.wikipedia.org/wiki/Module:Table_row_counter
-- This module counts table rows in wikitext.

local p = {}
local getArgs

-- this has a ways to go due to fandom-meta-table issues like getargs-copy...
-- sigh...
-- urp - or maybe not...  i think it ''just worked'' (tm)...  :-)
-- sigh, just lucky for one-table-on-current-page defaults-case...

function p.main(frame)
	if not getArgs then
		getArgs = require('Dev:Arguments').getArgs
	end
	return p._main(getArgs(frame, {wrappers = 'Template:Table Row Counter'}))
end

function p._main(args)
	-- Get the title object.
	local titleObj
	do
		local success
		success, titleObj = pcall(mw.title.new, args.page)
		if not success or not titleObj then
			titleObj = mw.title.getCurrentTitle()
		end
	end

	-- Get the page content.
	local content = titleObj:getContent()
	if not content then
		return nil
	end

	-- Find the wikitables on that page.
	local wikitables = {}
	do
		local iWikitable = 0
		local s1 = content:match('^({|.-\n|})')
		if s1 then
			iWikitable = iWikitable + 1
			wikitables[iWikitable] = s1
		end
		for s in content:gmatch('\n({|.-\n|})') do
			iWikitable = iWikitable + 1
			wikitables[iWikitable] = s
		end
	end

	-- Find the wikitable to work on.
	local wikitable
	local special
	-- if id, then 0.1
	-- if tableno, then tableno*0.01
	-- if ignore, then ignore*0.001
	if args.id then
		for i, s in ipairs(wikitables) do
			if s:match('^{|[^\n]*id *= *" *(%w+) *"') == args.id then
				wikitable = s
				break
			end
		end
	    special = 0.1
	else
		wikitable = wikitables[tonumber(args.tableno) or 1]
	    special = 0.01 * tonumber(args.tableno)
	end
	special = 0.001 * tonumber(args.ignore)
	if not wikitable then
		return nil
	end

	-- Count the number of rows.
	local count
	do
		local temp
		temp, count = wikitable:gsub('\n|%-', '\n|-')
	end

	-- Control for missing row markers at the start.
	if not wikitable:find('^{|[^\n]*%s*\n|%-') then
		count = count + 1
	end

	-- Control for extra row markers at the end.
	if wikitable:find('\n|%-[^\n]-%s*\n|}$') then
		count = count - 1
	end

	-- Subtract the number of rows to ignore, and make sure the result isn't
	-- below zero.
	count = count - (tonumber(args.ignore) or 0)
	if count < 0 then
		count = 0
	end
	retval = count + special
--	return count
	return retval
end

return p

