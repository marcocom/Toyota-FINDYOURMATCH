package com.digitalarbor.toyota.utilities.omniture 
{
	/*
	 * Omniture Class
	 * This class will need the library (interface_omniture.swc)
	 * 
	 * 
	 * */
	
	// omniture base class
	import com.omniture.ActionSource;
	
	// assets
	import com.digitalarbor.toyota.utilities.SWFInfo;
	
	public class Ominure
	{
		private var s:ActionSource;
		private var obj:Object;
		
		/////////////
		// 	singleton
		private static var instance:Ominure = null;
		public static function getInstance ():Ominure 
		{
			if (instance == null) {
				instance = new Ominure();
			}
			return instance;
		}
		////////////
		public function Ominure() {
			s = new ActionSource ();
			//
			configActionSource();
		}
		private function configActionSource():void
		{


			/* Specify the Report Suite ID(s) to track here */

			/**
			 * @SERVER
			 * if ( local server ("devtoyota"))
			 * if ( live server ("tmstoyota"))
			 * 
			 * if not defined, will send the variables to devtoyota
			 * */
			var server:String = SWFInfo.getInstance ().flashvars["omniture_server"];
			trace("omniture_server", server);
			s.account = (server != null)?server:"devtoyota";


			/* You may add or alter any code config here */
			/*
			 * pageName variable are defined in
			 * Animation.as
			 * AddToStage.as
			 * 
			 * 
			 * */
			
			s.pageName = "";
			
			s.pageURL = "";

			s.charSet = "UTF-8";
			s.currencyCode = "USD";

			/* Turn on and configure ClickMap tracking here */
			s.trackClickMap = true;
			s.movieID = "";


			/* Turn on and configure debugging here */
			s.debugTracking = true;
			s.trackLocal = false;

			/* WARNING: Changing any of the below variables will cause drastic changes
			to how your visitor data is collected.  Changes should only be made
			when instructed to do so by your account manager.*/
			s.dc = "112";
			s.trackingServer="metrics.toyota.com";
			s.trackingServerSecure="smetrics.toyota.com";
		}
		
		
		
		// omni utilities
		public function track_items (_obj:Object) :void
		{
			obj = _obj;
			if (collect_info ()) {
				// send to the server
				s.track ();
			};
			
			clean_info ();
			obj = null;
		}
		public function tracklink_items (obj_custom:Object, obj_tracklink:Object) :void
		{
			obj = obj_custom;
			if (collect_info ()) {
				// send to the server
				
				var linkType:String = (obj_tracklink.lnk_o != null)?obj_tracklink.lnk_o:"o";
				var linkTrack:String = (obj_tracklink.pev2 != null)?obj_tracklink.pev2:"null";
				
				s.trackLink (SWFInfo.getInstance().swf_URL, linkType, linkTrack);
			};
			
			clean_info ();
			obj = null;
		}
		//
		private function collect_info ():Boolean
		{
			// collect the omni OBJ
			for (var value:String in obj) {
				s[value] = obj[value];
			}
			
			// for now always be true
			return true;
		}
		private function clean_info ():void
		{
			s.clearVars ();
		}
		
		
		///////////////////////////////////////////////////
		public function get pageName():String
		{
			return s.pageName;
		}
		public function set pageName(value:String):void
		{
			s.pageName = value;
		}
		
	}
}