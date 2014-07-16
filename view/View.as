package com.digitalarbor.toyota.view 
{	
	import flash.display.Sprite;
	import flash.events.Event;
	
	//
	import com.digitalarbor.toyota.utilities.StageLocate;
	import com.digitalarbor.toyota.utilities.Custom_cursor;
	import com.digitalarbor.toyota.view.Background;
	import com.digitalarbor.toyota.view.map_vo.Map;
	import com.digitalarbor.toyota.view.Top_shadow;
	import com.digitalarbor.toyota.view.Logos;
	import com.digitalarbor.toyota.view.share_vo.ShareIcons;
	import com.digitalarbor.toyota.view.animation_vo.Animation;
	import com.digitalarbor.toyota.view.history_vo.HistoryNav;
	import com.digitalarbor.toyota.view.zoom_vo.ZoomNav;
	import com.digitalarbor.toyota.view.starthere_vo.StartHere;
	import com.digitalarbor.toyota.view.carrousel.Carrousel;
	import com.digitalarbor.toyota.view.cid_vo.Cid_form;
	import com.digitalarbor.toyota.event.ClassDispatcher;

	public class View extends Sprite
	{
		// interface
		public var background:Background;
		public var custom_cursor:Custom_cursor;
		public var mapContainer:Map;
		public var carrousel:Carrousel
		public var top_shadow:Top_shadow;
		public var toyota_logo:Logos;
		public var shareIcons:ShareIcons;
		public var history_nav:HistoryNav;
		public var zoom_nav:ZoomNav;
		public var startHere:StartHere;
		public var cid_form:Cid_form;
		
		// animation
		public var animation:Animation;
		
		//
		private var $dispatcher:ClassDispatcher;
		
		public function View ()
		{
			init ();
		}	
		private function init ():void
		{
			// interface
			initInterface ();
			
			$dispatcher = ClassDispatcher.getInstance ();
			$dispatcher.addEventListener (ClassDispatcher.START_ANIMATION, initAnimation);
			
			// animation 
			//initAnimation ();
		}
		private function initInterface ():void
		{
			background = new Background ();
			addChild (background);

			top_shadow = new Top_shadow ();
			addChild (top_shadow);
			
			mapContainer = new Map ();
			addChild (mapContainer);
			
			carrousel = new Carrousel ();
			addChild (carrousel);
			
			startHere = new StartHere ();
			addChild (startHere);

			history_nav = new HistoryNav ();
			addChild (history_nav);
			history_nav.x = 16; 
			history_nav.y = 70
			
			zoom_nav = new ZoomNav();
			addChild(zoom_nav);
			zoom_nav.x = 16; 
			zoom_nav.y = 130	

			shareIcons = new ShareIcons ();
			addChild (shareIcons);
			
			toyota_logo = new Logos ();
			addChild (toyota_logo);
			
			custom_cursor = new Custom_cursor ()
			addChild(custom_cursor);
		}	
		private function initAnimation (e:Event=null):void
		{
			animation = new Animation ();
			addChild (animation);
			
			animation.x = StageLocate.$stage.stage.stageWidth / 2;
			animation.y = StageLocate.$stage.stage.stageHeight / 2;
			
			cid_form = new Cid_form ();
			addChild (cid_form);
		}
	}
}