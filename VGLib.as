package{
	import org.flixel.*;
 
	public class VGLib{
	
		[Embed(source="Visual/VGEX_Font.png")]	 					private static var ImgFont:Class;
		[Embed(source="Visual/TextBox.png")] 						private static var ImgTextBox:Class;
	
		public static function DrawTextBox(TBContent:String, TBX:uint = 24, TBY:uint = 24, CenterMe:Boolean = false):FlxSprite{
		
			//Text
			
			
			//fuck this shit: use String.split();
			var TextText:Array = TBContent.split("<br>");
			FlxG.log(TextText);
			
			//Find the width
			var TBWidth:uint = 0;
			for(var a:uint = 0;a < TextText.length; a++){
				if(TBWidth < TextText[a].length){
					TBWidth = TextText[a].length;
				}
			}
			FlxG.log(TBWidth);
			TBWidth += 2;
			var TBHeight:uint = TextText.length + 2;
		
			//check centering
			if(CenterMe){
				TBX = (FlxG.width/2) - ((TBWidth*8)/2)
			}
		
			//See how high the string is
			var TB:FlxSprite = new FlxSprite(TBX, TBY);
			TB.makeGraphic((TBWidth*8), (TBHeight*8));
			for(var i:uint = 0; i < TBWidth-2; i++){
				//stamp top and bototm
				var TBTop:FlxSprite = new FlxSprite();
				var TBBottom:FlxSprite = new FlxSprite();
				TBTop.loadGraphic(ImgTextBox, false, false, 8, 8);
				TBBottom.loadGraphic(ImgTextBox, false, false, 8, 8);
				TBTop.frame = 1;
				//TBBottom.frame = 7;
				TB.stamp(TBTop, 8+(i*8), 0);
				TBTop.frame = 7;
				TB.stamp(TBTop, 8+(i*8), TB.height - 8);
				//TB.stamp(TBBottom, 8+(i*8));
				for(var j:uint = 0; j < TBHeight-2; j++){
					var TBBody:FlxSprite = new FlxSprite();
					TBBody.loadGraphic(ImgTextBox, false, false, 8, 8);
					TBBody.frame = 4;
					TB.stamp(TBBody, 8+(i*8), 8+(j*8));
				}
			}
			//Corners
			var TBCorner:FlxSprite = new FlxSprite();
			TBCorner.loadGraphic(ImgTextBox, false, false, 8, 8);
			TBCorner.frame = 0;
			TB.stamp(TBCorner, 0, 0);
			TBCorner.frame = 2;
			TB.stamp(TBCorner, TB.width-8, 0);
			TBCorner.frame = 6;
			TB.stamp(TBCorner, 0, TB.height-8);
			TBCorner.frame = 8;
			TB.stamp(TBCorner, TB.width-8, TB.height-8);
			
			//Sides
			for(var k:uint = 0; k < TBHeight-2;k++){
				TBCorner.frame = 3;			
				TB.stamp(TBCorner, 0, 8+(k*8));
				TBCorner.frame = 5;			
				TB.stamp(TBCorner, TB.width-8, 8+(k*8));
			}
			
			//Draw the string
			//Fun Part
			for(i = 0; i < TextText.length; i++){
				for(j = 0; j < TextText[i].length; j++){
					//draw this character
					TB.stamp(DrawLetter(TextText[i].charAt(j)), 8+j*8, 8+i*8);
				}
			}
			
			
			return TB;
		}
		
		private static function DrawLetter(TheLetter:String):FlxSprite{
			var Let:FlxSprite = new FlxSprite();
			Let.loadGraphic(ImgFont, false, false, 8, 8);
			Let.frame = GetCharAt(TheLetter);
			return Let;
		}
		
		private static function GetCharAt(CurrentChar:String):uint{
			switch(CurrentChar){
				case 'a':
				case 'A':
					return 0;
				case 'b':
				case 'B':
					return 1;
				case 'c':
				case 'C':
					return 2;
				case 'd':
				case 'D':
					return 3;
				case 'e':
				case 'E':
					return 4;
				case 'f':
				case 'F':
					return 5;
				case 'g':
				case 'G':
					return 6;
				case 'h':
				case 'H':
					return 7;
				case 'i':
				case 'I':
					return 8;
				case 'j':
				case 'J':
					return 9;
				case 'k':
				case 'K':
					return 10;
				case 'l':
				case 'L':
					return 11;
				case 'm':
				case 'M':
					return 12;
				case 'n':
				case 'N':
					return 13;
				case 'o':
				case 'O':
					return 14;
				case 'p':
				case 'P':
					return 15;
				case 'q':
				case 'Q':
					return 16;
				case 'r':
				case 'R':
					return 17;
				case 's':
				case 'S':
					return 18;
				case 't':
				case 'T':
					return 19;
				case 'u':
				case 'U':
					return 20;
				case 'v':
				case 'V':
					return 21;
				case 'w':
				case 'W':
					return 22;
				case 'x':
				case 'X':
					return 23;
				case 'y':
				case 'Y':
					return 24;
				case 'z':
				case 'Z':
					return 25;
				case ':':
					return 46;
				case ';':
					return 59;
				case '.':
					return 44;
				case '!':
					return 42;
				case '-':
					return 47;
				case '_':
					return 53;
				case '=':
					return 54;				
				case '$':
					return 48;
				case '*':
					return 49;
				case ',':
					return 45;				
				case '(':
					return 51;				
				case ')':
					return 52;				
				case '?':
					return 43;				
				case '<':
					return 65;				
				case '>':
					return 66;				
				case '[':
					return 67;
				case ']':
					return 68;
				case '\'':
					return 58;
				case '\\':
					return 69;
				case '"':
					return 60;
				case '/':
					return 61;
				case '^':
					return 62;	
				case '+':
					return 55;				
				case '0':
					return 28;				
				case '1':
					return 29;				
				case '2':
					return 30;				
				case '3':
					return 31;				
				case '4':
					return 32;				
				case '5':
					return 33;				
				case '6':
					return 34;				
				case '7':
					return 35;				
				case '8':
					return 36;				
				case '9':
					return 37;				
				case ' ':
					return 26;
				case '@':
					return 38;
				case '~':
					return 39;
				case "%":
					return 40;
			}
			return 0;
		}		
	}
}
