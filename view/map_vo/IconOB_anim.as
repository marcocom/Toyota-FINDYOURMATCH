package com.digitalarbor.toyota.view.map_vo 
{
	import com.digitalarbor.toyota.controller.Controller;
	import com.digitalarbor.toyota.library_assets.iconOB_anim_mc;
	import com.digitalarbor.toyota.model.Model;
	import com.digitalarbor.toyota.utilities.IMG_loader.ImgLoader;
	import com.greensock.*;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.*;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.sampler.NewObjectSample;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class IconOB_anim extends iconOB_anim_mc
	{
		public var __id:String;
		public var __groupId:String;
		public var __printMap:String;
		public var __iconPath:String;
		public var __title:String;
		public var __description:String;
		public var __hitButton:Function;
		public var __group_len:int;
		public var __x:Number=0;
		public var __y:Number = 0;
		public var __mapIcon:IconOB_img;
		
		public var __onSelected:String;

		public var externalIcon:ImgLoader;
		private var $controller:Controller;
		private var $model:Model;
		
		public var __button_block:Boolean = false;
		
		// textfield
		private var $limit_description_character:int = 53;
		private var $title_margen_botton:int = 3;
		
		private var timeline:TimelineLite = new TimelineLite();
		private var ease:Function = Expo.easeOut;
		
		private var filt_glow:GlowFilter;
		
		private var $iconImage:Sprite;

		public function IconOB_anim () 
		{ 
			TweenPlugin.activate([TintPlugin]);
			TweenPlugin.activate([ColorMatrixFilterPlugin])
		}
		
		public function init ():void
		{	
			$controller = Controller.getInstance ();
			$model = Model.getInstance();
			//trace(this, __iconPath);
			// external movie
			if (__iconPath != null) 
			{
				externalIcon = new ImgLoader(__iconPath);
				
				//adjust the size of the icons
				externalIcon.scaleX = externalIcon.scaleY = 0.7;
				
				// add the loaded icon to the container
				icon_container_mc.addChild(externalIcon);
			}
			
			// 
			//disabled_btn ();
			enabled_btn ();

			// set icons gray 
			//TweenLite.to(this, 1, { colorMatrixFilter: { saturation :1 }} );
			
			//
			filt_glow = new GlowFilter();
			filt_glow.blurX = filt_glow.blurY = 4;
			filt_glow.strength = 100;
			//filt_glow.quality = ;
			filt_glow.color = 0xFFFFFF;
			//
			textfields_info ();
			
			for each (var iconPlane:Object in $controller.$map_co.register_map_icons_img){
				if(iconPlane.material.__id == __id && iconPlane.material.__id > 0){
					trace("----IMAGE FOUND url:"+iconPlane.material.__imgPath);
					$iconImage = iconPlane.material.externalIcon as Sprite;
				}
			}
			
		}
		//////////////////////////////////////////////////////////////////////
		// textfields properties
		private function textfields_info ():void
		{
			// title
			title_txt.multiline = true;
			title_txt.autoSize = TextFieldAutoSize.CENTER;
			title_txt.wordWrap = true;
			title_txt.embedFonts = true;
			title_txt.thickness = 100;
			title_txt.sharpness = 150;
			title_txt.antiAliasType = AntiAliasType.ADVANCED;
			//title_txt.filters = [filt_glow];

			var title_format:TextFormat = new TextFormat ();
			title_format.letterSpacing = 1;
			title_format.size = 13;
			title_format.kerning = true;
			title_format.font = new BertholdAkzidenzGroteskC ().fontName;
			
			title_txt.htmlText = __title;
			title_txt.setTextFormat(title_format);
			
			
			// desription
			description_txt.multiline = true;
			description_txt.autoSize = TextFieldAutoSize.CENTER;
			description_txt.embedFonts = true;
			description_txt.thickness = 50;
			description_txt.sharpness = 400;
			description_txt.antiAliasType = AntiAliasType.ADVANCED;
			
			var description_format:TextFormat = new TextFormat ();
			description_format.letterSpacing = .5;
			description_format.size = 12;
			description_format.kerning = false;
			description_format.font = new BertholdAkzidenzGroteskC ().fontName;
			
			description_txt.htmlText = cropTextField(__description).toString();
			description_txt.setTextFormat(description_format);

			// init entry
			description_txt.alpha = 0;
			
			// adjust the description textfield
			description_txt.y -= description_txt.textHeight - 15;
		}
		
		private function cropTextField (value:String):* 
		{
			var stringCrop:* = (value.length > $limit_description_character) ? stringCrop = value.substring(0, $limit_description_character) : value;
			return stringCrop;
		}
		//////////////////////////////////////////////////////////////////////
		public function block_click_action ():void
		{
			__button_block = true;
			hitArea_btn.removeEventListener (MouseEvent.CLICK, __hitButton );
		}
		public function unblock_click_action ():void
		{
			__button_block = false;
			hitArea_btn.addEventListener (MouseEvent.CLICK, __hitButton );
		}
		//////////////////////////////////////////////////////////////////////
		public function enabled_btn (e:Event=null):void
		{
			
			title_txt.alpha = 1;
			description_txt.alpha = 1;
			hitArea_btn.enabled = true;
			
			// button area
			hitArea_btn.addEventListener (MouseEvent.CLICK, __hitButton );
			hitArea_btn.addEventListener (MouseEvent.ROLL_OVER, function ():void {
				showIconDescription ();
				startIconAnimation ();
				
				TweenLite.to($iconImage, .5, { colorMatrixFilter: { colorize:0xFF0000, brightness:2, saturation:0 }} );
				} );
			hitArea_btn.addEventListener (MouseEvent.ROLL_OUT, function ():void {
				hideIconDescription ();
				stopIconAnimation ();
				
				TweenLite.to($iconImage, .5, { colorMatrixFilter: { colorize:0xCCCCCC, brightness:2, saturation:0 }} );
				} );
				
			TweenLite.to(this, 1, { colorMatrixFilter: { saturation :1 }} );
		}
		public function disabled_btn (e:Event=null):void
		{
			title_txt.alpha = 0;
			description_txt.alpha = 0;
			hitArea_btn.enabled = false;
			
			// button area
			hitArea_btn.removeEventListener (MouseEvent.CLICK, __hitButton );
			hitArea_btn.removeEventListener (MouseEvent.ROLL_OVER, function ():void {
				
				showIconDescription ();
				startIconAnimation ();
				} );
			hitArea_btn.removeEventListener (MouseEvent.ROLL_OUT, function ():void {
				hideIconDescription ();
				stopIconAnimation ();
				} );
			
			// turn gray the icon
			TweenLite.to(this, 1, { colorMatrixFilter: { saturation :0 }} );
		}
		
		//////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		public function showIconDescription ():void
		{
			// always print in red the title
			//TweenLite.to(title_txt, .5, { tint:0xFF0000, ease:ease } );
			trace("ROLLOVER EVENT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			var title_format:TextFormat = new TextFormat ();
			title_format.color = 0xFF0000;
			title_txt.setTextFormat (title_format);
			
			// if description exist display it
			if(description_txt.text.length > 0){
				var newTitlePosY:int = description_txt.y - title_txt.textHeight - $title_margen_botton;
				TweenLite.to(title_txt, .5, { y: newTitlePosY, ease:ease } );
				TweenLite.to(description_txt, .5, { alpha:1, ease:ease } );
			}
		}
		
		public function hideIconDescription ():void
		{
			// always print in black the title
			//TweenLite.to(title_txt, .5, { tint:0x000000, ease:ease } );
			
			var title_format:TextFormat = new TextFormat ();
			title_format.color = 0x029BBD;
			title_txt.setTextFormat (title_format);
			
			// if description exist display it
			if(description_txt.text.length > 0){
				TweenLite.to(description_txt, .5, { alpha:0, ease:ease } );
				TweenLite.to(title_txt, .5, { y: 70, ease:ease } );
			}
		}
		//////////////////////////////////////////////////////////////////////
		// external init animation ( play() );
		public function startIconAnimation ():void
		{
			
			
			if(externalIcon.root_access != null) {
				externalIcon.root_access.gotoAndStop("rollover");
			}
		}
		public function stopIconAnimation ():void
		{
			if(externalIcon.root_access != null) {
				externalIcon.root_access.gotoAndStop("rollout");
			}
		}
		
	}
}