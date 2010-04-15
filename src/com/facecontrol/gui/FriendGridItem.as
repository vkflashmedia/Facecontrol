package com.facecontrol.gui
{
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.Bitmap;

	public class FriendGridItem extends GameObject
	{
		public function FriendGridItem(value:GameScene, userRaw:Object, drawLine:Boolean)
		{
			super(value);
			
			this.width = 329;
			this.height = 99;
			
			if (Util.multiLoader.hasLoaded(userRaw.pid)) {
				var photoBitmap:Bitmap = new Bitmap(Util.multiLoader.get(userRaw.pid).bitmapData);
				var photo:Photo = new Photo(_scene, photoBitmap, 16, 18, 61, 57, Photo.BORDER_TYPE_RECT);
				photo.photoBorderColor = 0x824e4c;
				photo.photoBorder = 1;
				addChild(photo);
			}
			
//			var label:TextField = new TextField();
//			label.x = 73;
//			label.y = 40;
//			label.width = 45;
//			label.height = 30;
//			label.text = userRaw.fname;
//			label.setTextFormat(new TextFormat(Util.tahoma.fontName, 10, 0x9a9a9a));
//			label.embedFonts = true;
//			label.antiAliasType = AntiAliasType.ADVANCED;
//			addChild(label);

			if (drawLine) {
				var bit:Bitmap = new Bitmap(Util.multiLoader.get(Images.FRIENDS_LINE).bitmapData);
				bit.x = 4;
				bit.y = height - 1;
				addChild(bit);
			}
		}
	}
}