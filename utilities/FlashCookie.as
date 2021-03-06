package com.digitalarbor.toyota.utilities 
{
	import flash.net.SharedObject;
	
	public class FlashCookie 
	{
		private var _$toyota_cookie:SharedObject;

		private var _write_car_result:int = 3;
		private var _write_car_carrousel:int = 2;
		
		
				/////////////
		// 	singleton
		private static var instance:FlashCookie = null;
		public static function getInstance ():FlashCookie
		{
			if (instance == null) {
				instance = new FlashCookie();
			}
			return instance;
		}
		//
		public function FlashCookie() {init ();}
		private function init ():void
		{
			//
			create_cookie ();
		}
		private function create_cookie ():void
		{
			_$toyota_cookie = SharedObject.getLocal("toyota_2011_spark_microsite");
			trace("_$toyota_cookie " + _$toyota_cookie)
			//
			if (!chekIfExist("click_carrousel_counter") && !chekIfExist("click_resultPage_counter")) {
				_$toyota_cookie.data.click_carrousel_counter = 0;
				_$toyota_cookie.data.click_resultPage_counter = 0;
			}
		}
		//*******
		public function click_counter (value:String):Boolean
		{
			var onLimit:Boolean;
			var included:Boolean = false;
			var incrementCounter:int = 0;
			switch (value) {
				case "carrousel":
					trace("----------------------------- click_carrousel_counter",read_variable("click_carrousel_counter") )
					onLimit = (int(read_variable("click_carrousel_counter"))+1 > _write_car_carrousel)?true:false;
					if (!onLimit) {
						incrementCounter = int(read_variable("click_carrousel_counter")) + 1;
						trace("incrementCounter " + incrementCounter);
						write_variable ("click_carrousel_counter", incrementCounter );
						included = true;
					}
				break;
				case "resultPage":
					trace("----------------------------- click_resultPage_counter ",read_variable("click_resultPage_counter") )
					onLimit = (int(read_variable("click_resultPage_counter"))+1 > _write_car_result)?true:false;
					if (!onLimit) {
						incrementCounter = int(read_variable("click_resultPage_counter")) + 1;
						trace("incrementCounter " + incrementCounter);
						write_variable ("click_resultPage_counter", incrementCounter );
						included = true;
					}
				break;
			}
			
			return included;
		}
		public function write_variable (name:String, value:*):void
		{
			_$toyota_cookie.data[name] = value;
			_$toyota_cookie.flush ();
		}
		public function read_variable (name:String):*
		{
			return _$toyota_cookie.data[name];
		}
		//*******
		private function chekIfExist (value:String):Boolean
		{
			return  (_$toyota_cookie.data[value] != null)?true:false;
		}
		private function clear_cookie ():void
		{
			_$toyota_cookie.clear();
		}
	}
}