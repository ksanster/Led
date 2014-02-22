package com.tengu.tools.leditor.logic.api
{
	public interface IEditorController
	{
		function addLayer (layerType:String, zIndex:int):void;
		function removeLayer (index:int):void;
		
		function moveCameraToCenter():void;
	}
}