///////////////////////////////////////////////////////
//
//   jQuery Plugin for NetTalk Menu
//   Part of NetTalk by CapeSoft
//   (c) 2018
//
///////////////////////////////////////////////////////

(function( $, undefined ) {

$.widget( "ui.ntmenu", {
        options: {
			id: '',          
			ul:'',			// id of first UL for the menu
			burger:'',     // id of hamburger
			viewOnly:0
		},
		state: {
			menuOpen:0
		},

		//------------------------------------------------------
        _create: function() {
			var _this=this;
        },

		//------------------------------------------------------
        _init: function() {
			var _this=this;
			$('#' + this.options.ul).menu(this.options);
			$('#' + this.options.burger).on('click.mn').on('click.mn',function(e){_this.burgerClick();});
            $('#' + this.options.ul).find('> li > ul').addClass('ui-corner-all ui-widget ui-widget-content')       //bj
			$('#' + this.options.ul).addClass('ui-widget');
			$('#' + this.options.ul).children('li').children('a').addClass('ui-widget ui-state-default');						
			$('#' + this.options.ul).hover(function(){return false;},function () {
				$('#' + _this.options.ul).menu("collapseAll", null, true);
			});			
        },
		//------------------------------------------------------
        burgerClick: function() {
			if (this.state.menuOpen==0){
				$('#' + this.options.ul).show();
				this.state.menuOpen=1
			} else {
				$('#' + this.options.ul).hide();
				this.state.menuOpen=0
			}
		}

//------------------------------------------------------
});

$.extend( $.ui.ntmenu, {
        version: "@VERSION"
});

})( jQuery );

///////////////////////////////////////////////////////
// end ntmenu
///////////////////////////////////////////////////////


