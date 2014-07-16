package com.digitalarbor.toyota.view.carrousel.application.view.components {
	
	import flash.events.MouseEvent;	
	import flash.net.navigateToURL;	
	import flash.net.URLRequest;	
	import flash.text.TextFormat;
	
	import com.digitalarbor.toyota.view.carrousel.application.model.vo.DataItemCar;
	import com.digitalarbor.toyota.view.carrousel.application.utils.UrlLoader;	
	
	import flash.text.AntiAliasType;	
	import flash.text.TextFieldAutoSize;	
	import flash.events.Event;	
	import flash.display.MovieClip;	
	import flash.display.Bitmap;	

	import flash.text.TextField;	
	import flash.display.Sprite;
	
	// assets
	import com.digitalarbor.toyota.controller.Controller;
	import com.digitalarbor.toyota.event.ClassDispatcher;
	
	// omniture
	import com.digitalarbor.toyota.utilities.omniture.Ominure;

	/**
	 * @author denis.gonzalez
	 */
	public class ItemCar extends MovieClip {

		public static const UP:String = "state_up";
		public static const OVER:String = "state_over";
		public static const DOWN:String = "state_down";
		public static const ITEM_ON_COMPLETE:String = "ItemOnComplete";
		
		private var currentState:String;
		private var imagen_up:Sprite;
		private var imagen_over:Sprite;
		private var imagen_down:Sprite;
		private var text_item : TextField;
		private var urlLoaderImagenUp:UrlLoader;
		private var urlLoaderImagenOver:UrlLoader;
		private var urlLoaderImagenDown:UrlLoader;
				
		private var is_imagen_up_complete : Boolean;
		private var is_imagen_over_complete : Boolean;
		private var is_imagen_down_complete : Boolean;
		
		private var _isEnable : Boolean;
		public var dataItemCar : DataItemCar;
		private var id : String;
		
		private var $dispatcher:ClassDispatcher;
		private var $controller:Controller;

		public function ItemCar(data : DataItemCar) {
			
			
			$controller = Controller.getInstance ();
			
			$dispatcher = ClassDispatcher.getInstance ();
			$dispatcher.addEventListener (ClassDispatcher.STOP_EVENTS, stopAllEvents);
			$dispatcher.addEventListener (ClassDispatcher.START_EVENTS, startAllEvents);
			
			dataItemCar = data;
			id = data.idItemcar;
			
			imagen_up = new Sprite();
			imagen_over = new Sprite();
			imagen_down = new Sprite();
			
			is_imagen_up_complete = false;
			is_imagen_over_complete = false;
			is_imagen_down_complete = false;
			
			addChild(imagen_up);
			addChild(imagen_over);
			addChild(imagen_down);
			
			text_item =	new TextField();
			text_item.embedFonts = true;
			text_item.thickness = 20;
			text_item.text = dataItemCar.title.toLocaleUpperCase();
			text_item.autoSize = TextFieldAutoSize.CENTER;
			text_item.selectable = false;
			text_item.wordWrap = false;
			text_item.antiAliasType = AntiAliasType.ADVANCED;
			
			var fm:TextFormat = new TextFormat ();
			fm.color = 0xFF0000;
			fm.bold = true;
			fm.letterSpacing = 1;
			fm.size = 14;
			fm.font = new BertholdAkzidenzGroteskBC ().fontName;
			
			// format
			text_item.setTextFormat(fm);

			addChild(text_item);

			if (dataItemCar.isEnable == "true"){
				isEnable = true;
			}else{
				isEnable = false;
			}
			
			init ();
		}

		public function init (): void {
			urlLoaderImagenUp = new UrlLoader(dataItemCar.url_imagen_up);
			urlLoaderImagenUp.addEventListener(UrlLoader.ON_COMPLETE, onCompleteUp);
	
			urlLoaderImagenOver = new UrlLoader(dataItemCar.url_imagen_over);
			urlLoaderImagenOver.addEventListener(UrlLoader.ON_COMPLETE, onCompleteOver);
	
			urlLoaderImagenDown = new UrlLoader(dataItemCar.url_imagen_down);
			urlLoaderImagenDown.addEventListener(UrlLoader.ON_COMPLETE, onCompleteDown);
			
			// 
			enabledCarButton ();
		}
		private function enabledCarButton ():void
		{
			_isEnable = true;
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		private function disabledCarButton ():void
		{
			_isEnable = false;
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			removeEventListener(MouseEvent.CLICK, onClick);
		}

		private function onCompleteUp(event : Event) : void {
			try {
				var loader:UrlLoader = event.target as UrlLoader;
				var img : Bitmap = Bitmap(loader.content);
				img.smoothing = true;
				imagen_up.addChild(img);
				imagen_up.cacheAsBitmap = true;
				
				imagen_up.x = -(imagen_up.width / 2);
				imagen_up.y = -(imagen_up.height / 2);
					
				//Center of title item
				text_item.x = (text_item.textWidth < imagen_up.width) ? -(text_item.textWidth / 2) : -(text_item.textWidth / 2);
				text_item.y = -(imagen_up.height / 2) - 20;
				
				is_imagen_up_complete = true;
				itemCarReady ();
			}catch(error : Error) {
				trace("<error> :onCompleteUp ItemCar:");
			}			
		}

		private function onCompleteOver(event : Event) : void {
			try {
				var loader:UrlLoader = event.target as UrlLoader;
				var img : Bitmap = Bitmap(loader.content);
				img.smoothing = true;
				imagen_over.addChild(img);
				imagen_over.cacheAsBitmap = true;
				imagen_over.x = -(imagen_over.width / 2);
				imagen_over.y = -(imagen_over.height / 2);
				is_imagen_over_complete = true;
				itemCarReady ();
			}catch(error : Error) {
				trace("<error> :onCompleteOver ItemCar:");
			}			
		}

		private function onCompleteDown(event : Event) : void {
			try {
				var loader:UrlLoader = event.target as UrlLoader;
				var img : Bitmap = Bitmap(loader.content);
				img.smoothing = true;
				imagen_down.addChild(img);
				imagen_down.cacheAsBitmap = true;
				imagen_down.x = -(imagen_down.width / 2);
				imagen_down.y = -(imagen_down.height / 2);
				is_imagen_down_complete = true;
				itemCarReady ();
			}catch(error : Error) {
				trace("<error> :onCompleteDown ItemCar:");
			}			
		}

		private function itemCarReady (): void {
			if (is_imagen_up_complete && is_imagen_over_complete && is_imagen_down_complete) {
				dispatchEvent(new Event(ITEM_ON_COMPLETE));
			}
		}
		
		public function update (state:String):void{
			switch (state){
				case UP :
				{
					if (_isEnable){
						buttonMode = true;
						imagen_up.visible = true;
						imagen_over.visible = false;
						imagen_down.visible = false;
						text_item.visible = false;
					}
					break;
				}
				case OVER :
				{
					if (_isEnable){
						buttonMode = true;
						imagen_up.visible = false;
						imagen_over.visible = true;
						imagen_down.visible = false;
						text_item.visible = true;
					}
					break;
				}
				case DOWN :
				{
					buttonMode = false;
					imagen_up.visible = false;
					imagen_over.visible = false;
					imagen_down.visible = true;
					text_item.visible = false;
					break; 
				}
			}
		}

		public function onClick(event:MouseEvent) : void {
			if (_isEnable) {

				// register in model the car name selected
				$controller.$map_co.selected_car_name = text_item.text;
				
				// omniture
				Ominure.getInstance ().pageName = "GM:All Vehicles:Find Your Match:Home";
				Ominure.getInstance ().tracklink_items( {
					
					// custom obj variables
					// text_item.text = car name
					eVar41:"GM:All Vehicles:Find Your Match:Questions:Vehicle Click:" + text_item.text,
					prop46:"GM:All Vehicles:Find Your Match:Questions:Vehicle Click:" + text_item.text

				},{
					
					// variables of custom link
					lnk_o:"o",
					pev2:"Tcom_Find Your Match_Questions_Vehicle Click"
					
				});
				///////////
				
				// first at all have to check if user has a CID
				var userCID:* = $controller.$user_center_info.user_cid;
				var userMID:* = $controller.$user_center_info.user_mid;
				var userSV:* = $controller.$user_center_info.user_survey;
				
				trace("userCID ",userCID, "userMID ",userMID, "userSV ",userSV)
				
				if (userCID != null && userMID != null && userSV != null) {
					
					// click counter (register clicks user on webservice limit 3)
					var sumitted:Boolean = $controller.$click_counter_co.user_click_on("carrousel");
					trace("sumitted",sumitted)
					if (sumitted) {
						//update client
						$controller.$user_center_info.update_consumer();

					}else { "User click on Limit (carrousel)", sumitted };
					
					var request:URLRequest = new URLRequest(dataItemCar.url_link);
					try {
						//navigateToURL(request, '_blank');
					} catch (error:Error) {
						trace("<error> :onClick ItemCar:");
					}
				}
				else {
					$controller.$user_center_info.open_cid_form ();
				}
			}
		}

		private function onMouseOver(event:MouseEvent):void {
			
			// disabled map drag
			if(_isEnable){
				$controller.$map_co.register_map.map_ready = false;
				
			}
			
			update(ItemCar.OVER);
		}
		
		private function onMouseUp(event:MouseEvent):void {
			
			// disabled map drag
			if(_isEnable){
			$controller.$map_co.register_map.map_ready = true;
			}
			
			update(ItemCar.UP);
		}
		
		public function set isEnable(isEnable : Boolean) : void {
			_isEnable = isEnable;
			
			if (_isEnable){
				update(UP);
			}else{
				update(DOWN);
			}			
		}
		///////////////////////////////////////////////////// 
		private function startAllEvents(e:Event):void 
		{
			enabledCarButton ();
		}
		
		private function stopAllEvents(e:Event):void 
		{
			disabledCarButton ();
		}
		/////////////////////////////////////////////////////
		public function get _id() : String {
			return id;
		}
		
		public function set _id(id : String) : void {
			this.id = id;
		}
	}
}
