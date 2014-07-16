package com.digitalarbor.toyota.view.animation_vo 
{
	import com.greensock.*
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// event
	import com.digitalarbor.toyota.event.EventDelay_cn;
	import com.digitalarbor.toyota.event.ClassDispatcher;
	
	// asset
	import com.digitalarbor.toyota.library_assets.animation_mc;
	
	// omniture
	import com.digitalarbor.toyota.utilities.omniture.Ominure;

	public class Animation extends animation_mc 
	{
		private var $step:uint = 1;
		private var $reStart:Boolean = true;
		private var $reStartTimer:uint = 2000;
		private var $default_tween_time:uint = 1;
		
		private var $dispacth:ClassDispatcher;
		
		public function Animation ()
		{
			// event
			$dispacth = ClassDispatcher.getInstance ();
			$dispacth.addEventListener (ClassDispatcher.ANIMATION_CONTINUE, function ():void { animation_sequense () } );
			$dispacth.addEventListener (ClassDispatcher.TURN_ON_QUESTION, turn_on_question_2);
			$dispacth.addEventListener (ClassDispatcher.TURN_OFF_QUESTION, turn_off_question_2);
			
			$dispacth.addEventListener (ClassDispatcher.TURN_ON_QUESTION_RESULT, turn_on_question_3);
			$dispacth.addEventListener (ClassDispatcher.TURN_OFF_QUESTION_RESULT, turn_off_question_3);
			
			// question list on movieclip
			question_1.alpha = 0;
			question_2.alpha = 0;
			question_3.alpha = 0;

			// init animation sequense 
			animation_sequense ();
		}
		private function animation_sequense ():void
		{
			switch ($step) {
				case 1:
					//trace("step 1");
					question_1.x = 0
					question_1.y = -80;
					TweenMax.to(question_1, $default_tween_time, { alpha:1 } );
					
					// omniture
					Ominure.getInstance ().pageName = "GM:All Vehicles:Find Your Match:Home";
					Ominure.getInstance ().track_items( {
							
							channel:"GM:Find Your Match",
							
							prop10:"GM:Find Your Match",
							prop11:"GM:All Vehicles:Find Your Match",
							prop8: "GM:All Vehicles:Find Your Match:Home",
							
							eVar41:"GM:All Vehicles:Find Your Match:HomePage"
						
						});
					///////////
					
				break;
				case 2:
					trace("step 2");
					// appear background shcema
					$dispacth.dispatchEvent (new Event(ClassDispatcher.ANIM_ALPHA_IN_MAP));
				break;
				case 3:
					//trace("step 3");
					// reduce the title Size
					TweenMax.to(question_1, $default_tween_time, { y: -228, scaleX:.5, scaleY:.5 } );
					
					// reduce the map Size 
					$dispacth.dispatchEvent (new Event(ClassDispatcher.ANIM_ZOOM_OUT_MAP));

					//trace("whaiting for 1 second");
					var continueDelay:EventDelay_cn = new EventDelay_cn (3000, function ():void {
							animation_sequense ();
							continueDelay = null;
						});
					
					$reStart = false;
				break;
				case 4:
					//trace("step 4");
					TweenMax.to(question_1, $default_tween_time, { alpha:0 } );
					
					// dispatch event
					$dispacth.dispatchEvent (new Event(ClassDispatcher.TOP_SHADOW_ON));
					
					TweenMax.to(question_2, $default_tween_time, { delay:1, alpha:1 } );
					
					// show starthere add
						trace("whaiting for 1 second");
					var starthere_delay:EventDelay_cn = new EventDelay_cn (1000, function ():void {
						$dispacth.dispatchEvent (new Event(ClassDispatcher.SHOW_STARTHERE));
						starthere_delay = null;
					});
					
					// flip back the (3D) MAP and zoom In of MAP 
					$dispacth.dispatchEvent (new Event(ClassDispatcher.ANIM_ROTATE_MAP));
					
					// adjust starthere
					$dispacth.dispatchEvent(new Event(ClassDispatcher.ADJUST_STARTHERE));
					
					// stop animation whaiting for user interaction
					$reStart = false;
				break;
				case 5:
					//trace("step 5");
					//TweenMax.to(question_2, $default_tween_time, { alpha:0 } );

					// hide Starthere 
					$dispacth.dispatchEvent(new Event(ClassDispatcher.HIDE_STARTHERE));
					
					// show controls 
					$dispacth.dispatchEvent(new Event(ClassDispatcher.SHOW_CONTROLS));
					
					// show carrousel
					$dispacth.dispatchEvent(new Event(ClassDispatcher.CARRAOUSEL_ON));
				
				default :
				$reStart = false;
				$dispacth.removeEventListener (ClassDispatcher.ANIMATION_CONTINUE, function ():void { animation_sequense () } );
				//$step = 0;
			}
			
			// sequence
			$step++
			if($reStart){
				var sequense_delay:EventDelay_cn = new EventDelay_cn ($reStartTimer, function ():void {
					animation_sequense ();
					sequense_delay = null;
				});
			}
		}
		
		// turn back firstquestion
		private function turn_on_question_2 (e:Event):void
		{
			//trace("turn on question 2")
			TweenMax.to(question_2, $default_tween_time, { alpha:1 } );
		}
		private function turn_off_question_2 (e:Event):void
		{
			//trace("turn off question 2")
			TweenMax.to(question_2, $default_tween_time, { alpha:0 } );
		}
		
		// result question
		private function turn_on_question_3 (e:Event):void
		{
			//trace("turn on question 3")
			TweenMax.to(question_3, .5, { alpha:1 } );
		}
		private function turn_off_question_3 (e:Event):void
		{
			//trace("turn off question 3")
			TweenMax.to(question_3, .5, { alpha:0 } );
		}
	}
}