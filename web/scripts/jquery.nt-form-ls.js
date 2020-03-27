(function( $, undefined ) {
$.widget( "ui.ntformls", {
	options: {
		tablename: '',    
		table: {},
		divId: '',
		database: null,
		columns:[],
		record: {},
		primeField: function(field,table,fieldname,value,onlyIfBlank) {
			if (onlyIfBlank){
				if ($("#" + field).val() == false){
					$("#" + field).val(value);
				}
				if (this.record[fieldname] == false){
					this.record[fieldname] = value;
					this.database[table].record[fieldname] = value;
				}
			} else {
				$("#" + field).val(value);
				this.database[table].record[fieldname] = value; // not needed, but good to do
				this.record[fieldname] = value; // this is this.options here
			}	
		},	
		assignField: function(fieldname,value,onlyIfBlank) {			
			if (this.record[fieldname] == false || onlyIfBlank == false){
				this.record[fieldname] = value; // this is this.options here
			}	
		},			
		primeOnInsert: function(){},
		primeOnCopy: function(){},	 // after record loaded  
		primeOnChange: function(){}, // after record loaded
		assignOnSave: function(){},
		gotFocusBack:function(){},
		onFormOpen: function(action){}
	},	
	//------------------------------------------------------
	_init: function() {		
		this.options.database = database; // workaround for now, setting in options does not seem to be working.
		for (j in this.options.database.tables){
			if(this.options.database.tables[j].name == this.options.tablename){
				this.options.table = this.options.database.tables[j];
				$.extend(this.options.record,this.options.table.record);
				break;
			}
		}
	},	
//------------------------------------------------------
	start: function() {
	},	
//------------------------------------------------------
	stop: function() {
	},	
//------------------------------------------------------
	clearForm: function(elem) {
		$(elem).find('input').not('button, submit, reset, hidden, checkbox, radio').val('');
		$(elem).find('[type=checkbox]').attr('checked', false);	
		$(elem).find('[type=radio]').attr('checked', false);	
	},	
//------------------------------------------------------
	onFormOpen: function(action) {
		//console.log('on formopen ' + this.options.table.name)
		this.options.onFormOpen(action)
	},	
//------------------------------------------------------
	refresh: function() {	
		//console.log('on refresh ' + this.options.table.name)
		this.options.onFormOpen(0)
	},	
//------------------------------------------------------
	primeLookups: function() {	
	var _this = this;
	$('[data-nt-desc]').each(function(){
			var tbl = $(this).attr('data-nt-lut')
			var guid = $(this).val()
			var desc = $(this).attr('data-nt-desc')
			var elem = this;
			idbGet(_this.options.database,tbl,guid,function(record){ //oncomplete						
				$(elem).val(record[desc])
			})
		})
	},	
//------------------------------------------------------
	populate: function(action,guid) {
		var _this = this;
		var id = this.options.divId;		
		switch (action){
		case 1: //insert		
			this.clearForm(id);
			this.options.primeOnInsert();
			this.onFormOpen(action);
			$(id).ntform('show');	
			break
		case 2: //change
		case 4: //copy
			if (!guid){
				console.log('populating form, but no guid set')
			} else {
				idbGet(this.options.database,this.options.table,guid,function(record){ //oncomplete
						_this.options.record = record;
						ntd.setRow(record.guid); // guid might be changed by the idbGet from _first_ etc.
						$(id).ntformls( "populateRecord",_this.options.record)
						if (action==4){
							_this.options.record[_this.options.table.primarykeyfield] = ''; // clear guid, so Write does an Insert
						}
						if (action == 2){
							_this.primeLookups()
							_this.options.primeOnChange();
						} else if (action==4){
							_this.primeLookups()
							_this.options.primeOnCopy();
						}	
						_this.onFormOpen(action);
						$(id).ntform('show');	
					}, function(){ //not found
						console.log('populating form, but guid not found in local database')
						
					}, function(event){  //on error
						console.log('Error: ' + event.target.error.name + ' ' + event.target.error.message);
					});
			}
			break
		default:
			this.onFormOpen(action)
		}	
	},	
//------------------------------------------------------
	populateRecord: function(record) { // move fields from record to form fields
		var typ='';
		for (var i in this.options.columns){
			for (var j in record){
				if (j == this.options.columns[i].field){
					//
					typ = $(this.options.columns[i].id).attr('type');
					switch(typ){
						case 'checkbox':
							if(record[j]==$(this.options.columns[i].id).attr('value')){
								$(this.options.columns[i].id).attr('checked','checked')
							}	
							break
						default:
							$(this.options.columns[i].id).val(record[j])
					}	
					break;
				}
			}
		}
	},
//------------------------------------------------------
	onChangeField: function(elem){
		var id = '#' + $(elem).attr('id')
		for (var i in this.options.columns){
			if(this.options.columns[i].id==id){
				if (typeof this.options.columns[i].onChangeField == "function"){
					this.options.columns[i].onChangeField();
				}	
			}
		}	
	},
//------------------------------------------------------
	save: function(action,browseid,guid) { // move fields from form fields to options.record, and then write to table.
		this.options.record.guid = guid;
		var elem;
		for (var i in this.options.columns){
			for (var j in this.options.record){
				if (j == this.options.columns[i].field){
					elem = $(this.options.columns[i].id);
					this.options.record[j] = getFormFieldValue(elem,this.options.record[j]) // might return same value if field not found.
					break;
				}
			}
		}	
		this.options.assignOnSave();
		idbWrite(this.options.database,this.options.table,this.options.record,false,function(uid){ // oncomplete gets the guid of the saved record
			switch (action){
			case 1: //insert		
			case 4: //copy			
				$(browseid).ntbrowsels("populate",undefined,uid)
				break;
			case 3: //delete
				$(browseid).ntbrowsels("populate")
				break;
			case 2: //change
				$(browseid).ntbrowsels("repopulateRow",uid)
				break;
			}
		})	
	}
//------------------------------------------------------
});

$.extend( $.ui.ntformls, {
	version: "@VERSION"
});

})( jQuery );

