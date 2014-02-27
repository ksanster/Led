package com.tengu.tools.leditor.logic.external
{
	import com.tengu.log.LogFactory;
	import com.tengu.tools.leditor.api.ILayer;
	
	public class ExternalManager implements IExternalManager
	{
		public static const LAYER_TYPE:String = "layer-type";
		private var serializers:Object;
		public function ExternalManager()
		{
			initialize();
		}
		
		private function initialize():void
		{
			serializers = {};			
		}
		
		public function exportLayers(layersList:Vector.<ILayer>):XML
		{
			var xml:XML = <layers></layers>;
			var layer:ILayer;
			var exporter:ILayerSerializer;
			var count:uint = layersList.length;
			
			for (var i:int = 0; i < count; i++)
			{
				layer = layersList[i];
				exporter = serializers[layer.type];
				if (exporter == null)
				{
					LogFactory.getLogger(this).error("Serializer not set for type: " + layer.type);
					continue;
				}
				xml.appendChild( exporter.exportLayer(layer) );
			}
			
			return xml;
		}
		
		public function importLayers(value:XML):Vector.<ILayer>
		{
			var result:Vector.<ILayer> = new Vector.<ILayer>();
			var list:XMLList = value.children();
			var count:uint = list.length();
			var node:XML;
			var layerType:String;
			var importer:ILayerSerializer;
			for (var i:int = 0; i < count; i++)
			{
				node = list[i];
				layerType = node.@[LAYER_TYPE];
				importer = serializers[layerType];
				if (importer == null)
				{
					LogFactory.getLogger(this).error("Serializer not set for type: " + layerType);
					continue;
				}
				result[result.length] = importer.importLayer(node);
			}
			return result;
		}
		
		public function addExporter(layerType:String, exporter:ILayerSerializer):void
		{
			serializers[layerType] = exporter;
		}
	}
}