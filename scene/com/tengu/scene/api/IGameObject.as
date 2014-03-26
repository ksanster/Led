package com.tengu.scene.api
{
	import flash.events.IEventDispatcher;

	[Event(name="objectBoundsChanged", type="com.tengu.scene.events.GameObjectEvent")]
	[Event(name="objectFinalized", type="com.tengu.scene.events.GameObjectEvent")]
	public interface IGameObject extends IEventDispatcher
	{
		function set parent (value:IGameContainer):void;
		function get parent ():IGameContainer;
		
		function get x ():Number;
		function get y ():Number;
		function get z ():Number;
		
		function move (x:Number = 0, y:Number = 0, z:Number = 0):void;
		
		function finalize ():void;
	}
}