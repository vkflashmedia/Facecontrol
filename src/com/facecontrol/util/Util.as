package com.facecontrol.util
{
	import com.efnx.net.MultiLoader;
	import com.facecontrol.api.Api;
	import com.facecontrol.dialog.Alert;
	import com.facecontrol.dialog.MessageDialog;
	import com.facecontrol.dialog.MessageDialogEvent;
	import com.facecontrol.dialog.PaymentDialog;
	import com.facecontrol.forms.Background;
	import com.facecontrol.forms.PreloaderSplash;
	import com.flashmedia.basics.GameScene;
	import com.net.VKontakte;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.Font;
	import flash.text.TextField;
	
	public class Util
	{
		public static const WALL_POST_COMPENSATION:int = 5;
		
		public static const opiumBold:Font = new EmbeddedFonts_OpiumBold();
		public static const tahoma:Font = new EmbeddedFonts_TahomaEmbed();
		public static const tahomaBold:Font = new EmbeddedFonts_TahomaBoldEmbed();
		public static const university:Font = new EmbeddedFonts_University();
		public static const DEBUG:Boolean = true;
		
		public static var wrapper:Object;
		public static var user:Object;
		public static var inviteCount:int;
		
		public static var auth_key:String;
		public static var requestVotes:int = 0;
		public static var user_id:uint = 90412585;
		public static var viewer_id:uint = 90412585;
		public static var wall_id:String;
		
		public static var scene:GameScene;
		public static var multiLoader: MultiLoader = new MultiLoader();
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
		
		public static function showError(errorCode:int, errorMessage:String):void {
			PreloaderSplash.instance.resetModal();
			switch (errorCode) {
				default:
					Alert.show('Ошибка:', errorMessage, 'Ок');
			}
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
		
		public static function gotoUserProfile(uid:String):void {
			if (Util.user.account > 0) {
				Util.api.gotoProfile();
				Util.user.account -= 1;
				Background.instance.updateAccount();
				navigateToURL(new URLRequest('http://vkontakte.ru/id'+uid));
			}
			else {
				var message:MessageDialog = new MessageDialog(Util.scene, 'Сообщение', 'На вашем счету недостаточно' + 
						' монет. Пополнить счет?', 'Да', 'Нет');
				message.addEventListener(MessageDialogEvent.CANCEL_BUTTON_CLICKED, function(event:MessageDialogEvent):void {
					PaymentDialog.showPayment();
				});
				Util.scene.showModal(message);
			}
		}
		
		public static function random(low:Number=NaN, high:Number=NaN):Number {
			var low:Number = low;
			var high:Number = high;
		
			if(isNaN(low)) throw new Error("low must be defined");
			if(isNaN(high)) throw new Error("high must be defined");
		
			return Math.round(Math.random() * (high - low)) + low;
		}
	}
}