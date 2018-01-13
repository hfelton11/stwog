--[===[

This module implements the {{t|Table Row Counter}} template.

== Usage from wikitext ==

This module can be used from wikitext in the same way as the {{t|Table Row Counter}} template, by simply using <code>{{((}}#invoke:Table Row Counter|main</code> in place of <code>{{((}}Table Row Counter</code>.

== Usage from Lua modules ==

To use this module from other Lua modules, first load the module.

<source lang="lua">
local mTRC = require('Module:Table Row Counter')
</source>

You can then count table rows by using the _main function.

<source lang="lua">
mTRC._main(args)
</source>

<var>args</var> is a table containing the module arguments. See the [[Template:Table Row Counter|template documentation]] for more information about the available arguments, and for general caveats about this module's use.



<includeonly>{{#ifeq:{{SUBPAGENAME}}|sandbox||
<!-- Categories go here and interwikis go in Wikidata. -->

}}</includeonly>

--]===]

local p;

