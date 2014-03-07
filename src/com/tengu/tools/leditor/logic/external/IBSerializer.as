package com.tengu.tools.leditor.logic.external
{
	import com.tengu.scroll.layers.InfinityBitmapLayer;
	import com.tengu.tools.leditor.api.ILayer;
	import com.tengu.tools.leditor.assets.api.IAssetData;
	import com.tengu.tools.leditor.assets.api.IAssetManager;
	import com.tengu.tools.leditor.logic.api.ILayerFactory;
	import com.tengu.tools.leditor.model.enum.LayerType;
	
	public class IBSerializer implements ILayerSerializer
	{
		[Inject]
		public var assetManager:IAssetManager;

		[Inject]
		public var layerFactory:ILayerFactory;
		
		public function IBSerializer()
		{
		}
		
		public function exportLayer(value:ILayer):XML
		{
			const layer:InfinityBitmapLayer = value as InfinityBitmapLayer;
			const asset:IAssetData = assetManager.getAssetByBitmap(layer.bitmap);
			const assetId:String = (asset == null) ? "" : asset.id;
			var xml:XML = new XML("<" + XMLProtocol.LAYER + "></" + XMLProtocol.LAYER + ">" );
			xml.@[XMLProtocol.LAYER_TYPE] = value.type;
			xml.@[XMLProtocol.Z_INDEX] = value.focalIndex;
			xml.@[XMLProtocol.BITMAP] = assetId;
			
			return null;
		}
		
		public function importLayer(value:XML):ILayer
		{
			const bitmapId:String = String(value.@[XMLProtocol.BITMAP]);
			const asset:IAssetData = assetManager.getAsset(bitmapId);
			const zIndex:int = parseInt(String(value.@[XMLProtocol.Z_INDEX]));
			const result:ILayer = layerFactory.create(LayerType.INFINITE_BITMAP, zIndex);
			
			if (asset != null)
			{
				(result as InfinityBitmapLayer).bitmap = asset.bitmap;
			}
			return result;
		}
	}
}