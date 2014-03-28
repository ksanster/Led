package com.tengu.tools.leditor.api
{
	
	public interface IEditableLayer extends ILayer, ISelectable
	{
		function mouseDown (xCoord:Number, yCoord:Number):Boolean;
		function mouseMove (xCoord:Number, yCoord:Number):void;
		function mouseUp (xCoord:Number, yCoord:Number):void;
	}
}