package com.tengu.tools.leditor.model
{
	import com.tengu.tools.leditor.model.enum.ActionType;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class ActionModel extends EventDispatcher
	{
		public static const DEFAULT_BUTTONBAR_STATE:String = "defaultState";
		public static const ACTION_CHANGED:String = "actionChanged";
		
		private var modelActionType:String = ActionType.MOVE;
		
		[Bindable]
		public function set actionType(value:String):void 
		{
			if (modelActionType == value)
			{
				return;
			}
			modelActionType = value;
			dispatchEvent(new Event(ACTION_CHANGED));
		}
		
		public function get actionType():String 
		{
			return modelActionType;
		}
		
		[Bindable]
		public var buttonBarState:String;
		
		public function ActionModel()
		{
			//Empty
		}
	}
}