package com.tengu.tools.leditor.logic.external
{
	import com.tengu.tools.leditor.api.ILayer;
	
	import mx.collections.IList;

	public interface IExternalManager
	{
		function exportLayers (layersList:IList):XML;
		function importLayers (value:XML):Vector.<ILayer>;
		
		function addSerializer (layerType:String, serializer:ILayerSerializer):void;
	}
}