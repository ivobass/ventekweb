///////////////////////////////////////////////////////
//   
//   jQuery UI Plugin for leaflet.js maps
//   Part of NetTalk by CapeSoft 
//   (c) 2014 
//
///////////////////////////////////////////////////////
//var mymap; // debug only

(function( $, undefined ) {

$.widget( "ui.ntmap", {
	options: {
		procedure:'',
		ssl:0,
		equate:'',
		styleId:0,
		provider:0,		
		mapOptions: {},
		tileURL: '',
		tileOptions: {},
		tileLayers: {},
		scale:0,
		scaleOptions: {},
		urlExt:'',
		divId:'',
		clusters: {},
		polygons: {},
		markers: {},
		startLat:0,
		startLng:0,
		startZoom:0,
		moveHomeToClick:0,
		insertForm:'',
		insertCluster:'',
		locate:0,
		locateIcon:blueMarker,
		locateText:"",
		locateShow:0,
		controller:{},
		baseMaps:{},
		overlays:{},
		textStreet:'Street',	
		textStreet2:'Night',	
		textContours:'Contours',
		textSatellite:'Satellite',
		textOceans:'Oceans',
		textTerrain:'Terrain',
		textHybrid:'Hybrid',
		textTraffic:'Traffic'
	},

//------------------------------------------------------
	_create: function() {       
		if (this.options.urlExt==''){try{this.options.urlExt=ntdExt} catch(e){};}    
	},

//------------------------------------------------------
	_init: function() {
		var _this=this;
		this.options.mapId = L.map(this.options.divId,this.options.mapOptions);
		this.options.startZoom = this.options.mapId.options.zoom;
		if (this.options.locate){
			var _this=this;
			_this._init2();
			navigator.geolocation.getCurrentPosition(
				function(pos){ // success 
					_this.setView(pos.coords.latitude,pos.coords.longitude,_this.options.startZoom);				
					//_this._init2();			
					_this.addMarkerToMap("_home1_",pos.coords.latitude,pos.coords.longitude,{icon: _this.options.locateIcon },_this.options.locateText,_this.options.locateShow);					
				},
				function(err){ // fail
					_this.options.startLat = _this.options.mapId.options.center[0];
					_this.options.startLng = _this.options.mapId.options.center[1];			
					//_this._init2();			
				}


			);			
		} else {
			this.options.startLat = this.options.mapId.options.center[0];
			this.options.startLng = this.options.mapId.options.center[1];			
			this._init2();
		}	
	},	
	
//------------------------------------------------------
	_init2: function() {

		var _this=this;
		this.addTileLayers();
		if (this.options.scale){
			L.control.scale(this.options.scaleOptions).addTo(this.options.mapId)
		}
		this.options.mapId.on('click',function(e){_this.mapClicked(e)});		
		this.options.mapId.on('dragend',function(e){_this.mapMoved(e)});
		this.options.mapId.on('zoomend',function(e){_this.mapZoomed(e)});
		this.options.mapId.on('baselayerchange',function(e){_this.baselayerchange(e)});		
	},	
//------------------------------------------------------  	
	baselayerchange: function(e) {
		z = (e.layer.options.maxZoom);
		if (z < this.options.mapId.getZoom()){
			this.options.mapId.setZoom(z)	
		}
	},	
//------------------------------------------------------
	mapClicked: function(e) {
		var _this=this;
		$.get(this.options.procedure + '_' + this.options.divId + '_value'+this.options.urlExt,
		'_ajax_=1&_event_=clicked' + this.currentMap() + '&_lat_=' + e.latlng.lat + '&_lng_=' + e.latlng.lng,
		function(data){_this._onAjaxComplete(data);});		
		if (this.options.insertForm){
			ntd.push(this.options.insertForm,'','',1,1,'',this.options.procedure,'','_cluster_=' + this.options.insertCluster + '&_lat_=' + e.latlng.lat + '&_lng_=' + e.latlng.lng + this.currentMap(),null,null,null,null,this.options.equate);
		}
		if (this.options.moveHomeToClick){
			this.options.markers['_home_'].setLatLng([e.latlng.lat, e.latlng.lng]);
		}
	},	
//------------------------------------------------------
	mapZoomed: function(e) {
		var _this=this;
		$.get(this.options.procedure + '_' + this.options.divId + '_value'+this.options.urlExt,
		'_ajax_=1&_event_=zoomed' + this.currentMap() ,
		function(data){_this._onAjaxComplete(data);});		
	},	

//------------------------------------------------------
	mapMoved: function(e) {
		var _this=this;
		$.get(this.options.procedure + '_' + this.options.divId + '_value'+this.options.urlExt,
		'_ajax_=1&_event_=moved' + this.currentMap() ,
		function(data){_this._onAjaxComplete(data);});		
	},	
//------------------------------------------------------
	markerClicked: function(e,marker) {
		var _this=this;
		if (this.options.clusters[marker.clusterName].options.form){
			ntd.push(this.options.clusters[marker.clusterName].options.form,'','',1,marker.action,'',this.options.procedure,marker.bidv,'&_cluster_=' + marker.clusterName+'&_marker_=' + marker.bidv ,null,null,null,null,this.options.equate);
		} 
	},	

	//------------------------------------------------------
	markerDragged: function(e,marker) {
		var _this=this;
		$.get(this.options.procedure + '_' + this.options.divId + '_value'+this.options.urlExt,
		'_ajax_=1&_event_=dragged&_lat_=' + marker._latlng.lat + ' &_lng_=' + marker._latlng.lng + '&_bidv_=' + marker.bidv + '&_cluster_=' + marker.clusterName,
		function(data){_this._onAjaxComplete(data);});		
	},	
//------------------------------------------------------
	currentMap: function(e) {
		b = this.options.mapId.getBounds()
		s = '&_zoom_=' + this.options.mapId.getZoom() + '&_swLat_=' + b._southWest.lat + '&_swLng_=' + b._southWest.lng  + '&_neLat_=' + b._northEast.lat  + '&_neLat_=' + b._northEast.lng;
		return(s)
	},	

//------------------------------------------------------
	setView: function(lat,lng,zoom){
		if (!zoom){
			zoom = this.options.mapId.getZoom();
		}
		this.options.mapId.setView([lat,lng],zoom);
	},
//------------------------------------------------------
	home: function(){	
		this.options.mapId.setView([this.options.startLat,this.options.startLng],this.options.startZoom);
	},
//------------------------------------------------------
	locate: function(zoom){	
		var _this=this;
		navigator.geolocation.getCurrentPosition(
			function(pos){ // success 
				_this.setView(pos.coords.latitude,pos.coords.longitude,zoom);
			},
			function(err){ // fail
			
			}
		);
	},
//------------------------------------------------------
	addMarkerToMap: function(bidv,lat,lng,options,desc,descopen) {
		var _this=this;
		if (!this.options.markers[bidv]&& options.icon){

			this.options.markers[bidv] = L.marker([lat,lng],options).addTo(this.options.mapId);			
			this.options.markers[bidv].bidv = bidv; 			
		}	
		if (this.options.markers[bidv]){
			if(desc){
				if (descopen){
					this.options.markers[bidv].bindPopup(desc).openPopup();
				} else {
					this.options.markers[bidv].bindPopup(desc);
				}			
			} else {
				this.options.markers[bidv].on('click',function(e){_this.markerClicked(e,_this.options.markers[bidv])});	
			}	
			this.options.markers[bidv].on('dragend',function(e){_this.markerDragged(e,_this.options.markers[bidv])});				
			return this.options.markers[bidv];
		};
		return null;
	},

//------------------------------------------------------
	addPolygonToMap: function(options) {	
		if (! this.options.polygons[options.name]){			
			this.options.polygons[options.name] = L.layerGroup().addTo(this.options.mapId);			
		}	
		this.options.controller.addOverlay(this.options.polygons[options.name],options.name);
	},
//------------------------------------------------------
	addMarkersToPolygon: function(name,ar) {
		var ll=[];
		if(this.options.polygons[name]){
			this.options.polygons[name].markers = this.addMarkers(name,ar)
			
			for(var i=0; this.options.polygons[name].markers[i] ; i++){
				this.options.polygons[name].addLayer(this.options.polygons[name].markers[i]);
				ll[i] = this.options.polygons[name].markers[i]._latlng;
			}	
			L.polygon(ll).addTo(this.options.mapId);
		}
	},
	
//------------------------------------------------------
	addClusterToMap: function(options) {	
		if (!this.options.clusters[options.name]){
			this.options.clusters[options.name] = L.markerClusterGroup(options);			
			if (this.options.clusters[options.name]){
				this.options.mapId.addLayer(this.options.clusters[options.name]);
			}	
		}	


		this.options.controller.addOverlay(this.options.clusters[options.name],options.name);
	},
//------------------------------------------------------ (used after click to insert) 
	addMarkerToCluster: function(name,bidv,lat,lng,options,desc,descopen,action) {
		if(this.options.clusters[name]){
			marker = this.addMarker(bidv,lat,lng,options,desc,descopen,action);
			if (marker){
				marker.clusterName = name;
				this.options.clusters[name].addLayer(marker);
			}	
		}	
	},
//------------------------------------------------------
	addMarkersToCluster: function(name,ar) {
		if(this.options.clusters[name]){
			this.options.clusters[name].markers = this.addMarkers(name,ar)
			this.options.clusters[name].addLayers(this.options.clusters[name].markers);
		}
	},
//------------------------------------------------------
// array = [bidv, lat, lng, options, desc, descopen, formaction]
	addMarkers: function(name,ar) {
		var markersArray=[];
		for (var i=0; i < ar.length; i++){
			marker = this.addMarker(ar[i][0],ar[i][1],ar[i][2],ar[i][3],ar[i][4],ar[i][5],ar[i][6]);
			if (marker){
				marker.clusterName = name;
				markersArray[i] = marker;
			}	
		}
		return markersArray;
	},	
//------------------------------------------------------
	addMarker: function(bidv,lat,lng,options,desc,descopen,action) {
		var _this = this;
		if (lat != undefined && lng != undefined){
			var marker = L.marker([lat,lng],options);
			marker.bidv = bidv; 			
			marker.action = action;
			if (desc){
				if (descopen){
					marker.bindPopup(desc).openPopup();
				} else {
					marker.bindPopup(desc);
				}
			} else if (action){
				marker.on('click',function(e){_this.markerClicked(e,marker)});	
				marker.on('dragend',function(e){_this.markerDragged(e,marker)});	
			};
			return marker;
		}	
		return null;
	},	
//------------------------------------------------------
	updateMarker: function(bidv,lat,lng,options) {	
		for(var name in this.options.clusters){
			$(this.options.clusters[name].markers).each(function(i,m){
				if (m.bidv==bidv){
					m.setLatLng([lat,lng]);
					if (options.icon){	
						m.setIcon(options.icon);	
					}
					if (options.opacity){	
						m.setOpacity(options.opacity);	
					}					
					if (options.title){	
						$(m._icon).attr('title',options.title);
					}					
					
				}	
			})
		}	
	},
//------------------------------------------------------
	removeMarker: function(bidv) {	
		var _this=this;
		for(var name in this.options.clusters){
			$(this.options.clusters[name].markers).each(function(i,m){
				if (m.bidv==bidv){
					_this.options.clusters[name].removeLayer(m)
				}	
			})
		}	
	},
	
//------------------------------------------------------  
	_onAjaxComplete: function(data) {
		xmlProcess(data);
		return this;
	},

//------------------------------------------------------  
	addTileLayers: function() {
		var baseMaps = {};

		switch(this.options.provider){		
			case 11: //Net:MapBox                     
				this.options.tileLayers[0] = L.tileLayer(this.getURL(11),this.mandatoryTileOptions(11,this.options.tileOptions)).addTo(this.options.mapId);	
				this.options.baseMaps[this.options.textStreet] = this.options.tileLayers[0];
				this.options.controller = L.control.layers(this.options.baseMaps,this.options.overlays).addTo(this.options.mapId);
				break;
			case 21: //Net:MapQuestOpen:OSM  
			case 22: //Net:MapQuestOpen:Aerial        
				this.options.tileLayers[0] = L.tileLayer(this.getURL(21),this.mandatoryTileOptions(21,this.options.tileOptions)).addTo(this.options.mapId);	
				this.options.tileLayers[1] = L.tileLayer(this.getURL(22),this.mandatoryTileOptions(22,this.options.tileOptions));
				this.options.baseMaps[this.options.textStreet] = this.options.tileLayers[0];
				this.options.baseMaps[this.options.textSatellite] = this.options.tileLayers[1];
				this.options.controller = L.control.layers(this.options.baseMaps,this.options.overlays).addTo(this.options.mapId);
				break;
			case 31: //Net:Stamen:Watercolor          
				this.options.tileLayers[0] = L.tileLayer(this.getURL(31),this.mandatoryTileOptions(31,this.options.tileOptions)).addTo(this.options.mapId);	
				this.options.baseMaps[this.options.textStreet] = this.options.tileLayers[0];
				this.options.controller = L.control.layers(this.options.baseMaps,this.options.overlays).addTo(this.options.mapId);
				break;				
			case 41: //Net:Esri:WorldStreetMap        
			case 42: //Net:Esri:Delorme               
			case 43: //Net:Esri:WorldImagery   
			case 44: //Net:Esri:OceanBaseMap   
			case 45: //Net:Esri:NatGeoWorldMap 
				this.options.tileLayers[0] = L.tileLayer(this.getURL(41),this.mandatoryTileOptions(41,this.options.tileOptions)).addTo(this.options.mapId);	
				this.options.tileLayers[1] = L.tileLayer(this.getURL(42),this.mandatoryTileOptions(42,this.options.tileOptions));
				this.options.tileLayers[2] = L.tileLayer(this.getURL(43),this.mandatoryTileOptions(43,this.options.tileOptions));
				this.options.tileLayers[3] = L.tileLayer(this.getURL(44),this.mandatoryTileOptions(44,this.options.tileOptions));
				this.options.tileLayers[4] = L.tileLayer(this.getURL(45),this.mandatoryTileOptions(45,this.options.tileOptions));								
				this.options.baseMaps[this.options.textStreet] = this.options.tileLayers[0];
				this.options.baseMaps[this.options.textContours] = this.options.tileLayers[1];
				this.options.baseMaps[this.options.textSatellite] = this.options.tileLayers[2];
				this.options.baseMaps[this.options.textOceans] = this.options.tileLayers[3];
				this.options.baseMaps[this.options.textTerrain] = this.options.tileLayers[4];
				this.options.controller = L.control.layers(this.options.baseMaps,this.options.overlays).addTo(this.options.mapId);
				break;
			case 51: //Net:HERE:NormalDay     
			case 52: //Net:HERE:NormalGreyDay 
			case 53: //Net:HERE:SatelliteNoLabelsDay 
			case 54: //Net:HERE:SatelliteYesLabelsDay
			case 55: //Net:HERE:TerrainDay
			case 56: //Net:HERE:TrafficDay
				this.options.tileLayers[0] = L.tileLayer(this.getURL(51),this.mandatoryTileOptions(51,this.options.tileOptions)).addTo(this.options.mapId);	
				this.options.tileLayers[1] = L.tileLayer(this.getURL(53),this.mandatoryTileOptions(53,this.options.tileOptions));
				this.options.tileLayers[2] = L.tileLayer(this.getURL(54),this.mandatoryTileOptions(54,this.options.tileOptions));
				this.options.tileLayers[3] = L.tileLayer(this.getURL(55),this.mandatoryTileOptions(55,this.options.tileOptions));
				this.options.tileLayers[4] = L.tileLayer(this.getURL(56),this.mandatoryTileOptions(56,this.options.tileOptions));
				this.options.baseMaps[this.options.textStreet] = this.options.tileLayers[0];
				this.options.baseMaps[this.options.textSatellite] = this.options.tileLayers[1];
				this.options.baseMaps[this.options.textHybrid] = this.options.tileLayers[2];
				this.options.baseMaps[this.options.textTerrain] = this.options.tileLayers[3];
				this.options.baseMaps[this.options.textTraffic] = this.options.tileLayers[4];				
				this.options.controller = L.control.layers(this.options.baseMaps,this.options.overlays).addTo(this.options.mapId);
				break;
			}
		return this;
	},
	
//------------------------------------------------------
	mandatoryTileOptions: function(p,options) {           	
		switch(p){		
			case 11: //Net:MapBox                     
				options.attribution='<a href="http://www.mapbox.com/about/maps/" target="_blank">Terms &amp; Feedback</a>';
				break;
			case 21: //Net:MapQuestOpen:OSM  
				options.attribution='Tiles Courtesy of <a href="http://www.mapquest.com/">MapQuest</a> &mdash; Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>';
				options.subdomains="1234";
				break;
			case 22: //Net:MapQuestOpen:Aerial        
				options.attribution='Tiles Courtesy of <a href="http://www.mapquest.com/">MapQuest</a> &mdash; Portions Courtesy NASA/JPL-Caltech and U.S. Depart. of Agriculture, Farm Service Agency';
				options.subdomains="1234";
				options.maxZoom = 11;
				break;
			case 31: //Net:Stamen:Watercolor          
				options.attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>';				
				break;
			case 41: //Net:Esri:WorldStreetMap        
				options.attribution='Tiles &copy; Esri &mdash; Source: Esri, DeLorme, NAVTEQ, USGS, Intermap, iPC, NRCAN, Esri Japan, METI, Esri China (Hong Kong), Esri (Thailand), TomTom, 2012';
				options.maxZoom = 19
				break;
			case 42: //Net:Esri:Delorme               
				options.attribution='Tiles &copy; Esri &mdash; Copyright: &copy;2012 DeLorme';
				options.maxZoom = 11
				break;
			case 43: //Net:Esri:WorldImagery   
				options.attribution='Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community';
				options.maxZoom = 17
				break;
			case 44: //Net:Esri:OceanBaseMap   
				options.attribution='Tiles &copy; Esri &mdash; Sources: GEBCO, NOAA, CHS, OSU, UNH, CSUMB, National Geographic, DeLorme, NAVTEQ, and Esri';
				options.maxZoom = 10
				break;
			case 45: //Net:Esri:NatGeoWorldMap 
				options.attribution='Tiles &copy; Esri &mdash; National Geographic, Esri, DeLorme, NAVTEQ, UNEP-WCMC, USGS, NASA, ESA, METI, NRCAN, GEBCO, NOAA, iPC';
				options.maxZoom = 12
				break;
			case 51: //Net:HERE:NormalDay     
			case 52: //Net:HERE:NormalGreyDay 
			case 53: //Net:HERE:SatelliteNoLabelsDay 
			case 54: //Net:HERE:SatelliteYesLabelsDay
			case 55: //Net:HERE:TerrainDay           
			case 56: //Net:HERE:TrafficDay           
				options.attribution='Map &copy; <a href="http://developer.here.com">HERE</a>, Data &copy; NAVTEQ 2012';
				options.subdomains="1234";
				break;
			default:
				options.attribution='Tiles Courtesy of <a href="http://www.mapquest.com/">MapQuest</a> &mdash; Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>';
				options.subdomains="1234";			
			}
			return options;
	},
	
//------------------------------------------------------  
	getURL: function(p) {
		if (this.options.ssl){
			var h='https://'
		} else {
			var h='http://'
		}		
		switch(p){		
			case 11: //Net:MapBox
				return(h+'{s}.tiles.mapbox.com/v3/{devID}/{z}/{x}/{y}.png')
			case 21: //Net:MapQuestOpen:OSM           
				return(h+'otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.jpeg')
			case 22: //Net:MapQuestOpen:Aerial        
				return(h+'oatile{s}.mqcdn.com/tiles/1.0.0/sat/{z}/{x}/{y}.jpg')
			case 31: //Net:Stamen:Watercolor          
				return(h+'{s}.tile.stamen.com/watercolor/{z}/{x}/{y}.jpg')
			case 41: //Net:Esri:WorldStreetMap        
				return(h+'server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}')
			case 42: //Net:Esri:Delorme               
				return(h+'server.arcgisonline.com/ArcGIS/rest/services/Specialty/DeLorme_World_Base_Map/MapServer/tile/{z}/{y}/{x}')
			case 43: //Net:Esri:WorldImagery   
				return(h+'server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}')
			case 44: //Net:Esri:OceanBaseMap   
				return(h+'services.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer/tile/{z}/{y}/{x}')
			case 45: //Net:Esri:NatGeoWorldMap 
				return(h+'services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}')
			case 51: //Net:HERE:NormalDay     
				return(h+'{s}.base.maps.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png?app_id={devID}&app_code={appID}')
			case 52: //Net:HERE:NormalGreyDay 
				return(h+'{s}.base.maps.api.here.com/maptile/2.1/maptile/newest/normal.day.grey/{z}/{x}/{y}/256/png?app_id={devID}&app_code={appID}')
			case 53: //Net:HERE:SatelliteNoLabelsDay 
				return(h+'{s}.aerial.maps.api.here.com/maptile/2.1/maptile/newest/satellite.day/{z}/{x}/{y}/256/png?app_id={devID}&app_code={appID}')
			case 54: //Net:HERE:SatelliteYesLabelsDay
				return(h+'{s}.aerial.maps.api.here.com/maptile/2.1/maptile/newest/hybrid.day/{z}/{x}/{y}/256/png?app_id={devID}&app_code={appID}')	
			case 55: //Net:HERE:TerrainDay           
				return(h+'{s}.aerial.maps.api.here.com/maptile/2.1/maptile/newest/terrain.day/{z}/{x}/{y}/256/png?app_id={devID}&app_code={appID}')
			case 56: //Net:HERE:TrafficDay           
				return(h+'{s}.traffic.maps.api.here.com/maptile/2.1/traffictile/newest/terrain.day/{z}/{x}/{y}/256/png?app_id={devID}&app_code={appID}')
			default:
				return(h+'otile{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.jpeg')
		}
	},
//------------------------------------------------------
});

$.extend( $.ui.ntmap, {
	version: "@VERSION"
});

})( jQuery );

var greenMarker = L.icon({
    iconUrl: '/images/marker-icon-green.png',
	iconRetinaUrl: '/images/marker-icon-green-2x.png',
    shadowUrl: '/images/marker-shadow.png',
	iconSize: [25, 41],
	iconAnchor: [12, 41],
	popupAnchor: [1, -34],
	shadowSize: [41, 41]
});

var redMarker = L.icon({
    iconUrl: '/images/marker-icon-red.png',
    iconRetinaUrl: '/images/marker-icon-red-2x.png',
    shadowUrl: '/images/marker-shadow.png',
	iconSize: [25, 41],
	iconAnchor: [12, 41],
	popupAnchor: [1, -34],
	shadowSize: [41, 41]	
});
var pinkMarker = L.icon({
    iconUrl: '/images/marker-icon-pink.png',
    iconRetinaUrl: '/images/marker-icon-pink-2x.png',
    shadowUrl: '/images/marker-shadow.png',
	iconSize: [25, 41],
	iconAnchor: [12, 41],
	popupAnchor: [1, -34],
	shadowSize: [41, 41]	
});
var purpleMarker = L.icon({
    iconUrl: '/images/marker-icon-purple.png',
    iconRetinaUrl: '/images/marker-icon-purple-2x.png',
    shadowUrl: '/images/marker-shadow.png',
	iconSize: [25, 41],
	iconAnchor: [12, 41],
	popupAnchor: [1, -34],
	shadowSize: [41, 41]	
});
var brownMarker = L.icon({
    iconUrl: '/images/marker-icon-brown.png',
    iconRetinaUrl: '/images/marker-icon-brown-2x.png',
    shadowUrl: '/images/marker-shadow.png',
	iconSize: [25, 41],
	iconAnchor: [12, 41],
	popupAnchor: [1, -34],
	shadowSize: [41, 41]	
});
var blueMarker = L.icon({
    iconUrl: '/images/marker-icon-blue.png',
    iconRetinaUrl: '/images/marker-icon-blue-2x.png',
    shadowUrl: '/images/marker-shadow.png',
	iconSize: [25, 41],
	iconAnchor: [12, 41],
	popupAnchor: [1, -34],
	shadowSize: [41, 41]	
});
var aquaMarker = L.icon({
    iconUrl: '/images/marker-icon-aqua.png',
    iconRetinaUrl: '/images/marker-icon-aqua-2x.png',
    shadowUrl: '/images/marker-shadow.png',
	iconSize: [25, 41],
	iconAnchor: [12, 41],
	popupAnchor: [1, -34],
	shadowSize: [41, 41]	
});
var yellowMarker = L.icon({
    iconUrl: '/images/marker-icon-yellow-2x.png',
    iconRetinaUrl: '/images/marker-icon-yellow.png',
    shadowUrl: '/images/marker-shadow.png',
	iconSize: [25, 41],
	iconAnchor: [12, 41],
	popupAnchor: [1, -34],
	shadowSize: [41, 41]	
});

///////////////////////////////////////////////////////
// end ntmap
///////////////////////////////////////////////////////
