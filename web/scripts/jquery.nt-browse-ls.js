(function( $, undefined ) {
$.widget( "ui.ntbrowsels", {
        options: {
			//columns:[ {itemNumber: 0, field:"",orderBy:"", method:0, firstInCell:0, lastInCell: 0, cellClass:"", columnClass:"" }],
			database:null,
			divId:"",
			table:{},
			tableId:"",
			tableName:"",
			orderBy:[],
			rowClass:"",
			calcClass:function(){}			
		},
//------------------------------------------------------
	_init: function() {		
		this.options.database = database; // workaround for now, setting in options does not seem to be working.
		for (j in this.options.database.tables){
			if(this.options.database.tables[j].name == this.options.tableName){
				this.options.table = this.options.database.tables[j];
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
	refresh: function() {		
		this.populate();
	},	
//------------------------------------------------------
// orderBy might be a fieldname, array of field names, or column index. If not passed use options.orderby instead.
	populate: function(orderBy,selectedRowId) {
		if (orderBy === undefined){
			orderBy = this.options.orderBy
		} else {
			this.options.orderBy = orderBy
		}	
		if ($.isNumeric(orderBy)){
			var colIndex = this.getItemProperties(orderBy);
			orderBy = this.options.columns[colIndex].orderBy;
		}	
		var _this = this;
		var id = this.options.divId;
		var rows = 0;
		var s = '';
		if (!this.options.table || !this.options.table.name){
			this.options.table = idbCheckTable(this.options.tablename);
		}	
		doBrowseStart();
		idbSelect({	db:this.options.database,
					table:this.options.table,
					join:this.options.join,
					includeDeleted:this.options.includeDeleted,
					filter: this.options.filter,
					orderBy:orderBy,
					onrecord:doPopulateRecord,
					oncomplete:doBrowseEnd
				})
		function doBrowseStart(){
			$(_this.options.tableId).empty() // removes all the existing rows
			// add header
			s = s + '<div class="nt-browse-grid-row nt-browse-row-header browseinvoices-row-header" data-elem="browse-header-row">'
			for (var col=0; col < _this.options.columns.length ; col++){
				if (_this.options.columns[col].firstInCell){
					if (_this.options.columns[col].showHeader){
						if (_this.options.columns[col].prompt){
							s = s + '<div id="head_' + parseInt(col+1) + '" class="nt-browse-header-not-selected ui-corner-top nt-browse-grid-cell" data-elem="browse-header-cell">' +
							'<div class="' + _this.options.columns[col].headerContentClass + '">' + _this.options.columns[col].prompt + '</div></div>'
						} else {
							s = s + '<div id="head_' + parseInt(col+1) + '" class="nt-browse-header-not-selected ui-corner-top nt-browse-grid-cell" data-elem="browse-header-cell"></div>'					
						}	
					}					
				}
			}	
			s = s + '</div>'
			// add body
			s = s + '<div class="'+ _this.options.bodyClass+'" data-elem="browse-body">'
		}
		
		function doPopulateRecord(idx,record){ 											//on record
			s = s + _this.addRow()
			rows += 1
			return true			
		}
		function doBrowseEnd(){	//on complete
			if (rows==0){
				s = s + '<div class="'+_this.options.messageIfEmptyClass+'">' + _this.options.messageIfEmpty + '</div>' 
			}
			s = s + '</div>' // end of body
			if (rows==0){
				// footer
			}	
			$(_this.options.tableId).append(s);		
			$(_this.options.divId).ntbrowse("ready",selectedRowId);			
		}
		
	},	
//------------------------------------------------------
	selectb: function(guid,lookupField) {	
		idbGet(this.options.database,this.options.table,guid, 
			function(record){ //oncomplete
				var desc=$('#'+lookupField).data('nt-desc');
				if(desc){
					$('#'+lookupField).val(record[desc])
				} else {
					$('#'+lookupField).val(guid)
				}				
			},
			function(){ //not found
				console.log('After Lookup: but returned guid not found in local database')
			},
			function(event){  //on error
				console.log('Error: ' + event.target.error.name + ' ' + event.target.error.message);
			});
	},	
//------------------------------------------------------
	deleteb: function(guid) {	
		var _this=this;
		idbMarkDelete(this.options.database,this.options.table,guid,doRemove)
		
		function doRemove(){ // remove the row from the table.
			$(_this.options.tableId).find('[data-nt-id="'+guid+'"]').remove()
		}
	},
//------------------------------------------------------
	repopulateRow: function(guid) {	
		var _this=this;		
		idbGet(this.options.database,this.options.table,guid,doReplace,doAdd)
		
		function doReplace(record){ // replace the existing row with the new data
			var resultset =[]
			resultset.push(record); // TOTEST XXXX
			$(_this.options.tableId).find('[data-nt-id="'+guid+'"]').empty().append(_this.buildRow(0,resultset));
		}
		function doAdd(){ // repopulate the whole table to include the new data.
			_this.populate(_this.options.orderBy,guid);
		}	
	},
//------------------------------------------------------
	addRow: function() {	
		return '<div class="' + this.options.rowClass + '" data-elem="browse-row" data-nt-id="'+
				this.options.table.record[this.options.table.primarykeyfield]+'" data-do="ds">'	+ 	
				this.buildRow() + 
				'</div>'				
	},
//------------------------------------------------------
	buildRow: function() {		    
		var s = '';
		for (var col=0; col < this.options.columns.length ; col++){
			s = s + this.addCell(col);
		}
		return s;
	},	
//------------------------------------------------------
	addCell: function(col) {	
		var s = '';
		var value='';
		var field = this.options.columns[col].field;
		if (this.options.columns[col].firstInCell){
			s = '<div class="' + this.options.columns[col].cellClass +'" data-elem="browse-cell"><!-- start of cell -->'
		}
		if (this.options.columns[col].showPrompt){
			if (this.options.columns[col].prompt){
				s = s + '<div class="' +this.options.columns[col].promptClass + '">' + this.options.columns[col].prompt + '</div>'
			}
		}	
		if (this.options.columns[col].field){			
			if (this.options.columns[col].table){
				value = this.options.database[this.options.columns[col].table].record[this.options.columns[col].field]
			} else {
				value = this.options.table.record[this.options.columns[col].field]
			}
			if(this.options.columns[col].calcClass){
				s = s + '<div class="' + this.options.columns[col].columnClass + ' ' + this.options.columns[col].calcClass(value) + '">' + value + '</div>'
			} else {
				s = s + '<div class="' + this.options.columns[col].columnClass + ' ' + '">' + value + '</div>'			
			}	
		} else {						
			var button = this.options.columns[col].button;
			if (button){				
				var buttonIcon = this.options.columns[col].buttonIcon;
				id = 'btn_' + Math.random().toString(36).substr(3,4);
				s = s + '<div class="' + this.options.columns[col].columnClass +'">' + 
						'<button type="button" name="' + button + '_btn" id="' + id + '"' + ' value="" class="nt-' + button + '-button nt-small-button"  title="Click here to ' + button + ' this record"' + ' data-do="' + button + '">&#160;</button>' +
					  '</div>'+
					'<script>$("#'+ id + '").button({icons:{primary:"ui-icon-'+ buttonIcon +'"},text:false});</script>'
			} else {
				s = s + '<div></div>'
			}
		}
		if (this.options.columns[col].lastInCell){
			s = s + '</div><!-- end of cell-->'
		}
		return s;
	},	
//------------------------------------------------------
	getItemProperties: function(i) {
	  for (var colIndex in this.options.columns){
		if (this.options.columns[colIndex].itemNumber == i){
			return colIndex;
		}
	  }
	  return;
	},
//------------------------------------------------------
// tempting just to call Populate, but manually sorting here allows sorting on joined fields.
	clientSideSort: function(elem,dataValue,event,dataValueElement) {	
		var cell = $(event.target).get(0); // This is the thing clicked
		if ($(cell).attr('data-elem') != 'browse-header-cell'){
			cell = $(cell).closest('[data-elem="browseheadercell"]').get(0); // cell is the cell clicked on
		}
		var sameColumn =  $(cell).hasClass('nt-browse-header-selected');
	
		var descending = 0;
		if (dataValue < 0){
			dataValue = -dataValue;
			descending=1;
		}
	
		var rows = $(this.options.tableId).find('[data-elem="browse-row"]').toArray().sort(this.sortComparer(dataValue-1));
		if (descending){
			rows = rows.reverse()
		}
		for (var i = 0; i < rows.length; i++){$(this.options.tableId).append(rows[i])} // data part
		// now for the header part
		if (sameColumn){
			if (descending){
				$(dataValueElement).attr('data-value',dataValue)
				$(cell).find('.ui-icon-triangle-1-n').removeClass('ui-icon-triangle-1-n').addClass('ui-icon-triangle-1-s')
			} else {
				$(dataValueElement).attr('data-value',0 - dataValue)
				$(cell).find('.ui-icon-triangle-1-s').removeClass('ui-icon-triangle-1-s').addClass('ui-icon-triangle-1-n')
			}	
		} else {
			var oldCell = $(this.options.tableId).find('.nt-browse-header-selected');			
			$(oldCell).removeClass('nt-browse-header-selected')
				.addClass('nt-browse-header-not-selected')
				.find('.ui-icon-triangle-1-s,.ui-icon-triangle-1-n').eq(0).remove()
			$(oldCell).find('[data-value]').each(function(){
				$(this).attr('data-value',Math.abs($(this).attr('data-value')));	
			})	
				
			$(cell).removeClass('nt-browse-header-not-selected')
				.addClass('nt-browse-header-selected')
				.prepend('<span class="nt-icon-left ui-icon ui-icon-triangle-1-n"></span>')
				.find('[data-value]').attr('data-value',0-Math.abs(dataValue));
		}		
	},
//------------------------------------------------------	
	sortComparer: function (index) {
		var _this=this;
		return function(a, b) {			
			var field='';
			var left='';
			var right='';
			//for (var i=0; i <= orderBy.length ; i++){
			//	field = orderBy[i];
				left = _this.getCellValue(a, index);
				right = _this.getCellValue(b, index);
				if (left===undefined) return -1;
				if (right===undefined) return 1;			
				if ($.isNumeric(left) && $.isNumeric(right)){
					if (left-right != 0) {
						return left-right;
					} // else they are equal so cycle to next field in sort order.
				} else { // one of them is a string, so compare as strings
					if (left != right) {				
						return left.localeCompare(right,'de', { sensitivity: 'base' })
					} // else they are equal so cycle to next field in sort order.
				} 
			//} 
			return 0;			
		}	
	},
//------------------------------------------------------		
	getCellValue: function (row, index){ 
		return $(row).children('td').eq(index).find('*:not(:has("*"))').html()
	}	,
//------------------------------------------------------
	clickRow : function(row,ev){ 
	
	}
//------------------------------------------------------		
});

$.extend( $.ui.ntbrowsels, {
	version: "@VERSION"
});

})( jQuery );

