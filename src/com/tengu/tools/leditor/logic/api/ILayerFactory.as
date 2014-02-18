package com.tengu.tools.leditor.logic.api
{
	import com.tengu.tools.leditor.api.ILayer;

	public interface ILayerFactory
	{
		function create (layerType:String, zIndex:int):ILayer;
	}
}