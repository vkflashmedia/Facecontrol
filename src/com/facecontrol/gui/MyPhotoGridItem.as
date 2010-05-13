package com.facecontrol.gui
{
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class MyPhotoGridItem extends GameObject
	{
		private var _photoData:Object;
		
		public function MyPhotoGridItem(value:GameScene, photoData:Object, width:Number, height:Number)
		{
			super(value);
			_photoData = photoData;
			this.width = width;
			this.height = height;
			
			var photoBitmap:Bitmap = new Bitmap(Util.multiLoader.get(_photoData.pid).bitmapData);
			var photo:Photo = new Photo(_scene, photoBitmap, 4, 4, 61, 57, Photo.BORDER_TYPE_RECT);
			photo.photoBorderColor = 0x824e4c;
			photo.photoBorder = 1;
			addChild(photo);
			
			if (_photoData.votes_count > 0) {
				var star:Bitmap = BitmapUtil.cloneImageNamed(Images.RATING_ON);
				star.x = 73;
				star.y = 5;
				addChild(star);
			
				var rating:TextField = new TextField();
				rating.x = 93;
				rating.autoSize = TextFieldAutoSize.LEFT;
				rating.text = _photoData.rating_average;
				rating.setTextFormat(new TextFormat(Util.tahoma.fontName, 17.7, 0xffffff));
				rating.embedFonts = true;
				rating.antiAliasType = AntiAliasType.ADVANCED;
				addChild(rating);
				
				var votes:TextField = new TextField;
				votes.x = 73;
				votes.y = 29;
				votes.width = 45;
				votes.height = 30;
				votes.text = _photoData.votes_count;
				votes.setTextFormat(new TextFormat(Util.tahoma.fontName, 10, 0xb0dee6));
				votes.embedFonts = true;
				votes.antiAliasType = AntiAliasType.ADVANCED;
				addChild(votes);
				
				var label:TextField = new TextField;
				label.x = 73;
				label.y = 40;
				label.width = 45;
				label.height = 30;
				label.text = Util.votes(_photoData.votes_count);
				label.setTextFormat(new TextFormat(Util.tahoma.fontName, 10, 0x9a9a9a));
				label.embedFonts = true;
				label.antiAliasType = AntiAliasType.ADVANCED;
				addChild(label);
			}
			else {
				var noVotes1:TextField = new TextField;
				noVotes1.x = 73;
				noVotes1.y = 14;
				noVotes1.width = 40;
				noVotes1.text = "нет";
				noVotes1.autoSize = TextFieldAutoSize.CENTER;
				noVotes1.setTextFormat(new TextFormat(Util.tahoma.fontName, 10, 0x9a9a9a));
				noVotes1.embedFonts = true;
				noVotes1.antiAliasType = AntiAliasType.ADVANCED;
				addChild(noVotes1);
				
				var noVotes2:TextField = new TextField;
				noVotes2.x = 73;
				noVotes2.y = 24;
				noVotes2.width = 40;
				noVotes2.text = "голосов";
				noVotes2.autoSize = TextFieldAutoSize.CENTER;
				noVotes2.setTextFormat(new TextFormat(Util.tahoma.fontName, 10, 0x9a9a9a));
				noVotes2.embedFonts = true;
				noVotes2.antiAliasType = AntiAliasType.ADVANCED;
				addChild(noVotes2);
			}
			
			if (_photoData.main == 1) {
				var v:Bitmap = Util.multiLoader.get(Images.V);
				v.x = -4;
				v.y = 46;
				addChild(v);
			}
		}
		
		public function get photoData():Object {
			return _photoData;
		}
	}
}