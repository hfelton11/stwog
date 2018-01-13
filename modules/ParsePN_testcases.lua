-- inside: [[Category:Modules]] using this line once...

-- Unit tests for [[Module:ParsPN]]. Click talk page to run tests.
local p = require('Dev:UnitTests')
local glbls = require('Module:Globals')

local fail00 = 'invalid call to ParsePN-slash: zero arguments passed'
local fail01 = 'doSlash: no slashes found in arg-1'
local fail02 = 'doSlash: args .ne. 2 ...'
local fail04 = 'doSlash: too many slashes found in arg-1'
local fail05 = 'doSlash: NOT valid level...'
local fail06 = 'NOT an upgrade-level...'

local failXXX = 'DEBUG-uses only ... '
local failZ6 = 'doSlash: { [1] = CO,[2] = '
local failZ4 = ',[3] = CK,} '
local failZ3 = 'args:{ [1] = CO/'
local failZ1 = '/CK,[2] = isvalid,} '
local failY5 = 'ckPNkey:  sorc=CO PASSsorc=it worked ? sorta...C'
local failY4 = ' key=CK GETkey=it worked ... kirk-1'
local failY3 = ' GETtier=it worked... tier=1'
local failY2 = ' MkLnkKey=[[Captain&nbsp;Kirk]]'
local failX1 = ' ckPNvalid: '
local xxx01 = 'ell:Lfound:00xtra:choice?=00? '
local xxx02 = 'ell:L-found:1xtra:typo? >>L-1<<'
local xxx03 = 'ell:Xfound:1xtra:typo? >>X1<<'
local xxx04 = 'ell:XXXfound:1xtra:typo? >>XXX1<<'
local xxx05 = 'ell:Lfound:51xtra:choice?=51? '
local xxx39 = ' ckPNvalid:lvl=39'

local failYY = '/CK,[2] = tbd...,} '
local failY1 = failYY..failY5..failY4..failY3..failY2
local failX2 = failZ1..failY5..failY4..failY3..failY2
local failX3 = failZ4..failZ3

function p:test_slash_args()
    self:preprocess_equals('{{#invoke:ParsePN | slash }}', fail00)
    self:preprocess_equals('{{#invoke:ParsePN | slash | xxxxx }}', fail02)
    self:preprocess_equals('{{#invoke:ParsePN | slash | xxxxx | isok }}', fail01)
    self:preprocess_equals('{{#invoke:ParsePN | slash | aaa/ | isok }}', 'ok args')
    self:preprocess_equals('{{#invoke:ParsePN | slash | /bbb | isok }}', 'ok args')
    self:preprocess_equals('{{#invoke:ParsePN | slash | /bbb/ | isok }}', 'ok args')
    self:preprocess_equals('{{#invoke:ParsePN | slash | //ccc | isok }}', 'ok args')
    self:preprocess_equals('{{#invoke:ParsePN | slash | // | isok }}', 'ok args')
    self:preprocess_equals('{{#invoke:ParsePN | slash | aaa/bbb | isok }}', 'ok args')
    self:preprocess_equals('{{#invoke:ParsePN | slash | aaa/bbb/ccc | isok }}', 'ok args')
    self:preprocess_equals('{{#invoke:ParsePN | slash | aaa/bbb/ccc/ddd }}', fail02)
    self:preprocess_equals('{{#invoke:ParsePN | slash | aaa/bbb/ccc/ddd | isok}}', fail04)
end

function p:test_slash_XXXvalids()
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L00/CK | isvalid }}', failZ6..'L00'..failX3..'L00'..failX2..failX1..xxx01)
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L-1/CK | isvalid }}', failZ6..'L-1'..failX3..'L-1'..failX2..failX1..xxx02)
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/X1/CK | isvalid }}', failZ6..'X1'..failX3..'X1'..failX2..failX1..xxx03)
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/XXX1/CK | isvalid }}', failZ6..'XXX1'..failX3..'XXX1'..failX2..failX1..xxx04)
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L51/CK | isvalid }}', failZ6..'L51'..failX3..'L51'..failX2..failX1..xxx05)
end

function p:test_slash_AAAdebug()
--    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L39/ANU | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L39/CK | tbd... }}', failXXX..failZ6..'L39'..failX3..'L39'..failY1..xxx39)
end

--[[

function p:test_slash_debugs()
    self:preprocess_equals('{{#invoke:ParsePN | slash | aaa/ | getLink }}', 'debug')
    self:preprocess_equals('{{#invoke:ParsePN | slash | /bbb | isvalid }}', 'debug')
    self:preprocess_equals('{{#invoke:ParsePN | slash | /bbb/ | isvalid }}', 'debug')
    self:preprocess_equals('{{#invoke:ParsePN | slash | //ccc | isvalid }}', 'debug')
    self:preprocess_equals('{{#invoke:ParsePN | slash | // | isvalid }}', 'debug')
    self:preprocess_equals('{{#invoke:ParsePN | slash | aaa/bbb | isvalid }}', 'debug')
    self:preprocess_equals('{{#invoke:ParsePN | slash | aaa/bbb/ccc | isvalid }}', 'debug')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/LMNOP/CK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L00/CK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L00/AK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L00/CCP | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L00/ANU | tbd... }}', 'debug-Level')
end

function p:test_slash_longs()
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/CK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/AK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/CCP | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/ANU | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L00001/CK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/M1/CK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L33/CK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L50/CK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L95/CK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L50/AK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L95/AK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L96/AK | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L50/CCP | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L1/ANU | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L40/ANU | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L50/ANU | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L96/ANU | tbd... }}', 'debug-Level')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L165/ANU | tbd... }}', 'debug-Level')
end
function p:test_slash_oks2()
    self:preprocess_equals('{{#invoke:ParsePN | slash | aaa/bbb }}', fail02)
    self:preprocess_equals('{{#invoke:ParsePN | slash | aaa/bbb/ccc }}', fail02)
end

--]]

function p:test_slash_valids()
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/CK | isvalid }}', 'valid Lvl-1')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/AK | isvalid }}', 'valid Lvl-10')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/CCP | isvalid }}', 'valid Lvl-40')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L1/CK | isvalid }}', 'valid Lvl-1')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L5/CK | isvalid }}', 'valid Lvl-5')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L10/CK | isvalid }}', 'valid Lvl-10')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L49/CK | isvalid }}', 'valid Lvl-49')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L50/CK | isvalid }}', 'valid Lvl-50')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L165/CCP | isvalid }}', 'valid Lvl-165')
end

function p:test_slash_upgr()
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/CK | getUpgr }}', 'mk-def')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/AK | getUpgr }}', 'mk-def')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/CCP | getUpgr }}', 'mk-def')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L2/CK | getUpgr }}', fail06)
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L0000001/CK | getUpgr }}', 'mk-def')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L50/CK | getUpgr }}', 'mk-up10')
--    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L2/AK | getUpgr }}', 'tbd...')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L10/AK | getUpgr }}', 'mk-def')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L40/AK | getUpgr }}', fail06)
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L50/AK | getUpgr }}', 'mk-up10')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L95/AK | getUpgr }}', 'mk-up15')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L40/CCP | getUpgr }}', 'mk-def')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L50/CCP | getUpgr }}', 'mk-up03')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L95/CCP | getUpgr }}', fail06)
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L96/CCP | getUpgr }}', 'mk-up09')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L165/CCP | getUpgr }}', 'mk-up15')
end

function p:test_slash_links()
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/CK | getLink }}', '[[Captain&nbsp;Kirk]]')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/L50/CK | getLink }}', '[[Captain&nbsp;Kirk]]')
    self:preprocess_equals('{{#invoke:ParsePN | slash | CO/ZZZZ/CK | getLink }}', '[[Captain&nbsp;Kirk]]')
end

return p

