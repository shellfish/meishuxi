(function(_M) {
	_M = dojo.provide('lib.dijit.DataTable')
	dojo.require('dijit._Widget')

	dojo.declare('lib.dijit.DataTable', dijit._Widget, {
		dataSource:[],
		rowSize:2,            // 每行默认的列数
		postCreate:function() {
			// all magic happens here
			var root = this.domNode
			
			var table = dojo.doc.createElement('table')
			dojo.addClass(table, 'form') 
			root.appendChild(table)

			var tbody = dojo.doc.createElement('tbody')
			table.appendChild(tbody)


			// prepare for loop
			var count = 0
			var tr = dojo.doc.createElement('tr')

			var self = this
			dojo.forEach(this.dataSource, function(item) {
				var th = dojo.doc.createElement('th')
				var td = dojo.doc.createElement('td')
				th.innerHTML = item.key
				td.innerHTML = item.value
				tr.appendChild(th)
				tr.appendChild(td)
				


				if (++count % self.rowSize === 0) {
					// new row
					tbody.appendChild(tr)
					tr = dojo.doc.createElement('tr')
				}
			})

			if (count % this.rowSize !== 0) { tbody.appendChild(tr) }
		}
	})

})()
