package com.tengu.tools.leditor.logic.external
{
	import com.tengu.scroll.layers.InfinityBitmapLayer;
	import com.tengu.tools.leditor.api.ILayer;
	
	public class IBSerializer implements ILayerSerializer
	{
		public function IBSerializer()
		{
		}
		
		public function exportLayer(value:ILayer):XML
		{
			const layer:InfinityBitmapLayer = value as InfinityBitmapLayer;
			const asset
			var xml:XML = new XML("<" + XMLProtocol.LAYER + "></" + XMLProtocol.LAYER + ">" );
			xml.@[XMLProtocol.LAYER_TYPE] = value.type;
			xml.@[XMLProtocol.Z_INDEX] = value.focalIndex;
			xml.@[XMLProtocol.BITMAP] = layer.;
			
			return null;
		}
		
		public function importLayer(value:XML):ILayer
		{
			return null;
		}
	}
}