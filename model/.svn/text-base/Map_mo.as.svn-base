package com.digitalarbor.toyota.model 
{
	import flash.events.Event;

	// interface
	import com.digitalarbor.toyota.event.ClassDispatcher;
	import com.digitalarbor.toyota.view.map_vo.IconOB_img;
	
	public class Map_mo
	{
		private var $dispatcher:ClassDispatcher;
		
		public var $icons_xml:XML;
		public var $icons_arr:Array;
		
		// map
		private var $group_OB3D_arr:Array 		= [];
		private var $map_icons_arr:Array 		= [];
		private var $map_icons_img_arr:Array 	= [];
		private var $group_onView:Array			= [];
		private var $selected_icons_id:Array	= [];
		
		//
		private var $selected_car_name:String	= "";
		
		// history
		private var $user_selection_arr:Array = [];
		
		public function Map_mo() { init () };
		private function init ():void 
		{
			$dispatcher = ClassDispatcher.getInstance (); 
		};
		////////////////////////////////////////////////////////////////////////////
		///// SERVICES
		public function xml_icons_parse (xml:XML):void
		{
			$icons_xml = xml;
			$icons_arr = [];
			
			for each(var group:XML in xml..group)
			{
				// group container
				var group_arr:Array = [];
				
				var group_len:int = (group..item.length () * 50) / 2;

				for each (var item:XML in group..item) 
				{
					//
					var iconinfo:Object = new Object ();
					iconinfo.__groupId = group.@id;
					iconinfo.__id = item.@id;
					iconinfo.__printMap = item.@printMap;
					iconinfo.__onSelected = item.@onSelected;
					iconinfo.__title = item.title.text();
					iconinfo.__description = item.description
					iconinfo.__tooltip_point = item.description.@tooltip_point;
					iconinfo.__iconPath = item.icon.text();
					iconinfo.__imgPath = item.img.text();
					iconinfo.__group_len = group_len;
					iconinfo.__x = parseFloat(group.@x.toString());
					iconinfo.__y = parseFloat(group.@y.toString());
					//
					
					// add an icon to the group container
					group_arr.push(iconinfo);
				}
				
				// register
				$icons_arr.push (group_arr);
			}
			
			// dispatch
			// dispatch on Map.as
			$dispatcher.dispatchEvent (new Event (ClassDispatcher.ICON_PARSE_READY));
		}
		////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////
		public function set ob3D_arr (value:Array):void { $group_OB3D_arr.push(value); };
		public function get ob3D_arr ():Array { return $group_OB3D_arr; };
		
		public function set map_icons_arr (value:Array):void { $map_icons_arr = value; };
		public function get map_icons_arr ():Array { return $map_icons_arr; };
		
		public function set map_icons_img_arr (value:Array):void { $map_icons_img_arr = value; };
		public function get map_icons_img_arr ():Array { return $map_icons_img_arr; };
		
		public function get group_onView():Array { return $group_onView; }
		public function set group_onView(value:Array):void { 

			// current user selection
			$group_onView = value; 
			
			// history user selection questions
			$user_selection_arr.push ($group_onView);
		}
		
		public function get user_selection_arr ():Array { return $user_selection_arr };
		public function reset_user_selection_arr ():void { $user_selection_arr = [] };
		
		public function get update_user_selection_arr ():Array { 
			
			// delete the last added intem
			var remove:Array = $user_selection_arr.pop();
			
			// update current view
			$group_onView = $user_selection_arr[$user_selection_arr.length - 1];
			
			return remove };
		
		/*
		 * Selected icons (answers) by the user register
		 * */
		public function get selected_icons_id():Array { return $selected_icons_id; }
		
		public function update_selected_icons_id():void{ $selected_icons_id.pop (); }
		
		////////
		/* info:
		 * regist the car selected by te user from carrousel and final cars display
		 * 
		 * */ 
		public function get selected_car_name():String 
		{
			return $selected_car_name;
		}
		
		public function set selected_car_name(value:String):void 
		{
			$selected_car_name = value;
		}
		

	}
}