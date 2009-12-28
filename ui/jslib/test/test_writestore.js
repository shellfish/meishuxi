#! /usr/bin/env js

print('@DIRRC loading dojo...')
load('../dojo-release-1.4.0-src/dojo/dojo.js')

// test for dojo.data.Write
dojo.require('dojo.data.ItemFileWriteStore')

print('@DIREC  initialize store...')
// data from user info
var store = new  dojo.data.ItemFileWriteStore({
	data:{"items":[{"attribute":"type","value":"student"},{"attribute":"id","value":"D02390"},{"attribute":"姓名","value":"柳河东"},{"attribute":"性别","value":"男"},{"attribute":"政治面貌","value":"团员"},{"attribute":"电子邮件","value":"???"},{"attribute":"固定电话","value":"???"},{"attribute":"手机","value":"???"},{"attribute":"身份证号","value":"???"}]}
})

function isDirty() {
	print('$INFO store is ', store.isDirty() ? 'Dirty': 'Clean')
}

isDirty()

var features = store.getFeatures();
for(var i in features){
  print("#META Store supports feature: " + i);
}

print('@DIREC bind notify signal callbacks...')
dojo.connect(store, 'onSet', function(item, attribute, oldValue, newValue) {
	print('[' , item, ']:', attribute , ' changed from ', oldValue, ' to', newValue)
})




///////////////////////////////////////////////////////////////////////////
print('$INFO new items...')
for (var i=0; i < 3; i++) {
	var s1 = Math.random()
	store.newItem({attribute: s1, value:s1 })
}
isDirty()

///////////////////////////////////////////////////////////////////////////
print('$INFO traversal store...')
var gotItems = function(items, request){
  print("Number of items located: " + items.length);
 
  var attrs = null
  dojo.forEach(items, function(item, i) {
  		if (!attrs) attrs = store.getAttributes(item)
		print('Index ', i, '===>')
		for (var k in attrs) print(attrs[k], ' = ', item[attrs[k]])
  })
};
store.fetch({onComplete: gotItems});

//store.save({ onComplete:function() { print('********8')} })









