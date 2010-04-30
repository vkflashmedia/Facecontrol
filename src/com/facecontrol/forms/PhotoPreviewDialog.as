package com.facecontrol.forms
{
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
			
			bitmap = photo;
			bitmap.x = (Constants.APP_WIDTH - bitmap.width) / 2;
			bitmap.y = 80 + (540 - bitmap.height) / 2;
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function onClick(event:MouseEvent):void {
			_scene.resetModal(this);
		}
	}
}