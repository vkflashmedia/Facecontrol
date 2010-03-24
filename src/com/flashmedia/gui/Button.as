package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class Button extends GameObject
	{
		public static const STATE_UP:uint = 0;
		public static const STATE_DOWN:uint = 1;
		
		private static const HORIZONTAL_INDENT:uint = 10;
		private static const VERTICAL_INDENT:uint = 5;
		
		protected var _state:uint = STATE_UP;
//		protected var _textField:TextField = new TextField();
		
		protected var _upColor:uint = 0xa0a0a0;
		protected var _downColor:uint = 0x808080;
		
		public function Button(value:GameScene, aLabel:String=null, aX:uint=0, aY:uint=0, aWidth:uint=0, aHeight:uint=0)
		{
			super(value);
			var tf: TextField = new TextField();
			tf.text = aLabel;
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.selectable = false;
			textField = tf;
			
			var minWidth:uint = _textField.width + HORIZONTAL_INDENT*2;
			var minHeight:uint = _textField.height + VERTICAL_INDENT*2;
			
			this.debug = true;
			this.selectable = true;
			
			this.x = aX;
			this.y = aY;
			this.width = (aWidth < minWidth) ? minWidth : aWidth;
			this.height = (aHeight < minHeight) ? minHeight : aHeight;
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			
			update();
		}
		
		private function update():void {
			switch (_state) {
				case STATE_UP:
					fillBackground(_upColor, 1.0);
				break;
				case STATE_DOWN:
					fillBackground(_downColor, 1.0);
				break;
			}
//			graphics.lineStyle(1);
//			graphics.drawRect(0, 0, width, height);
			
//			_textField.x = 0;
			_textField.y = (height - _textField.height) / 2;
			_textField.width = width;
		}
		
		protected function mouseDownListener(event: MouseEvent): void {
			_state = STATE_DOWN;
			update();
		}
		
		protected override function mouseOutListener(event: MouseEvent): void {
			super.mouseOutListener(event);
			_state = STATE_UP;
			update();
		}
		
		protected function mouseUpListener(event: MouseEvent): void {
			_state = STATE_UP;
			update();
		}

		protected override function mouseClickListener(event: MouseEvent): void {
			super.mouseClickListener(event);
			_state = STATE_UP;
			update();
		}
	}
}