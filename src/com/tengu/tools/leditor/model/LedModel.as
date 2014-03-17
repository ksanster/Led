package com.tengu.tools.leditor.model
{
	import com.tengu.core.errors.SingletonConstructError;
	import com.tengu.tools.leditor.api.IEditableLayer;
	import com.tengu.tools.leditor.model.enum.LayerType;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	public class LedModel
	{
		public static const instance:LedModel = new LedModel();
		
		[Bindable]
		public var actions:ActionModel;

		[Bindable]
		public var files:FileModel;
		
		[Bindable]
		public var screenSettings:ScreenSettings;
		
		[Bindable]
		public var layers:LayerModel;
		
		public function LedModel()
		{
			if (instance != null)
			{
				throw new SingletonConstructError(this);
			}
			initialize();
		}
		
		private function initialize():void
		{
			actions = new ActionModel();
			actions.buttonBarState = ActionModel.DEFAULT_BUTTONBAR_STATE;
			
			files = new FileModel();
			screenSettings = new ScreenSettings();
			layers = new LayerModel();
		}
	}
}