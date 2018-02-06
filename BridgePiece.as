package{

	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class BridgePiece extends FlxSprite{
		//graphics
		[Embed(source="Visual/8byblock.png")] protected var ImgBlock:Class;
		
		//Original Y
		public var OriginalY:Number = 0;
		public var MaxY:Number = 0;
		private var Player:QTPi;
		public var Active:Boolean = false;
		
		//Partner sprites
		public var PartnerLeft:BridgePiece;
		public var PartnerRight:BridgePiece;
		
		//constructor
		public function BridgePiece(X:Number = 0, Y:Number = 0, player:QTPi = null){
			super(X,Y);
			loadGraphic(ImgBlock,true,true, 8, 8);
			Player = player;
			x = X;
			y = Y;
			OriginalY = Y;
			isShort = true;
			immovable = true;
		}
		
		private function CheckingLeft():uint{
			var LeftPartners:uint = 0;
			if(PartnerLeft != null){
				LeftPartners++;
			}else{
				return LeftPartners;
			}
			if(PartnerLeft.PartnerLeft != null){
				LeftPartners++;
			}else{
				return LeftPartners;
			}
			if(PartnerLeft.PartnerLeft.PartnerLeft != null){
				LeftPartners++;
			}else{
				return LeftPartners;
			}
			if(PartnerLeft.PartnerLeft.PartnerLeft.PartnerLeft != null){
				LeftPartners++;
			}else{
				return LeftPartners;
			}
			return LeftPartners;
		}
		
		private function CheckingRight():uint{
			var RightPartners:uint = 0;
			if(PartnerRight != null){
				RightPartners++;
			}else{
				return RightPartners;
			}
			if(PartnerRight.PartnerRight != null){
				RightPartners++;
			}else{
				return RightPartners;
			}
			if(PartnerRight.PartnerRight.PartnerRight != null){
				RightPartners++;
			}else{
				return RightPartners;
			}
			if(PartnerRight.PartnerRight.PartnerRight.PartnerRight != null){
				RightPartners++;
			}else{
				return RightPartners;
			}
			return RightPartners;
		}
		
		public function Finalize():void{
			if(PartnerLeft == null || PartnerRight == null){
				MaxY = OriginalY;
			}else{
				//count parnters
				var LeftPartners:uint = CheckingLeft();
				var RightPartners:uint = CheckingRight();
				//hardcode the max at 4. I dont feel like doing recursive bullshit
				//set the max Y to the lower of the 2 values
				if(LeftPartners > RightPartners){
					MaxY = OriginalY + RightPartners;
				}else{
					MaxY = OriginalY + LeftPartners;			
				}
			}
			//FlxG.log("Max Y: "+MaxY);
		}
		
		public function SetPartners(Obj1:BridgePiece, Obj2:BridgePiece):void{
			if(Obj1 != null){
				PartnerLeft = Obj1;
			}
			if(Obj2 != null){
				PartnerRight = Obj2;
			}
		}
		
		//update
		public override function update():void{
			super.update();
			if(y < OriginalY){
				y = OriginalY;
			}
			if(PartnerLeft == null || PartnerRight == null){
				y = OriginalY;
				return;
			}
			if((Player.x >= x && Player.x <= x+width) || (Player.x+Player.width >= x && Player.x+Player.width <= x+width)){
				//Height check
				if((Player.y >= y - 18) && (Player.y < y)){
					Active = true;
				}else{
					Active = false;
				}
			}else{
				Active = false;
			}
			
			if(Active){
				y = OriginalY + 4;
				if(!PartnerLeft.Active){
					if(PartnerLeft.PartnerLeft != null){
						PartnerLeft.y = OriginalY + 2;
					}else{
						y = OriginalY + 2;
					}
				}
				if(!PartnerRight.Active){
					if(PartnerRight.PartnerRight != null){
						PartnerRight.y = OriginalY + 2;
					}else{
						y = OriginalY + 2;
					}
				}
			}else{
				if(y > OriginalY){
					y -= .1;
				}else if(y < OriginalY){
					//FlxG.log("TOO HIGH :D");
					y = OriginalY;
				}
			}
		}
	}
}
