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
		
		protected var _upColor:uint = 0xa0a0a0;
		protected var _downColor:uint = 0x808080;
		
		public function Button(value:GameScene, aLabel:String=null, aX:uint=0, aY:uint=0, aWidth:uint=0, aHeight:uint=0)
		{
			super(value);
			this.label = aLabel;
			this.selectable = true;
			
			this.x = aX;
			this.y = aY;
			
			var minWidth:uint = _textField.width + HORIZONTAL_INDENT*2;
			var minHeight:uint = _textField.height + VERTICAL_INDENT*2;
			
			this.width = (aWidth < minWidth) ? minWidth : aWidth;
			this.height = (aHeight < minHeight) ? minHeight : aHeight;
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			
			update();
		}
		
		public function set label(text: String): void {
			if (!textField) {
				textField = new TextField();
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.selectable = false;
			}
			textField.text = text;
		}
		
		public function get label(): String {
			return textField.text;
		}
		
		public override function set width(value: Number):void {
			super.width = value;
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
			
			textHorizontalAlign = HORIZONTAL_ALIGN_CENTER;
			textVerticalAlign = VERTICAL_ALIGN_CENTER;
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