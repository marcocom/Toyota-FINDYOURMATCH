package com.digitalarbor.toyota.view.map_vo 
{
	import flash.display.DisplayObject;
	import flash.display.StageQuality;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	//tweenlite
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*
	
	//away
	import away3d.containers.View3D;
	import away3d.containers.Scene3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.Plane;
	import away3d.materials.MovieMaterial;
	import away3d.core.render.Renderer;
	import away3d.primitives.Sphere;
	import away3d.core.clip.FrustumClipping;
	import away3d.cameras.HoverCamera3D;
	import away3d.debug.AwayStats;

	//interface
	import com.digitalarbor.toyota.event.ClassDispatcher;
	import com.digitalarbor.toyota.controller.Controller;
	import com.digitalarbor.toyota.utilities.StageLocate;
	
	public class ConfigMapScene extends Sprite
	{
		// reverse animation
		TweenPlugin.activate([FramePlugin]);
		
		// stage
		private var _$centerPoint:Point;
		
		// init 3d
		private var updateTilt:int = 0;
		
		// away
		private var _$view:View3D;
		private var _$scene:Scene3D;
		private var _$camera:HoverCamera3D;
		private var _$camTarget:Sphere;

		// drag
		private var $map_ready:Boolean;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var lastCameraX:int;
		private var lastCameraY:int;
		
		// controller
		private var _$controller:Controller;
		
		// events
		private var $dispatcher:ClassDispatcher;

		
		public function ConfigMapScene()
		{ 
			init () 
		}
		private function init ():void
		{
			// events
			$dispatcher = ClassDispatcher.getInstance ();
			$dispatcher.addEventListener (ClassDispatcher.START_EVENTS, startAllEvents);
			$dispatcher.addEventListener (ClassDispatcher.STOP_EVENTS, stopAllEvents);
			
			// map controller
			_$controller = Controller.getInstance ();
			_$controller.$map_co.register_map = this;
			
			// stage center
			_$centerPoint = new Point (StageLocate.$stage.stage.stageWidth / 2, StageLocate.$stage.stage.stageHeight / 2);
			
			// scene 3d
			add_3DScene ();
			
			$map_ready = false;
		}
		private function add_3DScene ():void
		{
			// hover camera
			_$camera = new HoverCamera3D ();
			_$camera.panAngle = 180;
			_$camera.tiltAngle = updateTilt;
			_$camera.distance = 650
			_$camera.hover(true);
			
			var clipping:FrustumClipping = new FrustumClipping();
			
			
			// view
			_$view = new View3D ( { camera:_$camera, x:_$centerPoint.x , y:_$centerPoint.y } );
			_$view.clipping = clipping;
			_$view.mouseZeroMove = true
			addChild(_$view);
			
			// stats
			//addChild(new AwayStats(_$view));

			// target
			_$camTarget = new Sphere( { material:"red#black", radius:10 } );
			
			// init parameters (first target position);
			_$camTarget.y = 165;
			_$camTarget.x = 0;
			_$camTarget.z = 0;
			_$camTarget.visible = false;
			
			_$view.scene.addChild(_$camTarget);
			
			// look camera point
			_$camera.target = _$camTarget;
			_$camera.lookAt(_$camTarget.position);

			// add _$view 3d
			addChild(_$view);			

			// update stage
			addEventListener(Event.ENTER_FRAME, function ():void {
				_$camera.tiltAngle = updateTilt;
				_$camera.hover();
				_$view.render();
				
			});
			
			// stage listener 
			enabledStageListener ();
			
		}
		///////////////////////////////////////////////////// 
		private function startAllEvents(e:Event):void 
		{
			enabledStageListener ();
		}
		
		private function stopAllEvents(e:Event):void 
		{
			disabledStageListener ();
		}
		/////////////////////////////////////////////////////
		private function enabledStageListener ():void
		{
			// stage events
			// drag event
			trace("START STAGE")
			map_ready = true;
			StageLocate.$stage.stage.addEventListener (MouseEvent.MOUSE_UP, mouseUp);
			StageLocate.$stage.stage.addEventListener (MouseEvent.MOUSE_DOWN, mouseDown);
		}
		private function disabledStageListener ():void
		{
			// stage events
			// drag event
			trace("STOP STAGE")
			map_ready = false
			StageLocate.$stage.stage.removeEventListener (MouseEvent.MOUSE_UP, mouseUp);
			StageLocate.$stage.stage.removeEventListener (MouseEvent.MOUSE_DOWN, mouseDown);
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		// stage drag
		private function mouseUp (e:Event):void
		{
			target_stopDrag ();
		}
		private function mouseDown (e:Event):void
		{
			if (map_ready) {
				lastMouseX = StageLocate.$stage.stage.mouseX;
				lastMouseY = StageLocate.$stage.stage.mouseY;
				lastCameraX = -_$camera.target.x;
				lastCameraY = _$camera.target.y;
				
				StageLocate.$stage.stage.addEventListener(Event.MOUSE_LEAVE, target_stopDrag); 
				StageLocate.$stage.stage.addEventListener (MouseEvent.MOUSE_MOVE, target_startDrag);
				
				trace(e.target.name)
				switch (e.target.name) {
					case "startOver":
					case "stepBack":
					case "ZoomIn":
					case "ZoomOut":
					case "ZoomDefault":
					case "hitArea_btn":
					case "facebook_btn":
					case "tweet_btn":
					break;
					default:
					_$controller.$mouse_co.show_mouse ();
				}

			}else { trace("map it's not ready on scene") };
		}
		private function target_startDrag (e:Event):void
		{
			//Mouse.cursor = MouseCursor.HAND;
			
			switch (e.target.name) {
					case "startOver":
					case "stepBack":
					case "ZoomIn":
					case "ZoomOut":
					case "ZoomDefault":
					case "hitArea_btn":
					case "facebook_btn":
					case "tweet_btn":
					break;
					default:
					_$controller.$mouse_co.move_mouse ();
			}
			

			var cameraSpeed:* = 0.8;
			var x:* = cameraSpeed * (StageLocate.$stage.stage.mouseX - lastMouseX) + lastCameraX;
			var y:* = cameraSpeed * (StageLocate.$stage.stage.mouseY - lastMouseY) + lastCameraY;
			//
			_$camera.target.x = -x;
			_$camera.target.y = y;
		}
		private function target_stopDrag (e:Event=null):void 
		{
			//Mouse.cursor = MouseCursor.AUTO;
			if(e != null){
			switch (e.target.name) {
				case "startOver":
				case "stepBack":
				case "ZoomIn":
				case "ZoomOut":
				case "ZoomDefault":
				case "hitArea_btn":
				case "facebook_btn":
				case "tweet_btn":
				break;
				default:
				_$controller.$mouse_co.hide_mouse ();
			}}else {
				_$controller.$mouse_co.hide_mouse ();
			}
			
			
			//remove _$obContainer
			StageLocate.$stage.stage.removeEventListener (MouseEvent.MOUSE_MOVE, target_startDrag);
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		// stage zoom In / Out
		/* This events can be execute from (Map_co.as)
		 * 
		 * */
		public function target_zommOut ():void 
		{
			_$camera.target.moveDown (10);
		}
		public function target_zommIn ():void 
		{
			_$camera.target.moveUp (10);
		}
		public function target_zoomDefault ():void 
		{
			center_mapOn_group (_$controller.$map_co.register_group_onView[1]);
			
			//TweenLite.to (_$camera.target, .5, { x:0, y:0, ease:Quad.easeOut } );
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		// addPlane
		/* info:
		 * add an object to the ObjectContainer3D
		 * @name: used to register in to Model
		 * @material: if defined will include in to the plane3d ( sprite/movieclip )
		 * @p: aditional variables info to the plane3D
		 * */
		public function addPlane (name:String, material:MovieClip=null, p:Object=null):Object
		{
			var _$defaultMaterial:* = "white#red";
			
			// check if extra plane propertys exis
			if (p) {
			}
			// check if material exist
			if (material != null) {
				var m:MovieClip = material as MovieClip;
				var pm:MovieMaterial = new MovieMaterial (m, { precision:8, smooth:true, interactive:true, transparent:true } );

				
				//
				_$defaultMaterial = pm;
			}

			// 
			var _$itemContainer:Plane = new Plane ({material:_$defaultMaterial, rotationX:90});
			 // automatic get the w/h from material loaded
			_$itemContainer.width = (material!=null)?m.width:2000;
			_$itemContainer.height = (material != null)?m.height:2000;
			
			// propertys
			_$itemContainer.ownCanvas = true;
			_$itemContainer.pushback = true
			_$itemContainer.bothsides = false;
			
			// add the item to the 3d object container
			_$view.scene.addChild (_$itemContainer);

			
			// register item in Model
			_$controller.$map_co.add_OB3D ([name, { material:m, plane:_$itemContainer } ]);
			
			//
			return {material:m, plane:_$itemContainer};
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* info:
		 * 
		 * */
		public function block_click_group (group_id:String):void
		{
			// icons
			for each (var icon:* in _$controller.$map_co.register_map_icons) {
				if (icon.material.__groupId == group_id) {
					icon.material.block_click_action ()
				}
			}
		}
		public function unblock_click_group (group_id:String):void
		{
			// icons
			for each (var icon:* in _$controller.$map_co.register_map_icons) {
				if (icon.material.__groupId == group_id) {
					icon.material.unblock_click_action ()
				}
			}
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* info:
		 * Print Full Color image group
		 * @group_id:String = group to print, if @group_id = null, will print full color all the icons
		 * 
		 * */ 
		public function print_fullcolor_img_group (group_id:String=null):void
		{
			// img
			for each (var icon_img:* in _$controller.$map_co.register_map_icons_img) {
				if(group_id != null){
					if (icon_img.material.__groupId == group_id) {
						icon_img.material.enabled_btn ();
					}
				}else {
					icon_img.material.enabled_btn ();
				}
			}
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* info:
		 * Print Gray Color image group
		 * @group_id:String = group to print, if @group_id = null, will print gray color all the icons
		 * 
		 * */ 
		public function print_graycolor_img_group (group_id:String = null):void
		{
			// img
			for each (var icon_img:* in _$controller.$map_co.register_map_icons_img) {
				if(group_id != null){
					if (icon_img.material.__groupId == group_id) {
						icon_img.material.disabled_btn ();
					}
				}else {
					icon_img.material.disabled_btn ();
				}
			}
		} 
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* info:
		 * open and active the group
		 * */ 
		public function open_map_group (group_id:String):void
		{
			// img
			for each (var icon_img:* in _$controller.$map_co.register_map_icons_img) {
				if (icon_img.material.__groupId == group_id) {
					icon_img.material.print_white ();
				}
			}
			StageLocate.$stage.stage.quality = StageQuality.LOW;
			// icons
			var zIn:* = -55
			for each (var icon:* in _$controller.$map_co.register_map_icons) {
				if (icon.material.__groupId == group_id) {
					icon.plane.visible = true;
					
					if (icon.material.__groupId.indexOf("ex") != -1) {
						zIn = -20;
					}

					TweenLite.to (icon.plane, .5, { z: zIn, ease:Quad.easeOut } );
					TweenLite.to (icon.plane, .5, { delay:.1, rotationX: 170, onComplete:function ():void {StageLocate.$stage.stage.quality = StageQuality.BEST;} } );
				}
			}
		}
		public function close_map_group (group_id:String):void
		{
			// img
			for each (var icon_img:* in _$controller.$map_co.register_map_icons_img) {
				if (icon_img.material.__groupId == group_id) {

					if (icon_img.material.__groupId.indexOf("ex") != -1) {
						icon_img.plane.visible = false;
					}
					
					icon_img.material.delete_white ();
				}
			}
			
			// icons
			
			StageLocate.$stage.stage.quality = StageQuality.LOW;
			for each (var icon:* in _$controller.$map_co.register_map_icons) {
				if (icon.material.__groupId == group_id) {
					icon.plane.visible = false;
					TweenLite.to (icon.plane, 1, { z: 0, rotationX: 90, onComplete:function ():void {StageLocate.$stage.stage.quality = StageQuality.BEST;} } );
				}
			}
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* info:
		 * open and active the group
		 * Called from Map.as
		 * */ 
		public function center_mapOn_group (onSelected:String):void
		{
			trace("CENTER ON GROUP", onSelected);
			
			var ex_adjust:int;
			StageLocate.$stage.stage.quality = StageQuality.LOW;
			
			for each (var icon:* in _$controller.$map_co.register_map_icons) {
				if (icon.material.__groupId == onSelected) {
					
					ex_adjust = 0
					
					if (icon.material.__groupId.indexOf ("ex") != -1) {
						ex_adjust = 35;
					}
					
					var centerX:int = icon.plane.x + icon.material.__group_len + ex_adjust;
					TweenLite.to (_$camera.target, 1, { x:centerX, y:icon.plane.y, ease:Quad.easeOut, onComplete:function ():void {
						open_map_group (_$controller.$map_co.register_group_onView[1]);	StageLocate.$stage.stage.quality = StageQuality.BEST;
					} } );
					return;
				}
			}
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* info:
		 * open and active the group
		 * Called from Map.as
		 * */ 
		public function move_to_group (_groupId:String):void
		{
			
			StageLocate.$stage.stage.quality = StageQuality.LOW;
			trace("MOVE TO GROUP", _groupId);
			for each (var icon:* in _$controller.$map_co.register_map_icons) {
				if (icon.material.__groupId == _groupId) {
					var centerX:int = icon.plane.x + icon.material.__group_len;
					TweenLite.to (_$camera.target, 1, { x:centerX, y:icon.plane.y, ease:Quad.easeOut, onComplete:function ():void {StageLocate.$stage.stage.quality = StageQuality.BEST;} } );
					return;
				}
			}
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* info:
		 * print the map next to the icon
		 * */ 
		public function print_map (map_id:String):void
		{
			
			trace("PRINT MAP ROAD" + map_id);
			if (map_id != "") {
				
				var mapToPrint:MovieClip = _$controller.$map_co.get_register3D_object ("road")[1].material[map_id];

				mapToPrint.visible = true;
				TweenLite.to(mapToPrint, 1, { frame:21 } );

			}
			
			// if ( ex_ ) found = will open the road circles hided
			if (_$controller.$map_co.register_group_onView[1].indexOf("ex") != -1) {
				for each (var icon_img:* in _$controller.$map_co.register_map_icons_img) {
					if (icon_img.material.__groupId == _$controller.$map_co.register_group_onView[1]) {
						icon_img.plane.visible = true;
					}
				}
			}
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		/* info:
		 * 
		 * */ 
		public function close_map_road (map_id:String):void
		{
			trace("CLOSE MAP ROAD" + map_id);
			if (map_id != ""){
				
				var mapToClose:MovieClip = _$controller.$map_co.get_register3D_object ("road")[1].material[map_id];
				
				 TweenLite.to(mapToClose, 1, { frame:1, onComplete:function ():void { mapToClose.visible = false; }} );
			}
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		// utilities
		
		public function icons_img_alpha (value:int):void
		{
			if(_$controller.$map_co.register_map_icons_img != null) {
				for each (var icon_img:* in _$controller.$map_co.register_map_icons_img) {
					TweenLite.to(icon_img.material, 1, { alpha:value, ease:Quad.easeOut } );
				}
			}else { trace("icons not register yet") };
			
			if(_$controller.$map_co.register_map_icons != null) {
				for each (var icon:* in _$controller.$map_co.register_map_icons) {
					TweenLite.to(icon.material, 1, { alpha:value, ease:Quad.easeOut } );
				}
			}else { trace("icons not register yet") };
		}
		
		// alpha Object
		public function map_alpha (value:int):void
		{
			TweenLite.to(_$controller.$map_co.get_register3D_object("road")[1].material, 1, { alpha:value } );
		}
		
		// 
		public function cameraTaget_y (value:int):void
		{
			StageLocate.$stage.stage.quality = StageQuality.LOW;
			TweenLite.to(_$camera.target, 1, { y:value, ease:Quad.easeOut, onComplete:function ():void {StageLocate.$stage.stage.quality = StageQuality.BEST;} } );
		}
		public function cameraTaget_z (value:int):void
		{
			StageLocate.$stage.stage.quality = StageQuality.LOW;
			TweenLite.to(_$camera.target, 1, { z:value, ease:Quad.easeOut, onComplete:function ():void {StageLocate.$stage.stage.quality = StageQuality.BEST;} } );
		}
		
		// distance camera
		public function camera_distance (value:int):void
		{
			StageLocate.$stage.stage.quality = StageQuality.LOW;
			TweenLite.to(_$camera, 1, { distance:value, ease:Quad.easeOut, onComplete:function ():void {StageLocate.$stage.stage.quality = StageQuality.BEST;} } );
		}
		
		// zoom camera
		public function camera_zoom (value:int):void
		{
			StageLocate.$stage.stage.quality = StageQuality.LOW;
			TweenLite.to(_$camera, 1, { zoom:value, ease:Quad.easeOut, onComplete:function ():void {StageLocate.$stage.stage.quality = StageQuality.BEST;} } );
		}
		
		// tilt camera
		public function camera_tilt (value:int):void
		{
			updateTilt = value;
		}
		
		// block map drag event
		public function get map_ready():Boolean 
		{
			return $map_ready;
		}
		public function set map_ready(value:Boolean):void 
		{
			trace("set in ", value)
			$map_ready = value;
		}
	}
}