package com.tengu.tools.leditor.logic.api
{
	import com.tengu.tools.leditor.api.ILayer;
	
	import mx.core.UIComponent;

	public interface ILayerFactory
	{
		function create (layerType:String, zIndex:int):ILayer;
		function createControls (layerType:String):UIComponent;
		
	}
}