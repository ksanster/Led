package com.tengu.scene.api
{
	import com.tengu.geom.Vector2d;
	import com.tengu.math.IntRectangle;
	
	import flash.events.IEventDispatcher;

	[Event(name="objectBoundsChanged", type="com.tengu.scene.events.GameObjectEvent")]
	[Event(name="objectFinalized", type="com.tengu.scene.events.GameObjectEvent")]
	public interface IGameObject extends IEventDispatcher
	{
		function set parent (value:IGameContainer):void;
		function get parent ():IGameContainer;
		
		function set bounds (value:IntRectangle):void;
		function get bounds ():IntRectangle;
		
		function get x ():Number;
		function get y ():Number;
		function get z ():Number;
		
		function move (x:Number = 0, y:Number = 0, z:Number = 0):void;
		function setSize (width:int = 0, length:int = 0, height:int = 0):void;
		
		function finalize ():void;
	}
}