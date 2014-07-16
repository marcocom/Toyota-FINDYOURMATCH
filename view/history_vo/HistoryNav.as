package com.digitalarbor.toyota.view.history_vo 
{
	import com.digitalarbor.toyota.controller.Controller;
	import com.digitalarbor.toyota.event.ClassDispatcher;
	import com.digitalarbor.toyota.library_assets.history_nav_mc;
	import com.digitalarbor.toyota.utilities.omniture.Ominure;
	import com.digitalarbor.toyota.view.map_vo.ConfigMapScene;
	import com.greensock.*;
	import com.greensock.easing.Quad;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class HistoryNav extends history_nav_mc
	{
		
		private var $controller:Controller;
		private var $dispatcher:ClassDispatcher;
		private var $map:ConfigMapScene;
		private var $icons:HistoryIconsContainer;
		
		private var timer_back:Timer;
		
		public function HistoryNav()
		{
			$controller = Controller.getInstance ();
			
			$dispatcher = ClassDispatcher.getInstance();
			$dispatcher.addEventListener (ClassDispatcher.SHOW_CONTROLS, show_controls);
			$dispatcher.addEventListener (ClassDispatcher.HIDE_CONTROLS, hide_controls);
			
			$icons = new HistoryIconsContainer(this);
			this.addChild($icons);
			$icons.addEventListener(ClassDispatcher.OPEN_GROUP, _stepBack);
			
			this.alpha = 0;
		}
		private function enabled_btn ():void
		{
			// properties
			startOver.buttonMode = true;
			startOver.addEventListener (MouseEvent.CLICK, clickHandler);
			startOver.addEventListener (MouseEvent.ROLL_OVER, rolloverHandler);
			startOver.addEventListener (MouseEvent.ROLL_OUT, rolloutHandler);
			
			stepBack.buttonMode = true;
			stepBack.addEventListener (MouseEvent.CLICK, clickHandler);
			stepBack.addEventListener (MouseEvent.ROLL_OVER, rolloverHandler);
			stepBack.addEventListener (MouseEvent.ROLL_OUT, rolloutHandler);
		}
		private function disabled_btn ():void
		{
			// properties
			startOver.buttonMode = false;
			startOver.removeEventListener (MouseEvent.CLICK, clickHandler);
			startOver.removeEventListener (MouseEvent.ROLL_OVER, rolloverHandler);
			startOver.removeEventListener (MouseEvent.ROLL_OUT, rolloutHandler);
			
			stepBack.buttonMode = false;
			stepBack.removeEventListener (MouseEvent.CLICK, clickHandler);
			stepBack.removeEventListener (MouseEvent.ROLL_OVER, rolloverHandler);
			stepBack.removeEventListener (MouseEvent.ROLL_OUT, rolloutHandler);
		}
		private function clickHandler (e:MouseEvent):void
		{
			if($controller.$map_co.user_selection_arr.length > 1) {
				switch (e.currentTarget.name) {
					case "startOver":
					
						// prevent double set
						if (timer_back == null){
							// init step back
							_stepBack ();
						
							// automatic movement
							timer_back = new Timer (500, 0);
							timer_back.addEventListener (TimerEvent.TIMER, _stepBack);
							timer_back.start ();
						} else { trace("automatic history, waiting for finish proccess") };
						
						// omniture
						Ominure.getInstance ().pageName = "";
						Ominure.getInstance ().tracklink_items( {

							// custom obj variables
							prop46:"GM:All Vehicles:Find Your Match:Subsequent Questions:Start Over"
							
						},{

							// variables of custom link
							lnk_o:"o",
							pev2:"Tcom_Find Your Match_Subsequent Questions_Start Over Button"

						});
						///////////
						
					break;
					case "stepBack":
						_stepBack ();
						
						// omniture
						Ominure.getInstance ().pageName = "";
						Ominure.getInstance ().tracklink_items( {

							// custom obj variables
							prop14:"GM:All Vehicles:Find Your Match:Subsequent Questions:Step Back"
							
						},{

							// variables of custom link
							lnk_o:"o",
							pev2:"Tcom_Find Your Match_Subsequent Questions_Step Back Button"

						});
						///////////
					break;
				}
			} else { trace("Start Over / Step Back disabled"); };
		}
		private function rolloverHandler (e:MouseEvent):void
		{
		}
		private function rolloutHandler (e:MouseEvent):void
		{
		}
		//////////////////////////////////////////
		private function _stepBack (e:Event = null):void
		{
			//trace("step back")
			var $map:ConfigMapScene = $controller.$map_co.register_map;
			
			
			if ($controller.$map_co.user_selection_arr.length > 1) {
				
				// group on View
				var deletedItem:Array = $controller.$map_co.update_selection_arr;
				var total_register_selections:int = $controller.$map_co.user_selection_arr.length;
				var itemToMove:Array = $controller.$map_co.user_selection_arr[total_register_selections - 1];
				//
				if (itemToMove[1] != null) {
					
					// return to previous register group
					$map.move_to_group(itemToMove[1]);
					
					// open again previous group
					$map.open_map_group (itemToMove[1]);
					//$map.print_graycolor_img_group (itemToMove[1]);
				}
				if (itemToMove[1] == "central_group") {
					$map.unblock_click_group ("central_group");
					
					// block drag map
					$map.map_ready = false;
					
					// turn on the first question
					// executed in Animation.as
					$dispatcher.dispatchEvent (new Event (ClassDispatcher.TURN_ON_QUESTION));
					
					// start here on
					// executed in StartHere.as
					$dispatcher.dispatchEvent (new Event (ClassDispatcher.SHOW_STARTHERE));
					
					//
					$dispatcher.dispatchEvent (new Event (ClassDispatcher.HIDE_CONTROLS));
					
					// hide the Carrousel
					//$dispatcher.dispatchEvent (new Event (ClassDispatcher.TURN_OFF_ALLCARS))
					$dispatcher.dispatchEvent (new Event (ClassDispatcher.CARRAOUSEL_OFF));
				}
				
				if (deletedItem[1] != "central_group") {
					$map.close_map_group (deletedItem[1]);
					$map.close_map_road (deletedItem[2]);
					$map.print_graycolor_img_group (deletedItem[1]);
					
					if (deletedItem[1].indexOf("ex") != -1) {
						// block drag map
						$map.map_ready = true;
						
						// show final question
						// executes in Animation.as
						$dispatcher.dispatchEvent (new Event(ClassDispatcher.TURN_OFF_QUESTION_RESULT));
						
						// show carrousel
						$dispatcher.dispatchEvent (new Event(ClassDispatcher.CARRAOUSEL_ON));
						
						
					}
					
					// icons ids register update
					// array.pop (); on model
					$controller.$map_co.update_register_icon_id ();
					$dispatcher.dispatchEvent (new Event (ClassDispatcher.NEW_USER_ANSWER_UPDATED, false, true));
				}

			} else {
				timer_back.stop ();
				timer_back = null;
			}
		}
		public function show_controls(e:Event = null):void 
		{
			
			
			enabled_btn ();
			TweenLite.to(this, 1, { alpha:1, ease:Quad.easeOut } );
		}
		public function hide_controls(e:Event = null):void 
		{
			
			
			disabled_btn ();
			TweenLite.to(this, 1, { alpha:0, ease:Quad.easeOut} );
		}
	}
}