package com.tengu.tools.leditor.api
{
	
	public interface IEditableLayer extends ILayer
	{
		function mouseDown (xCoord:Number, yCoord:Number):void;
		function mouseMove (dx:Number, dy:Number):void;
		function mouseUp (xCoord:Number, yCoord:Number):void;
	}
}