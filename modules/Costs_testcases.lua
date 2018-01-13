-- costs/testcases module
-- inside: [[Category:Modules]] using this line once...

-- from initial talk-page-testing...
--<pre>

-- Unit tests for [[Module:Costs]]. Click talk page to run tests.
local p = require('Dev:UnitTests')
local mList = require('Dev:List')
local q = {}

local bullet = "&#8226; "
local bullet2 = mw.ustring.char(8226)

function p:test_wrongs()
    self:preprocess_equals('{{#invoke:costs |dilithium}}', 'nothing ventured, nothing gained...')
    self:preprocess_equals('{{#invoke:costs |dilithium| uhm}}', 'a lot of effort for naught...')
    self:preprocess_equals('{{#invoke:costs |dilithium| t8c}}', 'a lot of effort for naught...')
    self:preprocess_equals('{{#invoke:costs |dilithium| t1c| purple}}', 'i dont know how to do the how called purple')
end

local values1 = {    { [1] = 20,[2] = 20,},
                    { [1] = 25,[2] = 45,},
                    { [1] = 30,[2] = 75,},
                }
--local data1 = mList.makeListData('bulleted', values1)
--local htmlstr = mList.renderList(data1)
local htmlstr2 = '<ul><li>{ [1] = 20,[2] = 20,}&#32;\n<li>{ [1] = 25,[2] = 45,} \n<li>{ [1] = 30,[2] = 75,} \n</ul>'


--function q.t1c(frame)
--    return frame.preprocess('{{#invoke:costs |dilithium| TESTtest}}')
--end

function p:test_t1c()
--    local actual = self:preprocess('{{#invoke:costs |dilithium| TESTtest}}')
--    local tester = self:preprocess(data1.render
--    local valtst = mList.renderList(data1)
    self:preprocess_equals('{{#invoke:costs |dilithium| TESTtest}}', htmlstr2)
--    self:preprocess_equals('{{#invoke:costs |dilithium| t1c}}', valt1c)
--    self:preprocess_equals('{{#invoke:costs |dilithium| t1c| fancy}}', valt1cfancy)
end

return p

