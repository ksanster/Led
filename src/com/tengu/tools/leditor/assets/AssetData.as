package com.tengu.tools.leditor.assets
{
	import com.tengu.tools.leditor.assets.api.IAssetData;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	public class AssetData extends EventDispatcher implements IAssetData
	{
		private var assetId:String;
		private var assetBitmap:BitmapData;
		private var assetPreview:BitmapData;
		
		public function AssetData(id:String, bitmap:BitmapData, preview:BitmapData)
		{
			assetId = id;
			assetBitmap = bitmap;
			assetPreview = preview;
		}
		
		[Bindable]
		public function set id(value:String):void 
		{
			assetId = value;
		}
		
		public function get id():String
		{
			return assetId;
		}
		
		[Bindable]
		public function set bitmap(value:BitmapData):void 
		{
			assetBitmap = value;
		}
		
		public function get bitmap():BitmapData
		{
			return assetBitmap;
		}
		
		[Bindable]
		public function set preview(value:BitmapData):void 
		{
			assetPreview = value;
		}
		
		public function get preview():BitmapData
		{
			return assetPreview;
		}
	}
}