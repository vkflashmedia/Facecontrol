package com.facecontrol.util
{
	import com.efnx.net.MultiLoader;
	import com.facecontrol.api.Api;
	import com.flashmedia.basics.GameScene;
	import com.net.VKontakte;
	
	import flash.text.Font;
	import flash.text.TextField;
	
	public class Util
	{
		public static const opiumBold:Font = new EmbeddedFonts_OpiumBold();
		public static const tahoma:Font = new EmbeddedFonts_TahomaEmbed();
		public static const tahomaBold:Font = new EmbeddedFonts_TahomaBoldEmbed();
		
		public static var src_small:String;
		public static var src:String;
		public static var src_big:String;
		
		public static var userId:uint = 11757602;//9028622;
		public static var firstName: String;
		public static var nickname: String;
		public static var lastName: String;
		public static var multiLoader: MultiLoader = new MultiLoader();
		public static var scene:GameScene;
		public static var api:Api = new Api();
		public static var vkontakte:VKontakte = new VKontakte();
		
		public static function createLabel(text:String, x:int, y:int, width:int=0, height:int=0):TextField {
			var label:TextField = new TextField();
			label.text = (text) ? text : "";
			label.x = x;
			label.y = y;
			label.width = width;
			label.height = height;
			label.selectable = false;
			
			return label;
		}
		
		public static function fullName(limit: int = 20): String {
			if (limit < 3) {
				limit = 3;
			}
			var fn: String = firstName + ' ' + ((nickname) ? (nickname + ' ') : '') + lastName;
			if (fn.length > limit) {
				fn = fn.substr(0, limit) + '...';
			}
			return fn;
		}
	}
}