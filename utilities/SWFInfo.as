package com.digitalarbor.toyota.utilities 
{
	// asset
	import com.digitalarbor.toyota.utilities.StageLocate;
	
	public class SWFInfo
	{
		private var $flashvars:Object;
		
		/////////////
		// 	singleton
		private static var instance:SWFInfo = null;
		public static function getInstance ():SWFInfo 
		{
			if (instance == null) {
				instance = new SWFInfo();
			}
			return instance;
		}
		public function SWFInfo()
		{
			// store the flashvar object
			$flashvars = StageLocate.$stage.stage.loaderInfo.parameters;
	
			// debug
			trace("/////////////////FLASHVARS///////////////////");
			for (var fv:* in $flashvars) {
				trace(fv+":",$flashvars[fv])
			}
			trace("/////////////////////////////////////////////\n");
		}
		
		public function get flashvars():Object 
		{
			return $flashvars;
		}
		
		public function get swf_URL():String
		{
			return StageLocate.$stage.stage.loaderInfo.url;
		}
	}
}