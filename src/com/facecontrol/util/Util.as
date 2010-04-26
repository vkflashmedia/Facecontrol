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
		
		public static const apiId:uint = 1827403;
		public static var user:Object;
		
		public static var userId:uint = /*11757602;*/9028622;
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
	}
}