package com.tengu.scene.api
{
    public interface IViewport
	{
		function addSceneView (value:ICameraView, focalX:int = 0, focalY:int = 0):void;
		function removeSceneView (value:ICameraView):void;
		
		function setSize (width:int, height:int):void;

		function moveTo (x:Number, y:Number):void;
		function moveBy (dx:Number, dy:Number):void;
		
		function scaleTo (scale:Number):void;
        function rotateTo (angle:Number):void;
		
		function get centerX ():Number;
		function get centerY ():Number;
	}
}