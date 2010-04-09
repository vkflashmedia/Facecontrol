package com.facecontrol.util
{
	public class UserObject
	{
		public var pid:String;
		public var src_big:String;
		public var comment:String;
		public var rating_average:String;
		public var fname:String;
		public var lname:String;
		public var nickname:String;
		public var votes_count:String;
		
		public function UserObject(obj:Object) {
			pid = obj["pid"];
			src_big = obj["src_big"];
			comment = obj["comment"];
			rating_average = obj["rating_average"];
			fname = obj["fname"];
			votes_count = obj["votes_count"];
		}

	}
}