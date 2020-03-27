(function( $, undefined ) {
	var BIG = 1;
	var SMALL = 0;
	var ZOOM = 1;
	var REGULAR = 0;


	var _dragging='';
	var _dragform='';
	var _zoomed=false;

$.widget("ui.ntcalendar", {
   // default options
	options: {
		id:'',
		proc: 'nothing',
		parent:'',
		divId: '',
		insertForm: '',
		insertText: 'Insert',
		changeText: 'Change',
		insertTip: 'Click here to insert a record',
		popupMode: true,
		otherFormParameters: '',
		size: SMALL,
		monthClass: '',
		smallMonthClass: '',
		contentClass: '',
		smallContentClass: '',
		labelClass: '',
		smallLabelClass: '',
		emptyLabelClass: '',
		smallEmptyLabelClass: '',
		zoomHeading: '',  
		draganddrop: true,
		gradients: true,
		headerClass:'ui-widget-header ui-corner-top nt-month-header', // s_web._SitesQueue.Defaults.Style.MonthHeader
		headingClass:'nt-heading',										// s_web._SitesQueue.Defaults.Style.MonthHeading

		subHeaderClass:'nt-month-header-cell nt-wide',				// s_web._SitesQueue.Defaults.Style.MonthHeaderCell
		emptyCellClass:'nt-monthday-empty-cell',
		cellClass:'nt-monthday-cell ui-corner-all',
		weekDayName:['S','M','T','W','T','F','S'],
		compressEmptyLines:false,
		wsLive:0,             // live refresh via web sockets
		wsTables:[]          // array of table names to monitor
   },
   state:{
		popLiveUpdate:0
	},
//------------------------------------------------------    
		_create: function() {
		},	
//------------------------------------------------------    
		begin: function() {
			var _this = this;
			$(this.element).find('[data-nt-month]').each(function(){_this._addMonth(this,REGULAR);});
			this._addButtons(this.options.size == SMALL ? true : false,REGULAR);
			this._addPopup();
			this.refreshZoom();
		},	
//------------------------------------------------------
        _init: function() {
			if (this.options.wsLive){
				for (var i = 0; i < this.options.wsTables.length; i++) {
					if(this.options.wsTables[i]){
						nts.watch(this.options.id,"","table","",this.options.wsTables[i],this.liveUpdate,this)
					}	
				}	
			}  		
        },
//------------------------------------------------------
//   do not use "this" in this method, use "_this' instead.
        liveUpdate: function(json,_this) {
			if(_this.state.popLiveUpdate==true){
				// some actions here will trigger a netrefresh on the server side, but we're already getting a set of refresh
				// data from the action itself. In which case the live update is suppressed.
				_this.state.popLiveUpdate=false
			} else {
				var fromdate = $('#' + _this.options.id).find('[data-nt-month]').first().attr('data-nt-month')
				var todate = $('#' + _this.options.id).find('[data-nt-month]').last().attr('data-nt-month')
				$.get(_this.options.proc,'_ajax_=1&_refresh_=current&_fromdate_=' + fromdate + '&_todate_=' + todate + '&_parentProc_=' + _this.options.parent,function(data){
						// when new month arrives						
						xmlProcess(data);					
						_this.refresh()
					});				
			}	
        },		
//------------------------------------------------------    
		refresh: function() {
			var _this = this;	
			$(this.element).find('[data-nt-month]').each(function(){_this._addMonth(this,REGULAR);});
			this._addButtons(true,REGULAR);
			this.refreshZoom();
		},
//------------------------------------------------------    
		refreshZoom: function() {
			if (_zoomed == true){
				var zoomMonth = '#' + $('#'+this.options.divId+'_zoom_div').find('[data-nt-month]:first').attr('id');
				this._zoomInMonth($(zoomMonth));
			}	
		},
//------------------------------------------------------      		
		_addPopup: function(){
			var _this = this;
			$(this.element).after('<div id="popup_' + this.options.divId + '_div" class="nt-hidden">' +
														'<div id="'+this.options.divId+'_zoom_div"></div></div>');
			$('#popup_' + this.options.divId + '_div').
			dialog({close: function(event, ui) {_zoomed = false; },  
							autoOpen: false, 
							width: 860, 
							modal: true, 
							position: ['center',15]})
			.removeClass('nt-hidden');				
		},
//------------------------------------------------------      
		clear: function(){
			$('#'+this.options.divId+'_cal_div').empty();
		},
//------------------------------------------------------      
		hide: function(){
			$('#'+this.options.divId+'_cal_div').hide();
		},
//------------------------------------------------------      
		show: function(){
			$('#'+this.options.divId+'_cal_div').show();
		},		
//------------------------------------------------------      
		addSmallHtmlMonth: function(date,m,y,headingText,firstDay,createDiv,createContents){
			var ml = [31,28,31,30,31,30,31,31,30,31,30,31];
			if (y%4==0){
				if (y % 100 == 0){
					if ( y % 400 == 0){
						ml[1] = 29;
					}
				} else {	
					ml[1] = 29;
				}
			}
			var id = 'd_'+m+'_'+y+'_div';
			var dayOneOffset = (date - firstDay) % 7;
			if (createDiv){
				$('#'+this.options.divId+'_cal_div').append(this.htmlSmallMonthWrapper(id,date));
			} else {
				$('#'+id).attr('data-nt-month',date);
			}	
			if (createContents){
				$('#'+id).append(this.htmlSmallMonthHeader(id,headingText))
				$('#'+id).append(this.htmlSmallMonthSubHeader(id))
				$('#'+id).append(this.htmlSmallMonthLines(this.options.divId,date,6,dayOneOffset,ml[m-1]))
			}
		},
//------------------------------------------------------      
		htmlSmallMonthWrapper: function(id,date){
			return(	'<div id="'+id+'" data-nt-month="'+date+'">' +
					'</div>')
		},
//------------------------------------------------------      
		htmlSmallMonthHeader: function(id,headingText){
			return(	'<div id="'+id+'_h" class="'+this.options.headerClass+'" data-nt-head="header">' +
					'<span class="'+this.options.headingClass+'" data-nt-heading="'+headingText+'">A</span>' +
					'</div>')
		},
//------------------------------------------------------      
		htmlSmallMonthSubHeader: function(id){
			return(	'<div id="'+id+'_sh"  class="'+this.options.subHeaderClass+'">' +
					'<div>'+this.options.weekDayName[0]+'</div>' +
					'<div>'+this.options.weekDayName[1]+'</div>' +
					'<div>'+this.options.weekDayName[2]+'</div>' +
					'<div>'+this.options.weekDayName[3]+'</div>' +
					'<div>'+this.options.weekDayName[4]+'</div>' +
					'<div>'+this.options.weekDayName[5]+'</div>' +
					'<div>'+this.options.weekDayName[6]+'</div>' +
					'</div>' )
		},
//------------------------------------------------------      
		htmlSmallMonthLines: function(id,date,weeks,dayOneOffset,dim){
			var s='';
			var i=0;
			var j=0;
			var day=1;
			if (!weeks) weeks=6;
			for(i=0; i < weeks; i++){
				s = s +	'<div id="'+id+'_m" class="nt-wide">' 
				for(j=0; j < 7 ; j++){
					if (dayOneOffset || day > 31 || day > dim){
						dayOneOffset -= 1;
						s = s +	'<div id="'+id+'_'+i+'_'+j+'" class="'+this.options.emptyCellClass+'">&#160;</div>';
					} else {
						s = s +	'<div id="'+id+'_'+ parseInt(date+day-1) +'" class="'+this.options.cellClass+'" data-nt-date="'+parseInt(date+day-1)+'"><div>'+day+'</div></div>';
						day += 1
					}					
				}	
				s = s +	'</div>'
				if (this.options.compressEmptyLines && day >= 31){
					break;
				}
			}
			return(s);
		},
//------------------------------------------------------      
		htmlSmallMonthClear: function(id,date,weeks,dayOneOffset,dim){
			var i=0;
			var j=0;
			var day=1;
			if (!weeks) weeks=6;
			for(i=0; i < weeks; i++){
				for(j=0; j < 7 ; j++){
					if (dayOneOffset || day > 31 || day > dim){
						dayOneOffset -= 1;
					} else {
						$('#' + id +'_'+ parseInt(date+day-1)).removeClass().addClass(this.options.cellClass)
						day += 1
					}										
				}	
				if (this.options.compressEmptyLines && day >= 31){
					break;
				}
			}
			return		
		},
//------------------------------------------------------      
		htmlSmallMonthData: function(date,m,firstDay,data){
			var id = 'd_'+date+'_div';
			var i=0;
			var _this=this;
			// clear month data
			var ml = [31,28,31,30,31,30,31,31,30,31,30,31];
			var dayOneOffset = (date - firstDay) % 7;
			this.htmlSmallMonthClear(this.options.divId,date,6,dayOneOffset,ml[m-1])			
			//
			if(!data){
				return
			}
			for (var i = 0; i < data.length; i++) {			
				$('#' + this.options.divId + '_' + parseInt(date-1+data[i][0])).each(function(){
					if (data[i-1]){
						if (data[i][2]==-1) data[i][2] = data[i-1][2];
						if (data[i][3]==-1) data[i][3] = data[i-1][3];
						if (data[i][4]==-1) data[i][4] = data[i-1][4];
						if (data[i][5]==-1) data[i][5] = data[i-1][5];
						if (data[i][6]==-1) data[i][6] = data[i-1][6];
						if (data[i][7]==-1) data[i][7] = data[i-1][7];
						if (data[i][8]==-1) data[i][8] = data[i-1][8];
						if (data[i][9]==-1) data[i][9] = data[i-1][9];
					}
					$(this)	.addClass(data[i][3])
							.attr('style',data[i][4])
							.attr('title',data[i][5])
							.attr('data-nt-image-big',data[i][6])
							.attr('data-nt-image-small',data[i][7])
							.attr('data-nt-id',data[i][8])
							.attr('data-nt-form',data[i][9])
							.attr('data-nt-place',data[i][10])
							;
					if 	(data[i][11] == 'r' || data[i][11] == 'i'){ 
						$(this).attr('data-nt-info',data[i][11]);
						if (data[i][8]){
							$(this).attr('data-nt-id','uk');
						}		
					}
					if (data[i][2] && _this.options.size == BIG){ // content
						$(this).html('<div>'+data[i][1]+'</div><div>'+data[i][2]+'</div>');
					} else { // just label
						$(this).html('<div>'+data[i][1]+'</div>');
					}
				});
			}
		},
		
//------------------------------------------------------      
		_addMonth: function(month,zoomed){
		  this._setHeader(month);
		  this._primeUpdates(month,zoomed);		
		  this._primeInserts(month,zoomed);
			this._makeDraggable(month,zoomed);
			this._makeDroppable(month,zoomed);
			(this.options.size == BIG || zoomed == ZOOM) ? this._bigMonth(month) : this._smallMonth(month);
			this._applyGradients(month);
		},
//------------------------------------------------------      
		_setHeader: function(month){
			var _this = this;
			var _span = $(month).find('[data-nt-heading]');
			var _atr = $(month).find('[data-nt-heading]').attr('data-nt-heading');
			$(_span).html(_atr);
		},
//------------------------------------------------------      
		_bigMonth: function(month){
			var _this = this;
			$(month).removeClass(_this.options.smallMonthClass).addClass(_this.options.monthClass);
		},
//------------------------------------------------------      
		_smallMonth: function(month){
			var _this = this;
			$(month).removeClass(_this.options.MonthClass).addClass(_this.options.smallMonthClass);
		},
//------------------------------------------------------      
		_primeInserts: function(month,zoomed) {	
			var _this = this;	
			$(month).find("[data-nt-date]").not("[data-nt-id]").add('[data-nt-info="i"]',month)
				.removeClass("drop0 drop1 drag0 drag1")
				.addClass("drop"+zoomed)
				.attr("title",this.options.insertTip)
				.bind("click",function(){
					if (_dragging==''){
						if (_this.options.popupMode && _this.options.insertForm){
							_this.state.popLiveUpdate=true;
							ntd.push(_this.options.insertForm,'',_this.options.insertText,1,1,null,_this.options.proc,'','_date_='+$(this).attr('data-nt-date')+'&'+_this.options.otherFormParameters,null,null,null,null,null,_this.options.parent);
						}	
					}		
				})	
				.find('div:first')
					.removeClass((_this.options.size==BIG || zoomed == ZOOM)? _this.options.smallEmptyLabelClass : _this.options.emptyLabelClass)
					.addClass((_this.options.size==BIG || zoomed == ZOOM) ? _this.options.emptyLabelClass : _this.options.smallEmptyLabelClass);
		},	
//------------------------------------------------------ 
		_primeUpdates: function(month,zoomed){ // find all full cells and prime them for call to update.
			var _this = this;	
				
			$(month).find("[data-nt-id]").not('[data-nt-info="r"]').not('[data-nt-info="i"]')
				.removeClass("drag0 drag1 drop0 drop1")
				.addClass("drag"+zoomed+" drop"+zoomed)
				.bind("click.cal",function(){
					if (_dragging=='' && $(this).attr('data-nt-form') != undefined){
						if (_this.options.popupMode){
							_this.state.popLiveUpdate=true;
							ntd.push($(this).attr('data-nt-form'),'',_this.options.changeText,1,2,null,_this.options.proc,$(this).attr('data-nt-id'),'_date_='+$(this).attr('data-nt-date')+'&'+_this.options.otherFormParameters,null,null,null,null,null,_this.options.parent);
						}	
					}
				})	
				
			$(month).find('[data-nt-id]')
				.addClass(_this.options.gradients ? "cal-grad" : "")
				.find('div:first')
					.removeClass((_this.options.size==BIG || zoomed == ZOOM) ? _this.options.smallLabelClass : _this.options.labelClass)
					.addClass((_this.options.size==BIG || zoomed == ZOOM) ? _this.options.labelClass : _this.options.smallLabelClass)
					.each(function(){
						if (_this.options.size==SMALL){
							image = $(this).parent().attr('data-nt-image-small');
							if (image){
								$(this).css('background-image','url("/'+image+'")');
							}	
						}
					})	
					.next()
						.removeClass((_this.options.size==BIG || zoomed == ZOOM) ? _this.options.smallContentClass : _this.options.contentClass)
						.addClass((_this.options.size==BIG || zoomed == ZOOM) ? _this.options.contentClass : _this.options.smallContentClass)
						.each(function(){
							if (_this.options.size==BIG || zoomed == ZOOM){
								image = $(this).parent().attr('data-nt-image-big');
								if (image){
									$(this).css('background-image','url("/'+image+'")');
								}	
							}
						})
						
			$(month)
				.find('[data-nt-place="f"]').removeClass('ui-corner-all').addClass((_this.options.size==BIG || zoomed == ZOOM)?'cal-corner-left':'cal-corner-left-small').end()
				.find('[data-nt-place="m"]').removeClass('ui-corner-all').end()
				.find('[data-nt-place="l"]').removeClass('ui-corner-all').addClass((_this.options.size==BIG || zoomed == ZOOM)?'cal-corner-right':'cal-corner-right-small').end()
				.find('[data-nt-place="s"]').removeClass('ui-corner-all').addClass((_this.options.size==BIG || zoomed == ZOOM)?'cal-corner-all':'cal-corner-all-small').end()
		},	
//------------------------------------------------------ 
		_makeDraggable: function(month,zoomed){
		  if (this.options.draganddrop){
			  $(month).find('.drag'+zoomed).draggable({
				  revert: 'invalid',
				  start: function(event, ui) { 
  					_dragging = $(this).attr('data-nt-id');
	  				_dragform = $(this).attr('data-nt-form');
		  		},
			  	stop: function(event, ui) { 
				  	setTimeout(function(){_dragging='';}, 300);
				  }
			  });
			};  
		},	
//------------------------------------------------------ 		
		_makeDroppable: function(month,zoomed){
			var _this = this;	            
			if (this.options.draganddrop){
			  $(month).find('.drop'+zoomed).droppable({
				  accept: '.drag'+zoomed,
				  drop: function(event, ui) { 
					_this.state.popLiveUpdate=true;
					ntd.push(_dragform,'',_this.options.changeText,1,2,null,_this.options.proc,_dragging,'_newdate_='+$(this).attr('data-nt-date'),1,null,null,null,null,_this.options.parent);
				  }
			  });
			};  
		},
//------------------------------------------------------ 
		_removeDragAndDrop: function(month,zoomed){
		  if (this.options.draganddrop){
				try{$(month).find('.drag'+zoomed).draggable("destroy");  } catch (e) {}	
				try{$(month).find('.drop'+zoomed).droppable("destroy");	 } catch (e) {}	
			};  
		},	
//------------------------------------------------------    
		_addButtons: function(addZoom,zoomed){
			var _this = this;
			$(this.element).find('[data-nt-month]:first').each(function(){_this._addPreviousButton(this,zoomed);});
			if (addZoom == 1){
				this._addZoomButtons();
			}	
			$(this.element).find('[data-nt-month]:last').each(function(){_this._addNextButton(this,zoomed);});
		},
//------------------------------------------------------ 		
		_addZoomButtons: function(){
			var _this = this;
			if (this.options.size == SMALL){
				$(this.element).find('[data-nt-month]').each(function(){_this._addZoomButton(this);});			
			}	
			this._bindZoomButtons();
		},
//------------------------------------------------------ 		
		_bindZoomButtons: function(){
			var _this = this;	
			$(this.element).find('.ui-icon-circle-zoomin').bind('click',function(){
				_this._zoomInMonth($(this).parent().parent());
			});
		},
//------------------------------------------------------ 		
		_zoomInMonth: function(month){		
			var _this = this;
			_zoomed = true;
			$('#popup_'+this.options.divId+'_div').dialog( "option", "title", _this.options.zoomHeading ).dialog('open');
			$('#'+this.options.divId+'_zoom_div').empty();
			$(month).clone().appendTo('#'+this.options.divId+'_zoom_div');
			var zoomMonth = $('#'+this.options.divId+'_zoom_div').find('[data-nt-month]:first')
			this._removeDragAndDrop(zoomMonth,0);
			this._removePreviousButton(zoomMonth,0);
			this._removeNextButton(zoomMonth,0);
			this._removeZoomButton(zoomMonth);
			this._zoomFormatIncoming(this);
		},
//------------------------------------------------------    
		_zoomFormatIncoming: function(_this){		
			_this._addMonth($('#'+ _this.options.divId + '_zoom_div').find('[data-nt-month]:first'),ZOOM);
			_this._addPreviousButton($('#'+ _this.options.divId + '_zoom_div').find('[data-nt-month]:first'),1);
			_this._addNextButton($('#'+ _this.options.divId + '_zoom_div').find('[data-nt-month]:last'),1);
		},
//------------------------------------------------------ 		
		_addZoomButton: function(month){
			var _this = this;
			var _id = $(month).attr('id') + '_zoom';
			if ($('#' + _id).html() == null){
				$(month)
					.find('[data-nt-heading]')
					.after('<span id="' + _id + '" class="nt-right ui-icon ui-icon-circle-zoomin">Zoom</span>')
			} 
		},
//------------------------------------------------------ 		
		_removeZoomButton: function(month){
			$(month).find('#' + $(month).attr('id') + '_zoom').remove();
		},		
//------------------------------------------------------    
		_addPreviousButton: function(month,zoomed){ 
			if ($('#' + this.options.divId + zoomed  + '_prev').attr('id') == undefined){
				$(month)
					.find('[data-nt-heading]')
					.before('<span id="' + this.options.divId + zoomed + '_prev" class="nt-hard-left ui-icon ui-icon-circle-triangle-w">Prev</span>')
				this._bindPreviousButton(month,zoomed);
			}	
		},
//------------------------------------------------------ 		
		_removePreviousButton: function(month,zoomed){
			$(month).find('#' + this.options.divId + zoomed  + '_prev').remove();
		},		
//------------------------------------------------------ 		
		_addNextButton: function(month,zoomed){
			if ($('#' + this.options.divId + zoomed  + '_next').attr('id') == undefined){		
				$(month)
					.find('[data-nt-heading]')
					.after('<span id="' + this.options.divId + zoomed + '_next" class="nt-right ui-icon ui-icon-circle-triangle-e">Next</span>');
					//.after('<span id="' + this.options.divId + zoomed + '_next" class="nt-right ui-icon ui-icon-circle-triangle-e">Next</span>');
				this._bindNextButton(month,zoomed);
			}	
		},
//------------------------------------------------------ 		
		_removeNextButton: function(month,zoomed){
			$(month).find('#' + this.options.divId + zoomed + '_next').remove();
		},
//------------------------------------------------------ 		
		_bindNextButton: function(month,zoomed){
			var _this = this;	
			if (zoomed==false){
				$('#' + this.options.divId + zoomed  + '_next').bind('click',function(){
					_this._scrollNext(month);
				});
			} else {
				$('#' + this.options.divId + zoomed  + '_next')
					.bind('click',function(){
						var parentMonth = '#'+$(month).attr('id');
						$(month).empty().remove();
						var nextMonth = $(parentMonth).next();
						if ($(nextMonth).attr('id') != undefined){
							_this._zoomInMonth(nextMonth);
						} else {
							_this._scrollNext(parentMonth,function(){
									nextMonth = $(parentMonth).next();
									_this._zoomInMonth(nextMonth);
								});
						}	
					});	
			}	
		},
//------------------------------------------------------ 		
		_bindPreviousButton: function(month,zoomed){
			var _this = this;	
			if (zoomed==false){
				$('#' + this.options.divId + zoomed  + '_prev').bind('click',function(){
					_this._scrollPrevious(month);
				});
			} else {
				$('#' + this.options.divId + zoomed  + '_prev')
					.bind('click',function(){
						var parentMonth = '#'+$(month).attr('id');
						$(month).empty().remove();
						var previousMonth = $(parentMonth).prev();
						if ($(previousMonth).attr('id') != undefined){
							_this._zoomInMonth(previousMonth);
						} else {
							_this._scrollPrevious(parentMonth,function(){
									previousMonth = $(parentMonth).prev();
									_this._zoomInMonth(previousMonth);
								});
						}	
					});	
			}	
		},
//------------------------------------------------------    
		_scrollNext: function(month,onComplete){		
			var _this = this;	
			_this._removeNextButton(month,REGULAR);
			// create holder for incoming new month
			var newId = _this._getNextDivName();
			var height = $(month).height();
			var width = $(month).width();
			var _ad = $(month).attr('data-nt-month');
			$(month)
				.after('<div id="'+ newId+'"></div>');
			// get new month	
			$.get(_this.options.proc,'_ajax_=1&_next_=' + _ad + '&_parentProc_=' + this.options.parent,function(data){
					// when new month arrives
					xmlProcess(data);
					$(_this.element).find('#' + newId).each(function(){_this._addMonth(this,REGULAR);});
					_this._addButtons(true,REGULAR);
					if (onComplete){
						onComplete();
					}	
				});
			$(_this.element).find('[data-nt-month]:first').empty().remove();
		},		
//------------------------------------------------------    
		_scrollPrevious: function(month,onComplete){		
			var _this = this;	
			_this._removePreviousButton(month,REGULAR);
			// create holder for incoming new month
			var newId = _this._getPreviousDivName();
			var height = $(month).height();
			var width = $(month).width();
			var _ad = $(month).attr('data-nt-month');
			$(month)
				.before('<div id="'+ newId+'" style="float:left"></div>');
			// get new month	
			$.get(_this.options.proc,'_ajax_=1&_prev_=' + _ad + '&_parentProc_=' + this.options.parent,function(data){
					// when new month arrives
					xmlProcess(data);
					$(_this.element).find('#' + newId).each(function(){;_this._addMonth(this,REGULAR);});
					_this._addButtons(true,REGULAR);
					if (onComplete){
						onComplete();
					}	
				});
			$(_this.element).find('[data-nt-month]:last').empty().remove();
		},		
//------------------------------------------------------    
		_getPreviousDivName: function(){		
			var d = $(this.element).find('[data-nt-month]:first').attr('id');
			var parts=d.split('_');
			if (parts[1]==1){
			  parts[2] = parseInt(parts[2]) - 1;
			  parts[1] = 12;
			} else {
				parts[1] = parseInt(parts[1]) - 1;
			}	
			d = parts.join('_');
			return(d);
		},
//------------------------------------------------------    		
		_getNextDivName: function(){
			var d = $(this.element).find('[data-nt-month]:last').attr('id');
			var parts=d.split('_');
			if (parts[1]==12){
			  parts[2] = parseInt(parts[2]) + 1;
			  parts[1] = 1;
			} else {
				parts[1] = parseInt(parts[1]) + 1;
			}	
			d = parts.join('_');
			return(d);
		},
//------------------------------------------------------      
		_applyGradients: function(month){
		  var _this=this;
			$(month).find('.cal-grad')
				.each(function(){
					var col = $(this).css('background-color');
					if (col != 'transparent'){
						if (Modernizr.cssgradients ==  false){
							if (window.ActiveXObject) {  //for IE
								var ua = navigator.userAgent;
								var re  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
								if (re.exec(ua) != null){
									this.style.filter = '"filter: progid:DXImageTransform.Microsoft.gradient(StartColorStr='+_this._colToIEHex(col)+', EndColorStr=#FFFFFFFF)"';
								}	
							}
						} else {
							$(this).css('background','-webkit-gradient(linear, 0 0, 0 100%, from('+col+'), to(#FFFFFF))'); 
							if ($(this).css('background') == ''){
								$(this).css('background','-moz-linear-gradient(center bottom, #FFFFFF 0%, '+col+' 75%)');
							}		
						}	
					}	
				});		
		},
//------------------------------------------------------    
		_colToIEHex: function(color) {
		  if (color.substr(0, 1) === '#') {
			return color;
		  }
		  var dig = /(.*?)rgb\((\d+), (\d+), (\d+)\)/.exec(color);    
		  var r = parseInt(dig[2]);
		  var g = parseInt(dig[3]);
		  var b = parseInt(dig[4]);    
		  var rgb = b | (g << 8) | (r << 16);    
		  return dig[1] + '#FF' + rgb.toString(16);
		},
//------------------------------------------------------    
	   destroy: function() {
		   $.Widget.prototype.destroy.apply(this, arguments); // default destroy
		   // now do other stuff particular to this widget
	   }
 });

$.extend( $.ui.ntcalendar, {
	version: "@VERSION"
});

})( jQuery );

//===============================================================================================================
//===============================================================================================================

(function( $, undefined ) {
// vars and equates here
//  var _timePerPixel=0;
//  var _changeClicked=0;

$.widget("ui.ntplanner", {
		// default options
		options: {
			id:'',
			proc: 'nothing',
			parent:'',
			divId: '',
			resizable: 1,
			dayWidth: 72,
			planWidth: 0,
			dayOuterWidth: 72,  
			height: 52,   
			padding: 3,
			startDay: 0,
			endDay: 86400,
			date: 0,
			columns: 7,
			changeText: 'Change',
			insertText: 'Insert',
			insertForm: '',      
			vertical: 0,
			gradients: true,
			showtimes: 1,     
			datesOnTop: 0,
			wsLive:0,             // live refresh via web sockets
			wsTables:[],          // array of table names to monitor
			_timePerPixel:0,    
			_changeClicked:0
		},
		state:{
			popLiveUpdate:false
		},
	//------------------------------------------------------
		_create: function() {
			this.refresh();
		},	
	//------------------------------------------------------
        _init: function() {
			if (this.options.wsLive){
				for (var i = 0; i < this.options.wsTables.length; i++) {
					if(this.options.wsTables[i]){
						nts.watch(this.options.id,"","table","",this.options.wsTables[i],this.liveUpdate,this)
					}	
				}	
			}  		
        },
	//------------------------------------------------------
	//   do not use "this" in this method, use "_this' instead.
        liveUpdate: function(json,_this) {			
			if (_this.state.popLiveUpdate==true){
				// some actions here will trigger a netRefresh on the server side, but we're already getting a set of refresh
				// data from the action itself. In which case the live update is suppressed.
				_this.state.popLiveUpdate=false
			} else {
				$.get(_this.options.proc,'_ajax_=1&_refresh_=current&_parentProc_=' + _this.options.parent,function(data){
						// when new data arrives
						xmlProcess(data);					
						_this.refresh()
					});				
			}	
        },		
	//------------------------------------------------------      
		hide: function(){
			$('#'+this.options.id).hide();
		},
	//------------------------------------------------------      
		show: function(){
			$('#'+this.options.id).show();
		},		
	//------------------------------------------------------
		addCanvas: function() {	   
			var i=(this.options.columns-1); 
			while(i>=0){
				$("[data-nt-row='data']").prepend('<canvas class="planner-back" width="'+(this.options.dayOuterWidth-2)+'" height="'+this.options.height+'" style="left:'+(i*this.options.dayOuterWidth)+'px;"></canvas>');
				i--;
			}  
		},
		//------------------------------------------------------    
		drawCanvasBackground: function() {	   		  
			if (this.options.showtimes == 1){
				var _this=this;
				var st=this.formatTime(this.options.startDay);
				var ed=this.formatTime(this.options.endDay);   	  	
				//$(".planner-back")
				var fc=$(".planner-back").eq(0).css('color');
				var fs=$(".planner-back").eq(0).css('font-size');
				$(".planner-back")
					.drawText({fillStyle:fc,strokeStyle:fc,x:5,y:26,text:st,align:"left",baseline:"middle",font:"normal "+fs+" Verdana, sans-serif"})
					.drawText({fillStyle:fc,strokeStyle:fc,x:this.options.dayWidth-5,y:26,text:ed,align:"right",baseline:"middle",font:"normal "+fs+" Verdana, sans-serif"});  		    
			}    
		},		
		//------------------------------------------------------    
		formatTime: function(t){
			var h = parseInt(t/360000);
			var m = parseInt(t%360000/6000);
			if (m<10) {
				return h + ':0' + m;
			} else {
				return h + ':' + m;
			}
		},
		//------------------------------------------------------   
		_resizable: function() {	
			// need to set max size, and also cope with browser window being resized smaller.
			var _this=this;
			if (this.options.resizable){
				$(this.element).find('#' + this.options.divId + '_resize_div').resizable({
					handles: "e", 
					alsoResize: '#'+ this.options.divId + '_columns_div',
					stop: function(event, ui) {SetSessionValue(_this.options.proc+':width',$(_this.element).find(".cal-scroll").width());}
				});
			} else {
				$('.cal-scroll').css('overflow-x','hidden');
			}
		},
		//------------------------------------------------------    
		_calcColumnWidths: function() {	
			var _this = this;		
			var _width=0;
			var _div;
			$(this.element).find('[data-nt-row="header"]').children().each(function(){
				$(this).width(_this.options.dayWidth);
				_this.options.dayOuterWidth = parseInt($(this).outerWidth(true));
			});
			_width=this.options.dayOuterWidth * this.options.columns;
			$('#'+this.options.divId+'_columns_div').children(':first').width(_width);	
			if (_this.options.vertical == 0){
				_this.options._timePerPixel = (this.options.columns*(this.options.endDay-this.options.startDay))/_width;
			} else if (_this.options.vertical == 86400){
				_this.options._timePerPixel = (this.options.endDay-this.options.startDay) / this.options.dayOuterWidth;
			} else {
				_this.options._timePerPixel = 100 * this.options.vertical / this.options.height;
			}			                                                       
		},
		//------------------------------------------------------    
		_prepareData: function() {	
			var _this = this;
			var dateStart=0;
			var dateEnd=0; 
			var viewDateStart=0;
			var viewDateEnd=0; 
			var timeStart=0;
			var timeEnd=0; 
			var dDraw=0;
			var dleft=0;
			var dright=0; 			
			var dheight=0;
			var dtop=0;
			var col=0;
			var dmarginTop=0;
			var dmarginBottom=0;
			var dmarginLeft=0;
			var dmarginRight=0;
			$(this.element).find("[data-nt-id]").each(function(){			  
				dDraw = 0;
				if (_this.options.vertical == 0){
					// plan with non-date/time as left column
					dDraw = 1;
					dleft = (($(this).attr('data-nt-start-date') - _this.options.date) * _this.options.dayOuterWidth) + 
							 (($(this).attr('data-nt-start-time') - _this.options.startDay) / _this.options._timePerPixel); 
					dright = (($(this).attr('data-nt-end-date') - _this.options.date) * _this.options.dayOuterWidth) + 
						   (($(this).attr('data-nt-end-time') - _this.options.startDay) / _this.options._timePerPixel); 		      
					dheight = _this.options.height -  _this.options.padding * 2 - 0;        
					dtop = _this.options.padding;
				} else if (_this.options.vertical == 86400){
					// plan with whole day as left column
					dDraw = 1;
					col = ($(this).attr('data-nt-column')-1);			    
					dleft = (col * _this.options.dayOuterWidth) +
							 (($(this).attr('data-nt-start-time') - _this.options.startDay) / _this.options._timePerPixel);			    
					dright = (col * _this.options.dayOuterWidth) + 
						   (($(this).attr('data-nt-end-time') - _this.options.startDay) / _this.options._timePerPixel); 		      
					if (dleft < col * _this.options.dayOuterWidth){
					  dleft = col * _this.options.dayOuterWidth;
					}
					if (dright > (col+1) * _this.options.dayOuterWidth){
						dright = (col+1) * _this.options.dayOuterWidth;
					}
					dheight = _this.options.height -  _this.options.padding * 2 - 0;
					dtop =  _this.options.padding;
				} else {                                     
				  // plan with varible time as the left column.
					dateStart = $(this).attr('data-nt-start-date');
					dateEnd = $(this).attr('data-nt-end-date');
					timeStart = $(this).attr('data-nt-start-time');
					timeEnd = $(this).attr('data-nt-end-time');
					viewDateStart = _this.options.date
					viewDateEnd = _this.options.date + _this.options.columns - 1
					
					if ((viewDateEnd < dateStart) || (viewDateStart > dateEnd)){
						dDraw = 0; // don't draw if viewable date is out of range
					} else if (dateStart == viewDateEnd && timeStart > _this.options.endDay){
						dDraw = 0; // don't draw if starts after viewable end
					} else if (dateEnd == viewDateStart && timeEnd < _this.options.startDay){
						dDraw = 0; // don't draw if ends before viewable start
					} else {
						dDraw = 1;						
						if ((dateStart == viewDateStart && timeStart < _this.options.startDay) || (dateStart < viewDateStart)){
							timeStart = _this.options.startDay;
						}
						if ((dateEnd == viewDateEnd && timeEnd > _this.options.endDay) || (dateEnd > viewDateEnd)){
							timeEnd = _this.options.endDay;
						}
						if (_this.options.datesOnTop){
							days = $(this).attr('data-nt-end-date')-$(this).attr('data-nt-start-date')+1;
						} else {
							days = 1;
						}
						dheight = (timeEnd-timeStart)/_this.options._timePerPixel; 
						col = ($(this).attr('data-nt-column')-1);
						dleft = (col*_this.options.dayOuterWidth)+5;
						dright = ((col+days)*_this.options.dayOuterWidth)-10;
						dtop = ((timeStart-_this.options.startDay)%(_this.options.vertical*100))/_this.options._timePerPixel;
						dmarginLeft = $(this).attr('data-nt-margin')
						dmarginRight = dmarginLeft;
					}
				}      
				if (dDraw){
					$(this)				
					.css('left',(dleft-(-dmarginLeft))+'px')
					.width(dright-dleft-0-dmarginLeft-dmarginRight)
					.css('top',dtop-(-dmarginTop)+'px')
					.css('height',dheight-dmarginTop-dmarginBottom+'px')
					.css('padding-left','0px') 
					.css('padding-right','0px')
					.removeClass('nt-hidden')
					.off('click.cal')
					.on('click.cal',function(e){
						_this.options._changeClicked = 1;
						_this.state.popLiveUpdate=true;
						ntd.push($(this).attr('data-nt-form'),'',_this.options.changeText,1,2,null,
						_this.options.proc,$(this).attr('data-nt-id'),'',0,'',$(this).parent().attr('data-nt-parent'),'','',_this.options.parent);
					})
				} else {
					$(this).addClass('nt-hidden');
				}
			});
		},
		//------------------------------------------------------    
		_bindInsert: function() {	
			var _this = this;
			$(this.element).find('[data-nt-row="data"]')
			.off('click.cal')
			.on('click.cal',function(e){
				if (_this.options._changeClicked == 0){
					if (_this.options.datesOnTop == 1){
						var _somedate =  _this.options.date + parseInt((e.pageX - $(this).offset().left) / _this.options.dayOuterWidth);
						if (_this.options.vertical == 0 || _this.options.vertical == 86400){
						  var _sometime = _this.options.startDay + parseInt(((e.pageX - $(this).offset().left) % _this.options.dayOuterWidth) * _this.options._timePerPixel);
						} else {
						  var po = $(this).parent().offset().top + $(this).parent().find(':first-child').height();
						  var _sometime = _this.options.startDay + parseInt((e.pageY-po) * _this.options._timePerPixel);
						}
					} else {
						var po = $(this).parent().offset().top + $(this).parent().find(':first-child').height();
						if (_this.options.vertical == 86400){  			
						var _somedate =  _this.options.date + parseInt((e.pageY-po) / $(this).height()) ;
						} else {
						var _somedate = _this.options.date;
						}
						if (_this.options.vertical == 0 || _this.options.vertical == 86400){  				  
						var _sometime = _this.options.startDay + parseInt(((e.pageX - $(this).offset().left) % _this.options.dayOuterWidth) * _this.options._timePerPixel);
						} else {    
						  var po = $(this).parent().offset().top + $(this).parent().find(':first-child').height();
						  var _sometime = _this.options.startDay + parseInt((e.pageY-po) * _this.options._timePerPixel);  				  
						}
					}
					if (_this.options.insertForm){
						_this.state.popLiveUpdate=true;
						ntd.push(_this.options.insertForm,'',_this.options.insertText,1,1,null,_this.options.proc,'','_date_='+ _somedate + '&_time_=' + _sometime + '&_bidv_=' + $(this).attr('data-nt-parent'),0,'',$(this).parent().attr('data-nt-parent'),'','',_this.options.parent);			
					}	
				} else {
					_this.options._changeClicked = 0;
				}	
			});
		},  

		
		//------------------------------------------------------    
		refresh: function() {	
			var _this=this;
			var i = $('.cal-scroll').width(); 		  
			if (this.options.planWidth){
				$('.cal-scroll').width(this.options.planWidth);
			} else {  
				if (i < this.options.dayWidth){
					$('.cal-scroll').width(20-(-this.options.dayWidth));
				}		  
			}    
			$('.planner-row-size').height(_this.options.height);
			this._calcColumnWidths();
			this._resizable();
			if (this.options.vertical >= 86400 || this.options.vertical==0){     			
				this.addCanvas();
				this.drawCanvasBackground();
			}  
			this._prepareData();
			this._bindInsert();      
		},		
		//------------------------------------------------------    
		destroy: function() {
			$.Widget.prototype.destroy.apply(this, arguments); // default destroy
			// now do other stuff particular to this widget
		}
 });

$.extend( $.ui.ntplanner, {
	version: "@VERSION"
});

})( jQuery );
	