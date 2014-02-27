package com.tengu.tools.leditor.logic.external
{
	import com.tengu.tools.leditor.api.ILayer;

	public interface IExternalManager
	{
		function exportLayers (layersList:Vector.<ILayer>):XML;
		function importLayers (value:XML):Vector.<ILayer>;
		
		function addExporter (layerType:String, exporter:ILayerSerializer):void;
	}
}