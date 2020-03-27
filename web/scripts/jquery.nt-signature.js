// nettalk signature pad
// requires jquery.signaturepad.js by Thomas J Bradley  -- http://thomasjbradley.ca/lab/signature-pad/
// requires json2.js by Douglas Crockford  -- http://www.json.org/js.html

(function( $, undefined ) {
$.widget( "ui.ntsignature", {
        options: {
                id: '',
                divId: '',
                formId: '',
                defaultAction:'drawIt',
                drawOnly:0,
                width:200,
                height:60,
                compress:1,
                displayOnly:0,
                clearButton: 1,
                jQueryButton: 1,
                clearIcon: 'ui-icon-arrowrefresh-1-w',
                clearText: 'Clear',
                lineColor:'#ccc',
                lineWidth:2,
                lineMargin:2,
                lineTop: 35,
                css: 'nt-left nt-entry ui-corner-all',
                sp:0
        },


//------------------------------------------------------
        _create : function() {
                this.addControl();
        },

//------------------------------------------------------
        addControl : function() {
                var _this=this;
                if (this.options.id == ''){
                        this.options.id = $(this.element).attr('id');
                }
                if (this.options.divId == ''){
                        this.options.divId = $(this.element).parent().attr('id');
                        if (this.options.divId == undefined){
                                this.options.divId = $(this.element).parent().parent().attr('id');
                        }
                }
                if (this.options.formId == ''){
                        this.options.formId = $(this.element).parents('form').attr('id');
                }
                var sig = _this.decompress($('#' + _this.options.id).val());
                var cb = '';
                if (this.options.clearButton){
                        cb = '<button type="button" id="' + this.options.id + '_clear'+'">'+ this.options.clearText +'</button>'
                }
                $('#' + this.options.divId).append('<div id="'+this.options.id+'_sigdiv" class="'+ this.options.css+'">' +
               '<canvas id = "'+this.options.id+'_canvas" class="pad" width="'+this.options.width+'" height="'+this.options.height+'"></canvas>' +
               '</div>' + cb);
                var options = '';
                if (_this.options.jQueryButton == 1){
                        if (_this.options.clearIcon){
                                options = {icons: {primary: _this.options.clearIcon}};
                        }
                        $('#'+ this.options.id + '_clear').button(options);
                }
                options = {
                        defaultAction: this.options.defaultAction,
                        drawOnly: this.options.drawOnly,
                        sig: '#' + this.options.id + '_sigdiv',
                        canvas: '#' + this.options.id + '_canvas',
                        displayOnly: this.options.displayOnly,
                        clear: '#' + this.options.id + '_clear',
                        lineColor: this.options.lineColor,
                        lineWidth: this.options.lineWidth,
                        lineMargin: this.options.lineMargin,
                        lineTop: this.options.lineTop,
                        output: '#' + this.options.id
                };
                _this.options.sp = $("#"+this.options.formId).signaturePad(options);
                if (sig){
                        _this.options.sp.regenerate(sig);
                }
                $("#"+this.options.formId).find('[data-do="save"]').off('click.ntsig').on('click.ntsig',function(e){
                        if (_this.options.displayOnly == 1){
                                $('#' + _this.options.id).remove();
                        } else {
                                $('#' + _this.options.id).val(_this.compress(_this.options.sp.getSignatureString()));
                        }
                });
        },

//------------------------------------------------------
        compress : function(sig) {
                if (this.options.compress == 1){
                        sig = sig.replace(/"lx":/g,'X');
                        sig = sig.replace(/,"ly":/g,'Y');
                        sig = sig.replace(/,"mx":/g,'W');
                        sig = sig.replace(/,"my":/g,'H');
                        //sig = sig.replace(/},{/g,'-');
						sig = sig.replace(/},{/g,'~');
                        return 'Y' + sig;
                } else {
                        return sig;
                }
        },

//------------------------------------------------------
        decompress : function(sig) {
                if (sig.substring(0,1) == 'Z'){
						sig = sig.replace(/-X/g,'},{X');
                        sig = sig.replace(/Z/,'');
                        sig = sig.replace(/X/g,'"lx":');
                        sig = sig.replace(/Y/g,',"ly":');
                        sig = sig.replace(/W/g,',"mx":');
                        sig = sig.replace(/H/g,',"my":');
                        
                } else {
					if (sig.substring(0,1) == 'Y'){
							sig = sig.replace(/Y/,'');
							sig = sig.replace(/X/g,'"lx":');
							sig = sig.replace(/Y/g,',"ly":');
							sig = sig.replace(/W/g,',"mx":');
							sig = sig.replace(/H/g,',"my":');
							sig = sig.replace(/~/g,'},{');
					}				
				}
                return sig;
        }
//------------------------------------------------------

});

$.extend( $.ui.ntsignature, {
        version: "@VERSION"
});

})( jQuery );
