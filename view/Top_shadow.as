package com.digitalarbor.toyota.view 
{
	import flash.events.Event;
	
	import com.greensock.*
	
	import com.digitalarbor.toyota.event.ClassDispatcher;
	
	// asset
	import com.digitalarbor.toyota.library_assets.top_shadow_mc;
	
	public class Top_shadow extends top_shadow_mc 
	{
		private var $dispatcher:ClassDispatcher;
		
		public function Top_shadow() 
		{
			alpha = 0;
			
			$dispatcher = ClassDispatcher.getInstance ();
			$dispatcher.addEventListener (ClassDispatcher.TOP_SHADOW_ON, showTopShadow);
		}	
		public function showTopShadow (e:Event) :void
		{
			TweenMax.to(this, 1.5, { alpha:1 } );
		}
		public function hideTopShadow (e:Event) :void
		{
			TweenMax.to(this, 1.5, { alpha:0 } );
		}
	}
}