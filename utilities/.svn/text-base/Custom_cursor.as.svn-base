package com.digitalarbor.toyota.utilities
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.events.MouseEvent;
	import hand_mc;
	
	import com.digitalarbor.toyota.controller.Controller;
	
	public class Custom_cursor extends Sprite 
	{
		private var _$hand:Sprite;

		public function Custom_cursor() { 
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init (e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point

			// register in model
			Controller.getInstance().$mouse_co.mouseClass = this;
			
		}
		public function up_handler():void 
		{
			if (_$hand != null) {
				_$hand.x = mouseX;
				_$hand.y = mouseY;
				removeChild(_$hand);
				_$hand = null;
			}
			
			Mouse.show ();
		}
		public function down_handler():void 
		{
			Mouse.hide ();
			
			_$hand = new hand_mc ();
			_$hand.x = mouseX;
			_$hand.y = mouseY;
			addChild(_$hand);
		}
		public function move_handler():void 
		{
			_$hand.x = mouseX;
			_$hand.y = mouseY;
		}
	}
}