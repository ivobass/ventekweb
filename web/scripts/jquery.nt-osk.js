///////////////////////////////////////////////////////
//   
// 	On Screen Keyboard
//  (c) 2014-2017 CapeSoft Software
//
///////////////////////////////////////////////////////

(function( $, undefined ) {

$.widget( "ui.ntosk", {
	options: {
		id:"",			// (empty) div id where the keyboard will go
		alphabet:[],	// a multi dimensioned array [keyboard, row, key] containing the text to display on the buttons
		css:[],			// a matching arracy with the css for each button
		action:[],		// a matching array with the action for each button. Blank means "text". 
						// Other options are caps, backspace, del, shift, space, enter and cycle (to cycle to the next keyboard.)
		wascss:[],
		rowIndent:[],
		autoHide:1,		// 1=on, 2=off. keyboard is hidden until focus is on an entry field.
		position: { my: "center", at: "center", of: window }, // position of the keyboard
		upper:1, 												
		lower:0,												// start keyboard as lower case
		toggle:false,
		width:800,	// the width of the keyboard.
		height:"auto",
		maxrows: 0,
		slideDirection: 'down',
		slideSpeed: 200,
		maxcols:[]	
	},
	state: {
		pos: 0,
		doHide:0,
		doUnfocus:0,
		mousedown:0,
		focus:""
	},
//------------------------------------------------------
	_init: function() {
		var _this=this;
		$('#'+this.options.id).css('overflow','hidden');
		$('#'+this.options.id).dialog({ 
			width: _this.options.width,
			height: _this.options.height,
			resizable:false, 
			closeOnEscape:false,
			title:"Keyboard",
			position: this.options.position,
			open: function(){ 
				_this.state.doHide = 0;
				_this.unFocus();
			}
		});
		$('#'+this.options.id).mousedown(function(){
			//console.log('OSK Mouse DOWN');
			_this.state.mousedown=1;
			_this.getFocus(); 
			$(_this.state.focus).attr('data-wait','true');
			_this.state.doHide = 0;
			_this.state.doUnfocus = 1; 
			setTimeout(function(){_this.unFocus()},10);  									
		});
		this.createKeyboard();
		if (this.options.lower){
			this.toggleCase();
		}
		if (this.options.autoHide){
			this.state.doHide=true;
			this.hide();
		}	
	},	
//------------------------------------------------------
	mdstatus: function(i) {
		if(i != undefined){
			this.state.mousedown=i;
		}	
		//console.log('OSK MDSTATUS this.state.mousedown=' + this.state.mousedown);
		return this.state.mousedown;
	},	
//------------------------------------------------------
	createKeyboard: function() {
		var _this=this;
		var kbd=0;
		var row=0;
		var key=0;
		$('#'+this.options.id).append('<div id="'+this.options.id+'_a" class="nt-kbd">');		
		for (kbd=0; kbd < this.options.alphabet.length ; kbd++){ // for each alphabet
		  if (this.options.alphabet[kbd].length > this.options.maxrows){
			this.options.maxrows = this.options.alphabet[kbd].length;
		  }
		  this.options.wascss.push([]);		  
		  for (row=0 ; row < this.options.alphabet[kbd].length; row++){ // for each row
			if (this.options.maxcols[row] == undefined){
				this.options.maxcols[row] = 0;
			}
			if ( this.options.alphabet[kbd][row].length > this.options.maxcols[row]){
				this.options.maxcols[row] = this.options.alphabet[kbd][row].length;
			}
			this.options.wascss[kbd].push([]);
			for (key=0 ; key < this.options.alphabet[kbd][row].length ; key++){
				if (this.options.action[kbd][row][key] == ''){
					this.options.action[kbd][row][key] = 'text';
				}
				this.options.wascss[kbd][row].push();
				this.options.wascss[kbd][row][key] = '';
			}
		  }
		}
		
		for(row=0; row < this.options.maxrows; row++){
			$('#'+this.options.id+'_a').append('<div id="'+this.options.id + '_' + row +'" class="nt-osk-x nt-osk-' + row + '"></div>');
			for(key=0; key < this.options.maxcols[row]; key++){
				$('#'+this.options.id + '_' + row).append('<div id="'+this.options.id + '_' + row + '_' + key + '" data-row="' + row + '" data-key="' + key + '">' + '</div>');
				$('#' + this.options.id + '_' + row + '_' + key).on('click',function(e){_this.clicked(e)})
			}
		}
		this.applyKeyboard(0);
		return this;
	},	
//------------------------------------------------------
	applyKeyboard: function(kbd) {		
		var row=0;
		var key=0;
		var _this=this;
		this.options.kbd = kbd;
		for (row=0 ; row < this.options.maxrows; row++){ // for each row
			if (row > this.options.alphabet[kbd].length){
				// hide row
				$('#'+this.options.id+'_' + row).hide();
			} else {
				$('#'+this.options.id+'_' + row).show();
				if (this.options.rowIndent[kbd][row]){
					$('#'+this.options.id + '_' + row).css("padding-left",this.options.rowIndent[kbd][row]);
				}
				for (key=0 ; key < this.options.maxcols[row] ; key++){
					if (key > this.options.alphabet[kbd][row].length){
						$('#' + this.options.id + '_' + row + '_' + key).hide();
					} else {
						$('#' + this.options.id + '_' + row + '_' + key)
							.html(this.options.alphabet[kbd][row][key])
							.attr('data-do',this.options.action[kbd][row][key])
							.removeClass(this.options.wascss[kbd][row][key])
							.addClass(this.options.css[kbd][row][key])
							.show();
							this.options.wascss[kbd][row][key] = this.options.css[kbd][row][key];
					}
				}
			}
		}
		$('#'+this.options.id).dialog({position: _this.options.position});		
		return this;
	},	
	
//------------------------------------------------------
	unFocus: function() {		
		if (this.state.doUnfocus){
			//console.log('OSK Unfocus calling SetFocus')
			this.setFocus(this.state.focus,this.state.pos)	
			this.state.doUnfocus = 0;
		}	
	},	
//------------------------------------------------------
	getFocus: function(elem) {
		if (elem){
			this.state.focus = elem;
		} else {	
			this.state.focus = document.activeElement;
		}			
		this.state.pos = this.getCursorPosition(this.state.focus);		
		//console.log('OSK GET FOCUS elem=' + $(this.state.focus).attr('id') + ' pos=' + this.state.pos)
		return this;
	},	
//------------------------------------------------------
	getCursorPosition: function(elem) { 
		if (!elem) {
			return 0;
		}	
        if ('selectionStart' in elem) {
            // Standard-compliant browsers
			try{ x = elem.selectionStart;}
			catch(e){x=0}
			return x;
        } else if (document.selection) {
            // IE
            $(elem).focus();
            var sel = document.selection.createRange();
            var selLen = document.selection.createRange().text.length;
            sel.moveStart('character', -elem.value.length);
            return sel.text.length - selLen;
        }	
	},	
//------------------------------------------------------
	setFocus: function(elem,pos) { 
		//console.log('OSK SetFocus - elem = ' + elem + ' pos = ' + pos);
		$(elem).attr('data-noFocus','true'); // prevents the event in nt-form from calling GetFocus.
		this.state.doUnfocus = 0;
		elem.value = elem.value;    // ^ this is used to not only get "focus", but to make sure we don't have it everything -selected- (it causes an issue in chrome, and having it doesn't hurt any other browser)
		if (elem !== null) {
			if (elem.createTextRange) {
				var range = elem.createTextRange();
				range.move('character', pos);
				range.select();
				return true;
			}
			else {
				try {
					x = elem.selectionStart;
				} catch(e){
					x = 0;
				}
				if (x || x === 0) {
					$(elem).focus();
					elem.setSelectionRange(pos,pos);
					return true;
				}
				else  { // fail city, fortunately this never happens (as far as I've tested) :)
					$(elem).focus();
					return false;
				}
			}
		}
	},	
//------------------------------------------------------
	clicked: function(e) {
		var restorefocus = true;
		var pos = this.getCursorPosition(this.state.focus);
		this.state.doHide = 0;
		this.state.doUnfocus = 0;
		//console.log('OSK CLICKED')		
		var elem = $(e.currentTarget).attr('id');
		var row = $('#'+elem).attr('data-row');
		var key = $('#'+elem).attr('data-key');
		$(this.state.focus).attr('data-wait','false');
		switch(this.options.action[this.options.kbd][row][key].toLowerCase()){
			case 'caps': 
				this.toggleCase();				
				break;
			case 'backspace': 
			case 'del': 
				pos = this.changeValue(this.state.focus,null,pos,this.options.action[this.options.kbd][row][key].toLowerCase());
				break;
			case 'shift': 
				this.toggleOne(true);
				break;
			case 'space': 
				pos = this.changeValue(this.state.focus,' ',pos);
				break;
			case 'enter': 				
				$(this.state.focus).trigger("sendchange");
				restorefocus = false;
				break;
			case 'cycle':
				this.cycleKeyboard();
				break;
			default:
				if ($(this.state.focus).attr('placeholder') == $(this.state.focus).val()){
					$(this.state.focus).val('');
				}
				s = $('#'+elem).html();
				if (this.options.toggle){				
					if (s === s.toLowerCase()){
						s = s.toUpperCase();
					} else {
						s = s.toLowerCase();
					}
				}
				pos = this.changeValue(this.state.focus,s,pos);			
				this.toggleOne(false);
		}			
		if (restorefocus){
			//console.log('OSK Clicked callng SetFocus')
			this.setFocus(this.state.focus,pos);
		}	
		return this;
	},	
//------------------------------------------------------
	cycleKeyboard: function(elem,sub,pos,action) {
		this.options.kbd += 1;		
		if (this.options.kbd == this.options.alphabet.length ){
			this.applyKeyboard(0);
		} else {
			this.applyKeyboard(this.options.kbd);
		}
		return this;
	
	},
//------------------------------------------------------
	changeValue: function(elem,sub,pos,action) {
		if (!elem) return pos;
		var s = $(elem).val();
		switch(action){
		case 'backspace':
			s = s.substring(0,pos-1) + s.substring(pos,s.length);
			pos -=1;
			break;
		case 'del':
			s = s.substring(0,pos) + s.substring(pos+1,s.length);
			break
		default:	
			s = s.substring(0,pos) + sub + s.substring(pos,s.length);
			pos += 1;
		}		
		$(elem).val(s);	
		$(this.state.focus).trigger("valuechanged");		
		return pos;
	},	
//------------------------------------------------------
	toggleOne: function(state) {
		this.options.toggle = state;
		if (state){
			$('#'+this.options.id).find('[data-do="shift"]').addClass('nt-osk-shift-invert');
		} else {
			$('#'+this.options.id).find('[data-do="shift"]').removeClass('nt-osk-shift-invert');
		}		
		return this;
	},	
//------------------------------------------------------
	toggleCase: function() {
		var s = "";
		if (this.options.upper){
			$('#'+this.options.id).find('[data-do="text"]').each(function(){
				s = $(this).html().toLowerCase()
				$(this).html(s);
			})
			this.options.upper = false;
		} else {
			$('#'+this.options.id).find('[data-do="text"]').each(function(){
				s = $(this).html().toUpperCase()
				$(this).html(s);
			})
			this.options.upper = true;
		}
	},	
//------------------------------------------------------
	show: function() {
		this.state.doHide = 0;
		if (this.options.isOpen==false){
			this.options.isOpen = true;
			$('#'+this.options.id).parent().show( 'slide', {direction: this.options.slideDirection}, this.options.slideSpeed)
		}
		return this;
	},	
//------------------------------------------------------
	startHide: function() {
		//console.log('OSK StartHide')		
		if (this.options.autoHide){
			var _this=this;
			this.state.doHide = 1;
			setTimeout(function(){_this.hide()},100);
		}	
		return this;
	},	
//------------------------------------------------------
	hide: function() {
		//console.log('OSK Hide this.state.doHide=' + this.state.doHide)
		if (this.state.doHide){
			$('#'+this.options.id).parent().hide('slide', {direction: this.options.slideDirection}, this.options.slideSpeed)
			this.options.isOpen = false;
		}	
	}	
//------------------------------------------------------
});

$.extend( $.ui.ntosk, {
	version: "@VERSION"
});

})( jQuery );
