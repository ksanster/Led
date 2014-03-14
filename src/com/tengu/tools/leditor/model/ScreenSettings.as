package com.tengu.tools.leditor.model
{
	public class ScreenSettings
	{
		[Bindable]
		public var viewportWidth:uint = 500;
		
		[Bindable]
		public var viewportHeight:uint = 600;
		
		[Bindable]
		public var levelWidth:uint = 500;
		
		[Bindable]
		public var levelHeight:uint = 10000;
		
		[Bindable]
		public var locked:Boolean = false;
		
		public function ScreenSettings()
		{
			//Empty
		}
	}
}