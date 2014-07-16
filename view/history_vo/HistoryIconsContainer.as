package com.digitalarbor.toyota.view.history_vo 
{	
	import com.digitalarbor.toyota.controller.Controller;
	import com.digitalarbor.toyota.event.ClassDispatcher;
	import com.digitalarbor.toyota.model.Model;
	import com.digitalarbor.toyota.utilities.IMG_loader.ImgLoader;
	import com.digitalarbor.toyota.utilities.StageLocate;
	import com.digitalarbor.toyota.view.map_vo.ConfigMapScene;
	import com.greensock.TweenNano;
	import com.greensock.easing.Quad;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class HistoryIconsContainer extends Sprite
	{
		private static const ICONS_SPACER:Number = 200;
		
		private var $map:ConfigMapScene;
		private var $controller:Controller;
		private var $parent:HistoryNav;
		private var $model:Model;
		
		private var $dispatcher:ClassDispatcher;
		
		private var $icons_arr:Array = [];
		private var $icons_img_arr:Array = [];
		
		private var $firstQuestion:Boolean = true;
		
		private var carIconsArr:Array = [];
		
		private var currentCount:Number = 0;
		
		private var iconsContainer:Sprite;
		
		public function HistoryIconsContainer(addTo:HistoryNav)
		{
			//
			$controller = Controller.getInstance ();
			$dispatcher = ClassDispatcher.getInstance ();
			
			$model = Model.getInstance();
			//
			$parent = addTo;
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			$dispatcher.addEventListener(ClassDispatcher.NEW_USER_ANSWER_UPDATED, newChoice);
			
			//
			//add_img ();
		}
		
		private function onAdded(e:Event):void
		{
		}
		
		private function clearContainer():void
		{
			trace("CLEAR CONTAINER childs:"+iconsContainer.numChildren);
			
				for (var i:int; i < iconsContainer.numChildren; i++){
					var mc:* = iconsContainer.getChildAt(i);
					trace("deleting:"+mc.name);
					mc.parent.removeChild(mc);
					
				}
			    
			
		}
		
		private function newChoice(e:Event):void
		{
			
			
			if ($model.$map_mo.selected_icons_id.length != currentCount){
				trace("\n>>>>>>>>>>>>>>>>>>> HISTORY ICONS : CHOICE <<<<<<<<<<<<<<<<<<<<<<<< CURRENT COUNT:"+ currentCount+" new:"+$model.$map_mo.selected_icons_id.length);
		
				currentCount = $model.$map_mo.selected_icons_id.length;
				
				
				
				if(iconsContainer){ 
					clearContainer();
					iconsContainer.parent.removeChild(iconsContainer);
				}
				
				iconsContainer = new Sprite();
				addChild(iconsContainer);
				iconsContainer.y = 100;
				iconsContainer.alpha = 0;
				iconsContainer.scaleX = iconsContainer.scaleY = .5;
				
				carIconsArr = $controller.$map_co.register_map_icons_img;
				
				for(var i:int; i < currentCount; i++){
					
					trace("icon id:"+$model.$map_mo.selected_icons_id[i]);
					
					for each (var iconPlane:Object in $controller.$map_co.register_map_icons_img){
						if(iconPlane.material.__id == $model.$map_mo.selected_icons_id[i] && iconPlane.material.__id > 0){
							
							var img:Sprite = new ImgLoader(iconPlane.material.__imgPath);
							img.name = iconPlane.material.__groupId;
							iconsContainer.addChild(img);
							img.x = i * 260;
							
							trace("----IMAGE FOUND url:"+iconPlane.material.__imgPath);
						}
					}
					
				}
				
				iconsContainer.x = (StageLocate.$stage.stage.stageWidth / 2) - (iconsContainer.width / 2);
				TweenNano.to(iconsContainer, 2, {alpha:1, ease:Quad.easeOut});
				iconsContainer.addEventListener(MouseEvent.CLICK, iconClick);
				iconsContainer.buttonMode = true;
				
				/*THE KEY?*********************************	
				$controller.$map_co.register_map_icons_img OR
				Model.getInstance ().$map_mo.map_icons_arr
				******************************************/
			}
		}
		
		private function iconClick(e:MouseEvent):void
		{
			dispatchEvent(new Event(ClassDispatcher.OPEN_GROUP, false, true));
		}
		
		private function onRemoved(e:Event):void
		{
			
		}
		
		
	}
}