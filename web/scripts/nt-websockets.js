
  // message format
  // [command]|[scope]|[name]|[value]
  // [commands]
  // watch nowatch set get add list call
  
  // examples
  // watch sessionvalue user
  // nowatch sessionvalue user
  // set sessionvalue user frank
  // watch channel chat
  // nowatch channel chat
  // add channel chat "hello world"
  // call someproc parm1 parm2 ...
  
  // [scope]
  // sessionvalue hostvalue channel table

// -------------------------------------------------------------------
function ntSockets(){
this.url=new Array();
this.connection=new Array();
this.onmessagelist=new Array();
this.onopenlist=new Array();
this.watching=false;
this.watchingList=new Array();
}

// -------------------------------------------------------------------
ntSockets.prototype._buildURL = function (url){
	var arr = url.split('//');
	switch (arr[0].toLowerCase()){
	case "ws:":
	case "wss:":
		return (url);
	case "http:":
		url.replace('http:','ws:')
		return (url);
	case "https:":
		url.replace('https:','wss:')
		return (url);
	default:
		if (window.location.protocol=='https:'){
			protocol='wss:';
		} else {
			protocol='ws:';
		}
		url = protocol + '//' + location.hostname.toLowerCase() + (location.port ? ':'+location.port: '') + '/' + url;
	}	
	return(url)
}
// -------------------------------------------------------------------
ntSockets.prototype.open = function (url, onopen, onmessage){
	var found=false;
	var j=0;
	var i=0	
	var _this=this;
	
	url = this._buildURL(url);
	
	for(i=0 ; i < this.url.length ; i++){
		if  (this.url[i] == url){
			//console.log('existing url ' + url + ' i=' + i)
			found = true;
			this.onopenlist[i].push(onopen);
			j = this.onopenlist[i].length - 1

			if (this.connection[i].readyState==1){  //1==OPEN; CLOSING=2; CLOSED=3; CONNECTING=0
				_this.onopen(0,i,j);			
			}	
			this.onmessagelist[i].push(onmessage);
			break;
		}
	}
	if (!found){
		//console.log('new url ' + url);
		this.url.push(url);
		this.onopenlist.push(new Array());
		this.onmessagelist.push(new Array());
		this.connection.push( new WebSocket(url, ['json']));

		i = this.url.length - 1;
		this.onopenlist[i].push(onopen);		
		this.onmessagelist[i].push(onmessage);
		j = this.onopenlist[i].length - 1;
		
		
		this.connection[i].onopen = function (event) {
			//console.log('on open not found ' + i + ' ' + j)
			_this.onopen(event,i,j);	
		}
		this.connection[i].onmessage = function (event) {
			_this.onmessage(event,i);
		}
		this.connection[i].onerror = function (event) {
			_this.onerror(event,i);
		}
		this.connection[i].onclose = function (event) {
			_this.onclose(event,i);
		}
	}	
	return i;
};
// -------------------------------------------------------------------
ntSockets.prototype.onopen = function(event,i,j){

	if (j){
		this.onopenlist[i][j](i);
	} else {	
		for(j=0; j < this.onopenlist[i].length ; j++){
			this.onopenlist[i][j](i);		
		}
	}
};
// -------------------------------------------------------------------
ntSockets.prototype.onmessage = function(event,i){
	var obj = JSON.parse(event.data);
	for(var j=0; j < this.onmessagelist[i].length ; j++){
		this.onmessagelist[i][j](event,obj,i)
	}
};
// -------------------------------------------------------------------
ntSockets.prototype.onerror = function(event,i){
	//console.log('ntSockets.onerror state=' + this.connection[i].readyState)
};
// -------------------------------------------------------------------
ntSockets.prototype.onclose = function(event,i){
	//console.log('ntSockets.onclose')
};
// -------------------------------------------------------------------
ntSockets.prototype.sendText = function(i,text){
	//console.log('Sending Connection ' + i + ' text=' + text);
	this.connection[i].send(text);
};
// -------------------------------------------------------------------
ntSockets.prototype.inWatchingList = function(maybeWatch) {
	var exists = false;
	for (var i=0 ; i < this.watchingList.length ; i++){
		exists=true;
		for(var prop in maybeWatch) {
			if(maybeWatch[prop] !== this.watchingList[i][prop]) {
				exists = false;
				break;
			}
		}
		if (exists){
			break
		}
	}	
	return exists;
};
// -------------------------------------------------------------------
ntSockets.prototype.watch = function(wid,url,scope,id,varname,callback,that){
	var thisWatch={
			wid:wid,
			url:url,
			scope:scope,
			id:id,
			varname:varname
		}
	if (this.inWatchingList(thisWatch)==true){
		return
	}
	this.watchingList.push(thisWatch);

	var _this=this;
	if (varname == undefined){
		varname = id;
	}
	varname = varname.toLowerCase()
	this.open(url, 
		function(i){ // on open
			_this.sendText(i,'watch ' + scope + ' ' + varname);	
		},
		function(event,json,i){ // on message
			if (callback){				
				if ((json['name']==varname) && (json['scope'] == scope)){
					callback(json,that);
				}	
			} else {
				if (json['scope'] == scope){
					if (json['name'] == varname){
						switch ($(id).prop('tagName')){
						case "INPUT":	
							$(id).val(json['value']);
							break;
						default:
							$(id).html(json['value']);
						}
					}
				}
			}	
		}
	)
}
// -------------------------------------------------------------------
var nts = new ntSockets();

//////////////////////////////////////////////////////////////////////////////////////////////
// testing
//	var watchRandom = nts.watch('', 'hostvalue', '#random');
//	var watchCounter = nts.watch('', 'hostvalue', '#counter');


