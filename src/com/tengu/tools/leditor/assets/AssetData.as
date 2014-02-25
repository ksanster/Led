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
		
		public function get id():String
		{
			return assetId;
		}
		
		public function get bitmap():BitmapData
		{
			return assetBitmap;
		}
		
		public function get preview():BitmapData
		{
			return assetPreview;
		}
	}
}