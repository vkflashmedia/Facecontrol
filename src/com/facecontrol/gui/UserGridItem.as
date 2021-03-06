package com.facecontrol.gui
{
	import com.facecontrol.forms.AllUserPhotoForm;
	import com.facecontrol.forms.PreloaderSplash;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.Form;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class UserGridItem extends GameObject
	{
		private var _user:Object;
		public function UserGridItem(value:GameScene, userRaw:Object, photoBitmap:Bitmap, drawLine:Boolean, showFavoriteLink:Boolean=true, ownerForm:Form=null)
		{
			super(value);
			_user = userRaw;
			setSelect(true);
			
			this.width = 329;
			this.height = 99;
			
			var photo:Photo;
			if (userRaw.pid) {
				photo = new Photo(_scene, photoBitmap, 16, 18, 61, 57, Photo.BORDER_TYPE_RECT);
				photo.photoBorderColor = 0x4c3542;
				photo.photoBorder = 1;
				photo.horizontalScale = Photo.HORIZONTAL_SCALE_ALWAYS;
				photo.verticalScale = Photo.VERTICAL_SCALE_ALWAYS;
				addChild(photo);
				
				var morePhotos:LinkButton = new LinkButton(value, Util.getMorePhotoString(userRaw.sex), 14, 75);
				morePhotos.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0x8bbe79, null, null, true), CONTROL_STATE_NORMAL);
				morePhotos.textField.embedFonts = true;
				morePhotos.textField.antiAliasType = AntiAliasType.ADVANCED;
				morePhotos.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function (event: GameObjectEvent): void {
					scene.showModal(PreloaderSplash.instance);
					AllUserPhotoForm.instance.user = userRaw;
					AllUserPhotoForm.instance.returnForm = ownerForm;
					AllUserPhotoForm.instance.show();
				});
				addChild(morePhotos);
			}
			else if (userRaw.photo_big) {
				photo = new Photo(_scene, photoBitmap, 16, 18, 61, 57, Photo.BORDER_TYPE_RECT);
				photo.photoBorderColor = 0x4c3542;
				photo.photoBorder = 1;
				addChild(photo);
				
				var invite:LinkButton = new LinkButton(value, 'пригласить', 258, 75);
				invite.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0xce7716, null, null, true), CONTROL_STATE_NORMAL);
				invite.textField.embedFonts = true;
				invite.textField.antiAliasType = AntiAliasType.ADVANCED;
				invite.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onInviteClick);
				addChild(invite);
			}
			
			if (userRaw.hasOwnProperty('frame')) {
				photo.frameIndex = userRaw.frame;
			}
			
			var componentY: int = 12;
			
			if (userRaw.hasOwnProperty('rating')) {
//				var label:TextField = Util.createLabel('Рейтинг: ', 89, 60);
				var label:TextField = Util.createLabel('Рейтинг: ', 89, componentY + 4);
				label.autoSize = TextFieldAutoSize.LEFT;
				label.embedFonts = true;
				label.antiAliasType = AntiAliasType.ADVANCED;
				label.selectable = false;
				label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0x9a9a9a));
				addChild(label);
				
				var index:int = label.length;
				label.appendText(userRaw.rating);
				label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xffffff), index, label.text.length);
				
				componentY += label.height;
			}
			
			if (userRaw.votes_count && userRaw.votes_count > 0) {
				var star:Bitmap = BitmapUtil.cloneImageNamed(Images.RATING_ON);
				star.x = 89;
				star.y = componentY + 5;
				addChild(star);
				
				var rating:TextField = new TextField();
				rating.x = 112;
				rating.y = componentY;
				rating.autoSize = TextFieldAutoSize.LEFT;
				rating.text = userRaw.rating_average;
				rating.setTextFormat(new TextFormat(Util.tahoma.fontName, 17.7, 0xffffff));
				rating.embedFonts = true;
				rating.antiAliasType = AntiAliasType.ADVANCED;
				rating.selectable = false;
				addChild(rating);
				
				var votesCount:String = userRaw.votes_count;
				var votes:TextField = new TextField;
				votes.x = 151;
				votes.y = componentY + 5;
				votes.autoSize = TextFieldAutoSize.LEFT;
				votes.text = '(' + votesCount + ' ' + votesString(userRaw.votes_count) + ')';
				votes.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0x9a9a9a));
				votes.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xb0dee6), 1, votesCount.length + 1);
				votes.embedFonts = true;
				votes.antiAliasType = AntiAliasType.ADVANCED;
				votes.selectable = false;
				addChild(votes);
				
				componentY += 5 + star.height;
			}
			else {
				var noVotes:TextField = new TextField();
				noVotes.x = 89;
				noVotes.y = componentY + 4;
				noVotes.autoSize = TextFieldAutoSize.LEFT;
				noVotes.text = 'нет голосов';
				noVotes.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xb0dee6));
				noVotes.embedFonts = true;
				noVotes.antiAliasType = AntiAliasType.ADVANCED;
				noVotes.selectable = false;
				addChild(noVotes);
				componentY += 4 + noVotes.height;
			}
			
//			var vkButton:Button = new Button(_scene, 90, 41);
			var vkButton:Button = new Button(_scene, 90, componentY + 4);	
			vkButton.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.VK_ICON), CONTROL_STATE_NORMAL);
			vkButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK,
				function(event:GameObjectEvent):void {
					Util.gotoUserProfile(userRaw.uid);
				}
			);
			addChild(vkButton);
			
//			var name:LinkButton = new LinkButton(value, Util.fullName(userRaw, 25), 113, 39);
			var name:LinkButton = new LinkButton(value, Util.fullName(userRaw, 25), 113, componentY + 2);
			name.textField.setTextFormat(new TextFormat(Util.tahomaBold.fontName, 12, 0xffa21e, false, false, true));
			name.textField.embedFonts = true;
			name.textField.antiAliasType = AntiAliasType.ADVANCED;
			name.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK,
				function(event:GameObjectEvent):void {
					Util.gotoUserProfile(userRaw.uid);
				}
			);
			addChild(name);
			
			/*
			if (userRaw.age && userRaw.age > 0) {
				label.text = userRaw.age + ' ' + ageString(userRaw.age);
				label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xffffff), 0, label.text.length);
			}
			
			var i:int;
			if (userRaw.country) {
				i = 0;
				
				if (label.text) {
					i = label.text.length;
					label.appendText(', ' + userRaw.country);
				}
				else label.text = userRaw.country;
				label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0x9a9a9a), i, label.text.length);
			}
			
			if (userRaw.city) {
				i = 0;
				if (label.text) {
					i = label.text.length;
					label.appendText(', ' + userRaw.city);
				}
				else label.text = userRaw.city;
				label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0x9a9a9a), i, label.text.length);
			}
			*/
			if (userRaw.hasOwnProperty('favorite') && showFavoriteLink) {
				var favorite:LinkButton = new LinkButton(value,
					(userRaw.favorite) ? 'Удалить из избранных' : 'Добавить в избранные', 214, 75, TextFieldAutoSize.RIGHT);
				favorite.width = 100;
				favorite.height = favorite.textField.height;
				favorite.update();
				favorite.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0xce7716, null, null, true), CONTROL_STATE_NORMAL);
				favorite.textField.embedFonts = true;
				favorite.textField.antiAliasType = AntiAliasType.ADVANCED;
				favorite.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onFavoriteClick);
				addChild(favorite);
			}
			
			if (drawLine) {
				var line:Bitmap = BitmapUtil.cloneImageNamed(Images.FRIENDS_LINE);
				line.x = 4;
				line.y = height - 1;
				addChild(line);
			}
		}
		
		private static function ageString(age:int):String {
			var result:String;
			switch (age) {
				case 11:
				case 12:
				case 13:
				case 14:
					result = 'лет';
				break;
				
				default: {
					var remainder:int = age % 10;
					switch (remainder) {
						case 1:
							result = 'год';
						break;
						case 2:
						case 3:
						case 4:
							result = 'года';
						break;
						default:
							result = 'лет';
					}
				}
			}
			
			return result;
		}
		
		private static function votesString(votes:int):String {
			var result:String;
			switch (votes) {
				case 11:
				case 12:
				case 13:
				case 14:
					result = 'голосов';
				break;
				
				default: {
					var remainder:int = votes % 10;
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
			}
			
			return result;
		}
		
		public function onFavoriteClick(event:GameObjectEvent):void {
			PreloaderSplash.instance.showModal();
			if (_user.favorite) Util.api.deleteFavorite(Util.viewer_id, _user.uid);
			else Util.api.addFavorite(Util.viewer_id, _user.uid);
		}
		
		public function onInviteClick(event:GameObjectEvent):void {
			if (Util.wrapper.external) {
				Util.wrapper.external.showInviteBox();
			}
		}
	}
}