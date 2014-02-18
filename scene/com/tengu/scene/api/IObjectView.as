package com.tengu.scene.api
{
	import com.tengu.calllater.api.IValidable;

	public interface IObjectView extends IValidable
	{
		function get sleeping ():Boolean;
		
		function assignObject (value:IGameObject):void;
		function removeObject():void;
		
		function awake ():void;
		function sleep ():void;
		
	}
}