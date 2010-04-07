package com.facecontrol.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class Photo extends GameObject
	{
		private var _photo:Bitmap;
		private var _thumbnail:Bitmap;
		private var _transparentSquare:Sprite;
		private var _squareMask:Sprite;
		
		public function Photo(value:GameScene, image:Bitmap, x:int, y:int, width:int, height:int)
		{
			super(value);
			
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			autoSize = false;
			
			photo = image;
		}
		
		private function update():void {
			if (_thumbnail) {
				removeChild(_thumbnail);
			}
			
			_thumbnail = new Bitmap(_photo.bitmapData);
			var matrix:Matrix = new Matrix();
			var s:Number = width / _thumbnail.width;
			matrix.scale(s, s);
			_thumbnail.transform.matrix = matrix;
			if (_thumbnail.height > height) {
				s = height / _thumbnail.height;
				matrix.scale(s, s);
				_thumbnail.transform.matrix = matrix;
			}
				
			if (_transparentSquare) {
				removeChild(_transparentSquare);
			}
			_transparentSquare = new Sprite();
			_transparentSquare.graphics.beginFill(0x0, 0.5);
			_transparentSquare.graphics.drawRoundRect(-2, -2, _thumbnail.width + 4, _thumbnail.height + 4, 15, 15);
			addChild(_transparentSquare);
			addChild(_thumbnail);
			
			if (_squareMask) {
				removeChild(_squareMask);
			}
			_squareMask = new Sprite();
			_squareMask.graphics.beginFill(0x0);
			_squareMask.graphics.drawRoundRect(0, 0, _thumbnail.width, _thumbnail.height, 15, 15);
			addChild(_squareMask);
			_thumbnail.mask = _squareMask;
			
		}
		
		public function set photo(value:Bitmap):void {
			if (value != null) {
				_photo = value;
				update();
			}
		}
		
		public function get photo():Bitmap {
			return _photo;
		}
		
		public override function get bitmap():Bitmap {
			return _thumbnail;
		}
		
//		public override function destroy():void {
//			if (_thumbnail) {
//				removeChild(_thumbnail);
//				_thumbnail.bitmapData.dispose();
//			}
//			super.destroy();
//		}
	}
}