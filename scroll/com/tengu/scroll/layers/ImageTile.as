package com.tengu.scroll.layers
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class ImageTile extends BaseTile
	{
		private var bitmapData:BitmapData;
		private var bitmapIndex:int;
		
		public function set index(value:int):void 
		{
			bitmapIndex = value;
		}
		
		public function get index():int 
		{
			return bitmapIndex;
		}
		
		public function set bitmap(value:BitmapData):void 
		{
			bitmapData = value;
			setSize(value.width, value.height);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get bitmap():BitmapData
		{
			return bitmapData;
		}

		public function ImageTile()
		{
			super();
		}
	}
}