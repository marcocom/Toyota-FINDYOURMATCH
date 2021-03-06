package com.digitalarbor.toyota.controller 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	// tween
	import com.greensock.*
	
	// interface
	import com.digitalarbor.toyota.event.ClassDispatcher;
	import com.digitalarbor.toyota.view.map_vo.ConfigMapScene;
	import com.digitalarbor.toyota.model.Map_mo;
	import com.digitalarbor.toyota.model.Model;
	
	public class Map_co
	{
		private var $dispatcher:ClassDispatcher = ClassDispatcher.getInstance ();
		private var $map_model:Map_mo;
		private var $register_map:ConfigMapScene;
		
		////////////////////////////////////////////////
		public function Map_co () { init () };
		private function init ():void
		{
			// access
			$map_model = Model.getInstance ().$map_mo;
		}
		
		/////////
		/* info:
		 * register the 3D object add to the object container
		 * @value:
		 * [name, { material:m, plane:_$itemContainer } ]
		 * */
		public function add_OB3D (value:Array):void 
		{
			$map_model.ob3D_arr = value;
		};
		
		/////////
		/*
		 * config map register
		 * this variable come from ( ConfigMapScene.as )
		 * */
		public function set register_map (value:ConfigMapScene):void 
		{
			$register_map = value;
		}
		public function get register_map ():ConfigMapScene 
		{
			return $register_map;
		}
		/////////
		/*
		 * map zoomIN / zoomOUT / zoomDefault
		 * */
		public function zoomIn ():void 
		{
			if ($register_map != null) {
				$register_map.target_zommIn ();
			}
		}
		public function zoomOut ():void 
		{
			if ($register_map != null) {
				$register_map.target_zommOut ()
			}
		}
		public function zoomDefault ():void 
		{
			if ($register_map != null) {
				$register_map.target_zoomDefault ();
			}
		}

		/////////
		/* info:
		 * if @name:null = will return a string name list of register objects else
		 * retun an array [object name, {material , plane}]
		 * */ 
		public function get_register3D_object (name:String=null):*
		{
			var ob3D:* = "";
			if(name != null){
				ob3D = "object3D not register";
				for each (var ob:Array in $map_model.ob3D_arr) {
					if (ob[0] == name) { ob3D = ob;}
				}
			}
			else {
				var ONnames_arr:Array = [];
				for each (var ob_name:Array in $map_model.ob3D_arr) {
					ONnames_arr.push(ob_name[0]);
				}
				ob3D = ONnames_arr;
			}
			return ob3D;
		}
		/////////
		/* info:
		 * return the register icons on XML parser document ()
		 * */ 
		public function get_map_groups ():Array
		{
			return Model.getInstance ().$map_mo.$icons_arr;
		}
		////////
		/* info: register all the  loaded icons on to the map
		 * */ 
		public function set register_map_icons (value:Array):void
		{
			Model.getInstance ().$map_mo.map_icons_arr = value;
		}
		public function get register_map_icons ():Array
		{
			return Model.getInstance ().$map_mo.map_icons_arr;
		}
		
		////////
		/* info:
		 * register all the  loaded img on to the map
		 * */ 
		public function set register_map_icons_img (value:Array):void
		{
			Model.getInstance ().$map_mo.map_icons_img_arr = value;
		}
		public function get register_map_icons_img ():Array
		{
			return Model.getInstance ().$map_mo.map_icons_img_arr;
		}
		
		
		
		////////
		/* info:
		 * register the next groupOn View
		 * When user click on a option, this will register the next group to Open
		 * */ 
		public function set register_group_onView (value:Array):void
		{
			var add:Boolean;
			var register_group:Array = Model.getInstance ().$map_mo.user_selection_arr;
			
			// check if group doesn't exist to register
			if (register_group.length > 0) {
				add = true;
				for each (var group:Array in register_group) {
					if (group[0] == value[0]) {
						add = false;
						return;
					}
				}
				if (add) {
					Model.getInstance ().$map_mo.group_onView = value;
				}
			
			// first group to register
			}else { 
				Model.getInstance ().$map_mo.group_onView = value; };
		}
		
		
		public function get register_group_onView ():Array
		{
			return Model.getInstance ().$map_mo.group_onView;
		}
		
		////////
		/* info:
		 * This return an array with all the user selection
		 * 
		 * */ 
		public function get user_selection_arr ():Array
		{
			return Model.getInstance ().$map_mo.user_selection_arr;
		}
		
		////////
		/* info:
		 * delete the last array element and return the deleted item
		 * 
		 * */ 
		public function get update_selection_arr ():Array
		{
			return Model.getInstance ().$map_mo.update_user_selection_arr;
		}
		////////
		/* info:
		 * This return an array with all the user selection
		 * 
		 * */ 
		public function reset_user_selection_arr ():void
		{
			Model.getInstance ().$map_mo.reset_user_selection_arr ();
		}
		////////
		/* info:
		 * regist the id for the current question and build an array of the answers
		 * 
		 * */ 
		public function set_register_icon_id (value:String):void
		{
			var register_id:Array = Model.getInstance ().$map_mo.selected_icons_id;
			
			// if icon id already exist, will be not included in to the history arrayW
			if (register_id.indexOf (value) == -1) {
				
				// regist the item
				Model.getInstance ().$map_mo.selected_icons_id.push(value);

				// dispatch on MacMenu.as
				$dispatcher.dispatchEvent (new Event (ClassDispatcher.NEW_USER_ANSWER_UPDATED, false, true));
			}
		}
		public function get_register_icon_id ():Array
		{
			return Model.getInstance ().$map_mo.selected_icons_id;
		}
		public function update_register_icon_id ():void
		{
			return Model.getInstance ().$map_mo.update_selected_icons_id ();
		}
		////////
		/* info:
		 * regist the car selected by te user from carrousel and final cars display
		 * 
		 * */ 
		public function set selected_car_name (value:String):void
		{
			Model.getInstance ().$map_mo.selected_car_name = value;
		}
		public function get selected_car_name ():String
		{
			return Model.getInstance ().$map_mo.selected_car_name;
		}
		
	}
}