package com.tengu.scene.api
{
	public interface IGameContainer extends IGameObject
	{
        function get children ():Vector.<IGameObject>;

		function add (child:IGameObject):void;
		function remove (child:IGameObject):void
		function removeAll ():void
	}
}