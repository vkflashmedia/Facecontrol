package com.facecontrol.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class Photo extends GameObject
	{
		public static const BORDER_TYPE_ROUND_RECT:uint = 0;
		public static const BORDER_TYPE_RECT:uint = 1;
		
		private var _photoBorder:uint;
		private var _photoBorderColor:int;
		private var _borderType:uint = BORDER_TYPE_ROUND_RECT;
		
		private var _photo:Bitmap;
		private var _thumbnail:Bitmap;
		private var _transparentSquare:Sprite;
		private var _squareMask:Sprite;
		
		public function Photo(value:GameScene, image:Bitmap, x:int, y:int, width:int, height:int, type:uint=0)
		{
			super(value);
			
			_photoBorderColor = 0x000000;
			_borderType = type;
			_photoBorder = 2;
			
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			autoSize = false;
			photo = image;
		}
		
		public function set photoBorder(value:uint):void {
			_photoBorder = value;
			update();
		}
		
		public function set photoBorderColor(value:int):void {
			_photoBorderColor = value;
			update();
		}
		
		public function set borderType(value:uint):void {
			_borderType = value;
			update();
		}
		
		private function update():void {
			if (_photo) {
				if (_thumbnail) {
					removeChild(_thumbnail);
				}
				
				_thumbnail = new Bitmap(_photo.bitmapData);
				
				var matrix:Matrix = new Matrix();
				var s:Number = (width - _photoBorder*2) / _thumbnail.width;
				matrix.scale(s, s);
				_thumbnail.transform.matrix = matrix;
				
				if (_thumbnail.height > (height - _photoBorder*2)) {
					s = (height - _photoBorder*2) / _thumbnail.height;
					matrix.scale(s, s);
					_thumbnail.transform.matrix = matrix;
				}
					
				if (_transparentSquare) {
					removeChild(_transparentSquare);
				}
				
				_transparentSquare = new Sprite();
				_transparentSquare.graphics.beginFill(_photoBorderColor, 0.5);
				switch (_borderType) {
					case BORDER_TYPE_ROUND_RECT:
						_transparentSquare.graphics.drawRoundRect(0, 0, _thumbnail.width + _photoBorder*2, _thumbnail.height + _photoBorder*2, 15, 15);
					break;
					case BORDER_TYPE_RECT:
						_transparentSquare.graphics.drawRect(0, 0, _thumbnail.width + _photoBorder*2, _thumbnail.height + _photoBorder*2);
					break;
				}
				
				addChild(_transparentSquare);
				addChild(_thumbnail);
				
				if (_squareMask) {
					removeChild(_squareMask);
				}
				_squareMask = new Sprite();
				_squareMask.graphics.beginFill(_photoBorderColor);
				switch (_borderType) {
					case BORDER_TYPE_ROUND_RECT:
						_squareMask.graphics.drawRoundRect(_photoBorder, _photoBorder, _thumbnail.width, _thumbnail.height, 15, 15);
					break;
					case BORDER_TYPE_RECT:
						_squareMask.graphics.drawRect(_photoBorder, _photoBorder, _thumbnail.width, _thumbnail.height);
					break;
				}
				
				addChild(_squareMask);
				
				_thumbnail.x = _photoBorder;
				_thumbnail.y = _photoBorder;
				_thumbnail.mask = _squareMask;
			}
		}
		
		public function set photo(value:Bitmap):void {
			if (value != null) {
				_photo = BitmapUtil.clone(value);
				update();
			}
		}
		
		public function get photo():Bitmap {
			return _photo;
		}
		
		public override function get bitmap():Bitmap {
			return _thumbnail;
		}
	}
}