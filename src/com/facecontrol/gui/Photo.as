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
			while (numChildren > 0) {
				removeChildAt(0);
			}
				
			if (_photo) {
				_thumbnail = new Bitmap(_photo.bitmapData, "auto", true);
				
				var matrix:Matrix = new Matrix();
				var s:Number = (width - _photoBorder*2) / _thumbnail.width;
				matrix.scale(s, s);
				_thumbnail.transform.matrix = matrix;
				
				if (_thumbnail.height < (height - _photoBorder*2)) {
					s = (height - _photoBorder*2) / _thumbnail.height;
					matrix.scale(s, s);
					_thumbnail.transform.matrix = matrix;
				}
					
				_transparentSquare = new Sprite();
				_transparentSquare.graphics.beginFill(_photoBorderColor, 0.5);

				switch (_borderType) {
					case BORDER_TYPE_ROUND_RECT:
						_transparentSquare.graphics.drawRoundRect(0, 0, width, height, 15, 15);
					break;
					case BORDER_TYPE_RECT:
						_transparentSquare.graphics.drawRect(0, 0, width, height);
					break;
				}
				
				addChild(_transparentSquare);
				addChild(_thumbnail);
				
				_squareMask = new Sprite();
				_squareMask.graphics.beginFill(_photoBorderColor);
				
				switch (_borderType) {
					case BORDER_TYPE_ROUND_RECT:
						_squareMask.graphics.drawRoundRect(_photoBorder, _photoBorder, width - _photoBorder*2, height - _photoBorder*2, 15, 15);
					break;
					case BORDER_TYPE_RECT:
						_squareMask.graphics.drawRect(_photoBorder, _photoBorder, width - _photoBorder*2, height - _photoBorder*2);
					break;
				}
				
				addChild(_squareMask);
				
				_thumbnail.x = _photoBorder;
				_thumbnail.x = (width - _thumbnail.width) / 2;
				_thumbnail.y = _photoBorder;
				_thumbnail.mask = _squareMask;
			}
		}
		
		public function set photo(value:Bitmap):void {
			_photo = (value) ? BitmapUtil.cloneBitmap(value) : null;
			update();
		}
		
		public function get photo():Bitmap {
			return _photo;
		}
		
		public override function get bitmap():Bitmap {
			return _thumbnail;
		}
	}
}