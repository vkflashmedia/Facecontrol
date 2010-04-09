package com.facecontrol.util
{
	public class PhotoObject
	{
		public var pid:String;
		public var src_big:String;
		public var rating_average:String;
		public var votes_count:String;
		private var main:int;
		
		public function PhotoObject(obj:Object)
		{
			main = obj["main"];
			pid = obj["pid"];
			src_big = obj["src_big"];
			rating_average = obj["rating_average"];
			votes_count = obj["votes_count"];
		}

		public function get isMain():Boolean {
			return main == 1;
		}
	}
}