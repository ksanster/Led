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
	
	import mx.collections.IList;
	
	public class ImageTileSerializer implements ILayerSerializer
	{
		[Inject]
		public var assetManager:IAssetManager;
		
		[Inject]
		public var layerFactory:ILayerFactory;

		public function ImageTileSerializer()
		{
			//Empty
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
				childNode = exportTile(child);
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
			
			tileWidth  = parseInt(String(value.@[XMLProtocol.TILE_WIDTH]));
			tileHeight = parseInt(String(value.@[XMLProtocol.TILE_HEIGHT]));
			
			result.tileWidth  = tileWidth;
			result.tileHeight = tileHeight;
			result.brush = String(value.@[XMLProtocol.BITMAP]);

			tileList = assetManager.getTileList(result.brush, result.tileWidth, result.tileHeight);
			
			for (var i:int = 0; i < childCount; i++)
			{
				childNode = nodeList[i];
				
				child = importTile(childNode);
				child.setSize(tileWidth, tileHeight);
				child.bitmap = tileList[child.index];

				result.add(child);
			}
			
			return result;
		}
		
		private function exportTile (child:ImageTile):XML
		{
			const properties:IList = child.properties;
			const count:uint = properties.length;
			var property:Object;
			var node:XML;
			var result:XML = new XML("<" + 	XMLProtocol.CHILD + "><" + 
											XMLProtocol.PROPERTIES + "/></" + 
											XMLProtocol.CHILD + ">" );
			result.@[XMLProtocol.X] = child.x;
			result.@[XMLProtocol.Y] = child.y;
			result.@[XMLProtocol.WIDTH] = child.width;
			result.@[XMLProtocol.HEIGHT] = child.height;
			result.@[XMLProtocol.TILE_INDEX] = child.index;
			
			for (var i:int = 0; i < count; i++)
			{
				property = properties.getItemAt(i);
				node = new XML("<" + XMLProtocol.PROPERTY + "/>" );
				node.@[XMLProtocol.KEY] 	= property[XMLProtocol.KEY];
				node.@[XMLProtocol.VALUE] 	= property[XMLProtocol.VALUE];
				result.appendChild(node);
			}
			return result;
		}
		
		private function importTile (node:XML):ImageTile
		{
			const nodeList:XMLList = node[XMLProtocol.PROPERTIES];
			const count:uint = nodeList.length();
			
			const x:int = parseInt(String(node.@[XMLProtocol.X]));
			const y:int = parseInt(String(node.@[XMLProtocol.Y]));
			const w:int = parseInt(String(node.@[XMLProtocol.Y]));
			const h:int = parseInt(String(node.@[XMLProtocol.Y]));
			
			var result:ImageTile = new ImageTile();
			var propNode:XML;
			var property:Object;
			
			result = new ImageTile();
			result.move(x, y);
			result.index = parseInt(String(node.@[XMLProtocol.TILE_INDEX]));
			
			for (var i:int = 0; i < count; i++)
			{
				propNode = nodeList[i];
				property = {};
				property[XMLProtocol.KEY] = String(node.@[XMLProtocol.KEY]) || "";
				property[XMLProtocol.VALUE] = String(node.@[XMLProtocol.VALUE]) || "";
				result.properties.addItem(property);
			}
			
			return result;
		}

	}
}