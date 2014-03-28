package com.tengu.tools.leditor.model
{
	import com.tengu.scroll.layers.BaseTile;
	import com.tengu.tools.leditor.model.enum.SelectionType;

	public class SelectionModel
	{
		private var selected:BaseTile;
		
		private function set selectionFlag(value:Boolean):void 
		{
			if (selected != null)
			{
				selected.selected = value;
				selectionState = value ? SelectionType.TILE : SelectionType.NONE;
			}
		}
		
		[Bindable]
		public function set selectedTile(value:BaseTile):void 
		{
			if (selected == value)
			{
				return;
			}
			selectionFlag = false;
			selected = value;
			selectionFlag = true;
		}
		
		public function get selectedTile():BaseTile 
		{
			return selected;
		}
		
		[Bindable]
		public var selectionState:String = SelectionType.NONE;
		
		public function SelectionModel()
		{
			//Empty
		}
	}
}