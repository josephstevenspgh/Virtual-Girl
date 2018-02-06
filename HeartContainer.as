package{

	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class HeartContainer extends FlxSprite{
	
		//media
		//graphics
		[Embed(source="Visual/HeartContainer.png")] protected var ImgHC:Class;
		
		
		//Jump Control
				
		//constructor
		public function HeartContainer(X:Number = 0, Y:Number = 0){
			super(X,Y);
			
			loadGraphic(ImgHC,true,true,16, 16);
			
			height 	= 12;
			width  	= 14;
			frame	= 2;
			
			offset = new FlxPoint(0, 0);
			
			addAnimation("BEAT IT", [0, 1, 2, 3, 4, 5], 5, true);
			play("BEAT IT");
		}
		
		//update
		public override function update():void{
			super.update();
		}
	}
}
