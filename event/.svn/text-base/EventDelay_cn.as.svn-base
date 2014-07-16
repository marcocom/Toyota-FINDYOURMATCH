package com.digitalarbor.toyota.event
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class EventDelay_cn extends Timer
	{
		private var $userMethod:Function;
		
		public function EventDelay_cn(delay:Number, userMethod:Function) 
		{
			super(delay, 1);
			
			$userMethod = userMethod;
			
			this.addEventListener(TimerEvent.TIMER_COMPLETE, executeMethod);
			this.start ();
		}
		private function executeMethod (e:TimerEvent):void
		{
			$userMethod ();
		}
		public function stopTimer ():void
		{
			this.stop ();
		}
	}

}