package com.digitalarbor.toyota.view.map_vo 
{
	
	import com.digitalarbor.toyota.event.EventDelay_cn;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	import flash.sampler.NewObjectSample;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.filters.GlowFilter;
	
	import com.greensock.*
	import com.greensock.plugins.*
	import com.greensock.easing.Expo;
	
	// tooltip
	import com.digitalarbor.toyota.view.tooltip.event.TooltipEvent;
	import com.digitalarbor.toyota.view.tooltip.vo.VOData;
	import com.digitalarbor.toyota.view.tooltip.Tooltip;

	// assets
	import com.digitalarbor.toyota.utilities.IMG_loader.ImgLoader;
	import com.digitalarbor.toyota.library_assets.iconOB_result_mc;
	import com.digitalarbor.toyota.controller.Controller;
	
	// omniture
	import com.digitalarbor.toyota.utilities.omniture.Ominure;

	public class IconOB_result extends iconOB_result_mc
	{
		public var __id:String;
		public var __groupId:String;
		public var __printMap:String;
		public var __iconPath:String;
		public var __title:String;
		public var __description:*;
		// i'm not using the standart click event
		public var __hitButton:Function;
		/////////////////////////////////////////
		public var __group_len:int;
		public var __tooltip_point:String;
		public var __x:Number=0;
		public var __y:Number = 0;
		
		public var __onSelected:String;

		public var externalIcon:ImgLoader;
		
		public var __button_block:Boolean = false;
		
		// textfield
		private var $title_margen_botton:int = 3;
		
		private var timeline:TimelineLite = new TimelineLite();
		private var ease:Function = Expo.easeOut;
		
		private var filt_glow:GlowFilter;
		
		// tooltip
		private var dt:VOData = new VOData();
		private var tp:Tooltip = new Tooltip();
		
		private var waitForHide:Timer;
		
		private var $controller:Controller;
		

		public function IconOB_result () { 
			TweenPlugin.activate([TintPlugin]);
			TweenPlugin.activate([ColorMatrixFilterPlugin])
			};
		public function init ():void
		{	
			if (stage) { initStage() } else { addEventListener (Event.ADDED_TO_STAGE, initStage) };
			
			$controller = Controller.getInstance ();
			
			// external movie
			if (__iconPath != null) 
			{
				externalIcon = new ImgLoader(__iconPath);
				
				//adjust the size of the icons
				externalIcon.scaleX = externalIcon.scaleY = .7;
				
				// add the loaded icon to the container
				icon_container_mc.addChild(externalIcon);
			}
			
			// 
			//disabled_btn ();
			enabled_btn ();

			//
			filt_glow = new GlowFilter();
			filt_glow.blurX = filt_glow.blurY = 4;
			filt_glow.strength = 100;
			//filt_glow.quality = ;
			filt_glow.color = 0xFFFFFF;
			//
			
			// tooltip
			tp.addEventListener(TooltipEvent.FACEBOOK,clickToolTipHandler);
			tp.addEventListener(TooltipEvent.TWITTER,clickToolTipHandler);
			tp.addEventListener(TooltipEvent.LEARN_MORE,clickToolTipHandler);
			tp.addEventListener(TooltipEvent.DISCLAIMER, clickToolTipHandler);
			
			// tooltip fade in / out
			tp.tweenTime = .2
			
			// timer
			waitForHide = new Timer (100, 1);
			waitForHide.addEventListener (TimerEvent.TIMER_COMPLETE, function ():void { tp.clear (); } )
			
			
			// internal
			tp.addEventListener (MouseEvent.ROLL_OUT, rollOut_handler);
			tp.addEventListener (MouseEvent.ROLL_OVER, rollOver_handler);

			//
			textfields_info ();
			
		}
		private function initStage (e:Event=null):void
		{
			removeEventListener (Event.ADDED_TO_STAGE, initStage);
			
			// tooltip
			stage.addChild (tp);
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
			title_txt.thickness = 150;
			title_txt.sharpness = 50;
			title_txt.antiAliasType = AntiAliasType.ADVANCED;
			//title_txt.filters = [filt_glow];

			var title_format:TextFormat = new TextFormat ();
			title_format.letterSpacing = 1;
			title_format.size = 25;
			title_format.kerning = true;
			title_format.font = new BertholdAkzidenzGroteskC ().fontName;
			
			title_txt.htmlText = __title.toUpperCase ();
			title_txt.setTextFormat(title_format);

			// desription
			description_txt.multiline = true;
			description_txt.autoSize = TextFieldAutoSize.CENTER;
			description_txt.embedFonts = true;
			//description_txt.thickness = 50;
			//description_txt.sharpness = 50;
			description_txt.antiAliasType = AntiAliasType.ADVANCED;
			
			var description_format:TextFormat = new TextFormat ();
			description_format.letterSpacing = 1;
			description_format.size = 13;
			description_format.kerning = true;
			description_format.font = new BertholdAkzidenzGroteskC ().fontName;
			
			description_txt.htmlText = cropTextField(__description).toString();
			description_txt.setTextFormat(description_format);

			// init entry
			description_txt.alpha = 0;
			
			// adjust the description textfield
			description_txt.y -= description_txt.textHeight - 15;
		}
		
		private function cropTextField (value:String, cropSize:int = 50):*
		{
			var stringCrop:* = (value.length > cropSize)? stringCrop = value.substring(0, cropSize):value;
			return stringCrop;
		}
		//////////////////////////////////////////////////////////////////////
		public function block_click_action ():void
		{
			__button_block = true;
			hitArea_btn.removeEventListener (MouseEvent.CLICK, result_click_handler);
		}
		public function unblock_click_action ():void
		{
			__button_block = false;
			hitArea_btn.addEventListener (MouseEvent.CLICK,  result_click_handler);
		}
		
		//////////////////////////////////////////////////////////////////////
		private function result_click_handler(e:MouseEvent):void 
		{
			// omniture
			Ominure.getInstance ().pageName = "";
			Ominure.getInstance ().tracklink_items( {

				// custom obj variables
				// {Vehicle_Name}
				eVar41:"GM:All Vehicles:Find Your Match:Pick a Vehicle:" + __title,
				
				prop46:"GM:All Vehicles:Find Your Match:Pick a Vehicle:Learn More",
				prop22:"GM:All Vehicles:Find Your Match:Pick a Vehicle:CTA:Learn More"

			},{

				// variables of custom link
				lnk_o:"o",
				pev2:"Tcom_Find Your Match_Pick a Vehicle_Learn More Button"

			});
			///////////
			
			// register car name on model
			$controller.$map_co.selected_car_name = __title.toUpperCase ();
			
			// go to selecter car info page
			tp.clear ();
			car_url ();
		}
		//////////////////////////////////////////////////////////////////////
		public function enabled_btn (e:Event=null):void
		{
			title_txt.alpha = 1;
			description_txt.alpha = 1;
			hitArea_btn.enabled = true;
			
			// button area
			hitArea_btn.addEventListener (MouseEvent.CLICK, result_click_handler );
			hitArea_btn.addEventListener (MouseEvent.ROLL_OVER, function (e:Event):void {
					higlight_title_on ();

					// show tooltip
					//var delayToShow:EventDelay_cn = new EventDelay_cn (500, function ():void {
						show_tooltip ();
					//});

					//
					TweenLite.to(externalIcon, .5, { scaleX:.8, scaleY:.8 } );
					
				} );
			hitArea_btn.addEventListener (MouseEvent.ROLL_OUT, function ():void {
					higlight_title_off ();
					
					// wait for hide the tooltip
					startTimer ();
					
					//
					//externalIcon.scaleX = externalIcon.scaleY = .6;
					TweenLite.to(externalIcon, .5, { scaleX:.7, scaleY:.7 } ); 
					
				} );
				
			TweenLite.to(this, 1, { colorMatrixFilter: { saturation :1 }} );
		}

		////
		public function disabled_btn (e:Event=null):void
		{
			title_txt.alpha = 0;
			description_txt.alpha = 0;
			hitArea_btn.enabled = false;
			
			// button area
			hitArea_btn.removeEventListener (MouseEvent.CLICK, result_click_handler );
			hitArea_btn.removeEventListener (MouseEvent.ROLL_OVER, function ():void {
					higlight_title_on ();
					
					// show tooltip
					show_tooltip ();

					//
					TweenLite.to(externalIcon, .5, { scaleX:.7, scaleY:.7 } );
				} );
			hitArea_btn.removeEventListener (MouseEvent.ROLL_OUT, function ():void {
					higlight_title_off ();
					// tooltip hide
						tp.clear ();
						
					//
					TweenLite.to(externalIcon, .5, { scaleX:.6, scaleY:.6 } );
				} );
			
			// turn gray the icon
			TweenLite.to(this, 1, { colorMatrixFilter: { saturation :0 }} );
		}
		
		//////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		public function higlight_title_on ():void
		{
			var title_format:TextFormat = new TextFormat ();
			title_format.color = 0xFF0000;
			title_txt.setTextFormat (title_format);
		}
		
		public function higlight_title_off ():void
		{
			var title_format:TextFormat = new TextFormat ();
			title_format.color = 0x029BBD;
			title_txt.setTextFormat (title_format);
		}
		//////////////////////////////////////////////////////////////////////
		// tooltip
		private function show_tooltip ():void 
		{
			// tooltip point
			var tooltip_point:Point = new Point(__tooltip_point.split(",")[0], __tooltip_point.split(",")[1]);
			dt.xpos = tooltip_point.x;
			dt.ypos = tooltip_point.y;

			// tooltip description
			dt.description = cropTextField( __description.car_description.text (), 120); 

			var car_point:Array = [];
			for each (var point:* in __description.bullet) {
				car_point.push ( cropTextField(point.text (), 16));	
			}
			dt.points = car_point; 

			// car see more button
			dt.car = __title;

			// tooltip display
			tp.show (dt);

		}
		// tooltiptimer
		private function startTimer ():void
		{
			waitForHide.start ();
		}
		private function stopTimer ():void
		{
			waitForHide.stop ();
		}
		
		// tooltip event handler
		private function clickToolTipHandler(e:TooltipEvent):void {
			
			$controller.$map_co.selected_car_name = __title.toUpperCase ();
			
			if (e.type == TooltipEvent.FACEBOOK) {
				
				// omniture
				Ominure.getInstance ().pageName = "";
				Ominure.getInstance ().tracklink_items( {

					// custom obj variables
					prop46:"GM:All Vehicles:Find Your Match:Pick a Vehicle:Share on Facebook",
					prop22:"GM:All Vehicles:Find Your Match:Pick a Vehicle:CTA:Share on Facebook"

				},{

					// variables of custom link
					lnk_o:"o",
					pev2:"Tcom_Find Your Match_Pick a Vehicle_Share on Facebook"

				});
				///////////

				$controller.$share_co.share_class.call_facebook (__title); 
				tp.clear ();
			}
			
			if (e.type == TooltipEvent.TWITTER) {
				
				// omniture
				Ominure.getInstance ().pageName = "";
				Ominure.getInstance ().tracklink_items( {

					// custom obj variables
					prop46:"GM:All Vehicles:Find Your Match:Pick a Vehicle:Share on Twitter",
					prop22:"GM:All Vehicles:Find Your Match:Pick a Vehicle:CTA:Share on Twitter"

				},{

					// variables of custom link
					lnk_o:"o",
					pev2:"Tcom_Find Your Match_Pick a Vehicle_Share on Twitter"

				});
				///////////
				
				$controller.$share_co.share_class.call_tweeter (__title); 
				tp.clear ();

			}			

			if (e.type == TooltipEvent.LEARN_MORE) {
				
				// omniture
				Ominure.getInstance ().pageName = "";
				Ominure.getInstance ().tracklink_items( {

					// custom obj variables
					// {Vehicle_Name}
					eVar41:"GM:All Vehicles:Find Your Match:Pick a Vehicle:" + __title,
					prop46:"GM:All Vehicles:Find Your Match:Pick a Vehicle:Learn More",
					prop22:"GM:All Vehicles:Find Your Match:Pick a Vehicle:CTA:Learn More"

				},{

					// variables of custom link
					lnk_o:"o",
					pev2:"Tcom_Find Your Match_Pick a Vehicle_Learn More Button"

				});
				///////////
				
				car_url ();
				tp.clear ();
			} 
		}
		
		// tooltip rollOver
		private function rollOver_handler(e:MouseEvent):void 
		{
			stopTimer ();
		}
		// tooltip rollOut
		private function rollOut_handler(e:MouseEvent):void 
		{
			tp.clear ();
			stopTimer ();
		}
		////////////////////
		private function car_url ():void 
		{

			var _urlAsigned:String = $controller.$cars_co.get_car_url (__title);
			trace("_urlAsigned", _urlAsigned)
			
			// first at all have to check if user has a CID
			var userCID:* = $controller.$user_center_info.user_cid;
			var userMID:* = $controller.$user_center_info.user_mid;
			var userSV:* = $controller.$user_center_info.user_survey;
			
			trace("userCID ", userCID, "userMID ", userMID, "userSV ", userSV)
			
			if (userCID != null && userMID != null && userSV != null) {

				// click counter (register clicks user on webservice limit 3)
				var sumitted:Boolean = $controller.$click_counter_co.user_click_on("resultPage");
				trace("sumitted",sumitted)
				if (sumitted) {
					//update client
					$controller.$user_center_info.update_consumer();

				}else { "User click on Limit (resultPage)", sumitted };

				
				// goto car url info
				if(_urlAsigned.length >0){
					var request:URLRequest = new URLRequest(_urlAsigned);
					try {
						//navigateToURL(request, '_blank');
					} catch (error:Error) {
						trace("<error> :onClick ItemCar:");
					}
				}else {
					trace("URL not found " + __title);
				}
			}
			else {
				$controller.$user_center_info.formOpenBy = "resultPage";
				$controller.$user_center_info.open_cid_form ();
			}
		}
	}
}