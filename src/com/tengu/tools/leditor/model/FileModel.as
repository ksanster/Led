package com.tengu.tools.leditor.model
{
	public class FileModel
	{
		private var fileName:String;

		public var saved:Boolean = true;
		
		[Bindable]
		public function set projectFileName(value:String):void 
		{
			fileName = value;
		}
		
		public function get projectFileName():String 
		{
			return fileName;
		}

		public function FileModel()
		{
			//Empty
		}
	}
}