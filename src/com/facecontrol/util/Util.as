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
		
		public static var wrapper:Object;
		public static var user:Object;
		
		public static var userId:uint = 11854430;//57856825;//11854430;//9028622;//11757602;//9028622;//4136593;
		public static var viewer_id:uint = 11854430;//57856825;//11854430;
		public static var firstName: String;
		public static var nickname: String;
		public static var lastName: String;
		public static var multiLoader: MultiLoader = new MultiLoader();
		public static var scene:GameScene;
		public static var api:Api = new Api();
		public static var vkontakte:VKontakte = new VKontakte();
		
		public static function createLabel(text:String, x:int, y:int, width:int=0, height:int=0):TextField {
			var label:TextField = new TextField();
			label.text = (text) ? text : '';
			label.x = x;
			label.y = y;
			label.width = width;
			label.height = height;
			label.selectable = false;
			
			return label;
		}
		
		public static function getMorePhotoString(sex:String):String {
			var result:String = 'Другие ';
			switch (sex) {
				case '1':
					result += 'ее';
				break;
				case '2':
					result += 'его';
				break;
			}
			result += ' фото';
			return result;
		}
		
		public static function fullName(user:Object, limit: int = 20): String {
			if (limit < 3) {
				limit = 3;
			}
			var fn: String = '';
			if (user) {
				if (user.first_name) fn += user.first_name + ' ';
				if (user.nickname) fn += user.nickname + ' ';
				if (user.last_name) fn += user.last_name;
			}
//			var fn: String = firstName + ' ' + ((nickname) ? (nickname + ' ') : '') + lastName;
			if (fn.length > limit) {
				fn = fn.substr(0, limit) + '...';
			}
			return fn;
		}
		
		public static function votes(value:int):String {
			var result:String = '';
			switch (value) {
				case 11:
				case 12:
				case 13:
				case 14:
					result = 'голосов';
				break;
				default:
					var remainder:int = value % 10;
					switch (remainder) {
						case 1:
							result = 'голос';
						break;
						case 2:
						case 3:
						case 4:
							result = 'голоса';
						break;
						default:
							result = 'голосов';
					}
			}
			
			return result;
		}
		
		public static function votesCount(value:int):String {
			return value + ' ' + votes(value);
		}
	}
}