package com.tengu.scene.api
{
	public interface IViewFactory
	{
		function setDefaultView(objectViewClass:Class, containerViewClass:Class):void;
		function registerView (objectClass:Class, viewClass:Class):void;
		function createView (object:IGameObject):IObjectView;
		function disposeView (view:IObjectView):void;
	}
}