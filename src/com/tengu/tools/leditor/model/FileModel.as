package com.tengu.tools.leditor.model
{
	public class FileModel
	{
		private var fileName:String;
		private var fileContent:XML;
		

		[Bindable]
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
		
		public function set content(value:XML):void 
		{
			fileContent = value;
		}
		
		public function get content():XML 
		{
			return fileContent;
		}

		public function FileModel()
		{
			//Empty
		}
	}
}