package com.digitalarbor.toyota.controller 
{
	import com.digitalarbor.toyota.model.Model;
	import com.digitalarbor.toyota.controller.Map_co;
	import com.digitalarbor.toyota.event.ClassDispatcher;
	import com.digitalarbor.toyota.utilities.XML_loader.XmlLoader;
	
	public class Controller 
	{
		public var $model:Model;
		public var $user_center_info:UserCenterInfo_co;
		public var $map_co:Map_co;
		public var $share_co:Share_co;
		public var $cars_co:Cars_co;
		public var $mouse_co:Mouse_co;
		public var $click_counter_co:Click_counter_co;
		

		/////////////
		// 	singleton
		private static var instance:Controller = null;
		public static function getInstance ():Controller 
		{
			if (instance == null) {
				instance = new Controller();
			}
			return instance;
		}
		//
		public function Controller() { init (); }
		private function init ():void
		{
			$model = Model.getInstance ();
			$user_center_info = new UserCenterInfo_co ();
			$map_co = new Map_co ();
			$share_co = new Share_co ();
			$cars_co = new Cars_co ();
			$mouse_co = new Mouse_co ();
			$click_counter_co = new Click_counter_co ();
		}
		////////////////////////////////////////////////////////////////////////////
		///// SERVICES
		public function request_xml_info (area:String, value:String):void
		{
			var loadXML:XmlLoader;
			
			trace("NEW REQUEST ", area, value)
			switch (area) {
				case "map_icons":
					loadXML = new XmlLoader(value, $model.$map_mo.xml_icons_parse);
				break
			}
		}
	}
}