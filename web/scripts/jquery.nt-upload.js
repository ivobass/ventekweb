// nettalk file upload wrapper

(function( $, undefined ) {

$.widget( "ui.ntupload", {
	options: {
		proc: '',
		field: '',
		multiple: true,
		autoUpload: false,
		jQueryButtons: true, 				
		addText: 'Add Files',
		addIcon: '',
		addClass: '',
		addId: 'a',
		addOnce: 1,
		clearText: 'Clear',
		clearIcon: '',
		clearClass: '',
		clearId: 'l',
		startText: 'Start',
		startIcon: '',
		startClass: '',
		smallStartClass: '',
		startId: 's',		
		cancelText: 'Cancel',
		cancelIcon: '',
		cancelClass: '',		
		smallCancelClass: '',
		removeText: 'Remove',
		removeIcon: '',
		smallRemoveClass: '',		
		cancelId: 'c',
		progressId: 'p',
		progressClass: '',
		listTable: true,		
		tableId: '',
		tableClass: 'nt-upload-table ui-corner-all',		
		uploadingText: 'Uploading',
		uploadedText: 'Uploaded',
		failedText: 'Failed',
		waitingText: 'Waiting',
		cancelledText: 'Cancelled',
		progressEvents: 1,
		maxSize:1,
		maxWarning:'File Too Large',
		ntform:''
	},
	datas: new Array(),	
	waiting:0,
	started: 0,
	uploaded: 0,
	

//------------------------------------------------------
	_init : function() {       
	var _this=this;	
	this.options.addId = 'a' + Math.random().toString(36).substring(7);
	this.options.clearId = 'l' + Math.random().toString(36).substring(7);
	this.options.startId = 's' + Math.random().toString(36).substring(7);		
	this.options.startId = 's' + Math.random().toString(36).substring(7);		
	this.options.cancelId = 'c' + Math.random().toString(36).substring(7);
	this.options.progressId = 'p' + Math.random().toString(36).substring(7);
	
	if (this.options.jQueryButtons){		
	   
		if (this.options.addIcon){
			$(this.element).children('label').append('<span class="ui-button-icon-primary ui-icon '+this.options.addIcon+'"></span>');
			$(this.element).children('label').addClass('ui-button ui-widget ui-state-default ui-corner-all ui-button-text-icon-primary ' +this.options.addClass);			
		} else {
			$(this.element).children('label').addClass('ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only');
		}		
	} else {
		$(this.element).children('label').addClass('ui-button ui-corner-all nt-addfiles-button ' +this.options.addClass);
	}	
	$(this.element).children('label').append('<span id="'+this.options.addId+'" class="ui-button-text"><span>'+this.options.addText+'</span></span>');

	$(this.element).append('<button id="'+this.options.startId+'" data-inline="true" type="button" class="'+this.options.startClass+'">'+this.options.startText+'</Button>');
	$(this.element).append('<button id="'+this.options.clearId+'" data-inline="true" type="button" class="'+this.options.clearClass+'">'+this.options.clearText+'</Button>');
	$(this.element).append('<button id="'+this.options.cancelId+'" data-inline="true" type="button" class="'+this.options.cancelClass+'">'+this.options.cancelText+'</Button>');

	if (this.options.jQueryButtons){
		var options = {};
		if (this.options.startIcon){
			options = {icons: {primary: this.options.startIcon}};
		} else {
			$('#'+this.options.startId).addClass('nt-no-icon')
		}
		$('#'+this.options.startId).button(options).hide();
		options = {};
		if (this.options.clearIcon){
			options = {icons: {primary: this.options.clearIcon}};
		} else {
			$('#'+this.options.clearId).addClass('nt-no-icon')
		}	
		$('#'+this.options.clearId).button(options).hide();				
		options = {};
		if (this.options.cancelIcon){
			options = {icons: {primary: this.options.cancelIcon}};
		} else {
			$('#'+this.options.cancelId).addClass('nt-no-icon')
		}	
		$('#'+this.options.cancelId).button(options).hide();				
	} else {
		$('#'+this.options.startId).hide();	
		$('#'+this.options.clearId).hide();	
		$('#'+this.options.cancelId).hide();
	}
	
	if (this.options.listTable){
		if (!this.options.listTableId){
			this.options.tableId = 'T' + Math.random().toString(36).substring(7);
		}	
		$(this.element).append('<table id="'+this.options.tableId+'" class="'+this.options.tableClass+'"></table>');
		if (this.options.multiple){
		  $('#'+this.options.tableId).append('<tr><td colspan="4"><div id="'+this.options.progressId+'" class="'+this.options.progressClass+'" style="height:5px"></div></td></tr>');
		}  
	}
	$('#'+this.options.startId).off('click.ul').on('click.ul',function(e){_this.startall();});
	$('#'+this.options.clearId).off('click.ul').on('click.ul',function(e){_this.clearall();});
	$('#'+this.options.cancelId).off('click.ul').on('click.ul',function(e){_this.cancelall();});
	if (this.options.multiple){
	  $('#'+this.options.progressId).progressbar();
	  $('#'+this.options.progressId).hide();
	}  
	$('#'+this.options.tableId).hide();
	
  if (!!window.FormData) {
    this.options.progressEvents = true;
  } else {
    this.options.progressEvents = false;
  }	
	
	$(this.element).find('[data-do="input"]').fileupload({
        dataType: 'xml',
		url: _this.options.proc + '_' + _this.options.field + '_value?_event_=accepted',
		autoUpload: true,
		
        done: function (e, data) {
		  _this.doneone(e,data);
        },

        fail: function (e, data) {
		  _this.failone(e,data);
        },

		add: function(e,data){			
			_this.add(e,data);			
		},
		
		progressall: function (e, data) {
		  _this.progressall(e,data);			
		},
		
		progress: function (e, data) {
		  _this.progress(e,data);			
		}
		
    });
	
	},	

//------------------------------------------------------
	startall : function() {	 
        var _this=this;	                  
    if (this.options.progressEvents){
	      $('#'+this.options.progressId).show();
    }    
		if (this.options.jQueryButtons){
			$('#'+this.options.clearId).button().show();
			$('#'+this.options.cancelId).button().show();
		} else {
			$('#'+this.options.clearId).show();
			$('#'+this.options.cancelId).show();
		}		

		for(var d = 0; d < this.datas.length; d++){
			_this.startone(this.datas[d]);
		};		
	},		
	
//------------------------------------------------------
	clearall : function() {	 
    var _this=this;			
		for(var d = this.datas.length-1; d >= 0 ; d--){		    
			this.clearone(_this.datas[d]);
		};	
	},			
//------------------------------------------------------
	cancelall : function() {	 
        var _this=this;	
		$('#'+this.options.progressId).hide();
		for(var d = 0; d < this.datas.length; d++){
			_this.cancelone(this.datas[d]);
		};		
		if (this.options.jQueryButtons){
			$('#'+this.options.cancelId).button().hide();
			$('#'+this.options.startId).button().show();
			$('#'+this.options.clearId).button().show();		
		} else {
			$('#'+this.options.cancelId).hide();
			$('#'+this.options.startId).show();
			$('#'+this.options.clearId).show();		
		}		
	},			
//------------------------------------------------------
	startone : function(data) {	   
		if (this.options.progressEvents){
			$('#T'+data.context).show();
		}  
		$('#R'+data.context).hide();
		$('#C'+data.context).show();
		$('#W'+data.context).html('<span class="ui-corner-all ui-state-highlight nt-padding-5px">'+this.options.uploadingText+'</span>');
		data.submit();
		this.started += 1;
	},			
//------------------------------------------------------
	clearone : function(data,done) {	 		
		var _this=this;	
		var found=0;
		$('#T'+data.context).remove();
		if (done != true){
			$('#'+data.context).remove();
		}	
		for(var d = 0; d < this.datas.length; d++){
			if (_this.datas[d].context == data.context){
				found = true;				
			}	
			if (found){
				_this.datas[d] = _this.datas[d+1];
			}			
		}	
		this.datas.length -= 1;
		this.waiting -= 1;
		if (this.waiting == 0){
			if (this.options.jQueryButtons){
				$('#'+this.options.startId).button().hide();
				$('#'+this.options.clearId).button().hide();				
			} else {
				$('#'+this.options.startId).hide();
				$('#'+this.options.clearId).hide();				
			}			
			this.enableSave();
			if (this.uploaded ==0){
				$('#'+this.options.tableId).hide();
			}	
		}  
	},			
//------------------------------------------------------
	cancelone : function(data) {	 
        var _this=this;			
        if (!data.jqXHR) {
			data.errorThrown = 'abort';
			this._trigger('fail', data);			
        } else {
			data.jqXHR.abort();
        }		
		$('#W'+data.context).html('<span class="ui-state-error nt-padding-5px ui-corner-all">'+this.options.cancelledText+'</span>');
	},			
//------------------------------------------------------
	doneone : function(d,data) {	 
		$('#T'+data.context).hide();
		$('#S'+data.context).hide();
		$('#R'+data.context).hide();
		$('#C'+data.context).hide();
		$('#W'+data.context).html('<span class="ui-corner-all ui-state-highlight nt-padding-5px">'+this.options.uploadedText+'</span>');
		if(this.options.addOnce){
		  $('#' + this.options.field).parent().hide();
		}
		this.stopone();
		this.uploaded += 1;
		this.clearone(data,true);
		xmlProcess(data.jqXHR.responseText,true);
	},			
//------------------------------------------------------
	failone : function(d,data) {
		$('#T'+data.context).hide();
		$('#R'+data.context).show();
		$('#C'+data.context).hide();
		$('#W'+data.context).html('<span class="ui-state-error nt-padding-5px ui-corner-all">'+this.options.failedText+'</span>');
		this.stopone();
	},			
//------------------------------------------------------
	stopone : function() {	 
		this.started -= 1;
		if (this.started == 0){
			$('#'+this.options.progressId).hide();
			if (this.options.jQueryButtons){
				$('#'+this.options.cancelId).button().hide();
			} else {
				$('#'+this.options.cancelId).hide();
			}			
		}
	},			
	
//------------------------------------------------------
	add : function(e,data) {
		var _this=this;	
		var s='';
		if (this.options.multiple == false){
		  this.clearall();
		}
		$.each(data.files, function (index, file) {
			var bts;
			if (file.size == undefined){
				s = ''
			} else if (file.size < 1024){
				s = file.size + ' Bytes'
			} else if (file.size < 1048576){
				s = parseInt(file.size / 1024) + ' KB'
			} else {
				s = parseInt(file.size / 1048576) + ' MB'				
			}
			if (_this.options.maxSize && _this.options.maxSize < file.size){
				if (_this.options.maxSize < 1024){
					s = _this.options.maxSize + ' Bytes'
				} else if (_this.options.maxSize < 1048576){
					s = parseInt(_this.options.maxSize / 1024) + ' KB'
				} else {
					s = parseInt(_this.options.maxSize/ 1048576) + ' MB'				
				}
				alert(_this.options.maxWarning + ' : ' + file.name + ' > ' + s);
			} else {
				data.context = 'X' + Math.random().toString(36).substring(7);
				if (_this.options.multiple){    
					bts = '<td><button type="button" id="S'+data.context+'" data-inline="true" class="'+_this.options.smallStartClass+'">'+_this.options.startText+'</button></td>' +
						'<td><button type="button" id="R'+data.context+'" data-inline="true" class="'+_this.options.smallRemoveClass+'">'+_this.options.removeText+'</button></td>' +
					'<td	><button type="button" id="C'+data.context+'" data-inline="true" class="'+_this.options.smallCancelClass+'">'+_this.options.cancelText+'</button></td>' 
				} else {
					bts = '<td></td><td></td><td></td>'
				}			

				$('#'+ _this.options.tableId).append('<tr id="'+data.context+'"><td>'+file.name+'</td>' + 
												'<td id="Z'+data.context+'">'+s+'</td>'+
												'<td id="W'+data.context+'"><span class="">'+_this.options.waitingText+'</span></td>'+
												bts +
												 '</tr>' +
												 '<tr id="T'+data.context+'"><td colspan="6"><div id="P'+data.context+'" class="" style="height:10px"></div></td></tr>' 
												 );
				if (_this.options.jQueryButtons){
					var options = {};
					if (_this.options.startIcon){
						options = {icons: {primary: _this.options.startIcon}};
					} else {
						$('#S'+data.context).addClass('nt-no-icon')						
					}			
					$('#S'+data.context).button(options);
					options = {};
					if (_this.options.removeIcon){
						options = {icons: {primary: _this.options.removeIcon}};
					} else {
						$('#R'+data.context).addClass('nt-no-icon')
					}			
					$('#R'+data.context).button(options);
					options = {};
					if (_this.options.cancelIcon){
						options = {icons: {primary: _this.options.cancelIcon}};
					} else {
						$('#C'+data.context).addClass('nt-no-icon')
					}			
					$('#C'+data.context).button(options).hide();
				} else {
					$('#C'+data.context).hide();
				}
				$('#S'+data.context).off('click.ul').on('click.ul',function(e){_this.startone(data);});
				$('#R'+data.context).off('click.ul').on('click.ul',function(e){_this.clearone(data);});
				$('#C'+data.context).off('click.ul').on('click.ul',function(e){_this.cancelone(data);});
				
				$('#P'+data.context).progressbar();
				$('#T'+data.context).hide();
				_this.datas[_this.datas.length] = data;
				if (_this.options.autoUpload){
					_this.startone(data);
				}
				_this.waiting += 1;
			}	
		});		
		if(_this.waiting){
			$('#'+this.options.tableId).show();
			if (this.options.autoUpload == false){
				if (this.options.jQueryButtons){
					$('#'+this.options.startId).button().show();
					$('#'+this.options.clearId).button().show();
				} else {
					$('#'+this.options.startId).show();
					$('#'+this.options.clearId).show();
				}				
			} else {
				if (this.options.jQueryButtons){
					$('#'+this.options.cancelId).button().show();
				} else {
					$('#'+this.options.cancelId).show();
				}			
			}				
			this.disableSave();
		}	
	},
//------------------------------------------------------
	disableSave : function() {
		if (this.options.ntform){
			$(this.options.ntform).ntform("disableSave","upload");
		}	
	},	
//------------------------------------------------------
	enableSave : function() {
		if (this.options.ntform){
			$(this.options.ntform).ntform("enableSave","upload");
		}	
	},	
//------------------------------------------------------
	progressall : function(e,data) {
	  if (this.options.multiple){
		  $('#'+this.options.progressId).progressbar('value',parseInt(data.loaded / data.total * 100, 10));	  
		}  
	},	

//------------------------------------------------------
	progress : function(e,data) {	
	  $('#P'+data.context).progressbar('value',parseInt(data.loaded / data.total * 100, 10));
	}
	
	
//------------------------------------------------------
});

$.extend( $.ui.ntupload, {
	version: "@VERSION"
});

})( jQuery );
