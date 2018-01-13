-- copied from hfelton-wikia

-- Unit tests for [[Module:Bananas]]. Click talk page to run tests.
local p = require('Dev:UnitTests')

function p:test_numberOfHeroes()
    -- based upon current stripped-down version
    self:preprocess_equals('{{#invoke:HeroTable | numberOfHeroes}}', '10')
end


local SLISTDATA = {
	'\*\[\[Aira the Ice Mage\]\]\n',
	'\*\[\[Akayuki the Samurai\]\]\n',
	'\*\[\[Witch\'s Knight\]\]\n',
	'\*\[\[Wolf\]\]\n',
	'\*\[\[Wood Fairy\]\]\n',
	'\*\[\[Yeti\]\]\n',

	'\*\[\[Abracadaniel\]\]\n',
	'\*\[\[Banana Guard\]\]\n',
	'\*\[\[Tree Trunks\]\]\n',
	'\*\[\[Wildberry Princess\]\]\n',
}

function p:test_simpleList()
    -- based upon current stripped-down version
    self:equals_deep('Compare Resulting-Tables', '{{#invoke:HeroTable | simpleList}}', SLISTDATA, {nowiki=1})
end

return p

