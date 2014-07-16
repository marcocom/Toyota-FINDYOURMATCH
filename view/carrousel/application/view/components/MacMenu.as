package com.digitalarbor.toyota.view.carrousel.application.view.components {
	import flash.display.MovieClip;	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import com.digitalarbor.toyota.event.ClassDispatcher;
	import com.digitalarbor.toyota.controller.Controller;
	
	public class MacMenu extends Sprite {
		
		private var $dispatcher:ClassDispatcher;
		private var $controller:Controller;
		
		public static const CLICK:String = "click";
		
		public var clickedItem:String;
		
		private var template:Object;
		
		private var icon_min:Number;
		private var icon_max:Number;
		private var icon_size:Number;
		private var icon_spacing:Number;
		private var nWidth:Number;
		private var amplitude:Number;
		private var scale:Number;
		private var span:Number;
		private var ratio:Number;
		private var trend:Number;
		private var xmouse:Number;
		private var ymouse:Number;
		private var layout:String;
		private var items:Array;
		private var xhz:Array;
		private var tray:Sprite;		
		private var block:Boolean = false;
		public var blockMousePosition:Point;
		public var mouseOutOfStage:Boolean = false;
		
		public function MacMenu(template:Object) {
			
			$controller = Controller.getInstance ();
			
			$dispatcher = ClassDispatcher.getInstance ();
			$dispatcher.addEventListener (ClassDispatcher.NEW_USER_ANSWER_UPDATED, filterCars);
			$dispatcher.addEventListener (ClassDispatcher.TURN_OFF_ALLCARS, turnOffAllCars);
			$dispatcher.addEventListener (ClassDispatcher.STOP_EVENTS, stopAllEvents);
			$dispatcher.addEventListener (ClassDispatcher.START_EVENTS, startAllEvents);
			
			this.template = template;
			init();
		}
		
		public function redraw(update:Object):void{
			this.template = update;
			init();
		}
		
		private function init():void{
			setParams();
			setLayout();
			destroyIcons();
			createIcons();
			createTray();
			this.addEventListener(Event.ENTER_FRAME, monitorMenu);
		}
		
		private function setParams():void{
			this.icon_min = template.icon_min;
			this.icon_max = template.icon_max;
			this.icon_size = template.icon_size;
			this.icon_spacing = template.icon_spacing;
			this.amplitude = template.amplitude;
			this.span = template.span;
			this.ratio = template.ratio;
			this.trend = template.trend;
			this.layout = template.layout;
			this.items = template.items;
			xhz = new Array(); 
	}
		
		private function getSpan():Number{
			return (icon_min - 16) * (240 - 60) / (96 - 16) + 60;
		}
		
		private function getAmplitude():Number{
			return 2 * (icon_max - icon_min + icon_spacing);
		}
		
		private function setLayout():void{
			switch(layout)
			{
				case "left":
					this.rotation = 90;
					break;
				
				case "top":
					this.rotation = 180;
					break;
				
				case "right":
					this.rotation = 270;
					break;
				
				default:
					this.rotation = 0;
					break;
			}
		}
		
		public function getLayout():String{
			return layout;
		}
		
		private function destroyIcons():void{
			if ( this.numChildren > 0 ){
				var l:Number = this.numChildren;				
				this.removeEventListener(Event.ENTER_FRAME, monitorMenu);
				
				for ( var i:Number = l-1; i > 0; i-- ){
					removeChild(getChildAt(i));
				}
				removeChild(tray);
			}
		}
		
		private function createIcons():void{
			scale = 0;
			nWidth = (items.length - 1) * icon_spacing + items.length * icon_min;
			var left:Number = (icon_min - nWidth) / 2;
			var item : MovieClip;
			for ( var i:Number = 1; i < items.length + 1; i++ ){
				//item = items[i-1].id;
				item = items[i-1];
				var container:Sprite = new Sprite();
				container.name = String(i);
				addChildAt(container, i-1);
				var mc:DisplayObject = container.addChild(item);
				mc.name = String(item);
				var cont:* = getChildByName(String(i));				
				cont.getChildByName(item).y = -icon_size / 2;
				cont.getChildByName(item).rotation = -this.rotation;			
				cont.x = xhz[i-1] = left + (i-1) * (icon_min + icon_spacing) + icon_spacing / 2;
				cont.y = -icon_spacing;
			}
		}
		
		private function createTray():void{
			var height:Number = icon_min + 2 * icon_spacing;
			var width:Number = nWidth + 2 * icon_spacing;
			tray = new Sprite();
			tray.name = "tray";
			tray.graphics.lineStyle(0, 0xcccccc, 0.8);
			tray.graphics.beginFill(0xe8e8e8, 0.5);
			tray.graphics.drawRect(0, 0, width, -height);
			tray.graphics.endFill();
			tray.alpha = 0;
			addChildAt(tray, 0);
		}
		

		private function monitorMenu(event:Event = null):Boolean 
		{
			var dx:Number;
			var dim:Number;
			
			// Mouse moved or Dock is between states. Update Dock.
			blockMousePosition = (!block && !mouseOutOfStage)? new Point (this.mouseX, this.mouseY):new Point (0, 0);
			
			xmouse = blockMousePosition.x;
			ymouse = blockMousePosition.y;
			
			// Ensure that inflation does not change direction.
			trend = (trend == 0 ) ? (checkBoundary() ? 0.25 : -0.25) : (trend);
			scale += trend;
			if( (scale < 0.02) || (scale > 0.98) ) 
			{ 
				trend = 0; 
			}
			
			// Actual scale is in the range of 0..1
			scale = Math.min( 1, Math.max(0, scale) );
			
			// Hard stuff. Calculating position and scale of individual icons.
			for( var i:Number = 1; i < items.length+1; i++) 
			{
				dx = xhz[i-1] - xmouse;
				dx = Math.min( Math.max(dx, - span), span);
				dim = icon_min + (icon_max - icon_min) * Math.cos(dx * ratio) * (Math.abs(dx) > span ? 0 : 1) * scale;
				getChildAt(i).x = xhz[i-1] + scale * amplitude * Math.sin(dx * ratio);
				
				
				getChildAt(i).scaleX = getChildAt(i).scaleY = dim / icon_size;
				
			}
			
			updateTray();
			return true;
		}
		
		private function checkBoundary():Boolean {
			var buffer:Number = 4 * scale;
			return (ymouse < 0)
			&& (ymouse > -2 * icon_spacing - icon_min + (icon_min - icon_max) * scale)
			&& (xmouse - 35 > getChildAt(1).x - getChildAt(1).width / 2 - icon_spacing - buffer-40)
			&& (xmouse + 35 < getChildAt(items.length).x + getChildAt(items.length).width / 2 + icon_spacing + buffer+40);
		}
		
		private function updateTray():void{
			var x:Number;
			var w:Number;
			x = getChildAt(1).x - getChildAt(1).width / 2 - icon_spacing;
			w = getChildAt(items.length).x + getChildAt(items.length).width / 2 + icon_spacing;
			getChildByName("tray").x = x;
			getChildByName("tray").width = w - x;
		}
		//// 
		public function filterCars (e:Event = null):void
		{
			trace(">>>>>> MAC MENU : FILTER CARS");
			var ansSequence:Array = $controller.$map_co.get_register_icon_id ();
			var ansSequenceLen:int = ansSequence.length - 1;
			
			for ( var i:Number = 0; i < items.length; i++ ) {
				if(ansSequenceLen > -1) {
					if (items[i].dataItemCar.filterAnswers.indexOf(ansSequence[ansSequenceLen]) == -1 ) {
						items[i].isEnable = false;
						items[i].update (ItemCar.DOWN);
					}else {
						items[i].isEnable = true;
						items[i].update (ItemCar.UP);
					}
				}else {
					items[i].isEnable = true;
					items[i].update (ItemCar.UP);
				}
			}
		}
		public function turnOffAllCars (e:Event = null):void
		{
			var ansSequence:Array = $controller.$map_co.get_register_icon_id ();
			var ansSequenceLen:int = ansSequence.length - 1;
			
			for ( var i:Number = 0; i < items.length; i++ ) {
				items[i].isEnable = false;
				items[i].update (ItemCar.DOWN);
			}
		}
		public function resetSelectedCar (e:Event = null):void
		{
			var ansSequence:Array = $controller.$map_co.get_register_icon_id ();
			var ansSequenceLen:int = ansSequence.length - 1;
			
			for ( var i:Number = 0; i < items.length; i++ ) {
				if (items[i].dataItemCar.title.toLowerCase() == $controller.$map_co.selected_car_name.toLowerCase()){
					items[i].isEnable = true;
					items[i].update (ItemCar.UP);
				}
			}
		}
		///////////////////////////////////////////////////// 
		private function startAllEvents(e:Event):void 
		{
			// carrousel movement
			block = false;
			/////////////////////
			filterCars ();
			
		}
		private function stopAllEvents(e:Event):void 
		{
			// carrousel movement
			block = true;
			/////////////////////
		}
	}
}