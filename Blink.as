package{

	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class Blink extends FlxSprite{
	
		//media
		//graphics
		[Embed(source="Visual/Powerups.png")] protected var ImgQTPi:Class;
		
		
		//Jump Control
				
		//constructor
		public function Blink(X:Number = 0, Y:Number = 0){
			super(X,Y);
			
			loadGraphic(ImgQTPi,true,true,16, 16);
			
			height 	= 14;
			width  	= 14;
			frame	= 3;
			
			offset = new FlxPoint(0, 0);
		}
		
		//update
		public override function update():void{
			super.update();
		}
	}
}
