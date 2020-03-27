///////////////////////////////////////////////////////
//   
// 	Get some data from an external web server, and push it into an attribute of an element on this page.
//  By default the alternate input comes from http://127.0.0.1:80/GetData
//
///////////////////////////////////////////////////////

(function( $, undefined ) {

$.widget( "ui.ntexternal", {
	options: {
		id:"",				// the id of the widget
		ssl:0, 				// this widget should make an SSL connection to the other server
		host: "127.0.0.1", 	// the host name of the other server
		port:80,			// the port number of the other procedure
		url:"GetData", 		// the page (proceudre) of the other procedure
		parms:"", 			// any parameters to send as part of the call
		destId:"", 				// the id of the element to receive the value
		autostart:0, 		// start polling the other server immediately when this widget is created
		timer:1000, 		// the poll time for polling the other server
		polling:0,			// if 1 then polling is active. (Use start and stop methods to change this value.)
		attr:"value"		// the attribute of the element to place the result into
	},
//------------------------------------------------------
	_init: function() {
		if (this.options.autostart){
			this.start();
		}	
	},	
//------------------------------------------------------
	start: function(destId,attr) {
		if (destId){
			this.switchTo(destId,attr);
		}	
		if (this.options.polling == 0){
			this.options.polling = 1;
			this.poll(true);
		}	
		return this;
	},	
//------------------------------------------------------
	switchTo: function(destId,attr) {
		this.options.destId = destId;
		if (attr){
			this.options.attr=attr;
		}
		return this;
	},	
//------------------------------------------------------
	stop: function() {
		this.options.polling = 0;
		return this;
	},	
//------------------------------------------------------
	_onAjaxComplete: function(d) {
		if (d){
			$("#"+this.options.destId).attr(this.options.attr,d);		
			if (this.options.attr){
				$("#"+this.options.destId).change();
			}
		}	
	},	
//------------------------------------------------------
	poll: function(auto) {
		if (auto && this.options.polling == 0){
			return this;
		}
		this.getData();
		if (this.options.polling && auto && this.options.timer > 0){
			setTimeout('$("#'+this.options.id+'").ntexternal("poll",true);',this.options.timer);
		}	
		return this;
	},	
//------------------------------------------------------  	
	getData: function() {
		var _this=this;
		var protocol = 'http://';
		if (this.options.ssl){
			protocol = 'https://';
			if (this.options.port==80){
				this.options.port=443;
			}
		}	
		$.get(protocol + this.options.host+":"+this.options.port+"/"+this.options.url,
			"_ajax_=1&" + this.options.parms,
			function(d){_this._onAjaxComplete(d);});	
		return this;	
	}
//------------------------------------------------------
});

$.extend( $.ui.ntexternal, {
	version: "@VERSION"
});

})( jQuery );
