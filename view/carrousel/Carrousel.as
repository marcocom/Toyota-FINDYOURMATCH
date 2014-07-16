package com.digitalarbor.toyota.view.carrousel
{	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import com.greensock.*
	import com.greensock.easing.Bounce;
	
	import com.digitalarbor.toyota.view.carrousel.application.model.TemplateProxy;
	import com.digitalarbor.toyota.view.carrousel.application.view.components.MacMenu;
	import com.digitalarbor.toyota.view.carrousel.application.view.components.ItemCar;
	import com.digitalarbor.toyota.view.carrousel.application.model.vo.DataItemCar;
	import com.digitalarbor.toyota.view.carrousel.application.utils.UrlLoader;
	import com.digitalarbor.toyota.view.carrousel.application.model.ParserItemCar;
	
	import com.digitalarbor.toyota.event.ClassDispatcher;
	import com.digitalarbor.toyota.library_assets.carrousel_base_mc;
	import com.digitalarbor.toyota.utilities.StageLocate;
	import com.digitalarbor.toyota.controller.Controller;

	public class Carrousel extends Sprite
	{
		public static const MENU_DOCK_COMPLETE:String = "MenuDockComplete";
		
		private var template:TemplateProxy;
		private var menu:MacMenu;
		private var urlLoaderXML:UrlLoader;
		private var templateItems:Object;
		
		private var data_xml : XML;
		private var total_item:Number = 0;
		private var dataItemCars:Array;
		
		private var URL_XML:String = "xml/item_cars.xml";
		
		private var $final_y_pos:int;
		
		private var $dispatcher:ClassDispatcher;
		
		// interface
		private var carrouselBase:carrousel_base_mc;
		
		public function Carrousel ()
		{
			$dispatcher = ClassDispatcher.getInstance ();
			$dispatcher.addEventListener (ClassDispatcher.CARRAOUSEL_ON, show_carrousel)
			$dispatcher.addEventListener (ClassDispatcher.CARRAOUSEL_OFF, hide_carrousel)

			StageLocate.$stage.stage.addEventListener(Event.MOUSE_LEAVE, resetMouseArea); 
			
			// 
			init();
		}
		public function init():void{
			this.visible = false;

			// interface
			carrouselBase = new carrousel_base_mc ();
			carrouselBase.y = StageLocate.$stage.stage.stageHeight
			addChild (carrouselBase);
			carrouselBase.alpha = 0;
			carrouselBase.visible = false;

			template = new TemplateProxy();
			templateItems = template.getData();

			urlLoaderXML = new UrlLoader(URL_XML);
			urlLoaderXML.addEventListener(UrlLoader.ON_COMPLETE, onCompleteXML);

		}
		
		private function onCompleteXML(event : Event):void{
			var loader:UrlLoader = event.target as UrlLoader;
			data_xml = new XML(loader.content);
			dataItemCars = ParserItemCar.xmlParseItemCar(data_xml);
			
			//register in model
			Controller.getInstance ().$cars_co.carrousel_cars = dataItemCars;

			//
			onCreateItemCars(dataItemCars);
		}		

		private function onCreateItemCars(dataItemCars:Array):void{
			for (var i : Number = 0; i < dataItemCars.length; i++) {
				var itemCar :ItemCar = new ItemCar(dataItemCars[i]);
				itemCar.addEventListener(ItemCar.ITEM_ON_COMPLETE, menuDockComplete);
				templateItems.items.push(itemCar)
			}			
			
			
			menu = new MacMenu(templateItems);
			menu.alpha = 0;
			menu.visible = false;
			addChild(menu);
		
			alignContent();
			
			
		}
		private function menuDockComplete(event:Event):void{
			total_item ++;
			if (total_item == dataItemCars.length){
				this.visible = true;
				dispatchEvent(new Event(MENU_DOCK_COMPLETE));
			}
		}
		
		private function alignContent(event:Event = null):void
		{
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			
			if ( menu != null )
			{
				switch( template.getData().layout )
				{
					case "bottom":
						menu.x = w / 2;
						menu.y = h;
						break;
					
					case "right":
						menu.x = w;
						menu.y = h / 2;
						break;
					
					case "left":
						menu.x = 0;
						menu.y = h / 2;
						break;
					
					case "top":
						menu.y = 0;
						menu.x = w / 2;
				}
			}
			
			menu.y += 50
			
			//
			$final_y_pos = menu.y;
		}
		private function show_carrousel (e:Event = null):void
		{	
			var stagePosition:int = StageLocate.$stage.stage.stageHeight - carrouselBase.height;
			
			menu.visible = true;
			TweenLite.to (menu, 1, { y:stagePosition+30 ,alpha:1 } ); 
			
			carrouselBase.visible = true;
			TweenLite.to (carrouselBase, 1, { y:stagePosition ,alpha:1,  ease:Bounce.easeOut } ); 
		}
		
		private function hide_carrousel (e:Event = null):void
		{	
			var stagePosition:int = StageLocate.$stage.stage.stageHeight + carrouselBase.height;

			TweenLite.to (menu, .5, { y:stagePosition+60 , alpha:1, onComplete:function ():void {
					
					menu.visible = false;
				
				}} ); 
			
			
			TweenLite.to (carrouselBase, .5, { y:stagePosition , alpha:1, ease:Bounce.easeOut, onComplete:function ():void {
				
					carrouselBase.visible = false;
				
				} } ); 
		}
		
		// check if mouse it is on stage area
		private function resetMouseArea(e:Event):void 
		{
			StageLocate.$stage.stage.addEventListener(MouseEvent.MOUSE_MOVE, activateMouseArea);
			if(menu != null){
				menu.mouseOutOfStage = true;
			}
			
		}
		private function activateMouseArea(e:MouseEvent):void 
		{
			StageLocate.$stage.stage.removeEventListener(MouseEvent.MOUSE_MOVE, activateMouseArea); 
			menu.mouseOutOfStage = false;
		}
		
	}
}
