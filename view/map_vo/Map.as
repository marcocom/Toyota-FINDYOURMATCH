package com.digitalarbor.toyota.view.map_vo 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.greensock.*
	
	import com.digitalarbor.toyota.event.ClassDispatcher;
	import com.digitalarbor.toyota.controller.Controller;
	import com.digitalarbor.toyota.view.map_vo.ConfigMapScene;
	import com.digitalarbor.toyota.event.EventDelay_cn;
	
	// assets
	import com.digitalarbor.toyota.view.Background;
	import com.digitalarbor.toyota.view.map_vo.road_vo;
	
	//import com.digitalarbor.toyota.library_assets.map_component_mc;
	
	public class Map extends Sprite 
	{
		private var $dispatcher:ClassDispatcher = ClassDispatcher.getInstance();
		private var $controller:Controller = Controller.getInstance();
		
		public var $map:ConfigMapScene;
		private var $itemsOnStage:AddToStage;

		public function Map ()
		{
			$dispatcher.addEventListener(ClassDispatcher.ICON_PARSE_READY, icons_ready_onModel );
			
			// STATIC animation
			$dispatcher.addEventListener(ClassDispatcher.ANIM_ALPHA_IN_MAP, alphaIn_map_elements);
			$dispatcher.addEventListener(ClassDispatcher.ANIM_ZOOM_OUT_MAP, zoomOut_map_elements);
			$dispatcher.addEventListener(ClassDispatcher.ANIM_ROTATE_MAP, rotateY_map_elements);
			
			// call the xml
			get_map_info ();
		}
		
		private function get_map_info ():void
		{
			// request map info
			$controller.request_xml_info ("map_icons", "xml/iconmatrix.xml");
		}
		
		private function icons_ready_onModel (e:Event):void
		{
			setupMap ();
		}
		private function setupMap ():void
		{
			$map = new ConfigMapScene ();
			addChild ($map);
			
			// ADD 3dOBJECTs to the scene
			/*
			 * all 3dOB added will be register on Model.$map_mo 
			 * to access it please use:
			 * $controller.$map_co.get_register3D_object(object name);
			 * */

			 // map
			//var bk:Object = $map.addPlane ("background", new Background ());
			// map
			var road:Object = $map.addPlane("road", new road_vo());
			road.plane.x = 609;
			road.plane.y = -177;
			road.plane.z = 2;
			road.material.alpha = 0;
			
			// add items to the stage
			$itemsOnStage = new AddToStage($map);
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// animation sequense events
		private function alphaIn_map_elements (e:Event):void
		{
			$map.icons_img_alpha(1);
			$map.map_alpha(100);
		}
		private function zoomOut_map_elements (e:Event):void
		{
			$map.camera_distance(1800);
			$map.cameraTaget_y(-40);
		}
		private function rotateY_map_elements (e:Event):void
		{
			trace(">>>>>>>>>>>>>ROTATEY_MAP_ELEMENTS()<<<<<<<<<<<");
			$map.cameraTaget_z(-60);
			$map.camera_distance(180);
			$map.camera_tilt(-80);
			$map.print_graycolor_img_group();
			
			//
			var openGroup:EventDelay_cn = new EventDelay_cn (1200, function():void {
				$controller.$map_co.register_group_onView = ["","central_group",""];
				$map.open_map_group("central_group")});
		}
		//////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////	
	}
}