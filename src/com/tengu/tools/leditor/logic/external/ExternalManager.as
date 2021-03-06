package com.tengu.tools.leditor.logic.external
{
	import com.tengu.di.api.IInjector;
	import com.tengu.log.LogFactory;
	import com.tengu.tools.leditor.api.ILayer;
	import com.tengu.tools.leditor.model.LedModel;
	import com.tengu.tools.leditor.model.enum.LayerType;
	
	import mx.collections.IList;
	
	public class ExternalManager implements IExternalManager
	{
		private var serializers:Object;
		
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var model:LedModel;
		
		public function ExternalManager()
		{
			initialize();
		}
		
		private function initialize():void
		{
			serializers = {};			
		}
		
		[PostConstruct]
		public function postConstruct():void
		{
			var serializer:ILayerSerializer;
			
			serializer = injector.makeInstance(IBSerializer) as ILayerSerializer;
			addSerializer(LayerType.INFINITE_BITMAP, serializer);
			
			serializer = injector.makeInstance(ImageTileSerializer) as ILayerSerializer;
			addSerializer(LayerType.IMAGE_TILES, serializer);
		}
		
		public function exportLayers(layersList:IList):XML
		{
			var xml:XML = new XML("<" + XMLProtocol.LAYERS + "></" + XMLProtocol.LAYERS + ">" );
			var layer:ILayer;
			var exporter:ILayerSerializer;
			var count:uint = layersList.length;
			
			xml.@[XMLProtocol.WIDTH] = model.screenSettings.levelWidth;
			xml.@[XMLProtocol.HEIGHT] = model.screenSettings.levelHeight;
			
			for (var i:int = 0; i < count; i++)
			{
				layer = layersList.getItemAt(i) as ILayer;
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
			var list:XMLList = value[XMLProtocol.LAYERS].children();
			var count:uint = list.length();
			var node:XML;
			var layerType:String;
			var importer:ILayerSerializer;
			
			model.screenSettings.levelWidth  = parseInt(String(value.@[XMLProtocol.WIDTH]));
			model.screenSettings.levelHeight = parseInt(String(value.@[XMLProtocol.HEIGHT]));
			
			for (var i:int = 0; i < count; i++)
			{
				node = list[i];
				layerType = node.@[XMLProtocol.LAYER_TYPE];
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
		
		public function addSerializer(layerType:String, serializer:ILayerSerializer):void
		{
			serializers[layerType] = serializer;
		}
	}
}