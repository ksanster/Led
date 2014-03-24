package com.tengu.scroll.layers
{
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.tools.leditor.api.IEditableLayer;

	public class TileLayer extends BaseLayer implements IGameContainer, IEditableLayer
	{
		private var lTileWidth:uint = 32;
		private var lTileHeight:uint = 32;
		[Bindable]
		public function set tileWidth(value:uint):void 
		{
			lTileWidth = value;
			dispatchGameObjectEvent("tileSizeChanged", this);
		}
		
		public function get tileWidth():uint 
		{
			return lTileWidth;
		}
		[Bindable]
		public function set tileHeight(value:uint):void 
		{
			lTileHeight = value;
			dispatchGameObjectEvent("tileSizeChanged", this);
		}
		
		public function get tileHeight():uint 
		{
			return lTileHeight;
		}
		
		[Bindable]
		public function set tileWidthAsString(value:String):void 
		{
			tileWidth = parseInt(value);
		}
		
		public function get tileWidthAsString():String 
		{
			return String(tileWidth);;
		}
		
		[Bindable]
		public function set tileHeightAsString(value:String):void 
		{
			tileHeight = parseInt(value);
		}
		
		public function get tileHeightAsString():String 
		{
			return String(tileHeight);
		}
		
		public function TileLayer()
		{
			super();
		}
	}
}