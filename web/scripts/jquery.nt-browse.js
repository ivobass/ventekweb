///////////////////////////////////////////////////////
//
//   jQuery Plugin for NetTalk Browse
//   Part of NetTalk by CapeSoft
//   (c) 2018
//
///////////////////////////////////////////////////////

(function( $, undefined ) {

$.widget( "ui.ntbrowse", {
        options: {
			id: '',               // contains div name (minus the _div part)
			tableId: '',			
			mobile:0,
			randomid: '',
			procedure: '',            // server procedure
			title: '',            // title for dialog
			parent: '',           // parent procedure which is including this browse
			parentrid: '',        // rid of parent procedure if it is a browse
			form: '',             // url of the form procedure
			formInsert: '',
			formCopy: '',
			formChange: '',
			formView: '',
			formDelete: '',
			formpopup: 1,         // is the form procedure opened as a popup?
			popup: 0,             // is the browse on a popup window
			bgOne:'nt-browse-gb1',                  // first color used in greeen-barring
			bgTwo:'nt-browse-gb2',                  // second color used in green-barring
			bgOver:'nt-browse-mouseover',                   // color for row currently under mouse
			bgSelect:'nt-browse-selected',                  // highlight color - shows selected record
			rowsHigh:1,
			column:0,
			highlightSelected:1,
			greenbar:1,
			mouseover:1,
			rowSelected:1,
			resizable:0,
			value: '',
			selectAction: '',
			cancelAction: '',
			closeAction: '',
			lookupField: '',
			confirmDelete:1,
			confirmDeleteMessage:'Are you sure you want to delete this record?',
			deleteText:'Delete',
			cancelText:'No',
			confirmText:'Confirm',				
			expand: 'circle-arrow-s',
			contract: 'circle-arrow-n',
			addsec:'',    				// secwin access rights procedure name
			urlExt:'',
			json:0,
			localStorage:0,
			timer:0,				// live refresh via timer
			timerRefresh:'',
			wsLive:0,             // live refresh via web sockets
			wsTables:[],          // array of table names to monitor
			wsRefresh:'current',
			rubberband:0,
			hideRubberbandOnMouseUp:0,
			rubberbandMinColumn:0,
			rubberbandMaxColumn:0,
			viewOnly:0
		},
		state: {
			exportProgress:'',
			exportButton:'',
			rubberband:0,	// 0= off, 1=mouse down, 2=mouse moved sufficiently
			rubberStartCell:0,
			rubberStartX:0, // x pos of mouse when mouse down
			rubberStartY:0, // y pos of mouse when mouse down
			outofsight:0,  // band is "visible" but off the top of the visible part of the page
			rubberbandOn:0, // band is visible 
			mouseCol:0, // column the mouse is currently over
			mouseElem:0, // cell the mouse is currently over
			blurring:0
		},
		locVal:'',

		//------------------------------------------------------
        _create: function() {
			var _this=this;
			this.options.divId = '#' + this.options.id + '_div';
			$(this.options.divId).addClass("exists");
			if (this.options.urlExt==''){try{this.options.urlExt=ntdExt} catch(e){};}
			this.ready();			
			if (this.options.timer >0){
				this.timerStart(this.options.timer);
			}
			if (this.options.rubberband){
				$(this.options.divId).append('<div id="' + this.options.id + '_rubberband" class="nt-browse-rubberband"></div>')
				$('#' + this.options.id + '_rubberband').hide();
			}	
        },
		//------------------------------------------------------
        _init: function() {
			if (this.options.wsLive){
				for (var i = 0; i < this.options.wsTables.length; i++) {
					nts.watch(this.options.id,"","table","",this.options.wsTables[i],this.liveUpdate,this)
				}	
			}  		
        },
		//------------------------------------------------------
        liveUpdate: function(json,_this) {
			if (_this.options.wsRefresh != 'disabled'){
				_this.server(_this.options.procedure,'_refresh_='+_this.options.wsRefresh)		
			}
        },
		//------------------------------------------------------
		ready: function(selectedRowId) {
			this._prepColumns();
			this._makeResizable();
			this._bindEvents();
			this.refresh(selectedRowId);
			if (this.options.popup==1){
				try{
					$("#popup_" + this.options.procedure + "_div").dialog("option","title",this.options.title);
				} catch (e) {};	
			}					
        },

		//------------------------------------------------------
        destroy: function() {
			$.Widget.prototype.destroy.apply( this, arguments );
        },

		//------------------------------------------------------
		// called on window unload event
        destructor: function() {
			var parms = '_rid_=' + this.options.randomid + '&_event_=clearbrowse';
			return this;
        },

		//------------------------------------------------------
        _bindEvents : function() {
			var _this = this;
			$(this.element).find('[data-elem="browse-table"]').off('scroll.tbl').on('scroll.tbl',function(e){_this.scrollTable(e);});
			//$(this.element).off('scroll.tbl','[data-elem="browse-table"]').on('scroll.tbl','[data-elem="browse-table"]',function(e){_this.scrollTable(e);});
			$(this.element).off('focus.bt','[data-do="lo"]').on('focus.bt','[data-do="lo"]',function(e){_this.locateFocus(this);});
			$(this.element).off('blur.bt','[data-do="lo"]').on('blur.bt','[data-do="lo"]',function(e){_this.locateBlur(this);});
			$(this.element).off('asifBlur.bt','[data-do="lo"]').on('asifBlur.bt','[data-do="lo"]',function(e){_this.locateAsifBlur(this,e);});
			$(this.element).off('change.bt','[data-do="lo"]').on('change.bt','[data-do="lo"]',function(e){_this.locate(this,e);});
			$(this.element).off('input.bt','[data-do="lo"]').on('input.bt','[data-do="lo"]',function(e){_this.locate(this,e);});
			$(this.element).off('keyup.bt','[data-do="lo"]').on('keyup.bt','[data-do="lo"]',function(e){_this.KeyPressLoc(this,e);}); // only for IE8/IE9
			$(this.element).off('valuechanged.bt','[data-do="lo"]').on('valuechanged.bt','[data-do="lo"]',function(e){_this.locateChanged(this);});
			$(this.element).off('change.bt','[data-do="eip"]').on('change.bt','[data-do="eip"]',function(e){_this.eip(this);});
			$(this.element).off('click.bt','[data-do="cv"]').on('click.bt','[data-do="cv"]',function(e){_this.toggleRowStatus(this);});
			$(this.element).off('click.bt','[data-do="bserver"]').on('click.bt','[data-do="bserver"]',function(e){_this.bbutton(this);});
			$(this.element).off('click.bt','[data-do="sh"]').on('click.bt','[data-do="sh"]',function(ev){_this.sort(this,ev);});
			$(this.element).off('click.bt','[data-do="clo"]').on('click.bt','[data-do="clo"]',function(e){_this.clearLocator();});
			$(this.element).off('click.bt','[data-do="insert"]').on('click.bt','[data-do="insert"]',function(e){_this.edit(this,1,'insert');});
			$(this.element).off('click.bt','[data-do="copy"]').on('click.bt','[data-do="copy"]',function(e){_this.edit(this,4,'copy');});
			$(this.element).off('click.bt','[data-do="change"]').on('click.bt','[data-do="change"]',function(e){_this.edit(this,2,'change');});
			$(this.element).off('click.bt','[data-do="view"]').on('click.bt','[data-do="view"]',function(e){_this.edit(this,5,'view');});
			$(this.element).off('click.bt','[data-do="deleteb"]').on('click.bt','[data-do="deleteb"]',function(e){_this.deleteb(this);});
			$(this.element).off('click.bt','[data-do="browsecancel"]').on('click.bt','[data-do="browsecancel"]',function(e){_this.cancel();});
			$(this.element).off('click.bt','[data-do="close"]').on('click.bt','[data-do="close"]',function(e){_this.close();});
			$(this.element).off('click.bt','[data-do="select"]').on('click.bt','[data-do="select"]',function(e){_this.select(this);});
			$(this.element).off('click.bt','[data-do="first"]').on('click.bt','[data-do="first"]',function(e){_this.nav('','first');});
			$(this.element).off('click.bt','[data-do="previous"]').on('click.bt','[data-do="previous"]',function(e){_this.nav('','previous');});
			$(this.element).off('click.bt','[data-do="next"]').on('click.bt','[data-do="next"]',function(e){_this.nav('','next');});
			$(this.element).off('click.bt','[data-do="last"]').on('click.bt','[data-do="last"]',function(e){_this.nav('','last');});
			$(this.element).off('click.bt','[data-do="export"]').on('click.bt','[data-do="export"]',function(e){_this.exportTo('excel',this);});
			if (this.options.rubberband){
				$(this.element).off('mousedown.tbl','[data-elem="browse-table"]').on('mousedown.tbl','[data-elem="browse-table"]',function(e){_this.mouseDownTable(e);});
				$(this.element).off('mousemove.tbl','[data-elem="browse-table"]').on('mousemove.tbl','[data-elem="browse-table"]',function(e){_this.mouseMoveTable(e);});			
				$(this.element).off('mouseup.tbl','[data-elem="browse-table"]').on('mouseup.tbl','[data-elem="browse-table"]',function(e){_this.mouseUpTable(e);});
				$(this.element).off('mousedown.cll','[data-elem="browse-cell"]').on('mousedown.cll','[data-elem="browse-cell"]',function(e){_this.mouseDownCell(e,this);});
				$(this.element).off('mousemove.cll','[data-col]').on('mousemove.cll','[data-col]',function(e){_this.mouseMoveCell(e,this);});
				$(this.element).off('mouseup.cll','[data-elem="browse-cell"]').on('mouseup.cll','[data-elem="browse-cell"]',function(e){_this.mouseUpCell(e,this);});
				$(this.element).off('mousedown.rbr','#' + this.options.id + '_rubberband').on('mousedown.rbr','#' + this.options.id + '_rubberband',function(e){_this.mouseDownCell(e);_this.mouseDownTable(e);});
				$(this.element).off('mousemove.rbr','#' + this.options.id + '_rubberband').on('mousemove.rbr','#' + this.options.id + '_rubberband',function(e){_this.mouseMoveTable(e);});
			}
			return this;
        },

		//------------------------------------------------------
        refresh : function(selectedRowId) {
			this.setvalue(selectedRowId);
			this.options.table=document.getElementById(this.options.tableId);
			if (this.options.value){
				this.options.rowSelected = $('[data-nt-id="' + this.options.value + '"]').closest('[data-elem="browse-row"]').prevAll().length;
				this.options.rowSelected = parseInt(this.options.rowSelected/this.options.rowsHigh) * this.options.rowsHigh;
			} else {
				this.options.rowSelected = -1
			}	
		
			this._applyGreenBar();
			this._preContractVertically();
			
			var _this = this;			
			if (this.options.table){
				$('#' + this.options.tableId).find('[data-elem="browse-row"]')
					.off('mouseover.bt mouseout.bt click.bt dblclick.bt')
					.on('mouseover.bt',function(ev){_this._onMouseIn(this,ev);})
					.on('mouseout.bt',function(ev){_this._onMouseOut(this,ev);})
					.on('dblclick.bt',function(ev){_this._onDoubleClick(this,ev);})
					.on('click.bt',function(ev){_this.clickRow(this,ev);});
				$('#' + this.options.tableId + ' input')
					.off('keydown.bt focus.bt')
					.on('keydown.bt',function(e){_this._keydown(this,e);})
					.on('focus.bt',function(e){_this._setColumn(this,e);});
				
				$('#locator1' + _this.options.id + ',' + '#locator2' + _this.options.id)
					.off('keypress.bt')
					.off('keydown.bt')
					.off('keyup.bt')
					//.on('keypress.bt',function(e){return _this._keyPressLoc(this,e);})
					//.on('keyup.bt',function(e){return _this._keyUpLoc(this,e);})
					.on('keydown.bt',function(e){return _this._keyDownPaging(this,e);});
			}	
			return this;
        },

		//------------------------------------------------------
        activeTab: function( newValue ) {
			if ( newValue === undefined ) {
					return this.options.activeTab;
			}
			this._setOption( "activeTab", newValue );
			return this;
        },

		//------------------------------------------------------
        _setOption: function( opt, value ) {
			switch (opt){
			case "bgOver":
					this.options.bgOver = value;
					break;
			case "bgSelect":
					this.options.bgSelect = value;
					break;
			case "bgOne":
					this.options.bgOne = value;
					break;
			case "bgTwo":
					this.options.bgTwo = value;
					break;
			}
			$.Widget.prototype._setOption.apply( this, arguments );
        },

		//------------------------------------------------------
		colorBlock : function(block,what) {  // sets the color of a multi-row block.
			if ((this.options.greenbar == 0) && (this.options.mouseover==0) && (this.options.highlightSelected==0)){
				return 0;
			}

			var _this=this;
			var col=this.options.bgOne;
			var i = parseInt(block*this.options.rowsHigh);
			if (i > $('#' + this.options.tableId).find('[data-elem="browse-body"]').children().length){
				return 1;
			}
			if (this.options.mouseover==1 && what==1){
					col=this.options.bgOver;
			} else if(this.options.highlightSelected==1 && this.options.rowSelected==i){
					col=this.options.bgSelect;
			} else if (this.options.greenbar==1){
					col=(block%2==0) ?  this.options.bgOne :  this.options.bgTwo;
			}
			$('#' + this.options.tableId).find('[data-elem="browse-row"]').
			slice(i,i+_this.options.rowsHigh).each(function(){
					$(this).removeClass(_this.options.bgOne + ' ' + _this.options.bgTwo + ' ' + _this.options.bgOver + ' ' + _this.options.bgSelect).
					addClass(col);
			});
			return 0;
		},

		//------------------------------------------------------
		_colorRow : function(row,what) {  // draws a whole block, based on a row index
			this.colorBlock(parseInt(row / this.options.rowsHigh),what);
		},

		//------------------------------------------------------
		_onMouseIn : function(row,ev) {
			if ($(ev.currentTarget).parent().is("tbody")) {
				this._colorRow(row.sectionRowIndex,1); // row selection index is base 0
			} else {
				var i =  $(row).index()
				this._colorRow(i,1); // 1 = mouse in
			}
			ev.stopPropagation()
			return this;
		},

		//------------------------------------------------------
		_onMouseOut : function(row,ev) {
			if ($(ev.currentTarget).parent().is("tbody")) {
				this._colorRow(row.sectionRowIndex);
			} else {
				var i =  $(row).index()
				this._colorRow(i,0); // 0 = natural state
			}
			ev.stopPropagation()
			return this;
		},

		//------------------------------------------------------
		_onDoubleClick : function(elem,ev) {
		var recordId = $(elem).closest('[data-nt-id]').attr('data-nt-id');
		var dataDo = $(elem).closest('[data-do]').attr('data-do');
		if ((recordId) && (dataDo)){
			switch (dataDo){
			case "ds":
				this.select(this);
				break
			case "dc":
				if (this.options.viewOnly){
					this.edit(this,5,'view');  
				} else {
					this.edit(this,2,'change');  
				}
				break
			case "dv":
				this.edit(this,5,'view');  
				break
			}
		}
		return this;
		},
		//------------------------------------------------------
		clickRow : function(row,ev) {
			var cell = $(ev.target).get(0); // This is the element clicked on
			var recordId = $(cell).closest('[data-nt-id]').attr('data-nt-id');
			
			if ($(cell).attr('data-elem') != 'browse-cell'){		// anything except something inside the cell.						
				cell = $(cell).closest('[data-elem="browse-cell"]')
			}
			var sri = $(row).index()
			var cn = $(cell).attr('data-col')
			if (!cn){
			  cn = $(cell).index() + 1; 			// column number // base 1
			}  
			var i = this.options.rowSelected; // this.rowSelected holds the index of the first row in the selcted block.// row selected is base 0
			this.options.rowSelected = parseInt(sri/this.options.rowsHigh) * this.options.rowsHigh; 
			this._colorRow(i);
			this._colorRow(sri);
			this.setvalue(recordId);
			if (this.options.localStorage){
				$(this.options.divId).ntbrowsels("clickRow",row,ev);
			} else {
				this.server('_event_=rowclicked','_bidv_='+recordId + '&_column_=' + cn);
			}	
			this.setvalue(recordId);
			if($(row).attr('data-do') == "ss"){
				this.select();
			} else if($(row).attr('data-do') == "sc"){
				this.edit(this,2,'change');
			}	
			return this;
		},

		//------------------------------------------------------
		_applyGreenBar : function() {
			if (this.options.table == null){
				return;
			}
			if (!$('#' + this.options.tableId).find('[data-elem="browse-body"]')){
				return;
			}	
			if ((this.options.greenbar == 0) && (this.options.highlightSelected == 0) && (this.options.mouseover == 0)){
				return;
			}
			var b = 0;
			while(this.colorBlock(b) == 0){
				b++;
			}	
			return this;
		},

		//------------------------------------------------------
		_makeResizable : function() {
			if(this.options.resizable == 1){
				var _this = this;
				$('#' + _this.options.id.toLowerCase() + '_table_resize_div')
					.resizable({minwidth: _this.options.minwidth,minheight: _this.options.minheight,stop: function(event,ui){_this.resized();}});
			}
			return this;
		},

		//------------------------------------------------------
		resized : function() {
			this.server('_event_=resized&_width_=' + $(id).width() + '&_height_=' + $('#'+this.options.id.toLowerCase()+'_table_div').height());
			return this;
		},

		//------------------------------------------------------
		_restoreFocus : function() {
			if (this.options.column != 0) {
				if (this.options.table.nodeName=='TABLE'){
					$('#' + this.options.tableId + ' tbody > tr:first').children('td:eq('+this.options.column+')').find(':input:first').focus();
				}	
			}
			return this;
		},

		//------------------------------------------------------
		_setColumn : function(inp,e) {
			this.options.column = $(inp).closest('[data-elem="browse-cell"]').prevAll().length;
			return this;
		},

		//------------------------------------------------------
		_keyDownPaging : function(inp,e) {    // handle paging keys in EIP and locator fields
			if ((e.which == 191) && (e.shiftKey == true)){ // 191=?
				e.which = ntLookupKey;
			}

			switch(e.which){
				case 13: {
					$(inp).change();
					e.preventDefault();
					return false;
				}

				case $.ui.keyCode.PAGE_UP: {
					this.nav(inp.id,'previous');
					return false;
				}

				case $.ui.keyCode.PAGE_DOWN: {
					this.nav(inp.id,'next');
					return false;
				}

				case $.ui.keyCode.HOME: {
					if (e.ctrlKey==true){
						this.nav(inp.id,'first');
						return false;
					}
				}

				case $.ui.keyCode.END: {
					if (e.ctrlKey==true){
						this.nav(inp.id,'last');
						return false;
					}
				}

				//case 191:  // ?
				case ntLookupKey: {// F2 by default
					$("#"+inp.id+".hasDatepicker").each(
						function(i,v){
							e.preventDefault();
							$(inp).datepicker("show");
							return false;
						}
					);


					$("#"+inp.id).next(':button').each(
						function(i,v){
							$(this).click();
							return false;
						}
					)
				}
				return true;
			}
			return this;
		},

		//------------------------------------------------------
		// IE 8 does not support INPUT event. IE 9 handles INPUT event in a buggy way. // http://help.dottoro.com/ljhxklln.php
		// This method handles some of those cases
		KeyPressLoc : function(elem,ev) {      // Handle enter key in locator fields
			if (navigator.userAgent.indexOf('MSIE 8') > -1){
				$(elem).trigger('input');
			} else if (navigator.userAgent.indexOf('MSIE 9') > -1){
				switch(ev.which){
					case 8: // backspace
					case 46: // del key
					case 86: // ctrl-v
					case 88: // ctrl-x
						$(elem).trigger('input');
				}
			}
		},
		//------------------------------------------------------
		_keydown : function(inp,e) {  // bind up and down arrow keys in EIP in browse
			switch(e.which){
				case $.ui.keyCode.DOWN: {
					this._setColumn(inp,e);
					$(inp).closest('[data-elem="browse-row"]').nextAll(':eq(0)').children('[data-elem="browse-cell"]:eq('+this.options.column+')').find(':input:first').focus();
					e.which = 0;
					return false;
				}
				case $.ui.keyCode.UP: {
					this._setColumn(inp,e);
					$(inp).closest('[data-elem="browse-row"]').prevAll(':eq(0)').children('[data-elem="browse-cell"]:eq('+this.options.column+')').find(':input:first').focus();
					e.which = 0;
					return false;
				}
			}
			return this._keyDownPaging(inp,e);
		},

		//------------------------------------------------------
		_preContractVertically : function() {
			var _this=this;
			$(this.options.divId).find('[data-nt-ctd="true"]').each(function(i,elem){
				_this.setRowStatus(elem,true);
			});
			$(this.options.divId).find('[data-nt-ctd="false"]').each(function(i,elem){
				_this.setRowStatus(elem,false);
			});
			return this;
        },
		//------------------------------------------------------
		toggleRowStatus : function(elem) {
			//var l = this.options.rowsHigh-1;
			var tr = $(elem).closest('[data-elem="browse-row"]');
			if ($(elem).attr('data-nt-ctd')=='true'){
				var state=false;
			} else {
				var state=true;
			}	
			this.setRowStatus(elem,state);
			this.server('_event_=expcon','_bidv_='+ $(tr).attr('data-nt-id') +'_status_=' + state);
			
        },
		//------------------------------------------------------
		setRowStatus : function(elem,state) { // if state is true then row much be contracted (ie minimised).

			var exp = 'ui-icon-' + this.options.expand;
			var con = 'ui-icon-' + this.options.contract;
			var l = this.options.rowsHigh-1;
			if (state){ 
				$(elem).removeClass(con).addClass(exp).attr('data-nt-ctd','true').closest('[data-elem="browse-row"]').children('[data-elem="browse-cell"]').each(function(){
					$(this).attr('rowspanwas',$(this).attr('rowspan'));
					$(this).attr('rowspan',1)
				});
				$(elem).closest('[data-elem="browse-row"]').nextAll(':lt('+l+')').hide();
			} else {
				$(elem).removeClass(exp).addClass(con).attr('data-nt-ctd','false').closest('[data-elem="browse-row"]').children('[data-elem="browse-cell"]').each(function(){
					$(this).attr('rowspan',$(this).attr('rowspanwas'));
				});
				$(elem).closest('[data-elem="browse-row"]').nextAll(':lt('+l+')').show();
			}
			return this;
		},
//------------------------------------------------------
		_prepColumns : function() {
			var _this=this;
			if ((this.options.addsec != '') && (this.options.addsec != undefined)){
				var k = $('#'+_this.options.id.toLowerCase()+'_table_div').find('th:last').find('[data-key]').attr('data-key');
				if (k == undefined){
					$('#'+_this.options.id.toLowerCase()+'_table_div').find('th:last').append('<div class="nt-right" data-key="true"><a href="#" id="' + _this.options.id.toLowerCase() + '-browse-access" class="nt-browse-titlebar-access"><span class="ui-icon ui-icon-key"></span></a></div>');
					//Secwin Button
					$('#' + _this.options.id.toLowerCase() + '-browse-access').hover(function(){
						$(this).addClass('ui-state-hover');
					}, function(){
						$(this).removeClass('ui-state-hover');
					}).click(function(){
						ntd.push('secwinwebuseraccess','','header',1,2,null,'','','_screen_=' + _this.options.addsec);
						return false;
					});
				}
			}
			return this;
		},

        //------------------------------------------------------
        // needs refactor
		ec : function(hcb) {          // checkbox on top of column to set checkbox in whole column.
			for(var i=0;i<this.options.table.tHead.rows[0].cells.length;i++){
				if (this.options.table.tHead.rows[0].cells[i] == hcb.parentNode){
					var c = i;
				}
			}
			this.quiet = 1;
			for(i=0;i<this.options.table.tBodies[0].rows.length;i++){
				var o = this.options.table.tBodies[0].rows[i].cells[c].firstChild;
				cb = getCheckbox(o);
				if (cb != null){
					cb.checked = hcb.checked;
					cb.onclick();
				}
			}
			this.quiet = 0;
			return this;
		},

        //------------------------------------------------------
        disableButton : function(elem){
			try{$(elem).attr("disabled","disabled").removeClass('ui-state-focus').button( "refresh" );} catch (e) {};
        },
        //------------------------------------------------------
        enableButton : function(elem){
			try{$(elem).removeAttr("disabled").removeClass('ui-state-focus').button("refresh");} catch (e) {};
        },
		
        //------------------------------------------------------		
        bbutton : function(elem){
			this.disableButton(elem);
			this.eip(elem);
        },
        //------------------------------------------------------
		eip : function(elem) {
			var n = $(elem).attr("name");
			var vl= $(elem).data('luv')
			if (vl==undefined){
				vl=FieldValue(elem);
			}
			this.server('_event_=eipaccepted&_action_=2&_eipclm_='+ n.replace(/__/g,":"),'_bidv_=' + $(elem).closest('[data-nt-id]').attr('data-nt-id'),'value='+vl);
			return this;
		},

        //------------------------------------------------------
		setvalue : function(v) {
			if (v && (v != null) && (v != '')){
				this.options.value = v;
			}
			return this;
		},
		//------------------------------------------------------
		mouseDownCell : function(event,elem){
			var col = $(elem).attr('data-col')
			if (this.options.rubberbandMinColumn == 0 || col >= this.options.rubberbandMinColumn){
				if (this.options.rubberbandMaxColumn == 0 || col <= this.options.rubberbandMaxColumn){
					this.state.rubberbandOn = 1
					this.state.rubberStartCell = elem
					this.state.rubberEndCell = 0
					this.state.rubberStartX = event.pageX
					this.state.rubberStartY = event.pageY
				}
			}
		},
		//------------------------------------------------------
		mouseDownTable : function(event){			
			if (this.state.rubberbandOn == 1){
				var coords = {top:-10,left:-10};
				$('#' + this.options.id + '_rubberband').offset(coords);
				$('#' + this.options.id + '_rubberband').width(0);
				$('#' + this.options.id + '_rubberband').height(0); 
				this.state.rubberband = 1 // mouse down
			}	
			event.stopPropagation();
			event.preventDefault();
			event.cancelBubble=true;
			event.returnValue=false;
			return false;
		},
		//------------------------------------------------------
		scrollTable : function(event){		
			if (this.state.rubberbandOn == 1){
				this.calcRubberband(event);
			}	
		},
		//------------------------------------------------------
		mouseUpCell : function(event,elem){			
			this.state.rubberEndCell = this.state.mouseElem
		},
		//------------------------------------------------------
		mouseUpTable : function(event){						
			if (this.state.rubberband == 2){
				this.calcRubberband(event)
				this.selectRange()
			}				
			this.state.rubberband = 0 // mouse up
			this.unSelect();
			if (this.options.hideRubberbandOnMouseUp){
				this.hideRubberband()
			}	
		},
		//------------------------------------------------------
		mouseMoveCell : function(event,elem){	
			this.state.mouseCol = $(elem).attr('data-col')
			if (this.state.mouseCol){
				if (this.options.rubberbandMinColumn == 0 || this.state.mouseCol >= this.options.rubberbandMinColumn){
					if (this.options.rubberbandMaxColumn == 0 || this.state.mouseCol <= this.options.rubberbandMaxColumn){				
						this.state.mouseElem = elem;
					}
				}
			}	
		},
		//------------------------------------------------------
		mouseMoveTable : function(event){	
			if (this.state.rubberband == 1){
				if ((Math.abs(this.state.rubberStartX - event.pageX) > 10) || (Math.abs(this.state.rubberStartY - event.pageY) > 10)){
					this.state.rubberband = 2 // moved sufficently, so now active
					this.showRubberband();
				}	
			}
			if (this.state.rubberband == 2){
				if (this.state.mouseCol){
					if (this.options.rubberbandMinColumn == 0 || this.state.mouseCol >= this.options.rubberbandMinColumn){
						if (this.options.rubberbandMaxColumn == 0 || this.state.mouseCol <= this.options.rubberbandMaxColumn){
							this.calcRubberband(event);
						}	
					}
				}				
			}	
		},		
		//------------------------------------------------------
		showRubberband : function(){			
			$('#' + this.options.id + '_rubberband').show()
			this.state.rubberbandOn = 1
		},
		//------------------------------------------------------
		hideRubberband : function(){			
			$('#' + this.options.id + '_rubberband').hide()
			this.state.rubberbandOn = 0
		},
		//------------------------------------------------------
		selectRange : function() {
			if ($(this.state.rubberStartCell).closest('[data-nt-id]').index() <= $(this.state.rubberEndCell).closest('[data-nt-id]').index()){
				var firstId = $(this.state.rubberStartCell).closest('[data-nt-id]').attr('data-nt-id');			
				var lastId = $(this.state.rubberEndCell).closest('[data-nt-id]').attr('data-nt-id');	
			} else {
				var firstId = $(this.state.rubberEndCell).closest('[data-nt-id]').attr('data-nt-id');			
				var lastId = $(this.state.rubberStartCell).closest('[data-nt-id]').attr('data-nt-id');	
			}			
			var thisId = '';
			var between=0;
			var idList='';
			$(this.options.divId).find('[data-nt-id]').each(function(i,elem){
				thisId = $(elem).attr('data-nt-id')
				switch(between){
				case 0:
					if ( thisId == firstId){
						between = 1 // then drop to case 1
					} else {
						break
					}	
				case 1:
					idList = idList.concat(thisId + '|')
					if (thisId == lastId){
						between = 2
					}	
					break
				}
			})
			if (this.options.localStorage){
				$(this.options.divId).ntbrowsels("selectRange");
			} else {
				var fromCol = $(this.state.rubberStartCell).attr('data-col')
				var toCol = $(this.state.rubberEndCell).attr('data-col')
				if (parseInt(fromCol) > parseInt(toCol)){
				  var temp = fromCol;
				  fromCol = toCol;
				  toCol = temp;
				}
				if (fromCol && toCol){
					this.server('_event_=selectRange&_fromColumn_=' + fromCol +	'&_toColumn_=' + toCol + '&_bidvList_=' + idList)
				}
			}
		},
		//------------------------------------------------------
		calcRubberband : function(event){
			var coords = {top:0,left:0,width:0,height:0};
			var mouseX = event.pageX
			var mouseY = event.pageY
			if (mouseX < $(this.state.mouseElem).offset().left){
				mouseX = $(this.state.mouseElem).offset().left
			}
			if (mouseX > $(this.state.mouseElem).offset().left + $(this.state.mouseElem).width()){
				mouseX = $(this.state.mouseElem).offset().left + $(this.state.mouseElem).width()
			}
			if (mouseX < this.state.rubberStartX){
				if (this.state.rubberEndCell){
					coords.left = $(this.state.rubberEndCell).offset().left
				} else {
					coords.left = mouseX + 6
				}	
				coords.width = $(this.state.rubberStartCell).offset().left + $(this.state.rubberStartCell).width() - coords.left
			} else {
				coords.left = $(this.state.rubberStartCell).offset().left
				if (this.state.rubberEndCell){
					var right = $(this.state.rubberEndCell).offset().left + $(this.state.rubberEndCell).width()
					coords.width = right - coords.left;
				} else {
					coords.width = mouseX - coords.left - 6
				}	
			}
			if (mouseY < this.state.rubberStartY){
				if (this.state.rubberEndCell){
					coords.top = $(this.state.rubberEndCell).offset().top
				} else {
					coords.top = mouseY + 6
				}	
				coords.height = $(this.state.rubberStartCell).offset().top + $(this.state.rubberStartCell).height() - coords.top
			} else {
				coords.top = $(this.state.rubberStartCell).offset().top
				if (this.state.rubberEndCell){
					var bottom = $(this.state.rubberEndCell).offset().top + $(this.state.rubberEndCell).height()
					coords.height = bottom - coords.top - 4;
				} else {
					coords.height = mouseY - coords.top - 6
				}	
			}
			var top = $('#' + this.options.tableId).offset().top
			var bottom = top + $('#' + this.options.tableId).height()
			if (coords.top + coords.height < top){
				coords.height = 0;
			} else if (coords.top < top){
				var d = top - coords.top
				coords.top = top
				coords.height -= d;
			} else if (coords.top > bottom){
				coords.height = 0;
			} else if (coords.top + coords.height > bottom){
				coords.height = bottom - coords.top
			}
			
			if (coords.height <= 0 ){
				this.state.outofsight = 1;
				$('#' + this.options.id + '_rubberband').hide()
			} else if (this.state.outofsight){
				$('#' + this.options.id + '_rubberband').show()
			}
			$('#' + this.options.id + '_rubberband').offset(coords);
			$('#' + this.options.id + '_rubberband').width(coords.width);
			$('#' + this.options.id + '_rubberband').height(coords.height);
		},
		//------------------------------------------------------
		unSelect : function(){			
			if (document.selection) {
				document.selection.empty()
			} else {
				window.getSelection().removeAllRanges()
			}
		},
		//------------------------------------------------------
		exportTo : function(fmt,elem){			
			$(elem).prepend('<div id="ExportProgressLLKP" class="nt-export-progress"></div>');
			this.state.exportButton = elem;
			this.state.exportProgress = $('#ExportProgressLLKP');						
			this.disableButton(this.state.exportButton);
			$(this.state.exportButton).css('opacity','1');
			this.get('_event_=export&_exportto_=' + fmt)
			this.setTimer(2000);
			return this;
		},
		//------------------------------------------------------
		exportProgress : function(p){
			if (p<100){
				$(this.state.exportProgress).css('width',p+'%');
				this.setTimer(2000);
			} else {
				$(this.state.exportProgress).css('width','0%');
				this.enableButton(this.state.exportButton);
			}
		},

		//------------------------------------------------------
		setTimer : function(t) {
			setTimeout("$('"+this.options.divId+"').ntbrowse('server','"+this.options.procedure+"','_event_=timer');",t);
			return this;	
		},
		//------------------------------------------------------
		timerStart: function(t) {
			if(this.options.timerRefresh != 'disabled'){
				setTimeout("$('"+this.options.divId+"').ntbrowse('server','"+this.options.procedure+"','_refresh_="+this.options.timerRefresh+"');",t);
			}
			return this;	
        },
		//------------------------------------------------------
		timerStop: function() {
		
        },
		//------------------------------------------------------
		nav : function(f,d){
			this.fadeTable();
			if (this.options.json){
				this.serverJSON('_event_=nav&_refresh_='+d+'&focus=' + f);
			} else {
				this.server('_event_=nav&_refresh_='+d+'&focus=' + f);
			}	
			return this;
		},

        //------------------------------------------------------
		clearLocator : function(){
			$('#' + this.options.id + '_locator_a_div').find('input').val('');
			$('#' + this.options.id + '_locator_b_div').find('input').val('');
			this.fadeTable();
			this.locVal = '';
			this.server('_event_=locatorchanged&_refresh_=clearlocate')
			return this;
		},
        //------------------------------------------------------
		locate : function(elem,ev){
			if (this.locVal != $(elem).val()){
				if (ev.type=='input' || ev.type=='keypress'){
					this.locateChanged(elem);
				} else if (ev.type=='change'){
					this.goLocate(elem);
				}
			}	
			return this;	
/*			if ((ev.type=='input') && (this.state.blurring != true)){
				// to handle X in search field, always trigger if the locator is now blank.
				if ($(elem).val() == ''){
					this.clearLocator();
				} else {
					this.locateChanged(elem);
				}
				return this;
			}	
			this.state.blurring=false;
			if ((this.locVal != $(elem).val()) || (($(elem).attr('data-imm')!='true'))){ // tweaked for 7.31, to avoid /index.php?option=com_smf&Itemid=36&topic=5056.msg20017
				this.goLocate(elem);
			}
			return this;*/
		},
        //------------------------------------------------------
		// can be called from outside if the locator value has been changed.
		locateChanged : function(elem,force){
			// sync the values in both locators
			if (elem.id == 'locator1' + this.options.id){
				$('#locator2' + this.options.id).val($('#locator1' + this.options.id).val())
			} else if (elem.id == 'locator2' + this.options.id){
				$('#locator1' + this.options.id).val($('#locator2' + this.options.id).val())
			}
			// if imm then send the locator to the server
			if (($(elem).attr('data-imm')=='true') || (force)){
				this.goLocate(elem);
			}
		},
        //------------------------------------------------------
		// send the locator to the server
		goLocate : function(elem){
			this.fadeTable();
			this.locVal = $(elem).val();
			this.server('_event_=locatorchanged&_refresh_=locate',$(elem).attr("id")+'='+encodeURIComponent(this.locVal));
		},
        //------------------------------------------------------
		locateFocus : function(elem){
			if ($(elem).attr("data-noFocus") == "true"){
				$(elem).attr("data-noFocus","false");
			} else {	
				try{
					$('#osk').ntosk('getFocus',elem);
				} catch(e) {};
			}	
			try{
				$('#osk').ntosk('show');						
			} catch(e) {};	
		},
        //------------------------------------------------------
		locateBlur : function(){
			try{
				$('#osk').ntosk('startHide');
			} catch(e) {};	
			this.state.blurring=true;
		},
        //------------------------------------------------------
		locateAsifBlur : function(elem,e,i){
			if ( $(elem).val != this.locVal){
				this.locate(elem,e,i);				
			}
			try{
				$('#osk').ntosk('startHide');		
			} catch(e) {};	
		},
        //------------------------------------------------------
		sort : function(elem,ev){
			var dv = $(elem).attr('data-value')
			var dve;
			if (dv){
				dve = elem;
			} else {				
				dv = $(elem).children('a').attr('data-value');
				if (dv){
					dve = $(elem).children('a');
				}	
			}
			if (this.options.localStorage){
				$(this.options.divId).ntbrowsels("clientSideSort",elem,dv,ev,dve);				
			} else {
				this.server('_event_=sortchanged&_refresh_=sort',this.options.procedure+'_sort_' + this.options.randomid + '='+dv);
			} 	
			
			return this;
		},

        //------------------------------------------------------
        disable : function(){
			var _this=this;
			$(this.options.divId).find(':button').each(function(i,e){
				if($(e).attr('disabled') != 'disabled' ){
					$(e).attr("data-wait","wait").each(function(i,e){_this.disableButton(e)});;
				}
			})
			$('[data-elem="browse-row"]').off('mouseover.bt mouseout.bt click.bt') ;
		},
		
        //------------------------------------------------------
        enable : function(){
			var _this=this;
			$(this.options.divId).find('[data-wait="wait"]').removeAttr("data-wait").each(function(i,e){_this.enableButton(e)});
			this._bindEvents();
			this.refresh();
        },
		
        //------------------------------------------------------
        hide : function(){
			$(this.options.divId).hide();
        },
        //------------------------------------------------------
        show : function(){
			$(this.options.divId).show();
        },
        //------------------------------------------------------
        hideTable : function(){
			$('#' + this.options.tableId).fadeOut(200);
			$('#' + this.options.tableId).hide();
        },
        //------------------------------------------------------
        fadeTable : function(){
			$('#' + this.options.tableId).find('input, textarea, button, select').prop("disabled", true);
			$('#' + this.options.tableId).fadeTo(200,0.5)
        },
        //------------------------------------------------------
        unhideTable : function(){
			$('#' + this.options.tableId).css({opacity:1});
			$('#' + this.options.tableId).show();
        },
        //------------------------------------------------------
        serverClearLocator : function(){
			$('#' + this.options.id + '_locator_b_div').find('input').val('');
			$('#' + this.options.id + '_locator_a_div').find('input').val('');
        },
        //------------------------------------------------------
        locatorFocus : function(){
			$('#' + this.options.id + '_locator_b_div').find('input').focus();
			$('#' + this.options.id + '_locator_a_div').find('input').focus();
        },

		//------------------------------------------------------
        hideLocator : function(){
			$('#' + this.options.id + '_locator_b_div').hide();
			$('#' + this.options.id + '_locator_a_div').hide();
        },

        //------------------------------------------------------
        unhideLocator : function(i){
			if (i & 1){
				$('#' + this.options.id + '_locator_b_div').show();
			} else {
				$('#' + this.options.id + '_locator_b_div').hide();
			}
			
			if (i & 2){
				$('#' + this.options.id + '_locator_a_div').show();
			} else {
				$('#' + this.options.id + '_locator_a_div').hide();
			}
        },

        //------------------------------------------------------
        hideSelectButton : function(i){
			if(i){
				$('#'+ this.options.id +'_div').find('[data-do="select"]').hide();
			} else {
				$('#'+ this.options.id +'_div').find('[data-do="select"]').show();
			}	
		},
        //------------------------------------------------------
        hideButton : function(b){
			$('#'+ this.options.id +'_div').find('[data-do="'+b+'"]').hide();
		},
        //------------------------------------------------------
        showButton : function(b){
			$('#'+ this.options.id +'_div').find('[data-do="'+b+'"]').show();
		},
		//------------------------------------------------------
        hideFormButtons : function(i){
			if (i==true){
				$('#' + this.options.id + '_update_b_div').find('[data-do="insert"]').hide();
				$('#' + this.options.id + '_update_a_div').find('[data-do="insert"]').hide();			
			} else {
				$('#' + this.options.id + '_update_b_div').find('[data-do="insert"]').show();
				$('#' + this.options.id + '_update_a_div').find('[data-do="insert"]').show();
			}
			$('#' + this.options.id + '_update_b_div').find('[data-do="copy"]').hide();
			$('#' + this.options.id + '_update_a_div').find('[data-do="copy"]').hide();
			$('#' + this.options.id + '_update_b_div').find('[data-do="change"]').hide();
			$('#' + this.options.id + '_update_a_div').find('[data-do="change"]').hide();
			$('#' + this.options.id + '_update_b_div').find('[data-do="deleteb"]').hide();
			$('#' + this.options.id + '_update_a_div').find('[data-do="deleteb"]').hide();		
			$('#' + this.options.id + '_update_b_div').find('[data-do="view"]').hide();
			$('#' + this.options.id + '_update_a_div').find('[data-do="view"]').hide();		
			$('#' + this.options.id + '_update_b_div').find('[data-do="export"]').hide();
			$('#' + this.options.id + '_update_a_div').find('[data-do="export"]').hide();		
        },

        //------------------------------------------------------
        unhideFormButtons : function(){
			$('#' + this.options.id + '_update_b_div').find('[data-do="insert"]').show();
			$('#' + this.options.id + '_update_a_div').find('[data-do="insert"]').show();
			$('#' + this.options.id + '_update_b_div').find('[data-do="copy"]').show();
			$('#' + this.options.id + '_update_a_div').find('[data-do="copy"]').show();
			$('#' + this.options.id + '_update_b_div').find('[data-do="change"]').show();
			$('#' + this.options.id + '_update_a_div').find('[data-do="change"]').show();
			$('#' + this.options.id + '_update_b_div').find('[data-do="deleteb"]').show();
			$('#' + this.options.id + '_update_a_div').find('[data-do="deleteb"]').show();			
			$('#' + this.options.id + '_update_b_div').find('[data-do="view"]').show();
			$('#' + this.options.id + '_update_a_div').find('[data-do="view"]').show();			
			$('#' + this.options.id + '_update_b_div').find('[data-do="export"]').show();
			$('#' + this.options.id + '_update_a_div').find('[data-do="export"]').show();			
        },

        //------------------------------------------------------
        hideNav : function(){
			$('#' + this.options.id + '_nav_a').hide();
			$('#' + this.options.id + '_nav_b').hide();
        },
		
        //------------------------------------------------------
        unhideNav : function(disablePrev,disableNext){
			var _this=this;
			$('#' + this.options.id + '_nav_a').show();
			$('#' + this.options.id + '_nav_b').show();
			if (disablePrev==true){
				$('#' + this.options.id + '_nav_b').find('[data-do="first"]').each(function(i,e){_this.disableButton(e)});
				$('#' + this.options.id + '_nav_b').find('[data-do="first"]').each(function(i,e){_this.disableButton(e)});
				$('#' + this.options.id + '_nav_b').find('[data-do="previous"]').each(function(i,e){_this.disableButton(e)});
				$('#' + this.options.id + '_nav_a').find('[data-do="first"]').each(function(i,e){_this.disableButton(e)});
				$('#' + this.options.id + '_nav_a').find('[data-do="previous"]').each(function(i,e){_this.disableButton(e)});
			} else if (disablePrev==false) {
				$('#' + this.options.id + '_nav_b').find('[data-do="first"]').each(function(i,e){_this.enableButton(e)});
				$('#' + this.options.id + '_nav_b').find('[data-do="previous"]').each(function(i,e){_this.enableButton(e)});
				$('#' + this.options.id + '_nav_a').find('[data-do="first"]').each(function(i,e){_this.enableButton(e)});
				$('#' + this.options.id + '_nav_a').find('[data-do="previous"]').each(function(i,e){_this.enableButton(e)});
			}
			if (disableNext==true){
				$('#' + this.options.id + '_nav_b').find('[data-do="last"]').each(function(i,e){_this.disableButton(e)});
				$('#' + this.options.id + '_nav_b').find('[data-do="next"]').each(function(i,e){_this.disableButton(e)});
				$('#' + this.options.id + '_nav_a').find('[data-do="last"]').each(function(i,e){_this.disableButton(e)});
				$('#' + this.options.id + '_nav_a').find('[data-do="next"]').each(function(i,e){_this.disableButton(e)});
			} else if (disableNext==false){
				$('#' + this.options.id + '_nav_b').find('[data-do="last"]').each(function(i,e){_this.enableButton(e)});
				$('#' + this.options.id + '_nav_b').find('[data-do="next"]').each(function(i,e){_this.enableButton(e)});
				$('#' + this.options.id + '_nav_a').find('[data-do="last"]').each(function(i,e){_this.enableButton(e)});
				$('#' + this.options.id + '_nav_a').find('[data-do="next"]').each(function(i,e){_this.enableButton(e)});
			}
        },
		
        //------------------------------------------------------
		edit : function(elem,action,header){    
			var actionname='';
			var actionform='';
			var actionFormOverride='';
			this.setvalue($(elem).closest('[data-nt-id]').attr('data-nt-id'));
			switch(action){
			case 1: //Insert
				actionname ='insert_btn';
				actionform = $('[data-nt-id="'+this.options.value+'"]').attr('data-nt-insert');
				if (!actionform){
					actionform = this.options.formInsert;
				}
				break;
			case 2: //Change
				actionname ='change_btn';
				actionform = $('[data-nt-id="'+this.options.value+'"]').attr('data-nt-change');
				if (!actionform){
					actionform = this.options.formChange;
				}
				break;
			case 3: //Delete
				actionname ='change_btn';
				actionform = $('[data-nt-id="'+this.options.value+'"]').attr('data-nt-delete');
				if (!actionform){
					actionform = this.options.formDelete;
				}
				break;
			case 4: //Copy
				actionname ='copy_btn';
				actionform = $('[data-nt-id="'+this.options.value+'"]').attr('data-nt-copy');
				if (!actionform){
					actionform = this.options.formCopy;
				}
				break;
			case 5: //View
				actionname ='view_btn';
				actionform = $('[data-nt-id="'+this.options.value+'"]').attr('data-nt-view');
				if (!actionform){
					actionform = this.options.formView;
				}
				break;
			}
			if (actionform == ''){
				actionform = this.options.form;
			}
			if (this.options.formpopup){     
				header = ''; // don't default the header when called from a browse.
				ntd.push(actionform,'',header,1,action,null,this.options.procedure,this.options.value,'_parentProc_=' + this.options.parent,null,null,null,null,null,null,this.options.divId);
			} else {
				this.gotoPage(actionform,actionname,this.options.value);
			}
			return this;
		},

        //------------------------------------------------------
		deleteb : function(elem){
			var _this=this;
			if (this.options.confirmDelete){
				$('body').append('<div id="message_confirm" title="'+_this.options.confirmText+'">' + this.options.confirmDeleteMessage + '</div>');
				$( "#message_confirm" ).dialog({
					resizable: false,
					modal: true,
					buttons: [{
						text: _this.options.deleteText,
						click : function() {    
							$( this ).dialog( "close" );
							$( "#message_confirm" ).remove();
							_this.deletenow(elem);
						}
					}, {


						text: _this.options.cancelText,
						click: function() {
							$( this ).dialog( "close" );
							$( "#message_confirm" ).remove();
							return _this;
						}
					}]	
				});      
			} else {
				this.deletenow(elem);
			}
		},

		//------------------------------------------------------
		deletenow : function(elem){			
			this.options.form = this.options.form.replace("?","&");
			this.setvalue($(elem).closest('[data-nt-id]').attr('data-nt-id'));
			if (this.options.localStorage){
				$(this.options.divId).ntbrowsels("deleteb",this.options.value);				
			} else {
				this.serverPost('pressedButton=deleteb_btn','_event_=deleteb&_action_=3&_fromForm_='+ this.options.form,'_bidv_=' + this.options.value + '&_ajax_=1&_parentProc_=' +  this.options.parent + '&_parentRid_=' + this.options.parentrid);
			}	
			return this;
		},
        //------------------------------------------------------
		select : function(elem){
			if (elem){
				this.setvalue($(elem).closest('[data-nt-id]').attr('data-nt-id'));
			}
			if (this.options.popup){
				$('#'+ntd.getluf()).data('luv',this.options.value);
				if (this.options.localStorage){
					$(this.options.divId).ntbrowsels("selectb",this.options.value,ntd.getluf());				
				}	
				$('#'+ntd.getluf()).change();
				$('#popup_'+ntd.getdlg().toLowerCase()+'_div').dialog('close'); // close does a ntd.pop
			} else{
				this.gotoPage(this.options.selectAction,'select_btn',this.options.value,this.options.lookupField);
				return this;
			};
		},

        //------------------------------------------------------
		cancel : function(){
			if (this.options.popup){
				$('#popup_'+ntd.getdlg().toLowerCase()+'_div').dialog('close'); // close does a ntd.pop
			} else {
				this.gotoPage(this.options.cancelAction,'browsecancel_btn');
			}
			return this;
		},
        //------------------------------------------------------
		close : function(){
			if (this.options.popup){
				$('#popup_'+ntd.getdlg().toLowerCase()+'_div').dialog('close'); // close does a ntd.pop
			} else {
				this.gotoPage(this.options.closeAction,'close_btn');
			}
			return this;
		},
        //------------------------------------------------------
		rad : function(){     // Reset After Date
			this.eip(this.ct,this.eipclm,this.vs);
			return this;
		},

        //------------------------------------------------------
        gotoPage : function(a,n,v,l){
			$(':button').attr('disabled', 'disabled');
			$('#xdecfr').remove();
			var ht = '<form method = "POST" action="'+a+'" id="xdecfr">';
			if (n) ht = ht + '<input type="hidden" name="pressedbutton" value = "'+n+'" />';
			if (v) ht = ht + '<input type="hidden" name="_bidv_" value = "'+v+'" />';
			if (l) ht = ht + '<input type="hidden" name="lookupfield" value = "'+this.options.lookupField+'" />';
			if ($('#FormState')) ht = ht + '<input type="hidden" name="FormState" value = "'+$('#FormState').val()+'" />';
			ht = ht + '</form>';
			$(this.options.divId).append(ht)
			$('#xdecfr').submit();
			// this page terminates here
			return this;
		},

        //------------------------------------------------------
		sv : function(p0) {   // send async request to server
			var parms='';
			var _this=this;
			for(var d = 1; d < arguments.length; d++){
				parms += arguments[d] + '&';
			}
			parms += '_parentProc_=' + this.options.parent + '&_parentRid_=' + this.options.parentrid + '&_popup_=' + this.options.popup  + '&_rid_=' & this.options.randomid + '&_ajax_=1&_rnd_=' + Math.random().toString(36).substr(5);
			$.get(p0+ this.options.urlExt,parms,function(data){_this.onAjaxComplete(data);});
			return this;
		},

        //------------------------------------------------------
		get : function() {         // send async request to server procedure
			var parms='';
			var _this=this;
			for(var d = 0; d < arguments.length; d++){
				parms += arguments[d] + '&';
			}

			parms += '_parentProc_=' + this.options.parent + '&_parentRid_=' + this.options.parentrid + '&_ajax_=0&_popup_=' + this.options.popup + '&_rid_=' + this.options.randomid + '&_rnd_=' + Math.random().toString(36).substr(5);
			parms = parms.replace(/\r\n/g,"%0D%0A");
			parms = parms.replace(/\n\r/g,"%0D%0A");
			parms = parms.replace(/\r/g,"%0D%0A");
			parms = parms.replace(/\n/g,"%0D%0A");
			document.location = this.options.procedure + this.options.urlExt + '?' + parms;
			return this;
		},
        //------------------------------------------------------
		server : function() {         // send async request to server procedure
			var parms='';
			var _this=this;
			for(var d = 0; d < arguments.length; d++){
				parms += arguments[d] + '&';
			}

			parms += '_parentProc_=' + this.options.parent + '&_parentRid_=' + this.options.parentrid + '&_ajax_=1&_popup_=' + this.options.popup + '&_rid_=' + this.options.randomid + '&_rnd_=' + Math.random().toString(36).substr(5);
			parms = parms.replace(/\r\n/g,"%0D%0A");
			parms = parms.replace(/\n\r/g,"%0D%0A");
			parms = parms.replace(/\r/g,"%0D%0A");
			parms = parms.replace(/\n/g,"%0D%0A");
			$.get(this.options.procedure + this.options.urlExt,parms,function(data){_this.onAjaxComplete(data);});
			return this;
		},

        //------------------------------------------------------
		serverJSON : function() {         // send async request to server procedure
			var parms='';
			var _this=this;
			for(var d = 0; d < arguments.length; d++){
				parms += arguments[d] + '&';
			}

			parms += '_parentProc_=' + this.options.parent + '&_parentRid_=' + this.options.parentrid + '&_ajax_=1&_popup_=' + this.options.popup + '&_rid_=' + this.options.randomid + '&_rnd_=' + Math.random().toString(36).substr(5);
			parms = parms.replace(/\r\n/g,"%0D%0A");
			parms = parms.replace(/\n\r/g,"%0D%0A");
			parms = parms.replace(/\r/g,"%0D%0A");
			parms = parms.replace(/\n/g,"%0D%0A");
			$.getJSON(this.options.procedure + this.options.urlExt,parms,function(data){_this.onAjaxComplete(data);});
			return this;
		},

        //------------------------------------------------------
		serverPost : function() {     // send async request POST to server procedure
			var parms='';
			var _this=this;
			for(var d = 0; d < arguments.length; d++){ // supports multiple incoming arguments.
				parms += arguments[d] + '&';
			}
			parms += 'FormState=' + $('#FormState').val() + '&'
	
			parms += '_ajax_=1&_parentProc_=' + this.options.parent + '&_parentRid_=' + this.options.parentrid + '&_popup_=' + this.options.popup + '&_rid_=' + this.options.randomid + '&_rnd_=' + Math.random().toString(36).substr(5);
			$.post(this.options.procedure+ this.options.urlExt,parms,function(data){_this.onAjaxComplete(data);});
			return this;
		},

        //------------------------------------------------------
		onAjaxComplete : function(data) {
			xmlProcess(data);
			//this.ready();  // no need to call ready, the xmlProcess will recreate the object if needed.
			return this;
		},
        //------------------------------------------------------
		onAjaxCompleteJSON : function(data) {

			xmlProcess(data);
			//this.ready();  // no need to call ready, the xmlProcess will recreate the object if needed.
			return this;
		},
        //------------------------------------------------------
		process : function(data) {
		}
		

//------------------------------------------------------
});

$.extend( $.ui.ntbrowse, {
        version: "@VERSION"
});

})( jQuery );

///////////////////////////////////////////////////////
// end ntbrowse
///////////////////////////////////////////////////////


$(window).unload(function() {
  $(':ui-ntbrowse').ntbrowse("destructor");
});
