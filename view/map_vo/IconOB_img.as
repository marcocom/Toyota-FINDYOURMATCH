package com.digitalarbor.toyota.view.map_vo 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.text.TextFieldAutoSize;
	
	import com.greensock.*
	import com.greensock.plugins.*
	import com.greensock.easing.Expo;

	// assets
	import com.digitalarbor.toyota.utilities.IMG_loader.ImgLoader;
	import com.digitalarbor.toyota.library_assets.iconOB_img_mc;
	
	public class IconOB_img extends iconOB_img_mc
	{
		public var __id:String;
		public var __groupId:String;
		public var __imgPath:String;
		public var __x:int=0;
		public var __y:int = 0;
		
		public var __onSelected:String;
		public var externalIcon:ImgLoader;
		
		private var timeline:TimelineLite = new TimelineLite();
		private var ease:Function = Expo.easeOut;

		public function IconOB_img () { 
			
			TweenPlugin.activate([TintPlugin]);
			TweenPlugin.activate([ColorMatrixFilterPlugin])
		};
		public function init ():void
		{	
			//trace(this, __iconPath);
			// external movie
			if (__imgPath != null) 
			{
				if(__imgPath.length > 0){
					externalIcon = new ImgLoader(__imgPath);
				
					//adjust the size of the icons
					externalIcon.scaleX = externalIcon.scaleY = 1; //<<<<<<<<Changed by marcocom
				
					// add the loaded icon to the container
					icon_container_mc.addChild(externalIcon);
				}
			}
			
			// mask
			//icon_container_mc.mask = mask_container_mc;
			
			// shadow
			shadow_mc.alpha = 0;
			
			// 
			//disabled_btn ();
			//enabled_btn ();
		}
		//////////////////////////////////////////////////////////////////////
		public function enabled_btn (e:Event=null):void
		{
			TweenLite.to(this, 1, { colorMatrixFilter: { colorize:0xFF0000, brightness:2, saturation:0 }} );
		}
		public function disabled_btn (e:Event=null):void
		{
			// turn gray the icon
			TweenLite.to(this, 1, { colorMatrixFilter: { colorize:0xCCCCCC, brightness:2, saturation:0 }} );
		}
		public function print_white (e:Event=null):void
		{
			//enabled_btn ();
			// turn gray the icon
			TweenLite.to(shadow_mc, 1, { alpha:1, ease:ease } );
		}
		public function delete_white (e:Event=null):void
		{
			//disabled_btn ();
			// turn gray the icon
			TweenLite.to(shadow_mc, 1, { alpha:0, ease:ease } );
		}

		//////////////////////////////////////////////////////////////////////
		// external init animation ( play() );
		public function startIconAnimation ():void
		{
		}
		public function stopIconAnimation ():void
		{
		}
	}
}