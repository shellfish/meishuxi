dependencies = {
	layers: [
		{
			name: "../venus/core.js",
			dependencies: [
				"venus.core",
				'venus.base',
				'venus.rpc',
				'venus.config',
				'venus.shadow',
				'venus.registry'
			]
		}
	],

	prefixes: [
		[ "dijit", "../dijit" ],
		[ "dojox", "../dojox" ],
		['venus', '../venus'],
	]
};

