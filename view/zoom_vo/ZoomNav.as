package com.digitalarbor.toyota.view.zoom_vo 
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;

	// interface
	import com.digitalarbor.toyota.controller.Controller;
	import com.digitalarbor.toyota.library_assets.ZoomControls;
	import com.digitalarbor.toyota.event.ClassDispatcher;
	
	import com.greensock.*
	import com.greensock.easing.Quad;
	
	// omniture
	import com.digitalarbor.toyota.utilities.omniture.Ominure;

	public class ZoomNav extends ZoomControls
	{
		private var _$controller:Controller;
		private var $dispatcher:ClassDispatcher;
		
		public function ZoomNav ()
		{
			_$controller = Controller.getInstance();
			
			$dispatcher = ClassDispatcher.getInstance();
			$dispatcher.addEventListener (ClassDispatcher.SHOW_CONTROLS, show_controls);
			$dispatcher.addEventListener (ClassDispatcher.HIDE_CONTROLS, hide_controls);
			
			// this.ZoomIn
			// this.ZoomOut
			// this.ZoomDefault
			this.alpha = 0;
		}
		private function enabled_btn ():void
		{
			for (var i:int; i < this.numChildren; i++ ) {
				var item_btn:* = this.getChildAt(i);
				item_btn.buttonMode = true;
				item_btn.addEventListener (MouseEvent.MOUSE_DOWN, downHandlerFromControl);
				item_btn.addEventListener (MouseEvent.MOUSE_UP, removeEvent);
				item_btn.addEventListener (MouseEvent.MOUSE_OUT, removeEvent);
			}
		}
		private function disabled_btn ():void
		{
			for (var i:int; i < this.numChildren; i++ ) {
				var item_btn:* = this.getChildAt(i);
				item_btn.buttonMode = false;
				item_btn.removeEventListener (MouseEvent.MOUSE_DOWN, downHandlerFromControl);
				item_btn.removeEventListener (MouseEvent.MOUSE_UP, removeEvent);
				item_btn.removeEventListener (MouseEvent.MOUSE_OUT, removeEvent);
			}
		}
		private function removeEvent(e:MouseEvent):void 
		{
			switch (e.currentTarget.name) {
				case "ZoomIn":
					this.removeEventListener(Event.ENTER_FRAME, zoomIn);
				break;
				case "ZoomOut":
					this.removeEventListener(Event.ENTER_FRAME, zoomOut);
				break;
			}
		}
		private function downHandlerFromControl(e:MouseEvent):void 
		{
			switch (e.currentTarget.name) {
				case "ZoomIn":
					this.addEventListener(Event.ENTER_FRAME, zoomIn);
					
					// omniture
					Ominure.getInstance ().pageName = "";
					Ominure.getInstance ().tracklink_items( {

						// custom obj variables
						prop14:"GM:All Vehicles:Find Your Match:Subsequent Questions:Zoom In button"

					},{

						// variables of custom link
						lnk_o:"o",
						pev2:"Tcom_Find Your Match_Subsequent Questions_Zoom In button"

					});
					///////////
				break;
				case "ZoomOut":
				Ominure.getInstance ().pageName = "";
					this.addEventListener(Event.ENTER_FRAME, zoomOut);
					
					// omniture
					Ominure.getInstance ().tracklink_items( {

						// custom obj variables
						prop14:"GM:All Vehicles:Find Your Match:Subsequent Questions:Zoom Out button"

					},{

						// variables of custom link
						lnk_o:"o",
						pev2:"Tcom_Find Your Match_Subsequent Questions_Zoom Out button"

					});
					///////////
				break;
				case "ZoomDefault":
					_$controller.$map_co.zoomDefault ();
				break;
			}
		}
		private function zoomIn (e:Event):void
		{
			_$controller.$map_co.zoomIn ();
		}
		private function zoomOut (e:Event):void
		{
			_$controller.$map_co.zoomOut ();
		}
		public function show_controls(e:Event = null):void 
		{
			enabled_btn ();
			TweenLite.to(this, 1, { alpha:1, ease:Quad.easeOut } );
		}
		public function hide_controls(e:Event = null):void 
		{
			disabled_btn ();
			TweenLite.to(this, 1, { alpha:0, ease:Quad.easeOut } );
		}
	}
}