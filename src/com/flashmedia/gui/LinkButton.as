package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class LinkButton extends GameObject
	{
		public static const STATE_NORMAL:uint = 0;
		public static const STATE_HIGHLIGHTED:uint = 1;
		
		public var paginationIndex:int;
		
		protected var _normalStateTextFormat:TextFormat = new TextFormat();
		protected var _highlithedStateTextFormat:TextFormat;
		
		protected var _enabled:Boolean = true;
		protected var _state:uint = STATE_NORMAL;
				
		public function LinkButton(scene:GameScene, text:String=null, x:uint=0, y:uint=0)
		{
			super(scene);
//			setDownTextStyle();
			
			setTextField(new TextField());
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			_textField.mouseEnabled = false;
			
			this.setSelect(true);
			this.x = x;
			this.y = y;
			this.width = textField.width;
			this.height = textField.height;
			this.label = text;
			
			buttonMode = true;
			useHandCursor = true;
			setSelect(true);
			
//			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function update():void {
			switch (_state) {
				case STATE_NORMAL:
					textField.setTextFormat(_normalStateTextFormat);
				break;
				case STATE_HIGHLIGHTED:
					textField.setTextFormat(_highlithedStateTextFormat);
				break;
			}
			
			if (textField.autoSize == TextFieldAutoSize.LEFT) {
				width = textField.width;
				height = textField.height;
			}
		}
		
		public function set enabled(enable:Boolean):void {
			_enabled = enable;
			buttonMode = _enabled;
			useHandCursor = _enabled;
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public override function set width(value: Number):void {
			super.width = value;
			if (textField && textField.wordWrap) update();
		}
		
		public function set wordWrap(wrap:Boolean): void {
			textField.wordWrap = wrap;
			update();
		}
		
		public function get label():String {
			return textField.text;
		}
		
		public function set label(text:String):void {
			var format:TextFormat = textField.getTextFormat();
			textField.text = text;
			textField.setTextFormat(format);
			update();
		}
		
		public function setTextFormatForState(format:TextFormat, state:uint):void {
			switch (state) {
				case STATE_NORMAL:
					_normalStateTextFormat = format;
				break;
				case STATE_HIGHLIGHTED:
					_highlithedStateTextFormat = format;
				break;
			}
			update();
		}
		
		protected override function mouseOverListener(event: MouseEvent): void {
			super.mouseOutListener(event);
			if (_enabled) {
				if (_highlithedStateTextFormat) {
					_state = STATE_HIGHLIGHTED;
					update();
				}
			}
		}
		
		protected override function mouseOutListener(event: MouseEvent): void {
			super.mouseOutListener(event);
			
			if (_enabled) {
				_state = STATE_NORMAL;
				update();
			}
		}
		
//		protected override function mouseClickListener(event: MouseEvent): void {
//			super.mouseClickListener(event);
//			
//			if (_enabled) {
//				update();
//			}
//		}
	}
}