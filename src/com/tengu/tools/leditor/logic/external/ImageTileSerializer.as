package com.tengu.tools.leditor.logic.external
{
	import com.tengu.scroll.layers.ImageTileLayer;
	import com.tengu.tools.leditor.api.ILayer;
	import com.tengu.tools.leditor.assets.api.IAssetManager;
	import com.tengu.tools.leditor.logic.api.ILayerFactory;
	import com.tengu.tools.leditor.model.enum.LayerType;
	
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
			var xml:XML = new XML("<" + XMLProtocol.LAYER + "></" + XMLProtocol.LAYER + ">" );
			xml.@[XMLProtocol.LAYER_TYPE] = value.type;
			xml.@[XMLProtocol.Z_INDEX] = value.focalIndex;

			xml.@[XMLProtocol.TILE_WIDTH] = layer.tileWidth;
			xml.@[XMLProtocol.TILE_HEIGHT] = layer.tileHeight;
			
			return xml;
		}
		
		public function importLayer(value:XML):ILayer
		{
			const zIndex:int = parseInt(String(value.@[XMLProtocol.Z_INDEX]));
			const result:ImageTileLayer = layerFactory.create(LayerType.IMAGE_TILES, zIndex) as ImageTileLayer;
			
			result.tileWidth  = parseInt(String(value.@[XMLProtocol.TILE_WIDTH]));
			result.tileHeight = parseInt(String(value.@[XMLProtocol.TILE_HEIGHT]));

			return result;
		}
	}
}