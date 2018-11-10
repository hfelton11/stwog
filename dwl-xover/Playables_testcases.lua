-- Playables/testcases module

-- Unit tests for Module:PlayablesCode. Click talk page to run tests.
local p = require('Dev:UnitTests')


function p:test_hello()
	self:preprocess_equals('{{#invoke:PlayablesCode | hello}}', 'Hello, world!')
end

function p:test_main()
	self:preprocess_equals('{{#invoke:PlayablesCode | main}}', 'invalid call to PlayablesCode-main: zero arguments passed')
	self:preprocess_equals('{{#invoke:PlayablesCode | main | xxx }}', 'xxx')
	self:preprocess_equals('{{#invoke:PlayablesCode | main | xxx | yyy }}', 'main ok: yyy')
end

function p:test_GoodKey()
	self:preprocess_equals('{{#invoke:PlayablesCode | isGoodKey}}', 'false')
	self:preprocess_equals('{{#invoke:PlayablesCode | isGoodKey | xxx }}', 'false')
	self:preprocess_equals('{{#invoke:PlayablesCode | isGoodKey | AllDoctors }}', 'true')
end


return p

