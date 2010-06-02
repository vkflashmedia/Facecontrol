package com.facecontrol.dialog
{
	import com.facecontrol.gui.Photo;
	import com.facecontrol.util.Constants;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	public class PhotoPreviewDialog extends GameLayer
	{
		public function PhotoPreviewDialog(value:GameScene, photo:Bitmap)
		{
			super(value);
			
			this.graphics.beginFill(0x00, 0.5);
			this.graphics.drawRect(0, 0, _scene.width, _scene.height);
			
//			bitmap = photo;
//			bitmap.x = 50 + (Constants.APP_WIDTH - 100 - bitmap.width) / 2;
//			bitmap.y = 80 + (540 - bitmap.height) / 2;

			var photoWidth:int = photo.width > 540 ? 540 : photo.width;
			var photoHeight:int = photo.height > 600 ? 600 : photo.height;
			var p:Photo = new Photo(
				value,
				photo,
				(Constants.APP_WIDTH - photoWidth) / 2,
				80 + (540 - photoHeight) / 2,
				photoWidth,
				photoHeight,
				Photo.BORDER_TYPE_RECT);
			p.photoBorder = 1;
			addChild(p);
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function onClick(event:MouseEvent):void {
			_scene.resetModal(this);
		}
	}
}