///////////////////////////////////////////////////////
//   
// 	In-Browser Chat
//  (c) 2016 CapeSoft 
//
///////////////////////////////////////////////////////

(function( $, undefined ) {

$.widget( "ui.ntchat", {
	options: {
		id:"",
		chatId:"",
		user:"",
		divId:"",
		historyId:"",  // not passed in
		historyCss:"nt-chat-history",
		entryId:"",   // not passed in
		entryDivCss:"",
		entryCss:"nt-chat-entry nt-entry",		
		otherUserCss:"nt-chat-other-user",
		thisUserCss:"nt-chat-this-user",
		userNameCss:"nt-chat-username",
		url:"",
		urlExt:""
	},
	//------------------------------------------------------
	_init: function() {
		console.log('hello chat ' + this.options.id);	
		this.options.divId = '#' + this.options.id
		$(this.options.divId).append('<div id="'+this.options.id+'_history" class="'+this.options.historyCss+'"></div>');
		$(this.options.divId).append('<div id="'+this.options.id+'_entry_div" class="'+this.options.entryDivCss+'">' +
								'<div>Message</div>' +
								'<textarea id="' + this.options.id + '_entry" class="' + this.options.entryCss + '" data-do="chat" cols="30" rows="2"></textarea>' +
						   '</div>');
		this.options.historyId = this.options.divId + '_history';
		this.options.entryId = this.options.divId + '_entry';
		nts.watch("","channel","chat_"+this.options.chatId)
		this._bindEvents();
	},	
	//------------------------------------------------------
	_bindEvents: function(){
		var _this = this;
		$(this.options.entryId).off('blur.chat').on('blur.chat',function(e){console.log('x');return _this.sendMessage(this,e);})		
		$(this.options.entryId).off('keypress.chat').on('keypress.chat',function(e){return _this.onKeyPress(this,e);})
	},	
	//------------------------------------------------------
	setUserName: function(name) {
		console.log('SetUserName : ' + name)
		this.options.user = name;
	},	
	//------------------------------------------------------
	sendMessage: function(a,e) {
		var _this = this;
		var m=$(this.options.entryId).val()
		if (m){
			this.addMessage(this.options.user,this.options.user + ' ' + m,true);			
			$.get(this.options.url+this.options.urlExt,'chat='+ encodeURIComponent(m) + '&_event_=accepted&chatId=' + this.options.chatId + '&user=' + this.options.user,function(data){_this._onAjaxComplete(data);});
			$(this.options.entryId).val('');	
		}	
	},	
	//------------------------------------------------------
	onKeyPress: function(elem,e) {
		switch (e.which) {
			case 13:{ // enter
				this.sendMessage(elem,e);
				$(this.options.entryId).focus();
				return false
			}	
		}
	},		
	//------------------------------------------------------
	addMessage: function(user,text,me) {
		console.log('add message :' + user +  ' ' + text)
		if (user == this.options.user){
			if (me){
				$(this.options.historyId).append('<div class="' + this.options.thisUserCss + '">' + text + '</div><div class="nt-chat-clear"></div>')			
			}	
		} else {
			$(this.options.historyId).append('<div class="' + this.options.userNameCss + '">' + user + '</div><div class="' + this.options.otherUserCss + '">' + text + '</div><div class="nt-chat-clear"></div>')			
			Css = this.options.otherUserCss;		
		}		 		
		$(this.options.historyId).scrollTop($(this.options.historyId)[0].scrollHeight);
	},
	
	//------------------------------------------------------
	_onAjaxComplete: function(data) {
		xmlProcess(data);
		return this;
	}
	
//------------------------------------------------------

});

$.extend( $.ui.ntchat, {
	version: "@VERSION"
});

})( jQuery );

//===========================================================================================
//===========================================================================================
(function( $, undefined ) {

$.widget( "ui.ntmultichat", {
	options: {
		id:"",
		divId:"",
		chatCss:""
	},
	//------------------------------------------------------
	_init: function() {

	},
	//------------------------------------------------------
	newChat: function(chatId) {
		this.options.divId = '#' + this.options.id
		$(this.options.divId).append('<div id="'+this.options.id + '_' + chatId + '" class="'+this.options.chatCss+'"></div>');
		$("#"+ this.options.id + '_' + chatId).ntchat({chatId: chatId, id: this.options.id + '_' + chatId});
	}
	
//------------------------------------------------------

});

$.extend( $.ui.ntmultichat, {
	version: "@VERSION"
});

})( jQuery );
