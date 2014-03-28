package com.tengu.scroll.layers
{
	import com.tengu.scene.api.IPlainObject;
	import com.tengu.scene.objects.PlainObject;
	import com.tengu.tools.leditor.api.IPropertyContainer;
	import com.tengu.tools.leditor.api.ISelectable;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	public class BaseTile extends PlainObject implements IPlainObject, IPropertyContainer, ISelectable
	{
		private var isSelected:Boolean;
		private var propertyList:IList;
		
		public function set selected (value:Boolean):void
		{
			if (isSelected == value)
			{
				return;
			}
			isSelected = value;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function get selected ():Boolean
		{
			return isSelected;
		}

		[Bindable]
		public function set properties(value:IList):void 
		{
			propertyList = value;
		}
		
		public function get properties():IList
		{
			return propertyList;
		}

		public function BaseTile()
		{
			super();
		}
		
		protected override function initialize():void
		{
			super.initialize();
			propertyList = new ArrayCollection();
		}
	}
}