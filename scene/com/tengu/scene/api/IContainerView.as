package com.tengu.scene.api
{
	import com.tengu.math.IntRectangle;

	public interface IContainerView extends IObjectView
	{
		function setVisibleBounds (value:IntRectangle):void;
		function setViewFactory (value:IViewFactory):void;
	}
}