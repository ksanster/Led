package com.tengu.tools.leditor.logic.api
{
	import com.tengu.tools.leditor.api.IEditableLayer;

	public interface IEditorController
	{
		function addLayer (layerType:String, zIndex:int):void;
		function removeLayer (index:int):void;
		function setActiveLayer (layer:IEditableLayer):void;
		
		function moveCameraToCenter():void;
	}
}