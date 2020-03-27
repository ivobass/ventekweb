(function( $, undefined ) {

$.widget("ui.ntgauge", {
   // default options
        options: {
			id:'',
			wsLive:0,
			wsScope:"hostvalue",
			wsField:"bruce",			
			canvasId:'',
			textId:'',
			labelsId:'',
			value:0,
			maxValue: 100,
			minValue: 0,
			autoScale: 0,
			animationSpeed: 32,
			angle: -0.1, // The span of the gauge arc 0- hor, 0.5 top -0.5 bottom.
			lineWidth: 0.3, // The line thickness 0.7 is "full" 
			radiusScale: 0.8, // Relative radius
			limitMax: true,     // If false, max value increases automatically if value > maxValue
			limitMin: true,     // If true, the min value of the gauge will be fixed
			
			gradientType:0, // 0=radial, otherwise linear  // radial is from the middle, linear is from left to right.
			colorStart: 'white',   // gauge: shade of inside, "up to" value.	
			colorStop: '#3564a0',  // gauge: shade of outside color of gauge "up to" value
			strokeColor: '#F8F8F8',  // gauge: color of gauge "up to" max
			//shadowColor: '#F0F0F0', // donut only - border around strokeColor
			
			generateGradient: 1, // gauge only. If true, and percent colors set then gradients change between percent colors. Otherwise jumps color at percent changes.
			//percentColors: [[0.0, "#00FF00" ], [0.60, "#008800"], [0.75, "#880000"], [1.0, "#FF0000"]], // gauge only
			
			highDpiSupport: true,     // High resolution support						
			autoLabels:0,
			staticLabels: {
				font: "10px sans-serif",
				color: "#333333",
				labels: [],  // Print labels at these values
				fractionDigits: 0  // Optional: Numerical precision. 0=round off.
			},			
			pointer: {
				iconPath: '',  // Icon image source
				iconScale: 1,    // Size scaling factor
				iconAngle: 0.0,  // Rotation offset angle, degrees
				length: 0.5, // // Relative to gauge radius
				strokeWidth: 0.035, // The thickness
				color: '#000000' // Fill color
			},
			textPrefix:'',
			textSuffix:'',							  
			textPrefixClass:'',
			textNumberClass:'',
			textSuffixClass:'',							  			
			other:0
		},
		gauge:{},
		state: {
		},
		//------------------------------------------------------
		_create: function() {
			if(this.options.canvasId==''){
				this.options.canvasId = this.options.id + '-canvas'
			}
			if(this.options.textId==''){
				this.options.textId = this.options.id + '-text'
			}
			if(this.options.labelsId==''){
				this.options.labelsId = this.options.id + '-labels'
			}
			if (this.options.generateGradient){
				this.options.generateGradient = true; // library needs exact match.
			}	
			this.init();
		},
		//------------------------------------------------------
		init: function(){
			var c=0;
			var style = getComputedStyle($('#'+this.options.labelsId).get(0))			
			if (style){
				this.options.staticLabels.font = style.getPropertyValue('font-size') + ' ' + style.getPropertyValue('font-family')
				c = style.getPropertyValue('color')
				if (c){this.options.staticLabels.color = c}
			}	
			this.autoLabel()
			style = getComputedStyle($('#'+this.options.id + '-pointer').get(0))
			if (style){
				c = style.getPropertyValue('color')
				if (c){this.options.pointer.color = c}
			}			
			style = getComputedStyle($('#'+this.options.id + '-dial').get(0))
			if (style){
				c = style.getPropertyValue('color')
				if (c){this.options.colorStart = c}
				c = style.getPropertyValue('border-color')
				if (c){this.options.colorStop = c}				
				c = style.getPropertyValue('background-color')
				if (c){this.options.strokeColor = c}
			}			
			this.newGauge()
			if (this.options.wsLive){
			  nts.watch(this.options.id,"",this.options.wsScope,"",this.options.wsField,this.liveUpdate,this)
			}  
		},
		//------------------------------------------------------
		newGauge: function(){
			this.gauge = new Gauge($('#'+this.options.canvasId).get(0)).setOptions(this.options); 
			this.gauge.setTextField($('#'+this.options.textId).get(0))
			this.gauge.maxValue = this.options.maxValue; 
			this.gauge.setMinValue(this.options.minValue); 
			this.gauge.animationSpeed = this.options.animationSpeed; 
			this.gauge.set(this.options.value); // set actual value				
		},
		//------------------------------------------------------
		liveUpdate: function(json,_this){
			_this.setValue(json['value']);
		},
		//------------------------------------------------------
		setValue: function(value){
			this.options.value = value;
			if (this.options.autoScale && value > this.options.maxValue){
				this.bumpUp(value)
			}			
			this.gauge.set(value)
		},
		//------------------------------------------------------
		bumpUp: function(value) {
			if (this.options.maxValue < 10) {
			  this.options.maxValue = 10
			}  
			var p = Math.pow(10, Math.floor(Math.log10(value-1))); // nearest power of 10
			this.options.maxValue = (p+1) * 10
			this.gauge.maxValue = this.options.maxValue; 
			this.autoLabel();
			this.gauge.setOptions(this.options)
			// need to send new labels, and get it to redraw labbels...
		},
		//------------------------------------------------------
		autoLabel: function() {	
			if (this.options.autoLabels){
				var labs=[]
				if (this.options.angle > -0.45){
					if ($.isNumeric(this.options.minValue)){
						labs.push(this.options.minValue)
					}	
				} 
				var r = 0;
				var p = Math.pow(10, Math.floor(Math.log10(this.options.maxValue-1))) / 10; // nearest power of 10
				for(var i = 0; i < this.options.autoLabels ; i++){
					r = this.options.minValue + i * (this.options.maxValue / this.options.autoLabels)
					r = Math.round(r / p) * p
					if ($.isNumeric(r)){
						labs.push(r)
					}	
				}
				if (this.options.angle > -0.45){
					if ($.isNumeric(this.options.maxValue)){
						labs.push(this.options.maxValue)
					}	
				} 
				this.options.staticLabels.labels = labs				
			}
		},
		//------------------------------------------------------
		ready: function() {
		
		},
 		//------------------------------------------------------
		destroy: function() {
			$.Widget.prototype.destroy.apply(this, arguments); // default destroy
			// now do other stuff particular to this widget
		}
 });

$.extend( $.ui.gauge, {
        version: "@VERSION"
});

})( jQuery );
		
