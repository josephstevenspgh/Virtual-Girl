package{

	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class LavaTile extends FlxSprite{
	
		//media
		//graphics
		[Embed(source="Visual/Lava_Anim.png")] protected var ImgLava:Class;
		
		
		//Jump Control
				
		//constructor
		public function LavaTile(X:Number = 0, Y:Number = 0){
			super(X,Y);
			x = X;
			y = Y;
			loadGraphic(ImgLava,true,true,16, 16);
			
			addAnimation("Flowy", [0, 1, 2, 3], 10, true);
			play("Flowy");
		}
		
		//update
		public override function update():void{
			super.update();
		}
	}
}
