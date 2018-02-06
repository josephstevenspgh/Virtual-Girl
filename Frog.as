package{

	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class Frog extends FlxSprite{
	
		//media
		//graphics
		[Embed(source="Visual/Frog.png")] protected var ImgQTPi:Class;
		
		
		//Jump Control
		private var Jumping:Boolean				= false;
		private var CanJump:Boolean				= true;
		private var JumpPeakY:Number			= 0;
		private var LastJumped:Number			= 0;
				
		//constructor
		public function Frog(X:Number = 0, Y:Number = 0){
			super(X,Y);
			x = X;
			y = Y;
			loadGraphic(ImgQTPi,true,true,16, 16);
			
			height 	= 10;
			width  	= 15;
			
			offset = new FlxPoint(1, 6);
			
			maxVelocity.x = 200;
			maxVelocity.y = 200;
			
			drag.x = 500;
			drag.y = 1000;
			
			//Tilemap = TM;
			
			//create animations
			addAnimation("JumpLeft", 	[0], 			5, 	false);
			addAnimation("JumpRight", 	[1], 			5, 	false);
			/*
			addAnimation("Left", 	[2], 			5, 	true);
			addAnimation("Right", 	[4], 			5, 	true);
			addAnimation("Jumping",	[1], 			5, 	false);
			addAnimation("Falling",	[3], 			5, 	true);*/
		}
		
		private function OnGround():Boolean{
			//Check to see if QT-Pi is on the ground
			if(Jumping == false && velocity.y == 0){
				return true;
			}else{
				return false;
			}
		}
		
		//update
		public override function update():void{
			if(onScreen()){
				acceleration.x = 0;
				acceleration.y = drag.y;
						
				//Jump randomly - at least 1s between jumps
				if(LastJumped > 0){
					LastJumped -= FlxG.elapsed;
				}else{
					if(FlxG.random() < 0.025){
						Jump();
						LastJumped = 1;
					}
				}
			
			
				super.update();
			}
		}
		
		public function KillMe():void{
			x = -50;
		}
		private function Jump():void{
			if(isTouching(FLOOR)){
				Jumping = true;
				velocity.y = -256;
				if(FlxG.random() >= 0.5){
					//Jump Left
					play("JumpLeft");
					velocity.x = -512;
				}else{
					//Jump Right
					play("JumpRight");
					velocity.x = 512;
				}
			}
			super.update();
		}
	}
}
