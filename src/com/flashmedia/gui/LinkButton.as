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
		
		protected var _normalStateTextFormat:TextFormat = new TextFormat();
		protected var _highlithedStateTextFormat:TextFormat = new TextFormat();
		protected var _downTextFormat:TextFormat = new TextFormat();
		
		private var _textFormat:TextFormat;
		protected var _enabled:Boolean = true;
		protected var _state:uint = STATE_NORMAL;
		
		public function LinkButton(scene:GameScene, text:String=null, x:uint=0, y:uint=0, width:uint=0)
		{
			super(scene);
//			setTextStyle();
//			setOverTextStyle();
			setDownTextStyle();
			_textFormat = _normalStateTextFormat;
			
			var tf: TextField = new TextField();
			tf.defaultTextFormat = _textFormat;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			tf.mouseEnabled = false;
			setTextField(tf);
			
			this.setSelect(true);
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = textField.height;
			this.label = text;
			
			buttonMode = true;
			useHandCursor = true;
		}
		
		public override function get height():Number {
			return textField.height;
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
			/*
			if (textField.wordWrap) {
				textField.width = width;
			}
			else {
				width = textField.width;
			}
			height = textField.height;
			*/
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
		
		public override function destroy(): void {
			super.destroy();
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
		/*
		public function setTextStyle(color:uint=0, size:uint=12, font:String="Arial", bold:Boolean=false, italic:Boolean=false, underline:Boolean=true):void {
			_baseTextFormat.color = color;
			_baseTextFormat.size = size;
			_baseTextFormat.font = font;
			_baseTextFormat.bold = bold;
			_baseTextFormat.italic = italic;
			_baseTextFormat.underline = underline;
		}
		public function setOverTextStyle(color:uint=0x0000ff, size:uint=12, font:String="Arial", bold:Boolean=false, italic:Boolean=false, underline:Boolean=true):void {
			_overTextFormat.color = color;
			_overTextFormat.size = size;
			_overTextFormat.font = font;
			_overTextFormat.bold = bold;
			_overTextFormat.italic = italic;
			_overTextFormat.underline = underline;
		}
		*/
		
		public function setDownTextStyle(color:uint=0, size:uint=12, font:String="Arial", bold:Boolean=false, italic:Boolean=false, underline:Boolean=true):void {
			_downTextFormat.color = color;
			_downTextFormat.size = size;
			_downTextFormat.font = font;
			_downTextFormat.bold = bold;
			_downTextFormat.italic = italic;
			_downTextFormat.underline = underline;
		}
		
		/*
		public function setUnderline(underline:Boolean):void {
			var format:TextFormat = textField.getTextFormat();
			format.underline = _baseTextFormat.underline = _overTextFormat.underline = _downTextFormat.underline = underline;
			textField.setTextFormat(format);
		}
		
		public function setBold(bold:Boolean):void {
			_baseTextFormat.bold = _overTextFormat.bold = _downTextFormat.bold = bold;
		}
		*/
		protected override function mouseOverListener(event: MouseEvent): void {
			super.mouseOutListener(event);
			if (_enabled) {
				textField.setTextFormat(_highlithedStateTextFormat);
				update();
			}
		}
		
		protected override function mouseOutListener(event: MouseEvent): void {
			super.mouseOutListener(event);
			if (_enabled) {
				textField.setTextFormat(_textFormat);
				update();
			}
		}
		
		protected override function mouseClickListener(event: MouseEvent): void {
			super.mouseClickListener(event);
			if (_enabled) {
				_textFormat = _downTextFormat;
				update();
			}
		}
		
		public function get intVal():int // Used in Pagination, for example
	    {
			if (label == "«") return 1;
			if (label == "»") return -1;
			return parseInt(label);
	    }
	}
}