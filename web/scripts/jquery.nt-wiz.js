///////////////////////////////////////////////////////
//   
//   jQuery Plugin to turn form into wizard.
//   Part of NetTalk by CapeSoft 
//   (c) 2010 
//
///////////////////////////////////////////////////////

// first a small plugin to get, or set, the maximum height of a collection of elements.
(function( $ ){
  $.fn.maxHeight = function(h) {
		if (arguments.length > 0){
			this.each(function() {
				$(this).height(h);
			});
			return this;
		} else {
			var max = 0;
			this.each(function() {
				max = Math.max( max, $(this).height() );
			});
			return max;
		}	
  };
})( jQuery );

///////////////////////////////////////////////////////
// now the main ntwiz plugin.
///////////////////////////////////////////////////////

(function( $, undefined ) {

$.widget( "ui.ntwiz", {
	options: {
		procedure: '',
		validateOnNext: 0,
		active: 0,
		maxTab: 0,
		wizTabs: [],
		minHeight: 0,    
		popup: 0,
		saveOk: 0,
		hidePreviousButton: 0,
		disablePreviousButton: 0,
		ntform: '',
		hidden: []
	},

//------------------------------------------------------
	_create: function() {           
	  var _this = this;
		this.element.addClass( "ui-widget ui-widget-content ui-corner-all" );
		if (this.options.validateOnNext == 0){	
			$('[name="wiznext_btn"]').unbind('click.wiz').bind('click.wiz',function(e){
					_this.next();
				});
		} else {
			$('[name="wiznext_btn"]').unbind('click.wiz').bind('click.wiz',function(e){
					_this.tryNext();
				});
		}		
		$('[name="wizprevious_btn"]').unbind('click.wiz').bind('click.wiz',function(e){
			_this.previous();
			});
		this.options.wizTabs = this.element.find('> div');
		this.options.maxTab=this.options.wizTabs.length-1;
		
		var wizHeight = this.element.find('> div').maxHeight();
		if (this.options.minHeight > wizHeight){
		  wizHeight = this.options.minHeight;
		}
		// set them all to be the same height.
		this.element.find('> div').maxHeight(wizHeight).hide();

	},

//------------------------------------------------------
	_init: function() {
		this.active(this.active());
	},	

//------------------------------------------------------
	destroy: function() {
		this.element.removeClass( "ui-widget ui-widget-content ui-corner-all" );
		$.Widget.prototype.destroy.apply( this, arguments );
	},

//------------------------------------------------------
// shortcut to // .option("active", //
	active: function( newValue ) { 
		if ( newValue === undefined ) {
			return this.options.active;
		}
		this._setOption( "active", newValue );
		return this;
	},

//------------------------------------------------------
	_setOption: function( key, value ) {
		switch (key){
		case "active":
			$(this.options.wizTabs[this.options.active]).hide();
			this.options.active = value;                        
			$(this.options.wizTabs[this.options.active]).show();
			this.setButtons();
			$(this.options.wizTabs[this.options.active]).find(':input:enabled:visible:first').focus();
			break;
		case "maxTab":	
			this.options.maxTab = value;
			break;
		case "hideTab":
			this.options.hidden[value] = 1;
			break;
		case "unhideTab":
			this.options.hidden[value] = 0;
			break;
		case "saveOk":		
		  this.options.saveOk = value;  
		  this.setButtons();
		  break;
		} 
		$.Widget.prototype._setOption.apply( this, arguments );
	},

//------------------------------------------------------
  setButtons: function(){
		if (this.options.hidePreviousButton){
			$('[name="wizprevious_btn"]').hide();
		} else {
			if (this.active() == 0 || this.options.disablePreviousButton){  
				$('[name="wizprevious_btn"]').button( "option", "disabled", true ).removeClass('ui-state-focus ui-state-hover');
			} else {
				$('[name="wizprevious_btn"]').button( "option", "disabled", false ).removeClass('ui-state-focus ui-state-hover');
			}
		}
		if (this.active() == this.options.maxTab) {
			$('[name="wiznext_btn"]').button( "option", "disabled", true ).removeClass('ui-state-focus ui-state-hover');
		} else {
			$('[name="wiznext_btn"]').button( "option", "disabled", false ).removeClass('ui-state-focus ui-state-hover');		
		}
		if (this.options.saveOk != -1 && (this.active() == this.options.maxTab || this.options.saveOk == 1)){
			if (this.options.ntform){
				$(this.options.ntform).ntform('enableSave','wiz');
			} else {
				try{
					$('[name="save_btn"]').button( "option", "disabled", false ).removeClass('ui-state-focus ui-state-hover');
				} catch(e) {
					$('[name="save_btn"]').removeClass('ui-state-focus ui-state-hover');
				}
			}
		}  else {          			
			if (this.options.ntform){
				$(this.options.ntform).ntform('disableSave','wiz');
			} else {
				try{
					$('[name="save_btn"]').button( "option", "disabled", true ).removeClass('ui-state-focus ui-state-hover');
				} catch(e) {
					$('[name="save_btn"]').removeClass('ui-state-focus ui-state-hover');
				}
			}
		} 
		return this;
  },
//------------------------------------------------------  
	tryNext: function() {  
		var parms = '_ajax_=1&_popup_=' + this.options.popup;
		var _this=this;

		$.get(this.options.procedure + '_nexttab_' + this.options.active,parms,function(data){_this._onAjaxComplete(data);});
	},
//------------------------------------------------------  
	tabChanged: function (){
		var parms = '_ajax_=1&_popup_=' + this.options.popup + '&_tab_=' + this.options.active;
		var _this=this;
		$.get(this.options.procedure+'_tabchanged',parms,function(data){_this._onAjaxComplete(data);});
	},

//------------------------------------------------------  
	_onAjaxComplete: function(data) {
		xmlProcess(data);

		if (this.options.ntform){
			$(this.options.ntform).ntform('ready');
		}	
		return this;

	},
//------------------------------------------------------  
	next: function() {  
		for(var n = this.active()+1; n <= this.options.maxTab; n++){
			if (this.options.hidden[n] != 1){
				this.active(n);
				this.tabChanged();
				break;
			} 
		}
	},
//------------------------------------------------------   
	previous: function() {
		if (this.options.hidePreviousButton || this.options.disablePreviousButton){
			return this;
		}
		for(var n = this.active()-1; n >= 0; n--){
			if (this.options.hidden[n] != 1){
				this.active(n);
				this.tabChanged();
				break;
			} 
		}
		return this;
  },
//------------------------------------------------------   
	hideNext: function() {  
		$('[name="wiznext_btn"]').hide();	
	},
//------------------------------------------------------   
	showNext: function() {  
		$('[name="wiznext_btn"]').show();	
	},
//------------------------------------------------------   
	hidePrevious: function() {  
		$('[name="wizprevious_btn"]').hide();
	},
//------------------------------------------------------   
	showPrevious: function() {  
		$('[name="wizprevious_btn"]').show();
	}
//------------------------------------------------------
});

$.extend( $.ui.ntwiz, {
	version: "@VERSION"
});

})( jQuery );

///////////////////////////////////////////////////////
// end ntwiz
///////////////////////////////////////////////////////
