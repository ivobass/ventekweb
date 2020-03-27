///////////////////////////////////////////////////////
//   
//   jQuery UI Plugin for getUserMedia API
//   Part of NetTalk by CapeSoft 
//   (c) 2014 
//
///////////////////////////////////////////////////////

(function( $, undefined ) {

$.widget( "ui.ntcam", {
	options: {
		id: '',					// contains div name 
		procedure:'',			// the form procedure. Used to upload the image to.
		takeShotButtonId:'',	// button ID - takes a picture when clicked.
		imageId:'',				// <img> element to receive photo when snapshot is taken.
		video:true,
		audio:false,
		autoUpload:true,		//auto upload shots when taken
		width:120,
        height:0,
        streaming:false,
		videoElement: null,
		htracker: null,
		snapshot: document.createElement('canvas')
	},
    snapshots: [],

    stream: null,

//------------------------------------------------------
	_create: function() {      
	navigator.getUserMedia = (navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mediaDevices.getUserMedia || navigator.msGetUserMedia || false);
		
		window.AudioContext = (window.AudioContext || window.webkitAudioContext);
		window.URL = (window.URL ||	window.webkitURL);	
	},

//------------------------------------------------------
	_init: function() {
		this.bindEvents();
		this.start();		
	},	
//------------------------------------------------------
	bindEvents: function() {
		var _this=this;
		if (this.options.takeShotButtonId){
			$('#' + this.options.takeShotButtonId).on('click',function(e){_this.takeSnapshot(e)});
		}
		return this;		
	},	
//------------------------------------------------------
	setButton: function(id,action) {
		var _this=this;
		switch(action){		
			case 1:  //Take Pic   
				$('#' + id).on('click',function(e){_this.takeSnapshot(e)});
				break;		
			case 2:  //Upload Pic   
				$('#' + id).on('click',function(e){_this.uploadSnapshot(_this.options.snapshot)});
				break;		
		}	
		
	},
//------------------------------------------------------
	getStreamUrl: function() {
		if (window.URL && window.URL.createObjectURL) {
			return window.URL.createObjectURL(this.options.stream);
		} else {
			return this.options.stream;
		}		
	},	
//------------------------------------------------------
	createVideo: function() {
		var _this=this;
		if (! this.options.videoElement){
			this.options.videoElement = document.createElement('video');
			$('#' + _this.options.id).append(_this.options.videoElement);
			$(this.options.videoElement).css('height',$('#' + _this.options.id).css('height'));
		}	
		
		this.options.videoElement.addEventListener('canplay', function() {
		  if (!_this.options.streaming) {
			_this.options.height = _this.options.videoElement.videoHeight / (_this.options.videoElement.videoWidth / _this.options.width);
			_this.options.videoElement.style.width = _this.options.width;
			_this.options.videoElement.style.height = _this.options.height;
			_this.options.streaming = true;
		  }
		});
		return this;
	},	
//------------------------------------------------------
/*	createHeadTracker: function() {
		var _this=this;
		this.options.htracker = new headtrackr.Tracker();
		this.options.htracker.init(this.options.videoElement, this.options.snapshot);
		this.options.htracker.start();	
		document.addEventListener("facetrackingEvent", function( event ) {
				// once we have stable tracking, draw rectangle
				console.log('event.detection=' + event.detection + ' event.x=' + event.x + ' event.y=' + event.y + ' event.width=' + event.width + ' event.height=' + event.height);
/*				if (event.detection == "CS") {
					overlayContext.translate(event.x, event.y)
					overlayContext.rotate(event.angle-(Math.PI/2));
					overlayContext.strokeStyle = "#00CC00";
					overlayContext.strokeRect((-(event.width/2)) >> 0, (-(event.height/2)) >> 0, event.width, event.height);
					overlayContext.rotate((Math.PI/2)-event.angle);
					overlayContext.translate(-event.x, -event.y);
				} * /
			});		
	},	  */
//------------------------------------------------------
	linkAudio: function() {
		this.audioCtx = new window.AudioContext();
		this.audioStream = this.audioCtx.createMediaStreamSource(this.options.stream);

		var biquadFilter = this.audioCtx.createBiquadFilter();

		this.audioStream.connect(biquadFilter);
		biquadFilter.connect(this.audioCtx.destination);
		return this;
	},	
//------------------------------------------------------	
	takeSnapshot: function() {
		
		var	ctx = this.options.snapshot.getContext('2d');

		this.options.snapshot.width  = this.options.videoElement.videoWidth;
		this.options.snapshot.height = this.options.videoElement.videoHeight;

		ctx.drawImage(this.options.videoElement, 0, 0, this.options.videoElement.videoWidth, this.options.videoElement.videoHeight);

		this.snapshots.push(this.options.snapshot);
		this.showSnapshot(this.options.snapshot);
		if (this.options.autoUpload){
			this.uploadSnapshot(this.options.snapshot);
		}	
		ctx = null;
		return this;
	},	
//------------------------------------------------------	
	showSnapshot: function(snapshot) {
		$("#" + this.options.imageId).attr('src',snapshot.toDataURL('image/png'));
		return this;
	},	
//------------------------------------------------------	
	uploadSnapshot: function(snapshot) {
		$.post(this.options.procedure + '_' + this.options.id + '_value','_event_=accepted&ajax=1&_name_=' + this.options.id + '&_image_=' + snapshot.toDataURL('image/png'));
		return this;
	},		
//------------------------------------------------------
	error: function(err) {
		this.options.error = err;
	},	
//------------------------------------------------------	
	start: function() {
		if (! navigator.getUserMedia) {
		  this.error('USERMEDIA_NOT_SUPPORTED');
		  return false;
		}
		var _this=this;
		var result = navigator.getUserMedia(
			{ 
				video: _this.options.video, 
				audio: _this.options.audio 
			},
			function (stream) {
				_this.options.stream = stream;
				_this.createVideo();
				//_this.createHeadTracker();

				if (navigator.mozGetUserMedia) {
					_this.options.videoElement.mozSrcObject = stream;
				} else {
					_this.options.videoElement.src = _this.getStreamUrl();
				}

				if (_this.options.audio == true) {
					try {
						_this.linkAudio();
					} catch(e) {
						_this.error('AUDIO_NOT_SUPPORTED');
					}
				}

				//$('#' + _this.options.id).append(_this.options.videoElement);
				_this.options.videoElement.play();
			},
			function (err) {
				_this.error(err);
			}
		);	
		return this;
	},	
//------------------------------------------------------
	stop: function() {
		this.options.stream.stop();
		if (window.URL && window.URL.revokeObjectURL) {
		  window.URL.revokeObjectURL(_this.options.videoElement.src);
		}
		return this;
	}	
//------------------------------------------------------
});

$.extend( $.ui.ntcam, {
	version: "@VERSION"
});

})( jQuery );
