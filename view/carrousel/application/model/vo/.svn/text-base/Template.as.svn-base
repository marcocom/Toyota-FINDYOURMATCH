package com.digitalarbor.toyota.view.carrousel.application.model.vo
{
	public class Template
	{
		private var _icon_min:Number;
		private var _icon_max:Number;
		private var _icon_size:Number;
		private var _icon_spacing:Number;
		private var _amplitude:Number;
		private var _span:Number = Number.NEGATIVE_INFINITY;
		private var _ratio:Number;
		private var _trend:Number;
		private var _layout:String;
		private var _items:Array;
		
		// Icon minimum size.
		public function get icon_min():Number
		{
			return _icon_min;
		}
		
		public function set icon_min(value:Number):void
		{
			_icon_min = value;
		}
		
		// Icon maximum size.
		public function get icon_max():Number
		{
			return _icon_max;
		}
		
		public function set icon_max(value:Number):void
		{
			_icon_max = value;
		}
		
		// Actual icon size.
		public function get icon_size():Number
		{
			return _icon_size;
		}
		
		public function set icon_size(value:Number):void
		{
			_icon_size = value;
		}
		
		// Icon spacing.
		public function get icon_spacing():Number
		{
			return _icon_spacing;
		}
		
		public function set icon_spacing(value:Number):void
		{
			_icon_spacing = value;
		}
		
		// Amplitude.
		public function get amplitude():Number
		{
			return 2 * (icon_max - icon_min + icon_spacing);
		}
		
		// Span.
		public function get span():Number
		{
			return (icon_min - 16) * (240 - 60) / (96 - 16) + 60;
		}
		
		// Ratio.
		public function get ratio():Number
		{
			return Math.PI / 2 / span;
			
		}
		
		// Trend.
		public function get trend():Number
		{
			return _trend;
		}
		
		public function set trend(value:Number):void
		{
			_trend = value;
		}
		
		// Layout.
		public function get layout():String
		{
			return _layout;
		}
		
		public function set layout(value:String):void
		{
			_layout = value;
		}
		
		// Items array.
		public function get items():Array
		{
			return _items;
		}
		
		public function set items(value:Array):void
		{
			_items = value;
		}
		
		public function Template()
		{
			
		}
	}
}