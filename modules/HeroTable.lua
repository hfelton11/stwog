-- <pre>
-- copied from dungeonlink wikia and modified...
-- inside: [[Category:Modules]] using this line once...

--local heroLoader = require('Module:Hero')
--local skillData = require('Module:Skill')

local p = {}

--local CharacterCodes = require('Module:Charactercodes')

-- this was used for unit-testing on 2016-08-03
local TESTHEROES = {
	'Aira the Ice Mage',
	'Akayuki the Samurai',
	'Witch\'s Knight',
	'Wolf',
	'Wood Fairy',
	'Yeti',

	'Abracadaniel',
	'Banana Guard',
	'Tree Trunks',
	'Wildberry Princess',
}
-- actual data for THIS game...
local HEROES = { 'aaaTestHero-1', 'aaaTestHero-2', 'aaaTestHero-3', 'aaaTestHero-4'
    , 'kirk-1', 'kirk-2'
}
local TBDHEROES = { 'aaaTestHero-1', 'aaaTestHero-2', 'aaaTestHero-3', 'aaaTestHero-4'
    , 'anita-1', 'armus-2'
    , 'beverly-1', 'beverly-2', 'bird-of-prey-1', 'borg-1', 'borg-2', 'borg-3', 'borg-4', 'borg-cube-1', 'borja-1'
    , 'cardassian-1', 'cardassian-2', 'carlos-1', 'chekov-1', 'chekov-2', 'clayton-1'
    , 'danimetal-1', 'data-1', 'data-2'
    , 'early-bop-2', 'enterprise-1', 'enterprise-a', 'enterprise-d-1'
    , 'ferengi-marauder-2', 'flopez-1', 'fonsi-1', 'francis-1'
    , 'helmet-1', 'horta-2', 'human-antonio-2'
    , 'ivan-total-1'
    , 'jorge-2'
    , 'khan-3', 'kirk-1', 'kirk-2', 'klingon-2', 'klingon-3', 'klingon-4', 'klingon-5'
    , 'laforge-1', 'laforge-2'
    , 'mccoy-1', 'mccoy-2', 'mhigueras-1', 'monster-hero-1', 'monster-ship-1', 'mordi-1'
    , 'nodroz-1'
    , 'pablo-1', 'picard-1', 'picard-2'
    , 'q-3'
    , 'riker-1', 'riker-2', 'romulan-1', 'romulan-2', 'romulan-3', 'romulan-4', 'romulan-antonio-2', 'ruk-2'
    , 'sandra-1', 'scott-1', 'scott-2', 'spock-1', 'spock-2', 'sulu-1', 'sulu-2'
    , 'tarr-2'

    , 'tng-antican-2', 'tng-selay-2'
    , 'tos-gorn-3', 'tos-human-alvaro-2', 'tos-m113-2', 'tos-masked-2', 'tos-masked-3', 'tos-pnj-1-wife', 'tos-pnj-10-alberto', 'tos-pnj-11-alejandro', 'tos-pnj-12-masked-boss', 'tos-pnj-2-bad', 'tos-pnj-3-boss', 'tos-pnj-4-mask', 'tos-pnj-5-klingon-fake', 'tos-pnj-5-unmask', 'tos-pnj-6-human', 'tos-pnj-6-romulan', 'tos-pnj-7-ivan', 'tos-pnj-9-cigarrito'

    , 'troi-1', 'troi-2'
    , 'uhura-1', 'uhura-2'
    , 'worf-1', 'worf-2'
}

function p.numberOfHeroes(pFrame)
	return #HEROES
end
function p.numberOfTESTHeroes(pFrame)
	return #TESTHEROES
end

function p.simpleListNEWtbd(pFrame)
	local t = {}
	local heroes
	heroes = CharacterCodes.listcodes(pFrame)

	for i = 1, #heroes do
		t[#t+1] = '*[['..heroes[i]..']]'
	end

	return table.concat(t, '\n')
end
function p.simpleList(pFrame)
	local t = {}

	for i = 1, #HEROES do
		t[#t+1] = '*[['..HEROES[i]..']]'
	end

	return table.concat(t, '\n')
end
function p.simpleTESTList(pFrame)
	local t = {}

	for i = 1, #TESTHEROES do
		t[#t+1] = '*[['..TESTHEROES[i]..']]'
	end

	return table.concat(t, '\n')
end


local function _getTableHeader()
	local t = {}

	t[#t+1] = '{| class="wikitable sortable oddrow"'
	t[#t+1] = '! [[Tier]]'
	t[#t+1] = '! class="unsortable"|Image'
	t[#t+1] = '! Name'
	t[#t+1] = '! Type'
	t[#t+1] = '! Star'

	t[#t+1] = '! ATK'
	t[#t+1] = '! HP'
	t[#t+1] = '! FIRE'
	t[#t+1] = '! WATER'
	t[#t+1] = '! WOOD'
	t[#t+1] = '! HEAL'
	t[#t+1] = '! DEF'
	t[#t+1] = '! CRIT'
	t[#t+1] = '! FREEZE'
	t[#t+1] = '! TAUNT'
	t[#t+1] = '! BUFF'

	t[#t+1] = '! Dash'
	t[#t+1] = '! Passive'
	t[#t+1] = '! Skill'

	return table.concat(t, '\n')
end


local function _getTableRow(pHero)
	local t = {}

	t[#t+1] = '|- class="rowBackground-'..(pHero.base or "normal")..'"'
	t[#t+1] = 'style="text-align:center;" class="'..(_tierRankColor[pHero.tierPvP] or '')..'" data-sort-value="'..(_tierRankOrder[pHero.tierPvP] or '')..'"|'..pHero.tierPvP
	t[#t+1] = "[[File:"..pHero.image.."|42px|link="..pHero.name.."|&nbsp;]]"
	t[#t+1] = "[[" .. pHero.name .. "]]"
	t[#t+1] = 'style="text-align:center;" data-sort-value="'..string.lower(pHero.type)..'"|'..heroLoader.getTypeIcon(pHero.type, 21)
	t[#t+1] = 'style="text-align:center;"|'..heroLoader._evolutionNum(pHero.stars)

	t[#t+1] = pHero.attack or ""
	t[#t+1] = pHero.hp or ""
	t[#t+1] = pHero.fire or ""
	t[#t+1] = pHero.water or ""
	t[#t+1] = pHero.wood or ""
	t[#t+1] = pHero.heal or ""
	t[#t+1] = pHero.defense or ""
	t[#t+1] = pHero.critical or ""
	t[#t+1] = pHero.freeze or ""
	t[#t+1] = pHero.taunt or ""
	t[#t+1] = pHero.buff or ""

	t[#t+1] = getDash(pHero)
	t[#t+1] = getPassive(pHero)
	t[#t+1] = getSkill(pHero)

	return table.concat(t, '\n|')
end

function p.table(pFrame)
	local args = pFrame.arguments

	local limits = { stars = "highest" }

	local tHero = nil

	local heroList = {}
	-- Add to list and limit
	for i = 1, #HEROES do
		tHero = heroLoader.loadHero(HEROES[i])
		if tHero ~= nil then
			if type(limits.stars) == "number" then
				if tHero.evolutions[limits.stars] ~= nil then
					heroList[#heroList+1] = normalizeHeroEvolution(tHero, limits.stars)
				end
			else--if limits.stars == "highest" then
				for j = 6, 1, -1 do
					if tHero.evolutions[j] ~= nil then
						heroList[#heroList+1] = normalizeHeroEvolution(tHero, j)
						break
					end
				end
			end
		else
			heroList[#heroList+1] = HEROES[i]
		end
	end

	-- sort
	table.sort(heroList, function(a, b)
		if type(a) == "string" or type(b) == "string" then
			return type(a) ~= "string"
		elseif a.type ~= b.type then
			return (_typeOrder[a.type] or 100) < (_typeOrder[b.type] or 100)
		elseif a.tierPvP ~= b.tierPvP then
		    return (_tierRankOrder[a.tierPvP] or 100) < (_tierRankOrder[b.tierPvP] or 100)
		else--if a.base ~= b.base then
		    return (_baseOrder[a.base] or 100) < (_baseOrder[b.base] or 100)
		end

		--return (_tierRankOrder[a.tierPvP] or 100) < (_tierRankOrder[b.tierPvP] or 100)
	end)

	-- Add to screen
	local t = {}
	t[#t+1] = _getTableHeader()

	for i = 1, #heroList do
		tHero = heroList[i]
		if type(tHero) ~= "string" then
		    local good,tRow = pcall(_getTableRow, tHero)
		    if good then
			    t[#t+1] = tRow
			else
    			t[#t+1] = "|-"
    			t[#t+1] = '|colspan="2"|[Error]'
    			t[#t+1] = '| [[' .. (tHero.name and tHero.name or "[Error displaying]") .. ']]'
			end
		else
			t[#t+1] = "|-"
			t[#t+1] = '|'
			t[#t+1] = '|'
			t[#t+1] = '| [[' .. tHero .. ']]'
		end
	end

	t[#t+1] = '|}'

	return table.concat(t, '\n')
end

return p

