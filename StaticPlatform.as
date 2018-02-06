package{

	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class StaticPlatform extends FlxSprite{
	
		//media
		//graphics
		[Embed(source="Visual/SillyBlock.png")] protected var ImgBlock:Class;
		
		
		//Jump Control
				
		//constructor
		public function StaticPlatform(X:Number = 0, Y:Number = 0){
			super(X,Y);
			x = X;
			y = Y;
			loadGraphic(ImgBlock,true,true,16, 16);
			//Don't Move
			immovable = true;
			//Can walk over
			isShort = true;
		}
		
		//update
		public override function update():void{
			super.update();
		}
	}
}
