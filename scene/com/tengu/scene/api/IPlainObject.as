package com.tengu.scene.api
{
	public interface IPlainObject extends IGameObject
	{
		function get width ():uint;
		function get height ():uint;
		
		function setSize (width:int = 0, height:int = 0):void;
	}
}