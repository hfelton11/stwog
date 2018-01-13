-- creating a blank-space for Global variables
-- inside: [[Category:Modules]] using this line once...
-- This does not "harm" the _G namespace...
local D = {}
return D

-- to use, simply require this module and put your new globals into it...
--  file A:  local glb = require('Module:Globals')
--           glb.passedVariable = true
--           local function a()
--              if glb.passedVariable==true then...
--          end
-- see: https://coronalabs.com/blog/2013/05/28/tutorial-goodbye-globals/

