;var NetTalkVersion=11.05
// ---------------------------------------------

var cnt=0;
var tcnt=0;
var fcnt='';
var icnt='';
var ntMultiTab=false;

function initTabID(){
	ntMultiTab=true;
	var newId=false;
	var ce=false;
	if (!sessionStorage.id || localStorage.newIdRequired == 1){
		localStorage.newIdRequired = 0;
		sessionStorage.id = Math.random().toString(36).substr(5);		
		newId = true;
	} else {
		if (document.cookie.indexOf('x-TabID=') < 0){
			newId = true;
		}	
	}

	// for ajax calls no cookie is used - rather the x-TabID header is set to the current session storage ID.
	$.ajaxSetup({
		headers: { 'x-TabID': sessionStorage.id }
	});	
	
	if (newId){
		if (localStorage.fromTabId){
			$.get('NewTabID'+ntdExt,'_ajax_=1&x-FromTabID=' + localStorage.fromTabId,function(data){xmlProcess(data);});	
		} else {
			$.get('NewTabID'+ntdExt,'_ajax_=1',function(data){xmlProcess(data);});			
		}	
	}	
	
	// can't change headers for a non-ajax request. 
	// these cookies are "fleeting" so clear them away.
	document.cookie = 'x-TabID=; expires=Thu, 01-Jan-70 00:00:01 GMT;';	
	document.cookie = 'x-FromTabID=; expires=Thu, 01-Jan-70 00:00:01 GMT;';	
	localStorage.fromTabId = '';
	
	// mouse could be left, right or middle... so set FromTabId preemptivly.
	$('a').mousedown(function (event) { 
		localStorage.fromTabId = sessionStorage.id;
	}); 
	// a Ctrl-Click, or right-click/new tab or whatever does NOT go through this code. which is why FromTabID is set on MouseDown
	$('a').click(function (event) {		
		if (event.metaKey || event.ctrlKey || $(this).attr('target') == '_blank'){ 	// going to a new tab
		} else {  																	// normal click, so want TabID Cookie
			document.cookie = 'x-TabID=' + sessionStorage.id + ';';
		}		
	});  
	initTabIDButtons();
};

function initTabIDButtons(){	
	// setting on button click appears to be too late, so set on button down.
	$('button').mousedown(function (event) {initTabIDWorker();});  
	$('input[type="submit"]').mousedown(function (event) {initTabIDWorker();});  
	$('input[type="button"]').mousedown(function (event) {initTabIDWorker();});  
	$('input[type="image"]').mousedown(function (event) {initTabIDWorker();});  
	$('input[type="reset"]').mousedown(function (event) {initTabIDWorker();});  
	// pressing enter on button, when the button has the focus
	$('button').keydown(function(event){initTabIDWorker();});
	$('input[type="submit"]').keydown(function(event){initTabIDWorker();});
	$('input[type="button"]').keydown(function(event){initTabIDWorker();});
	$('input[type="image"]').keydown(function(event){initTabIDWorker();});
	$('input[type="reset"]').keydown(function(event){initTabIDWorker();});
};

function initTabIDWorker(){
	var t= $(this).attr('target');
	var oc = $(this).attr('onclick');
	if (oc){
		oc = oc.indexOf("'_blank'");
	} else {
		oc = -1;
	}
	if (t == '_blank' || oc >= 0){
		localStorage.fromTabId = sessionStorage.id;
		localStorage.newIdRequired = 1;
	} else {
		document.cookie = 'x-TabID=' + sessionStorage.id + ';';
	}		
}
function countDown(){
  hh = parseInt( cnt / 3600 );
  mm = parseInt( cnt / 60 ) % 60;
  ss = cnt % 60;
    var t = hh + ":" + (mm < 10 ? "0" + mm : mm) + ":" + (ss < 10 ? "0" + ss : ss);
  jQuery('#' + icnt).html(t);
  cnt -= 1;
  if (cnt ==0){
    window.open(fcnt,'_top');
  } else {
        setTimeout("countDown();",1000);
  }
};

function resetCountDown(){
  cnt = tcnt;
}

function startCountDown(t,f,i){
  if (t){
        tcnt = t;
    }
    if (f){
        fcnt = f;
    }
    if (i){
        icnt = i;
    }
    cnt = tcnt;
  countDown();
};

function versionCheck(v){
  var s = v + '';
  s = s.replace('.','');
  v = Number(v);
  if (v != NetTalkVersion){
    $('#_ver' + s).html('UPDATE OF WEB FOLDER REQUIRED - Try pressing Ctrl-F5. Server is on version ' + v + ' but web folder is on version ' +  NetTalkVersion);
	//window.location.reload(true);  // what happens if the server folder has not been updated though?
  } else {
        $('#_ver' + s).hide();
    }
}

function showInfo(m,t,d){
  if (!d){
    d = 'alert_div';
  }
  $('#'+d).html(m).hide().fadeIn(1000);
  if (t){
    setTimeout("hideInfo('"+d+"');",t);
  }
}
    
function hideInfo(d){    
  if (!d){
    d = 'alert_div';
  }
  $('#'+d).show().fadeOut(1000,function(){$('#'+d).html('')});
}  

function getScreenSize(force){
	if (force==true || sessionStorage._ScreenWidth_ != $(window).width() || sessionStorage._ScreenHeight_ != $(window).height()){
		sessionStorage._ScreenWidth_ = $(window).width();
		sessionStorage._ScreenHeight_ = $(window).height();
		$.get('SetSessionValue'+ntdExt,'_ScreenWidth_=' + $(window).width() + '&_ScreenHeight_=' + $(window).height() + '&_ajax_=1',function(data){xmlProcess(data);});
	}	
}

// ---------------------------------------------
// functions to handle busy graphic
var busyCounter=0;
$(document).ready(function() {
	busyCounter = 0;
	$("#_busy").hide(); 
	$(document).on("ajaxSend",function(event){
		$("#_busy").css('left',event.pageX).css('right',event.pageY);
		$("#_busy").show();
		busyCounter += 1;
		if (window.attachEvent && !window.addEventListener) { // detects IE8 and below
			$('input:radio, input:checkbox').unbind('click.iefix');
		};
	});
	$(document).on("ajaxComplete",function(){;
		if (busyCounter){busyCounter -= 1;}
		if (busyCounter ==0){ $("#_busy").hide(); };
		if (window.attachEvent && !window.addEventListener) { // detects IE8 and below
			$('input:radio, input:checkbox').on('click.iefix',function () {
				this.blur();
				this.focus();
			});
		}
	});
});
// ---------------------------------------------
function ntConfirm(m,t,b1,b2,f,p1,p2,p3){
	if (mobilemode){
		f(p1,p2,p3);
		return;
	}
	setTimeout(function(){
        var a = jQuery(":focus").attr('id');
		$("#message_alert").remove();
        if (t){
			$('body').append('<div id="message_alert" title="' + t + '">' + m + '</div>');
		} else {	
			$('body').append('<div id="message_alert" title="Alert">' + m + '</div>');
		}	
		$("#message_alert").dialog({
			resizable: false,
			modal: true,
			buttons: [	{			
				text: b1,
				click: function() {
					$(this).dialog("close");
					$("#message_alert").remove();
					f(p1,p2,p3);
				} }, {
				text: b2,
				click: function() {
					$(this).dialog("close");
					$("#message_alert").remove();					
				} } 				
			],
			open: function() {
				 $(this).parent().find('button:nth-child(1)').focus(); 
			},
			close: function() {
				 $('#' + a).focus();  
			}
		});		
    }, 1);
};
// ---------------------------------------------
function ntAlert(m,t,timer){
  setTimeout(function() {
        var a = jQuery(":focus").attr('id');
		$("#message_alert").remove();
        if (t){
			$('body').append('<div id="message_alert" title="' + t + '">' + m + '</div>');
		} else {	
			$('body').append('<div id="message_alert" title="Alert">' + m + '</div>');
		}	
		$("#message_alert").dialog({
			resizable: false,
			modal: true,
			buttons: {
				Ok: function() {
					$(this).dialog("close");
					$("#message_alert").remove();
				}
			},
			open: function() {
				 $(this).parent().find('button:nth-child(1)').focus(); 
			},
			close: function() {
				 $('#' + a).focus();  
			}
		});
		if (timer){
			setTimeout(function() { $("#message_alert").dialog("close"); }, timer);
		}
    }, 1);
}
// ---------------------------------------------
var hadfocus='';
var setfocus='';
function afterSv(){
  GreenAll();
  applyHTML5();
}

var tables = [];
function GreenAll(){
  for(var e = 0; e < tables.length; e++){
     tables[e].table=document.getElementById(tables[e].tid); // necessary after ajax call
     if (tables[e].table != null){
       tables[e].parseCell();
       tables[e].applyGreenBar();
     }
     tables[e].makeResizable();
     tables[e].prepColumns();
     tables[e].bind();
     //tables[e].restoreFocus();
  }
}
// -----------------------------------------------------------------------------------
// AutoTab support
// If an entry field has data-nt-autotab=1", then when the maxlength is reached focus
// automatically moves to the next field.
// -----------------------------------------------------------------------------------
jQuery.fn.focusNextInputField = function() { // this function from http://jqueryminute.com/, thanks to jdSharp.
    return this.each(function() {
        var fields = $(this).parents('form:eq(0),body').find('button,input,textarea,select').not('[readonly]');
        var index = fields.index( this );
        if ( index > -1 && ( index + 1 ) < fields.length ) {
            fields.eq( index + 1 ).focus();
        }
        return false;
    });
};

jQuery(document).ready( function(){
    jQuery("body").on("[data-nt-autotab=1]","keyup",function(e) {
        if ($(this).val().length == $(this).attr("maxlength")){
            if((e.which >= 32) && (e.which <= 122)){
                jQuery(':focus').focusNextInputField();
            }
        }
    });
});


// recursive function to find the first checkbox which is "inside" c.
function getCheckbox(c){
 if (c.type == 'checkbox'){
  return c;
 }
 if (c.firstChild != null){
  a = getCheckbox(c.firstChild);
  if (a != null){
  return a;
  }
 }
 while (c.nextSibling != null){
  a = getCheckbox(c.nextSibling);
  if (a != null){
   return a;
  }
 }
 return null;
}

function dsb(event,f,b,n,prid,prv){
 var i=0;
 if (n=='deleteb_btn'){
  if(confirm('Are you sure you want to delete this record?')==false){
   return false;
  }
 }
 // dont send files if form is cancelled.
 if (n=='cancel_btn'){
                jQuery(':file').remove();
 }
 // set all buttons disabled, if target of button is same frame.
 if (f.target == "" || f.target == "_self"){
         jQuery(':button').attr('disabled', 'disabled');
 }
 for (var e=0 ; e < f.elements.length; e++) {
   if (f.elements[e].name == prid){
    f.elements[e].value = prv;
    i = 1;
   }
 }
 var bid = document.createElement('INPUT');
 bid.type = 'hidden';
 bid.name = '_buttontext_';
 bid.value = $(event.target).closest("button").val();
 f.appendChild(bid);

 jQuery("#_webkit_").val(Math.random());
 if ((i==0) && (prid != '')){
  var rid = document.createElement('INPUT');
  rid.type = 'hidden';
  rid.name = prid;
  rid.value = prv;
  f.appendChild(rid);
 }
 var pb = document.createElement('INPUT');
 pb.type = 'hidden';
 pb.name = 'pressedButton';
 pb.value = n;
 f.appendChild(pb);
 osf(f);
 removePlaceHolder();
 f.submit();
}

function osf(f){
    if(f.target=='' || f.target=='_self' || f.target=='_top') {
        for (var e=0 ; e < f.elements.length; e++) {
            if(f.elements[e].type=='button'){
                f.elements[e].disabled = true;
            }
        }
    }
}

function ml(ta,ml,e){
	var k;
	if(window.event){ // IE
		k = e.keyCode
	} else if(e.which){ // Netscape/Firefox/Opera/Safari
		k = e.which
	};
	switch(k){
	case 8: // backspace
	case null:
	case undefined:  // del
	case 120: // ctrl-x
		return true		
	case 118: // ctrl-v
		break;
	}	  
	if (k > 60000){
		return true;
	}
	return (ta.value.length <= ml);
}

function firstFocus(id){
  var e;
  var t = 4000000000;
    jQuery(id + ' :input').not('[readonly],[disabled],[type="hidden"]').each(function(){
      tx = $(this).offset().top
      if (tx+1 < t && tx != 0){  // +1 to handle lookup buttons that are 1 pixel higher than the textarea field.
        e = this;
        t = tx;
      }
    })
    $(e).focus();
}

function nextFocus(f,pname,skipone){
  var i = 0;
  var j = 0;
  if (skipone==2){ // pname is specified control to get focus
    for (var e=0 ; e < f.elements.length; e++) {
      if(f.elements[e].name==pname){
  try{
    f.elements[e].focus();
  } catch (e) {
  }
  break;
      }
    }
  } else {
    for (var e=0 ; e < f.elements.length; e++) {
      if (i==1){
  if ((f.elements[e].type == "text") || (f.elements[e].type == "textarea") || (f.elements[e].type == "checkbox") || (f.elements[e].type == "radio") || (f.elements[e].type == "select-one")){
    //|| (f.elements[e].type == "button")
    if(f.elements[e].readOnly != true){
      if((skipone==1) && (j==0)){
        j = 1;
      } else {
        try{
    f.elements[e].focus();
        } catch (e) {
        }
        break;
      }
    }
  }
      }
      else{
  if(pname==''){
    if(f.elements[e].readOnly != true){
      try{
        f.elements[e].focus();
      } catch (e) {
      }
      break;
    }
  } else {
    if(f.elements[e].name==pname){
      i = 1;
    }
  }
      }
    }
  }
}


function removeElement(fn,dn){
 var f=document.getElementById(fn);
 var dv=document.getElementById(dn);
 var a;
 var b;
 if (dv != null){
  var divs = dv.getElementsByTagName('DIV');
  for(var e = divs.length-1; e>=0 ; e--){
   if ((divs[e].id != dn) && (divs[e].id != '')){
    removeElement(fn,divs[e].id);
   }
  }
  if (f != null){
   for(var e = f.elements.length-1; e>=0 ; e--) {
    a = f.elements[e].parentNode.id;
    b = dv.id
    if (a==b){
     try{
      dv.removeChild(f.elements[e]);
     } catch (e) {
     }
    }
   }
  }
 }
}

function FieldValue(f,e){
  var ans ='';
  var typ = f.type;
  var i = 0;
  var j = 0;
  if (typ == undefined){
    typ = f[0].type;
  }
  switch (typ){
  case "radio":
    j = f.length;
    for(i = 0; i < j; i++) {
      if(f[i].checked) {
  ans = f[i].value;
  break;
      }
    }
    break;
  case "checkbox":
    if (f.checked){
      ans = f.value;
    }
    break;
  case "select-multiple":
    j = f.length;
    for(i = 0; i < j; i++) {
      if(f.options[i].selected) {
        ans = ans + ';|;' + f.options[i].value;
    }
    }
    break;
  default:
    if ($(f).data('luv')){
      ans = $(f).data('luv');
    } else {
      ans = f.value;
    }
  }
  // if called as a post, do not encode & and %. If called from EIP then do.
  if ((ans != undefined) && ((e == 0) || (e == undefined))){
                ans = ans.replace(/%/g,"%25");
                ans = ans.replace(/&/g,"%26");
                ans = ans.replace(/#/g,"%23");
				ans = ans.replace(/\+/g,"%2B");
        }
  return ans
}

function SetSessionValue(name,value){
	$.get('SetSessionValue'+ntdExt,name+'='+value+'&_ajax_=1',function(data){xmlProcess(data);});
}

function TabChanged(url,value){
	$.get(url+ntdExt,'_tab_='+value+'&_ajax_=1',function(data){xmlProcess(data);});
}

function aGet(url,parms){
	$.get(url+ntdExt,parms+'&_ajax_=1&_cb_='+url,function(data){xmlProcess(data);ntWidth();});
}

function GetTab(name){
	$.get(name+ntdExt,'_ajax_=1',function(data){xmlProcess(data);});
}

function xmlProcess(data,processString){
	if ((typeof(data) == 'string') && (processString != true)) {
		$('html').trigger("ajaxComplete");
		return;
	}
	$('response',data).each(function(i){
		var t = $("response",data).get(i); // returns Element object
		var e = $(t).attr("type");
		if (window.ActiveXObject) {  //for IE
			var s = t.xml;           // IE 9 doesn't get this
			if (s == undefined){
						var s = (new XMLSerializer()).serializeToString(t); // but IE9 can do this, which IE7/8 can't
			}
		} else { // code for Mozilla, Firefox, Opera, etc.
			var s = (new XMLSerializer()).serializeToString(t);
		}
		if (s){
			s = s.substring(s.indexOf('>')+1,s.lastIndexOf('<'));
			if (e=='element'){
				d = $(t).attr("id");
				$("#"+d).replaceWith(s);
				try{$("#"+d).page().removeClass("ui-page").css('border',0);} catch(e){};
			} else if (e=='script'){
				s = s.replace(/&quot;/g,'"');
				s = s.replace(/&amp;/g,"&");
				s = s.replace(/&lt;/g,"<");
				s = s.replace(/&gt;/g,">");
				try{
				eval(s);
				} catch (e){
					try{
					} catch (e){}
				}
			}
		}
	});
	afterSv();
	if (ntMultiTab){
		initTabIDButtons();
	}
    gradient();
    resetCountDown();
}

// SetServer
function sv(id,name,ev,val,par,sil){
	hadfocus = id;
	if(par==undefined){
		$.get(name+ntdExt,{_event_: ev,value: val,_ajax_:1, _rnd_: Math.random()},function(data){xmlProcess(data);});
	}else{
		var parms='';
		for(var d = 2; d < arguments.length; d++){
			parms += arguments[d] + '&';
		}
		parms += '_ajax_=1&_rnd_=' + Math.random();
		$.get(name+ntdExt,parms,function(data){xmlProcess(data);});
	}
}

//Set timer
function SetTimer(name,t,par,sil){
	if(par==undefined)  {par='fred=1'};
	if(sil==undefined)  {sil='fred=2'};
	setTimeout("sv('','"+name+"','','','"+par+"','"+sil+"');",t);
};

// SelectDate and ResetAfterDate called by Date Lookup button
var cr1;
var cs;
var ct;
var cb1;
var cb2;
// SelectDate
function sd(f,e,p,r,b1,b2){
 ct = document.forms[f].elements[e];
 switch (p){
 case "@D6":
 case "@D06":
  var c = new calendar6(ct);
  break;
 case "@D2":
 case "@D02":
  var c = new calendar2(ct);
  break;
 }
 c.popup();
 if (arguments.length == 4){
  cr1 = r;
  cs = 1;
 }
 if (arguments.length == 6){
  cr1 = r;
  cs = 2;
  cb1 = b1;
  cb2 = b2;
 }
}
// ResetAfterDate
// removed in 7.24 - I think it's no longer used here - it's moved into nt-browse
//function rad(){
//	if (cs==1){
//		sv('',cr1,1,ct.value);
//		cs = 0;
//	}
//	if (cs==2){
//		sv('',cr1,cb1,cb2,'Value='+ct.value);
//		cs = 0;
//	}
//}

// jQuery Default Settings
jQuery.datepicker.setDefaults({
   closeText: 'Cancel',
   dateFormat: 'm/dd/yy',
   showButtonPanel: true,
   showOn: 'nothing',
   buttonImageOnly: true,
   buttonImage: '/styles/images/calendar.gif',
   buttonText: 'Calendar',
   constrainInput: false
});

// html5 helper-functions for browsers that don't yet support html5.
// Modernizr is used as a detector so if browser has native support these functions do nothing.
// ---------------------------------------------
function applyPlaceHolderElement(e){
 var t = e.attr('placeholder');
 var f = e.parents('form:first');
 if (e.val() === ''){
  e.val(t);
  e.css('color', '#888');
 }
 e.bind('focus.placeholder', function(event) {
  if (e.val() === t){
   e.val('');
  }
  e.css('color', '');
 });
 e.bind('blur.placeholder', function(event) {
  if (e.val() === ''){
         e.val(t);
   e.css('color', '#888');
  }
 });
 f.bind("submit.placeholder", function(event) {
  if (e.val() === t){
   e.val("");
  }
 });
};

// ---------------------------------------------
// Jan 2010 - Webkit support placeholder on a <input> but none yet on <textarea>
function applyPlaceHolder(){
	$('[placeholder]').each(function(i) {
		var e = $(this);
		if (!Modernizr.input.placeholder && e.type === 'INPUT'){
			// do nothing
		} else {
			if ($(e).is(":focus")) {
				// do nothing
			} else {
				applyPlaceHolderElement(e);
			}
		};
	});
};
// ---------------------------------------------
function removePlaceHolder(){
	$('[placeholder]').each(function(i) {
		var e = $(this);
		if (e.val() === e.attr('placeholder')){
			e.val("");
		}
	});
};
// ---------------------------------------------
function applyHTML5(){
	applyPlaceHolder();
}
// ---------------------------------------------
function bubbleStyle(div,attr,col){
    if ((attr=='background-color') && (col != 'transparent')){
		$("#"+div).parent().css('background-color',col);
        $("#"+div).css('background-color','transparent');
        $("#"+div).parent('[class~="nt-grad"]').each(function(){
			if (Modernizr.cssgradients ==  false){
				if (window.ActiveXObject) {  //for IE
					var ua = navigator.userAgent;
					var re  = new RegExp("MSIE ([0-8]{1,}[\.0-8]{0,})");
					if (re.exec(ua) != null){
						$("#"+div).parent().each(function(){
							this.style.filter = '"filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='+col+', endColorstr=#FFFFFFFF)"';
						});
					}
				}
			} else {

				$(this).css('background','linear-gradient(to top, #FFFFFF 0%, '+col+' 75%)');
				//$("#"+div).parent().css('background','-webkit-gradient(linear, 0 0, 0 100%, from('+col+'), to(#FFFFFF))');
				//if ($("#"+div).parent().css('background') == ''){
				//	$("#"+div).parent().css('background','-moz-linear-gradient(center bottom, #FFFFFF 0%, '+col+' 75%)');
				//}


			}
		});
    }
}

function gradient(){
	$('.nt-grad').each(function(){
		var col = $(this).css('background-color');
		if ((col != 'transparent') && (col != 'rgba(0, 0, 0, 0)')){
			if (Modernizr.cssgradients ==  false){
				if (window.ActiveXObject) {  //for IE
					var ua = navigator.userAgent;
					var re  = new RegExp("MSIE ([0-8]{1,}[\.0-8]{0,})");
					if (re.exec(ua) != null){
						this.style.filter = '"filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='+col+', endColorstr=#FFFFFFFF)"';
					}
				}
			} else {
				$(this).css('background','linear-gradient(to top, #FFFFFF 0%, '+col+' 75%)');			
				//$(this).css('background','-webkit-gradient(linear, 0 0, 0 100%, from('+col+'), to(#FFFFFF))');
				//if ($(this).css('background') == ''){
				//	$(this).css('background','-moz-linear-gradient(center bottom, #FFFFFF 0%, '+col+' 75%)');
				//}
			}
        }
	});
}

// ---------------------------------------------
function browseCssSupport(){
// $('body').prepend('<div id="_ntbc_" class="nt-browse-colors"></div>');
}

// ---------------------------------------------
jQuery(document).ready( function(){jQuery('.rounded').corners();});

// ---------------------------------------------
// run html5 support scripts when page opens
jQuery(document).bind('ready', function(event) {
	applyHTML5();
	gradient();
    browseCssSupport();
});
// ---------------------------------------------
// IE checkbox / radio fix for IE <= 8
// http://norman.walsh.name/2009/03/24/jQueryIE
$(function () {
	if (window.attachEvent && !window.addEventListener) { // detects IE8 and below
        $('input:radio, input:checkbox').bind('click.iefix',function () {
            this.blur();
            this.focus();
        });
    }
});


// ---------------------------------------------
//  Extension of jQueryUi dialog to add a call to SetAccess
// ---------------------------------------------
(function(jQuery){
    var _init = jQuery.ui.dialog.prototype._init;

    //Custom Dialog Init
    jQuery.ui.dialog.prototype._init = function() {
        _init.apply(this, arguments);
        var _this=this;
    if ((this.options.addsec != '') && (this.options.addsec != undefined)){
            tb = this.uiDialogTitlebar;
            tb.append('<a href="#" id="dialog-access" class="dialog-access ui-dialog-titlebar-access ui-corner-all"><span class="ui-icon ui-icon-key"></span></a>');
            //Secwin Button
            jQuery('.dialog-access', tb).hover(function(){
                jQuery(this).addClass('ui-state-hover');
            }, function(){
                jQuery(this).removeClass('ui-state-hover');
            }).click(function(){
                ntd.push('secwinwebuseraccess','','header',1,2,null,'','','_screen_=' + _this.options.addsec);
                return false;
            });
        }
    };

})(jQuery);


function swpf(id,addsec){
	$('#form-access-'+id).prepend('<a href="#" id="a-form-access-'+id+'" class="nt-form-page-access ui-widget-header ui-corner-all"><span class="ui-icon ui-icon-key"></span></a>');
	$('#a-form-access-'+id).hover(function(){
		$(this).addClass('ui-state-hover');
	}, function(){
		$(this).removeClass('ui-state-hover');
	}).click(function(){
		ntd.push('secwinwebuseraccess','','header',1,2,null,'','','_screen_=' + addsec);
		return false;
	});
}

function primeLocation(pLat,pLong,pAlt,pAcc,pAltAcc,pHeading,pSpeed,pDiv){
	if (pDiv){
		$(pDiv).html('Getting position')
	}

	var watchId = navigator.geolocation.watchPosition(
		function(pos){ // location found
			navigator.geolocation.clearWatch(watchId);
			$(pLat).val(pos.coords.latitude);
			$(pLong).val(pos.coords.longitude);
			$(pAlt).val(pos.coords.altitude);
			$(pAcc).val(pos.coords.accuracy);
			$(pAltAcc).val(pos.coords.altitudeAccuracy);
			$(pHeading).val(pos.coords.heading);
			$(pSpeed).val(pos.coords.speed);
			if (pDiv){
				$(pDiv).html('Position:' + pos.coords.latitude.toString().substring(0,7) +',' + pos.coords.longitude.toString().substring(0,7))
			}
			
		},
		function(err){ // location not found
			switch(err.code){
				case err.PERMISSION_DENIED: 
					//debug('Device Location: Permission Denied')
					$(pDiv).html('Location: Permission Denied')
					break;
				
				case err.POSITION_UNAVAILABLE: 
					//debug('Device Location: Position Unavailable')
					$(pDiv).html('Location: Permission Unavailable')
					break;
					
				case err.TIMEOUT: 
					//debug('Device Location: Timeout')
					$(pDiv).html('Location: Permission Timeout')
					break;
					
				default: 
					//debug('Device Location: Unknown Error: ' + err.code)
					$(pDiv).html('Location: Unknown Error: ' + err.code)
				break;
			}
		},
		{ enableHighAccuracy: false, timeout: 30000,maximumAge: 300000 }		
		);


	navigator.geolocation.getCurrentPosition(
		function(pos){ // location found
			//debug('location found ' + pos.coords.latitude +  ',' + pos.coords.longitude + ' pDiv=' + pDiv)
			$(pLat).val(pos.coords.latitude);
			$(pLong).val(pos.coords.longitude);
			$(pAlt).val(pos.coords.altitude);
			$(pAcc).val(pos.coords.accuracy);
			$(pAltAcc).val(pos.coords.altitudeAccuracy);
			$(pHeading).val(pos.coords.heading);
			$(pSpeed).val(pos.coords.speed);
			if (pDiv){
				$(pDiv).html('Position:' + pos.coords.latitude.toString().substring(0,7) +',' + pos.coords.longitude.toString().substring(0,7))
			}
		},
		function(err){ // location not found
			switch(err.code){
				case err.PERMISSION_DENIED: 
					//debug('Device Location: Permission Denied')
					$(pDiv).html('Location: Permission Denied')
					break;
				
				case err.POSITION_UNAVAILABLE: 
					//debug('Device Location: Position Unavailable')
					$(pDiv).html('Location: Position Unavailable')
					break;
					
				case err.TIMEOUT: 
					//debug('Device Location: Timeout')
					$(pDiv).html('Location: Timeout')
					break;
					
				default: 
					//debug('Device Location: Unknown Error: ' + err.code)
					$(pDiv).html('Location: Unknown Error: ' + err.code)
				break;
			}

		},
		{ enableHighAccuracy: false, timeout: 30000,maximumAge: 300000 }		
		);
}

function getLocation(){
	navigator.geolocation.getCurrentPosition(sendLocation,noSendLocation);
}

function sendLocation(pos){
	$.get('SetSessionValue'+ntdExt,'_Latitude_=' + pos.coords.latitude +
                               '&_Longitude_=' + pos.coords.longitude +
                               '&_Altitude_=' + pos.coords.altitude +
                               '&_Accuracy_=' + pos.coords.accuracy +
                               '&_AltitudeAccuracy_=' + pos.coords.altitudeAccuracy +
                               '&_Heading_=' + pos.coords.heading +
                               '&_Speed_=' + pos.coords.speed +
                               '&_LocationUnixTime_=' + parseInt(pos.timestamp/1000) +
                               '&_LocationDate_=' + parseInt(pos.timestamp / 86400000 + 61730) +
                               '&_LocationTime_=' + parseInt((pos.timestamp % 86400000) / 10) +
                               '&_LocationError_=' +
                               '&_ajax_=1'
         ,function(data){xmlProcess(data);});
}

function noSendLocation(err){
	switch(err.code){
		case err.PERMISSION_DENIED: 
			SetSessionValue('_LocationError_',err.code + '_permission_denied');
			debug('Location: Permission Denied')
			break;
		
		case err.POSITION_UNAVAILABLE: 
			SetSessionValue('_LocationError_',err.code + '_position_unavailable');
			debug('Location: Position Unavailable')
			break;
			
		case err.TIMEOUT: 
			SetSessionValue('_LocationError_',err.code + '_timeout');
			debug('Location: Timeout')
			break;
			
		default: 
			SetSessionValue('_LocationError_',err.code + '_unknown');
			debug('Location: Unknown Error: ' + err.code)
			break;
	}
};

function ntPlay(wav){
	var audio = new Audio(wav);
	audio.play();
};

function ntWidth(){
	$('#body_div').css('min-width',$('#contentbody_div').outerWidth(true) + $('.nt-menuleft:first').outerWidth(true) +20);
}

function consoleLog(s){
  //$('#consolelog').append(s + '<br/>')
}

function today(pic){
	var p=0;
	var td = new Date(); // primed with current date and time
	return formatDate(td,pic);
}
function formatDate(td,pic){
	var zero=false;

	var dd = td.getDate();
	var mm = td.getMonth()+1; //January is 0!
	var yyyy = td.getFullYear();
	if (!pic){
		p = 1;
	} else { // default to mm/dd/yyyy
		if (pic.charAt(0) == '@'){
			pic = pic.substring(1) // remove leading @
		}
		if (pic.charAt(0) == 'D' || pic.charAt(0) == 'd'){
			pic = pic.substring(1) // remove leading D or d
		}
		if (pic.charAt(0) == '0'){
			zero = true;
		}
		p = parseInt(pic);
		if ( p < 1){ p = 1};
	}	
	switch(p){
	case 1: // mm/dd/yyyy
	case 2: 
		if (zero){
			if(mm<10) { mm='0'+mm} 			
		}

		if(dd<10) {	dd='0'+dd} 
		td = mm+'/'+dd+'/'+yyyy;
		break;
	case 3: 
		break;
	case 4: 
		break;
	case 5: 
	case 6: 
		if (zero){
			if(dd<10) {	dd='0'+dd} 
		}
		if(mm<10) { mm='0'+mm} 			
		td = dd+'/'+mm+'/'+yyyy;
		break;
	case 7: 
		break;
	case 8: 
		break;
	case 9: 
	case 10: 
		if(dd<10) {	dd='0'+dd} 
		if(mm<10) { mm='0'+mm} 			
		td = yyyy+'/'+mm+'/'+dd;	
		break;
	case 11: 
		break;
	case 12: 
		break;
	case 13: 
		break;
	case 14: 
		break;
	case 15: 
		break;
	case 16: 
		break;
	default:
		if(dd<10) {	dd='0'+dd} 
		if(mm<10) { mm='0'+mm} 
		td = mm+'/'+dd+'/'+yyyy;	
		break;
	}	
	return td;
}
function clock(pic){
	var td = new Date();
	var hh = td.getHours(); // => 9
	var mm = td.getMinutes(); // =>  30
	var ss = td.getSeconds(); // => 51
	if(ss<10) {	ss='0'+ss} 
	if(mm<10) { mm='0'+mm} 
	td = hh+':'+mm+':'+ss;	
	return td;
	
}
function GetUserTimeOffset(){
	date = new Date();
	SetSessionValue('_UserTimeOffset_',date.getTimezoneOffset()) 
};

function debug(text){
	$("#debug").append(text + '<br/>') ;
	console.log(text);
}

function getUTCTime(){
 var t = new Date().getTime();
 return t;
}
function onlyDigits(text){
	if(text){
		text.replace(/[^0-9]/g, '');
	}
	return text;	
}
function autoHeightText(textarea){
	var text = $('#' + textarea).val();
    var matches = text.match(/\n/g); // // look for any "\n" occurences
    var breaks = matches ? matches.length : 2;
	$('#' + textarea).attr('rows',breaks + 2);
}
;
function makeUrlData(fields){
	var ans = ''
	$.each(fields,function(index,value){
	  ans = ans + '&' + encodeURIComponent($($('#'+value)).attr('data-do')) +'=' + encodeURIComponent($('#'+value).val())
	})
	ans = ans.substr(1) // removes the leading &
	return(ans)
}
function textToTextarea(text,textarea){
	console.log(text);
	console.log(textarea);
	text = text.replace(/&/g, "&amp;");
	text = text.replace(/</g, "&lt;");
	text = text.replace(/>/g, "&gt;");
	$('#' + textarea).html(text);
	autoHeightText(textarea);	
}
;
