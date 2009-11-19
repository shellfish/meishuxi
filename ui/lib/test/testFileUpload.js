(function(_M) {
	_M = dojo.provide('lib.test.testFileUpload')
	dojo.require("dojox.form.FileUploader");
	dojo.require("dijit.form.Button");

	lib.core = {}
	_M.bindApp = lib.core.bindApp =  function() {

		var upload_button = new dijit.form.Button({
			label:'上传',
			title:'上传'
		})
		upload_button.placeAt(dojo.body())

		var uploader = new dojox.form.FileUploader({
			isDebug:true,
			deferredUploading:true,
			uploadUrl:'ReceiveFile.php',
			uploadOnChange:false,
			force:'',
			fileListId:'attachmentList'
			}, upload_button.domNode);

		var  button = new dijit.form.Button({
			label:'提交',
			id:'uploadFiles'
		})

		button.placeAt( dojo.body() , 'first')

		dojo.connect(dojo.byId('uploadFiles'), 'onclick', uploader, 'upload');

	}

})()
