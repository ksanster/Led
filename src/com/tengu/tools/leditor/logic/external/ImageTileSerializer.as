package com.tengu.tools.leditor.logic.external
{
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scroll.layers.ImageTile;
	import com.tengu.scroll.layers.ImageTileLayer;
	import com.tengu.tools.leditor.api.ILayer;
	import com.tengu.tools.leditor.assets.api.IAssetManager;
	import com.tengu.tools.leditor.logic.api.ILayerFactory;
	import com.tengu.tools.leditor.model.enum.LayerType;
	
	import flash.display.BitmapData;
	
	import mx.containers.Tile;
	
	public class ImageTileSerializer implements ILayerSerializer
	{
		[Inject]
		public var assetManager:IAssetManager;
		
		[Inject]
		public var layerFactory:ILayerFactory;

		public function ImageTileSerializer()
		{
		}
		
		public function exportLayer(value:ILayer):XML
		{
			const layer:ImageTileLayer = value as ImageTileLayer;
			var child:ImageTile;
			var children:Vector.<IGameObject>;
			var childNode:XML;
			var xml:XML = new XML("<" + XMLProtocol.LAYER + "></" + XMLProtocol.LAYER + ">" );
			xml.@[XMLProtocol.LAYER_TYPE] = value.type;
			xml.@[XMLProtocol.Z_INDEX] = value.focalIndex;

			xml.@[XMLProtocol.TILE_WIDTH] = layer.tileWidth;
			xml.@[XMLProtocol.TILE_HEIGHT] = layer.tileHeight;
			
			xml.@[XMLProtocol.BITMAP] = layer.brush;
			
			children = layer.children;
			
			for each (child in children)
			{
				childNode = new XML("<" + XMLProtocol.CHILD + "></" + XMLProtocol.CHILD + ">" );
				childNode.@[XMLProtocol.X] = child.x;
				childNode.@[XMLProtocol.Y] = child.y;
				childNode.@[XMLProtocol.WIDTH] = child.width;
				childNode.@[XMLProtocol.HEIGHT] = child.height;
				childNode.@[XMLProtocol.TILE_INDEX] = child.index;
				
				xml.appendChild(childNode);
			}
			
			return xml;
		}
		
		public function importLayer(value:XML):ILayer
		{
			const zIndex:int = parseInt(String(value.@[XMLProtocol.Z_INDEX]));
			const result:ImageTileLayer = layerFactory.create(LayerType.IMAGE_TILES, zIndex) as ImageTileLayer;
			const nodeList:XMLList = value.children();
			const childCount:uint = nodeList.length();
			var tileWidth:int  = parseInt(String(value.@[XMLProtocol.TILE_WIDTH]));
			var tileHeight:int = parseInt(String(value.@[XMLProtocol.TILE_HEIGHT]));
			var tileList:Vector.<BitmapData>;
			var child:ImageTile;
			var childNode:XML;
			var w:int;
			var h:int;
			var x:int;
			var y:int;
			var index:int;
			
			tileWidth  = parseInt(String(value.@[XMLProtocol.TILE_WIDTH]));
			tileHeight = parseInt(String(value.@[XMLProtocol.TILE_HEIGHT]));
			
			result.tileWidth  = tileWidth;
			result.tileHeight = tileHeight;
			result.brush = String(value.@[XMLProtocol.BITMAP]);

			tileList = assetManager.getTileList(result.brush, result.tileWidth, result.tileHeight);
			
			for (var i:int = 0; i < childCount; i++)
			{
				childNode = nodeList[i];
				x = parseInt(String(childNode.@[XMLProtocol.X]));
				y = parseInt(String(childNode.@[XMLProtocol.Y]));
				w = parseInt(String(childNode.@[XMLProtocol.Y]));
				h = parseInt(String(childNode.@[XMLProtocol.Y]));
				
				child = new ImageTile();
				child.setSize(tileWidth, tileHeight);
				child.move(x, y);
				child.index = parseInt(String(childNode.@[XMLProtocol.TILE_INDEX]));
				child.bitmap = tileList[child.index];

				result.add(child);
			}
			
			return result;
		}
	}
}