/**
 *
 * Color picker
 * Original Author: Stefan Petre www.eyecon.ro
 * Modified, and extended, for use with NetTalk
 * 
 * Dual licensed under the MIT and GPL licenses
 * 
 */
jQuery.extend(jQuery.expr[':'], {
    focus: function(element) { 
        return element == document.activeElement; 
    }
});
 
(function ($) {
	var ColorPicker = function () {
		var
			ids = {},
			inAction,
			charMin = 65,
			visible,
			tpl = '<div class="ui-widget ui-widget-content ui-corner-all colorpicker">' +
			          '<div class="ui-widget-header ui-corner-all colorpicker_header">Select Color</div>' +
			          '<div class="colorpicker_color">' +
			            '<div>' +
			              '<div>' +
			              '</div>' +
			            '</div>' +
			          '</div>' +
			          '<div class="colorpicker_hue">' +
			            '<div>' +
			            '</div>' +
			          '</div>' +
			          '<div class="colorpicker_new_color">' +
			          '</div>' +
			          '<div class="colorpicker_current_color">' +
			          '</div>' +
			          '<div>' +
			            '<div class="colorpicker_hex colorpicker_field">' +
			              '<div class="colorpicker_prompt colorpicker_hex_prompt">Hex #</div>' +
			              '<input type="text" maxlength="6" style="width:5em" />' +
			            '</div>' +
			          '</div>' +  
			          '<div class="colorpicker_rgb">' + 
			            '<div class="colorpicker_rgb_r colorpicker_field">' +
			              '<div class="colorpicker_prompt">Red</div>' +
			              '<input type="number" maxlength="3" min="0" max="255" style="width:3em" />' +
			              '<spaner></spaner>' +
			            '</div>' +
			            '<div class="colorpicker_rgb_g colorpicker_field">' +
			              '<div class="colorpicker_prompt">Green</div>' +
			              '<input type="number" maxlength="3" min="0" max="255" style="width:3em" />' +
			              '<spaner></spaner>' +
			            '</div>' +
			            '<div class="colorpicker_rgb_b colorpicker_field">' +
			              '<div class="colorpicker_prompt">Blue</div>' +
			              '<input type="number" maxlength="3" min="0" max="255" style="width:3em" />' +
			              '<spaner></spaner>' +
			            '</div>' +
			          '</div>' +  
			          '<div class="colorpicker_hsb">' + 
			            '<div class="colorpicker_hsb_h colorpicker_field">' +
			              '<div class="colorpicker_prompt">Hue</div>' +
			              '<input type="number" maxlength="3" min="0" max="360" style="width:3em" />' +
			              '<spaner></spaner>' +
			            '</div>' +
			            '<div class="colorpicker_hsb_s colorpicker_field">' +
			              '<div class="colorpicker_prompt">Sat</div>' +
			              '<input type="number" maxlength="3" min="0" max="100" style="width:3em" />' +
			              '<spaner></spaner>' +
			            '</div>' +
			            '<div class="colorpicker_hsb_b colorpicker_field">' +
			              '<div class="colorpicker_prompt">Bright</div>' +
			              '<input type="number" maxlength="3" min="0" max="100" style="width:3em" />' +
			              '<spaner></spaner>' +
			            '</div>' +
			          '</div>' +  
			          '<div class="colorpicker_submit">' +
									'<button type="button" class="ui-button ui-widget ui-state-default ui-button-text-only ui-button-text ui-corner-all" role="button" aria-disabled="false">' +
										'<span class="ui-button-text">OK</span>' +
									'</button>' +
			          '</div>' +
			          '<div class="colorpicker_cancel">' +
									'<button id="cpcb" type="button" class="ui-button ui-widget ui-state-default ui-button-text-only ui-button-text ui-corner-all" role="button" aria-disabled="false">' +
										'<span class="ui-button-text">Cancel</span>' +
									'</button>' +
			          '</div>' +
			      '</div>',
			defaults = {
				eventName: 'click',
				onShow: function () {},
				onBeforeShow: function(){},
				onHide: function () {},
				onChange: function () {},
				onSubmit: function () {},
				showIcon: true,
				showField: true,
				color: 'ff0000',
				livePreview: true,
				liveField: '',
				liveScope: 'color',
				liveGradients: true,
				dataField: '',
				closeOnSubmit: true,
				
				flat: false
			},
			fillRGBFields = function  (hsb, cal) {
				var rgb = HSBToRGB(hsb);
				$(cal).data('colorpicker').fields
					.eq(1).val(rgb.r).end()
					.eq(2).val(rgb.g).end()
					.eq(3).val(rgb.b).end();
			},
			fillHSBFields = function  (hsb, cal) {
				$(cal).data('colorpicker').fields
					.eq(4).val(hsb.h).end()
					.eq(5).val(hsb.s).end()
					.eq(6).val(hsb.b).end();
			},
			fillHexFields = function (hsb, cal) {
				$(cal).data('colorpicker').fields
					.eq(0).val(HSBToHex(hsb)).end();
			},
			setSelector = function (hsb, cal) {
				$(cal).data('colorpicker').selector.css('backgroundColor', '#' + HSBToHex({h: hsb.h, s: 100, b: 100}));
				$(cal).data('colorpicker').selectorIndic.css({
					left: parseInt(150 * hsb.s/100, 10),
					top: parseInt(150 * (100-hsb.b)/100, 10)
				});
			},
			setHue = function (hsb, cal) {
				$(cal).data('colorpicker').hue.css('top', parseInt(150 - 150 * hsb.h/360, 10));
			},
			setCurrentColor = function (hsb, cal) {
				$(cal).data('colorpicker').currentColor.css('backgroundColor', '#' + HSBToHex(hsb));
			},
			setNewColor = function (hsb, cal) {
				$(cal).data('colorpicker').newColor.css('backgroundColor', '#' + HSBToHex(hsb));
			},
			keyDown = function (ev) {
				var pressedKey = ev.charCode || ev.keyCode || -1;
        var v = parseInt($("input:focus").val());
        var min = parseInt($("input:focus").attr("min"));
        var max = parseInt($("input:focus").attr("max"));
        if (v == 'Nan'){
					v = 0;
        }
				switch(pressedKey){
					case 36: // home
						v = min;
						$("input:focus").val(v);
						break;

					case 107: // grey +
					case 38: // up arrow
						v = v + 1;
						if (v > max){v = max;}
						$("input:focus").val(v);
						break;
					case 33: // page up	
						v = v + 10;
						if (v > max){v = max;}
						$("input:focus").val(v);
						break;
					case 109: // grey -
					case 40: // down arrow
						v = v - 1;
						if (v < min){	v = min;}
						$("input:focus").val(v);
						break;
					case 34: // page down
						v = v - 10;
						if (v < min){	v = min;}
						$("input:focus").val(v);
						break;
					case 35: // end
						v = max;
						$("input:focus").val(v);
						break;
						
					default:
						if ((pressedKey > charMin && pressedKey <= 90) || pressedKey == 32) {
							return false;
						}
				}	
				var cal = $(this).parent().parent().parent();
				if (cal.data('colorpicker').livePreview === true) {
					change.apply(this);
				}
			},
			change = function (ev) {
				if (this.parentNode==undefined){
					return;
				}			
				var cal = $(this).parent().parent().parent(), col;
				if (this.parentNode.className.indexOf('_hex') > 0) {
					cal.data('colorpicker').color = col = HexToHSB(fixHex(this.value));
				} else if (this.parentNode.className.indexOf('_hsb') > 0) {
					cal.data('colorpicker').color = col = fixHSB({
						h: parseInt(cal.data('colorpicker').fields.eq(4).val(), 10),
						s: parseInt(cal.data('colorpicker').fields.eq(5).val(), 10),
						b: parseInt(cal.data('colorpicker').fields.eq(6).val(), 10)
					});
				} else {
					cal.data('colorpicker').color = col = RGBToHSB(fixRGB({
						r: parseInt(cal.data('colorpicker').fields.eq(1).val(), 10),
						g: parseInt(cal.data('colorpicker').fields.eq(2).val(), 10),
						b: parseInt(cal.data('colorpicker').fields.eq(3).val(), 10)
					}));
				}
				if (ev) {
					fillRGBFields(col, cal.get(0));
					fillHexFields(col, cal.get(0));
					fillHSBFields(col, cal.get(0));
				}
				setSelector(col, cal.get(0));
				setHue(col, cal.get(0));
				setNewColor(col, cal.get(0));
				if (cal.data('colorpicker').liveField != ''){
					$(cal.data('colorpicker').liveField).css(cal.data('colorpicker').liveScope,'#' + HSBToHex(col));
					if (cal.data('colorpicker').liveScope == 'background-color'){
						applyGradients(cal);
					}	
				};
				cal.data('colorpicker').onChange.apply(cal, [col, HSBToHex(col), HSBToRGB(col)]);
			},
			blur = function (ev) {
				var cal = $(this).parent().parent().parent();
				//cal.data('colorpicker').fields.parent().removeClass('colorpicker_focus');
			},
			focus = function () {
				charMin = this.parentNode.className.indexOf('_hex') > 0 ? 70 : 65;
				//$(this).parent().parent().parent().data('colorpicker').fields.parent().removeClass('colorpicker_focus');
				//$(this).parent().addClass('colorpicker_focus');
			},
			downIncrement = function (ev) {
				var field = $(this).parent().find('input').focus();
				var current = {
					el: $(this).parent().addClass('colorpicker_slider'),
					max: this.parentNode.className.indexOf('_hsb_h') > 0 ? 360 : (this.parentNode.className.indexOf('_hsb') > 0 ? 100 : 255),
					y: ev.pageY,
					field: field,
					val: parseInt(field.val(), 10),
					preview: $(this).parent().parent().parent().data('colorpicker').livePreview					
				};
				$(document).bind('mouseup', current, upIncrement);
				$(document).bind('mousemove', current, moveIncrement);
			},
			moveIncrement = function (ev) {
				ev.data.field.val(Math.max(0, Math.min(ev.data.max, parseInt(ev.data.val + ev.pageY - ev.data.y, 10))));
				if (ev.data.preview) {
					change.apply(ev.data.field.get(0), [true]);
				}
				return false;
			},
			upIncrement = function (ev) {
				change.apply(ev.data.field.get(0), [true]);
				ev.data.el.removeClass('colorpicker_slider').find('input').focus();
				$(document).unbind('mouseup', upIncrement);
				$(document).unbind('mousemove', moveIncrement);
				return false;
			},
			downHue = function (ev) {
				var current = {
					cal: $(this).parent(),
					y: $(this).offset().top
				};
				current.preview = current.cal.data('colorpicker').livePreview;
				$(document).bind('mouseup', current, upHue);
				$(document).bind('mousemove', current, moveHue);
			},
			moveHue = function (ev) {
				change.apply(
					ev.data.cal.data('colorpicker')
						.fields
						.eq(4)
						.val(parseInt(360*(150 - Math.max(0,Math.min(150,(ev.pageY - ev.data.y))))/150, 10))
						.get(0),
					[ev.data.preview]
				);
				return false;
			},
			upHue = function (ev) {
				fillRGBFields(ev.data.cal.data('colorpicker').color, ev.data.cal.get(0));
				fillHexFields(ev.data.cal.data('colorpicker').color, ev.data.cal.get(0));
				$(document).unbind('mouseup', upHue);
				$(document).unbind('mousemove', moveHue);
				return false;
			},
			downSelector = function (ev) {
				var current = {
					cal: $(this).parent(),
					pos: $(this).offset()
				};
				current.preview = current.cal.data('colorpicker').livePreview;
				$(document).bind('mouseup', current, upSelector);
				$(document).bind('mousemove', current, moveSelector);
			},
			moveSelector = function (ev) {
				change.apply(
					ev.data.cal.data('colorpicker')
						.fields
						.eq(6)
						.val(parseInt(100*(150 - Math.max(0,Math.min(150,(ev.pageY - ev.data.pos.top))))/150, 10))
						.end()
						.eq(5)
						.val(parseInt(100*(Math.max(0,Math.min(150,(ev.pageX - ev.data.pos.left))))/150, 10))
						.get(0),
					[ev.data.preview]
				);
				return false;
			},
			upSelector = function (ev) {
				fillRGBFields(ev.data.cal.data('colorpicker').color, ev.data.cal.get(0));
				fillHexFields(ev.data.cal.data('colorpicker').color, ev.data.cal.get(0));
				$(document).unbind('mouseup', upSelector);
				$(document).unbind('mousemove', moveSelector);
				return false;
			},
			enterButton = function (ev) {
				$(this).find('button').addClass('ui-state-focus');
			},
			leaveButton = function (ev) {
				$(this).find('button').removeClass('ui-state-focus');
			},
			clickSubmit = function (ev) {
				var cal = $(this).parent();
				var col = cal.data('colorpicker').color;
				cal.data('colorpicker').origColor = col;
				setCurrentColor(col, cal.get(0));
				$(cal.data('colorpicker').dataField).val('#' + HSBToHex(col));
				cal.data('colorpicker').onSubmit(col, HSBToHex(col), HSBToRGB(col), cal.data('colorpicker').el);
				if (cal.data('colorpicker').closeOnSubmit == true){
					//$(cal.data('colorpicker').el).ColorPickerHide();
					hide(ev);
				}
				$(cal.data('colorpicker').dataField).change()
			},
			clickCancel = function (ev) {
				hide(ev);
			},
			show = function (ev) {
				var cal = $('#' + $(this).data('colorpickerId'));
				//if (cal.data('colorpicker').dataField != ''){
					$(this).ColorPickerSetColor($(cal.data('colorpicker').dataField).val());
				//}

				cal.data('colorpicker').onBeforeShow.apply(this, [cal.get(0)]);
				var pos = $(this).offset();
				var viewPort = getViewport();
				var top = pos.top + this.offsetHeight;
				var left = pos.left;
				if (top + 176 > viewPort.t + viewPort.h) {
					top -= this.offsetHeight + 176;
				}
				if (left + 356 > viewPort.l + viewPort.w) {
					left -= 356;
				}
				cal.css({left: left + 'px', top: top + 'px'});
				if (cal.data('colorpicker').onShow.apply(this, [cal.get(0)]) != false) {
					cal.show();
				}
				$(document).bind('mousedown', {cal: cal}, maybehide);
				return false;
			},
			maybehide = function (ev) {
				if (!isChildOf(ev.data.cal.get(0), ev.target, ev.data.cal.get(0))) {
					hide(ev);
				}
			},
			hide = function(ev){
					if (ev.data.cal.data('colorpicker').onHide.apply(this, [ev.data.cal.get(0)]) != false) {
						ev.data.cal.hide();
						if (ev.data.cal.data('colorpicker').liveField != ''){
							$(ev.data.cal.data('colorpicker').liveField).css(ev.data.cal.data('colorpicker').liveScope,'#' + HSBToHex(ev.data.cal.data('colorpicker').origColor) );
							if (ev.data.cal.data('colorpicker').liveScope == 'background-color'){
								applyGradients(ev.data.cal);
							}	
						};
					}
					$(document).unbind('mousedown', maybehide);			
			},
			isChildOf = function(parentEl, el, container) {
				if (parentEl == el) {
					return true;
				}
				if (parentEl.contains) {
					return parentEl.contains(el);
				}
				if ( parentEl.compareDocumentPosition ) {
					return !!(parentEl.compareDocumentPosition(el) & 16);
				}
				var prEl = el.parentNode;
				while(prEl && prEl != container) {
					if (prEl == parentEl)
						return true;
					prEl = prEl.parentNode;
				}
				return false;
			},
			getViewport = function () {
				var m = document.compatMode == 'CSS1Compat';
				return {
					l : window.pageXOffset || (m ? document.documentElement.scrollLeft : document.body.scrollLeft),
					t : window.pageYOffset || (m ? document.documentElement.scrollTop : document.body.scrollTop),
					w : window.innerWidth || (m ? document.documentElement.clientWidth : document.body.clientWidth),
					h : window.innerHeight || (m ? document.documentElement.clientHeight : document.body.clientHeight)
				};
			},
			fixHSB = function (hsb) {
				return {
					h: Math.min(360, Math.max(0, hsb.h)),
					s: Math.min(100, Math.max(0, hsb.s)),
					b: Math.min(100, Math.max(0, hsb.b))
				};
			}, 
			fixRGB = function (rgb) {
				return {
					r: Math.min(255, Math.max(0, rgb.r)),
					g: Math.min(255, Math.max(0, rgb.g)),
					b: Math.min(255, Math.max(0, rgb.b))
				};
			},
			fixHex = function (hex) {
				var len = 6 - hex.length;
				if (len > 0) {
					var o = [];
					for (var i=0; i<len; i++) {
						o.push('0');
					}
					o.push(hex);
					hex = o.join('');
				}
				return hex;
			}, 
			HexToRGB = function (hex) {
				var hex = parseInt(((hex.indexOf('#') > -1) ? hex.substring(1) : hex), 16);
				return {r: hex >> 16, g: (hex & 0x00FF00) >> 8, b: (hex & 0x0000FF)};
			},
			HexToHSB = function (hex) {
				return RGBToHSB(HexToRGB(hex));
			},
			RGBToHSB = function (rgb) {
				var hsb = {
					h: 0,
					s: 0,
					b: 0
				};
				var min = Math.min(rgb.r, rgb.g, rgb.b);
				var max = Math.max(rgb.r, rgb.g, rgb.b);
				var delta = max - min;
				hsb.b = max;
				if (max != 0) {
					
				}
				hsb.s = max != 0 ? 255 * delta / max : 0;
				if (hsb.s != 0) {
					if (rgb.r == max) {
						hsb.h = (rgb.g - rgb.b) / delta;
					} else if (rgb.g == max) {
						hsb.h = 2 + (rgb.b - rgb.r) / delta;
					} else {
						hsb.h = 4 + (rgb.r - rgb.g) / delta;
					}
				} else {
					hsb.h = -1;
				}
				hsb.h *= 60;
				if (hsb.h < 0) {
					hsb.h += 360;
				}
				hsb.s *= 100/255;
				hsb.b *= 100/255;
				return hsb;
			},
			HSBToRGB = function (hsb) {
				var rgb = {};
				var h = Math.round(hsb.h);
				var s = Math.round(hsb.s*255/100);
				var v = Math.round(hsb.b*255/100);
				if(s == 0) {
					rgb.r = rgb.g = rgb.b = v;
				} else {
					var t1 = v;
					var t2 = (255-s)*v/255;
					var t3 = (t1-t2)*(h%60)/60;
					if(h==360) h = 0;
					if(h<60) {rgb.r=t1;	rgb.b=t2; rgb.g=t2+t3}
					else if(h<120) {rgb.g=t1; rgb.b=t2;	rgb.r=t1-t3}
					else if(h<180) {rgb.g=t1; rgb.r=t2;	rgb.b=t2+t3}
					else if(h<240) {rgb.b=t1; rgb.r=t2;	rgb.g=t1-t3}
					else if(h<300) {rgb.b=t1; rgb.g=t2;	rgb.r=t2+t3}
					else if(h<360) {rgb.r=t1; rgb.g=t2;	rgb.b=t1-t3}
					else {rgb.r=0; rgb.g=0;	rgb.b=0}
				}
				return {r:Math.round(rgb.r), g:Math.round(rgb.g), b:Math.round(rgb.b)};
			},
			// bj start bruce
			RGBStringToHex = function (rgbString){
				var parts = rgbString.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/); // parts now should be ["rgb(0, 70, 255", "0", "70", "255"]
				delete (parts[0]);
				for (var i = 1; i <= 3; ++i) {
					parts[i] = parseInt(parts[i]).toString(16);
					if (parts[i].length == 1) parts[i] = '0' + parts[i];
				}
				return('#' + parts.join('')); // "0070ff"
			}, // bj end bruce
			RGBToHex = function (rgb) {
				var hex = [
					rgb.r.toString(16),
					rgb.g.toString(16),
					rgb.b.toString(16)
				];
				$.each(hex, function (nr, val) {
					if (val.length == 1) {
						hex[nr] = '0' + val;
					}
				});
				return hex.join('');
			},
			HSBToHex = function (hsb) {
				return RGBToHex(HSBToRGB(hsb));
			},
			applyGradients = function(cal){
				if (cal.data('colorpicker').liveGradients == true){
					var col = $(cal.data('colorpicker').liveField).css('background-color');
					if (col != 'transparent'){
						if (Modernizr.cssgradients ==  false){
							if (window.ActiveXObject) {  //for IE
								$(cal.data('colorpicker').liveField).each(function(){
									this.style.filter = '"filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='+col+', endColorstr=#FFFFFFFF)"';
								});	
							}
						} else {
							$(cal.data('colorpicker').liveField).css('background','-webkit-gradient(linear, 0 0, 0 100%, from('+col+'), to(#FFFFFF))'); 
							if ($(cal.data('colorpicker').liveField).css('background') == ''){
								$(cal.data('colorpicker').liveField).css('background','-moz-linear-gradient(center bottom, #FFFFFF 0%, '+col+' 75%)');
							}	
						}	
					}	
				}	
			},
			restoreOriginal = function () {
				var cal = $(this).parent();
				var col = cal.data('colorpicker').origColor;
				cal.data('colorpicker').color = col;
				fillRGBFields(col, cal.get(0));
				fillHexFields(col, cal.get(0));
				fillHSBFields(col, cal.get(0));
				setSelector(col, cal.get(0));
				setHue(col, cal.get(0));
				setNewColor(col, cal.get(0));
				if (cal.data('colorpicker').liveField != ''){
					$(cal.data('colorpicker').liveField).css(cal.data('colorpicker').liveScope,'#' + HSBToHex(col));
					if (cal.data('colorpicker').liveScope == 'background-color'){
						applyGradients(cal);
					}	
				};
			};
		return {
			init: function (opt) {
				opt = $.extend({}, defaults, opt||{});
				if (typeof opt.color == 'string') {
					opt.color = HexToHSB(opt.color);
				} else if (opt.color.r != undefined && opt.color.g != undefined && opt.color.b != undefined) {
					opt.color = RGBToHSB(opt.color);
				} else if (opt.color.h != undefined && opt.color.s != undefined && opt.color.b != undefined) {
					opt.color = fixHSB(opt.color);
				} else {
					return this;
				}
				
				return this.each(function () {
					if (!$(this).data('colorpickerId')) {
						var options = $.extend({}, opt);
						options.origColor = opt.color;
						var id = 'colorpicker_' + parseInt(Math.random() * 1000);
						$(this).data('colorpickerId', id);
						var cal = $(tpl).attr('id', id);
						if (options.flat) {
							cal.appendTo(this).show();
						} else {
							cal.appendTo(document.body);
						}
						options.dataField = '#' + $(this).attr("id");
						if (opt.showIcon == true){
							var _this = '#' + $(this).attr("id");
							$(this).after('<img  class="colorpicker_lookup" src="/styles/images/colorpicker_lookup.png"/>');
							$(this).next('img').bind('click', function(){ $(_this).trigger('click');});
//							$(this).after('<div class="colorpicker_lookup"></div>');
//							$(this).next('div').bind('click', function(){ $(_this).trigger('click');});
//							$(this).next('div').position({my: "right top", at: "right top", of: _this})
						} 
						if (opt.showField == false) {
							$(this).addClass('nt-hidden');
						}
						
						options.fields = cal
											.find('input')
												.bind('keyup', keyDown)
												.bind('change', change)
												.bind('blur', blur)
												.bind('focus', focus);
						cal
							.find('span').bind('mousedown', downIncrement).end()
							.find('>div.colorpicker_current_color').bind('click', restoreOriginal);
						options.selector = cal.find('div.colorpicker_color').bind('mousedown', downSelector);
						options.selectorIndic = options.selector.find('div div');
						options.el = this;
						options.hue = cal.find('div.colorpicker_hue div');
						cal.find('div.colorpicker_hue').bind('mousedown', downHue);
						options.newColor = cal.find('div.colorpicker_new_color');
						options.currentColor = cal.find('div.colorpicker_current_color');
						cal.data('colorpicker', options);
						cal.find('div.colorpicker_submit')
							.bind('mouseenter', enterButton)
							.bind('mouseleave', leaveButton)
							.bind('click', {cal: cal}, clickSubmit);
						cal.find('div.colorpicker_cancel')
							.bind('mouseenter', enterButton)
							.bind('mouseleave', leaveButton)
							.bind('click', {cal: cal}, clickCancel);							
						fillRGBFields(options.color, cal.get(0));
						fillHSBFields(options.color, cal.get(0));
						fillHexFields(options.color, cal.get(0));
						setHue(options.color, cal.get(0));
						setSelector(options.color, cal.get(0));
						setCurrentColor(options.color, cal.get(0));
						setNewColor(options.color, cal.get(0));
						if (options.flat) {
							cal.css({
								position: 'relative',
								display: 'block'
							});
						} else {
							$(this).bind(options.eventName, show);
						}
					}
				});
			},
			showPicker: function() {
				return this.each( function () {
					if ($(this).data('colorpickerId')) {
						show.apply(this);
					}
				});
			},
			hidePicker: function() {
				return this.each( function () {
					if ($(this).data('colorpickerId')) {
						$('#' + $(this).data('colorpickerId')).hide(); // jQuery method, not local method.
					}
				});
			},
			setColor: function(col) {
				if (typeof col == 'string') {
				  // bj start bruce
				  if (col.substr(0,3) == 'rgb'){
						col = RGBStringToHex(col);
					}
					// bj end bruce 
					col = HexToHSB(col);
				} else if (col.r != undefined && col.g != undefined && col.b != undefined) {
					col = RGBToHSB(col);
				} else if (col.h != undefined && col.s != undefined && col.b != undefined) {
					col = fixHSB(col);
				} else {
					return this;
				}
				return this.each(function(){
					if ($(this).data('colorpickerId')) {
						var cal = $('#' + $(this).data('colorpickerId'));
						cal.data('colorpicker').color = col;
						cal.data('colorpicker').origColor = col;
						fillRGBFields(col, cal.get(0));
						fillHSBFields(col, cal.get(0));
						fillHexFields(col, cal.get(0));
						setHue(col, cal.get(0));
						setSelector(col, cal.get(0));
						setCurrentColor(col, cal.get(0));
						setNewColor(col, cal.get(0));
					}
				});
			}
		};
	}();
	$.fn.extend({
		ColorPicker: ColorPicker.init,
		ColorPickerHide: ColorPicker.hidePicker,
		ColorPickerShow: ColorPicker.showPicker,
		ColorPickerSetColor: ColorPicker.setColor
	});
})(jQuery);
