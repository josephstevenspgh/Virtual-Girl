package{

	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class OrbOfGoal extends FlxSprite{
	
		//media
		//graphics
		[Embed(source="Visual/OrbOfGoal.png")] protected var ImgQTPi:Class;
		
		
		//Jump Control
				
		//constructor
		public function OrbOfGoal(X:Number = 0, Y:Number = 0){
			super(X,Y);
			
			loadGraphic(ImgQTPi,true,true,16, 16);
			
			height 	= 14;
			width  	= 14;
			
			offset = new FlxPoint(1, 1);
		}
		
		//update
		public override function update():void{
			super.update();
		}
	}
}
