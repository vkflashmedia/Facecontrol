package com.facecontrol.gui
{
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class FriendGridItem extends GameObject
	{
		public function FriendGridItem(value:GameScene, userRaw:Object, drawLine:Boolean)
		{
			super(value);
			
			this.width = 329;
			this.height = 99;
			
			var photoBitmap:Bitmap;
			var photo:Photo;
			if (Util.multiLoader.hasLoaded(userRaw.pid)) {
				photoBitmap = BitmapUtil.cloneImageNamed(userRaw.pid);
				photo = new Photo(_scene, photoBitmap, 16, 18, 61, 57, Photo.BORDER_TYPE_RECT);
				photo.photoBorderColor = 0x4c3542;
				photo.photoBorder = 1;
				addChild(photo);
				
				var morePhotos:LinkButton = new LinkButton(value, Util.getMorePhotoString(userRaw.sex), 214, 75, TextFieldAutoSize.RIGHT);
				morePhotos.width = 50;
				morePhotos.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0x8bbe79, null, null, true), CONTROL_STATE_NORMAL);
				morePhotos.textField.embedFonts = true;
				morePhotos.textField.antiAliasType = AntiAliasType.ADVANCED;
				addChild(morePhotos);
			}
			else if (Util.multiLoader.hasLoaded(userRaw.photo_big)) {
				photoBitmap = BitmapUtil.cloneImageNamed(userRaw.photo_big);
				photo = new Photo(_scene, photoBitmap, 16, 18, 61, 57, Photo.BORDER_TYPE_RECT);
				photo.photoBorderColor = 0x4c3542;
				photo.photoBorder = 1;
				addChild(photo);
				
				var invite:LinkButton = new LinkButton(value, 'пригласить', 258, 75);
				invite.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0xce7716, null, null, true), CONTROL_STATE_NORMAL);
				invite.textField.embedFonts = true;
				invite.textField.antiAliasType = AntiAliasType.ADVANCED;
				addChild(invite);
			}
			
			if (userRaw.votes_count && userRaw.votes_count > 0) {
				var star:Bitmap = BitmapUtil.cloneImageNamed(Images.RATING_ON);
				star.x = 89;
				star.y = 17;
				addChild(star);
				
				var rating:TextField = new TextField();
				rating.x = 112;
				rating.y = 12;
				rating.autoSize = TextFieldAutoSize.LEFT;
				rating.text = userRaw.rating_average;
				rating.setTextFormat(new TextFormat(Util.tahoma.fontName, 17.7, 0xffffff));
				rating.embedFonts = true;
				rating.antiAliasType = AntiAliasType.ADVANCED;
				addChild(rating);
				
				var votesCount:String = userRaw.votes_count;
				var votes:TextField = new TextField;
				votes.x = 151;
				votes.y = 17;
				votes.autoSize = TextFieldAutoSize.LEFT;
				votes.text = '(' + votesCount + ' ' + votesString(userRaw.votes_count) + ')';
				votes.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0x9a9a9a));
				votes.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xb0dee6), 1, votesCount.length + 1);
				votes.embedFonts = true;
				votes.antiAliasType = AntiAliasType.ADVANCED;
				addChild(votes);
			}
			else {
				var noVotes:TextField = new TextField();
				noVotes.x = 89;
				noVotes.y = 16;
				noVotes.autoSize = TextFieldAutoSize.LEFT;
				noVotes.text = 'нет голосов';
				noVotes.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xb0dee6));
				noVotes.embedFonts = true;
				noVotes.antiAliasType = AntiAliasType.ADVANCED;
				addChild(noVotes);
			}
			
			var name:TextField = new TextField();
			name.x = 89;
			name.y = 39;
			name.autoSize = TextFieldAutoSize.LEFT;
			name.text = userRaw.first_name;
			name.setTextFormat(new TextFormat(Util.tahomaBold.fontName, 12, 0xffa21e));
			name.embedFonts = true;
			name.antiAliasType = AntiAliasType.ADVANCED;
			addChild(name);
			
			var label:TextField = new TextField();
			label.x = 89;
			label.y = 60;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			addChild(label);
			
			if (userRaw.age) {
				label.text = userRaw.age + ' ' + ageString(userRaw.age);
				label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xffffff), 0, label.text.length);
			}
			else if (userRaw.bdate) {
				var age:int = 0;
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
	}
}