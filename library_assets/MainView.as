package com.digitalarbor.toyota.library_assets 
{
	import flash.display.Sprite;
	import flash.events.Event;

	import com.greensock.*
	import com.greensock.easing.Quad;
	
	import com.digitalarbor.toyota.event.ClassDispatcher;

	public dynamic class MainView extends Sprite
	{
		private var $dispatcher:ClassDispatcher;
		
		public function MainView() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			this.visible = false;
		}
		public function init(e:Event = null):void 
		{	
			$dispatcher = ClassDispatcher.getInstance();
			$dispatcher.addEventListener (ClassDispatcher.SHOW_CONTROLS, show_controls);
			$dispatcher.addEventListener (ClassDispatcher.HIDE_CONTROLS, hide_controls);

			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function show_controls(e:Event = null):void 
		{
			this.visible = true;
			this.alpha = 0;
			TweenLite.to(this, 1, { alpha:1, ease:Quad.easeOut } );
		}
		public function hide_controls(e:Event = null):void 
		{
			TweenLite.to(this, 1, { alpha:0, ease:Quad.easeOut, onComplete:function ():void {this.visible = false;} } );
		}
	}
}