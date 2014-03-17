package com.tengu.tools.leditor.model
{
	import com.tengu.tools.leditor.model.enum.ActionType;

	public class ActionModel
	{
		public static const DEFAULT_BUTTONBAR_STATE:String = "defaultState";
		[Bindable]
		public var actionType:String = ActionType.MOVE;
		
		[Bindable]
		public var buttonBarState:String;
		
		public function ActionModel()
		{
			//Empty
		}
	}
}