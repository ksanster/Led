package com.tengu.tools.leditor.assets
{
	import com.tengu.core.errors.SingletonConstructError;
	import com.tengu.log.LogFactory;
	import com.tengu.tools.leditor.assets.api.IAssetData;
	import com.tengu.tools.leditor.assets.api.IAssetManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import mx.collections.ArrayCollection;
	
	public class AssetManager implements IAssetManager
	{
		private static const POINT:Point = new Point();
		private static const DEFAULT_SIZE:uint = 50;
		private static const DEFAULT_BITMAP:BitmapData = new BitmapData(DEFAULT_SIZE, DEFAULT_SIZE, false, 0xfff000);
		private static const DEFAULT_ASSET:IAssetData = new AssetData("", DEFAULT_BITMAP, DEFAULT_BITMAP);
		
		public static const instance:AssetManager = new AssetManager();
		
		private var assets:Vector.<IAssetData>;
		private var assetsById:Object;
		
		private var tiles:Object;
		
		private var indicesHash:Dictionary;		
		private var assetsHash:Dictionary;		
		
		[Bindable]
		public var previewWidth:uint	= DEFAULT_SIZE;
		
		[Bindable]
		public var previewHeight:uint	= DEFAULT_SIZE;
		
		[Bindable]
		public var assetCollection:ArrayCollection;
		
		public final function get assetList():Vector.<IAssetData> 
		{
			return assets;
		}
		
		public function AssetManager()
		{
			if (instance != null)
			{
				throw new SingletonConstructError(this);
			}
			assets = new Vector.<IAssetData>();
			assetsById  = {};
			tiles  = {};
			assetCollection = new ArrayCollection();
			indicesHash = new Dictionary();
			assetsHash = new Dictionary();
		}
		
		public final function setPreviewSize(width:uint, height:uint):void
		{
			previewWidth  = width || DEFAULT_SIZE;
			previewHeight = height || DEFAULT_SIZE;
		}
		
		public final function addAsset(id:String, bitmapData:BitmapData):void
		{
			const asset:IAssetData = new AssetData(	id, 
													bitmapData,
													generatePreview(bitmapData));
			var index:int = assets.indexOf(id);
			if (index == -1)
			{
				index = assets.length;
				assets[index] = asset;
				assetCollection.addItem(asset);
			}
			indicesHash[bitmapData] = index;
			assetsHash[bitmapData] = asset;
			assetsById[id] = asset;
			LogFactory.getLogger(this).debug("bitmap added: " + id);
		}
		
		public final function getAsset (id:String):IAssetData
		{
			return assetsById[id] || DEFAULT_ASSET;
		}
		
		public function getAssetByBitmap (bitmap:BitmapData):IAssetData
		{
			return  assetsHash[bitmap];
		}
		
		public function getIndexByBitmap (bitmap:BitmapData):int
		{
			if (indicesHash[bitmap] == null)
			{
				return -1;
			}
			return indicesHash[bitmap];
		}
		
		public function importEmbedded (sourceClass:Class):void
		{
			const typeXml:XML = describeType(sourceClass);
			var childNode:XML;
			var bitmapClass:Class;
			var bitmap:Bitmap;
			
			for each (childNode in typeXml.constant.(@type == "Class"))
			{
				bitmapClass = sourceClass[childNode.@name];
				bitmap = new bitmapClass();
				addAsset(childNode.@name, bitmap.bitmapData);
			}
			
			for each (childNode in typeXml.variable.(@type == "Class"))
			{
				bitmapClass = sourceClass[childNode.@name];
				bitmap = new bitmapClass();
				addAsset(childNode.@name, bitmap.bitmapData);
			}
		}
		
		public function getTileList (assetId:String, tileWidth:uint, tileHeight:uint):Vector.<BitmapData>
		{
			const tilesetId:String = assetId + "_" + tileWidth + "_" + tileHeight;
			var tileset:Vector.<BitmapData> = tiles[tilesetId];
			if (tileset == null)
			{
				tileset = generateTileset(assetId, tileWidth, tileHeight);
				tiles[tilesetId] = tileset;
			}
			return tileset;
		}
		
		private function generateTileset(assetId:String, tileWidth:uint, tileHeight:uint):Vector.<BitmapData>
		{
			var result:Vector.<BitmapData> = new Vector.<BitmapData>();
			var asset:IAssetData = getAsset(assetId);
			var rect:Rectangle = new Rectangle(0, 0, tileWidth, tileHeight);
			var tile:BitmapData;
			var source:BitmapData;
			var sourceWidth:uint;
			var sourceHeight:uint;
			if (asset != null)
			{
				source = asset.bitmap;
				
				sourceWidth = source.width;
				sourceHeight = source.height;
				
				for (var x:uint = 0; x < sourceWidth; x += tileWidth)
				{
					for (var y:uint = 0; y < sourceHeight; y += tileHeight)
					{
						rect.x = x;
						rect.y = y;
						tile = new BitmapData(tileWidth, tileHeight, true, 0x00FFFFFF);
						tile.copyPixels(source, rect, POINT, null, null, true);
						result[result.length] = tile;
					}
				}
			}
			return result;
		}
		
		private function generatePreview(bitmapData:BitmapData):BitmapData
		{
			var preview:BitmapData = new BitmapData(previewWidth, previewHeight, true, 0xFFFFFFFF);
			var bounds:Rectangle = bitmapData.getColorBoundsRect(0xFF000000,0x00000000, false);
			if (bounds.width > 0 && bounds.height > 0)
			{
				
				bounds.width = Math.min(bounds.width, previewWidth);
				bounds.height = Math.min(bounds.width, previewHeight);
				preview.copyPixels(bitmapData, bounds, POINT);
			}
			else
			{
				preview.copyPixels(bitmapData, preview.rect, POINT);
			}
			return preview;
		}
	}
}