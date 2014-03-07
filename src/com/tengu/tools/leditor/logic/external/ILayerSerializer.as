package com.tengu.tools.leditor.logic.external
{
	import com.tengu.tools.leditor.api.ILayer;

	public interface ILayerSerializer
	{
		function exportLayer (value:ILayer):XML;
		function importLayer (value:XML):ILayer;
	}
}