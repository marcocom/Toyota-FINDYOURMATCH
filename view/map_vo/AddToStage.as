package com.digitalarbor.toyota.view.map_vo 
{	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// assets
	import com.digitalarbor.toyota.controller.Controller;
	import com.digitalarbor.toyota.event.ClassDispatcher;
	import com.digitalarbor.toyota.view.map_vo.IconOB_img;
	import com.digitalarbor.toyota.view.map_vo.IconOB_anim;
	import com.digitalarbor.toyota.view.map_vo.IconOB_result;
	
	// omniture
	import com.digitalarbor.toyota.utilities.omniture.Ominure;

	public class AddToStage 
	{
		private var $map:ConfigMapScene;
		private var $controller:Controller;

		private var $dispatcher:ClassDispatcher;
		
		private var $icons_arr:Array = [];
		private var $icons_img_arr:Array = [];
		
		private var $firstQuestion:Boolean = true;
		
		public function AddToStage(addTo:ConfigMapScene)
		{
			//
			$controller = Controller.getInstance ();
			$dispatcher = ClassDispatcher.getInstance ();
			//
			$map = addTo;
			
			//
			add_img ();
			add_anim ();
		}
		private function add_img ():void
		{
			var groups_img_arr:Array = $controller.$map_co.get_map_groups ();
			var groups_img_len:uint = groups_img_arr.length;
			
			var iconCounter:uint = 0;
			var iconDistance:uint = 0;
			
			//
			for each (var group:Array in groups_img_arr)
			{
				// reset
				iconDistance = 0;
				
				for each (var icon_info:* in group) {
					
					var distance:* = 76;
					var iconScaleDefault:* = 0.7;
					var iconVisibleDefault:* = true;
					
					// static img
					var iconOB_img:Object = $map.addPlane ("icon_img_" + iconCounter++, new IconOB_img());
					
					// icon info
					iconOB_img.material.__groupId = icon_info.__groupId;
					iconOB_img.material.__id = icon_info.__id;
					iconOB_img.material.__imgPath = icon_info.__imgPath;
					
					if (icon_info.__groupId.indexOf("ex") != -1) {
						
						distance = 110
						iconScaleDefault = 1;
						iconVisibleDefault = false;
					}
					
					
					//icon position
					iconOB_img.plane.x = icon_info.__x + iconDistance;
					iconDistance += distance;
					
					iconOB_img.plane.y = icon_info.__y;
					
					// icon init params
					iconOB_img.plane.z = 0;
					iconOB_img.plane.scale(iconScaleDefault);

					// icon material alpha
					iconOB_img.material.alpha = 0;
					
					// icon material alpha
					iconOB_img.plane.visible = iconVisibleDefault;

					// init Icon
					iconOB_img.material.init();
					
					// register icon (internal)
					$icons_img_arr.push (iconOB_img);
				}
				
			}
				// register on Model <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<moved by marcocom from inner loop.
				$controller.$map_co.register_map_icons_img = $icons_img_arr;
		}
		
		// animations
		private function add_anim ():void
		{
			var groups_arr:Array = $controller.$map_co.get_map_groups ();
			var groups_len:uint = groups_arr.length;
			
			var iconCounter:uint = 0;
			var iconDistance:int = -10;
			
			//
			for each (var group:Array in groups_arr)
			{
				// reset
				iconDistance = -10;
				var distance:* = 80;
				var iconScaleDefault:* = 0.7;
				var iconZ:* = 5
				
				for each (var icon_info:* in group) {
					
					var iconOB:*
					if (icon_info.__groupId.indexOf("ex") != -1) {
						
						distance = 115;
						iconScaleDefault = .4;
						
						iconOB = new IconOB_result ();
						
					} else {
						
						iconOB = new IconOB_anim();
						
					}

					// icon
					var iconOB_anim:Object = $map.addPlane ("icon_anim_" + iconCounter++, iconOB);

					//icon position
					iconOB_anim.plane.x = icon_info.__x+10 + iconDistance;
					iconDistance += distance;
					
					iconOB_anim.plane.y = icon_info.__y;
					
					// icon init params
					iconOB_anim.plane.z = -10;
					iconOB_anim.plane.scale(iconScaleDefault);
					
					// icon material alpha
					iconOB_anim.plane.visible = false;
					
					// icon info
					iconOB_anim.material.__groupId = icon_info.__groupId;
					iconOB_anim.material.__onSelected = icon_info.__onSelected;
					iconOB_anim.material.__id = icon_info.__id;
					iconOB_anim.material.__printMap = icon_info.__printMap
					iconOB_anim.material.__iconPath = icon_info.__iconPath;
					iconOB_anim.material.__title = icon_info.__title;
					iconOB_anim.material.__description = icon_info.__description;
					iconOB_anim.material.__group_len = icon_info.__group_len;
					
					if (icon_info.__groupId.indexOf("ex") != -1) {
						iconOB_anim.material.__tooltip_point = icon_info.__tooltip_point;
					}
										
					iconOB_anim.material.__hitButton = function (e:MouseEvent):void {

							// omniture
							Ominure.getInstance ().pageName = "";
							Ominure.getInstance ().tracklink_items( {
								
								// custom obj variables
								prop46:"GM:All Vehicles:Find Your Match:Questions:User Click"

							},{
								
								// variables of custom link
								lnk_o:"o",
								pev2:"Tcom_Find Your Match_Questions_User Click"
								
							});
							///////////
							
							if (e.currentTarget.parent.__groupId == "central_group") {
								// disabled the central buttons
								$map.block_click_group (e.currentTarget.parent.__groupId);
								
								// enabled drag
								$map.map_ready = true;
								
								// turn on the first question
								// executed in Animation.as
								$dispatcher.dispatchEvent (new Event (ClassDispatcher.TURN_OFF_QUESTION));
								
								// start here on
								// executed in StartHere.as
								$dispatcher.dispatchEvent (new Event (ClassDispatcher.HIDE_STARTHERE));
								
								// show the Carrousel
								$dispatcher.dispatchEvent (new Event (ClassDispatcher.CARRAOUSEL_ON));
								
								//
								$dispatcher.dispatchEvent (new Event (ClassDispatcher.SHOW_CONTROLS));
							}
							
							// execute when user click the central group
							if ($firstQuestion) {
								$firstQuestion = false;
								
								// enabled map drag
								$map.map_ready = true;
								
								// last step of animation
								// hide the Start Here asset
								$dispatcher.dispatchEvent (new Event(ClassDispatcher.ANIMATION_CONTINUE));
							}

							// open selected group
							/*
							 * icon id
							 * group to move
							 * map to print
							 * */
							$controller.$map_co.register_group_onView = [e.currentTarget.parent.__id, e.currentTarget.parent.__onSelected, e.currentTarget.parent.__printMap];;

							// close selected group ( to prevent icon overlapping )
							$map.close_map_group (e.currentTarget.parent.__groupId);
							$map.print_fullcolor_img_group (e.currentTarget.parent.__groupId);
							
							// locate in center stage
							$map.center_mapOn_group (e.currentTarget.parent.__onSelected);
							
							// print map on stage
							$map.print_map (e.currentTarget.parent.__printMap);
							
							// register icon id selected
							$controller.$map_co.set_register_icon_id (e.currentTarget.parent.__id);
							
							// if icon is a Result Icon click
							if (e.currentTarget.parent.__onSelected.indexOf("ex") != -1) {
								
								// will be fire on result car page open group
								// omniture
								Ominure.getInstance ().pageName = "";
								Ominure.getInstance ().track_items( {
									
									channel:"GM:Find Your Match",
									
									prop10:"GM:Find Your Match",
									prop11:"GM:All Vehicles:Find Your Match",
									prop8: "GM:All Vehicles:Find Your Match:Pick a Vehicle"
									
								});
								///////////
								
								// block map drag
								$map.map_ready = false;
								 
								// show final question
								$dispatcher.dispatchEvent (new Event(ClassDispatcher.TURN_ON_QUESTION_RESULT));

								// hide carrousel
								$dispatcher.dispatchEvent (new Event(ClassDispatcher.CARRAOUSEL_OFF));
								
								
							}
						}
					
					// init Icon
					iconOB_anim.material.init();
					
					// register icon (internal)
					$icons_arr.push (iconOB_anim);
				}
				
				// register on Model
				$controller.$map_co.register_map_icons = $icons_arr;
			}
			
			trace("ICONS REGISTER ON MAP");
			// view.as
			$dispatcher.dispatchEvent(new Event(ClassDispatcher.START_ANIMATION));
		}
		
		// cueanimation
		private function add_cue (icon_info:*):void
		{
			var iconCounter:uint = 0;
			var iconOB_anim:Object = $map.addPlane ("icon_cue_" + iconCounter++, new IconOB_anim());

			//icon position
			iconOB_anim.plane.x = icon_info.__x;
			iconOB_anim.plane.y = icon_info.__y;

			// icon init params
			iconOB_anim.plane.z = 3;
			//iconOB_anim.plane.scale(iconScaleDefault);

			// icon material alpha
			iconOB_anim.plane.visible = true;

			// icon info
			iconOB_anim.material.__groupId = icon_info.__groupId;
			iconOB_anim.material.__id = icon_info.__id;
			iconOB_anim.material.__iconPath = icon_info.__iconPath;
			iconOB_anim.material.__title = icon_info.__title;
			iconOB_anim.material.__description = icon_info.__description;
		}
	}
}