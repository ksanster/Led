package assets.skins
{
    import flash.display.GradientType;
    import flash.display.Graphics;
    
    import mx.controls.scrollClasses.ScrollBar;
    import mx.skins.Border;
    import mx.utils.ColorUtil;
    
    /**
     *  The skin for all the states of the up or down button in a ScrollBar.
     */
    public class ScrollArrowSkin extends Border
    {    
        override public function get measuredWidth():Number
        {
            return ScrollBar.THICKNESS;
        }
               
        override public function get measuredHeight():Number
        {
            return ScrollBar.THICKNESS;
        }
        
        override protected function updateDisplayList(w:Number, h:Number):void
        {
            super.updateDisplayList(w, h);
    
            // User-defined styles.
            var borderColor:uint = getStyle("borderColor");
            var backgroundColor:uint = getStyle("backgroundColor");
            var borderColorDark:uint = ColorUtil.adjustBrightness(borderColor, -50);
            var arrowColor:uint = 0x444444;
            var arrowColorDark:uint = 0x111111;
            var fillAlphas:Array = getStyle("fillAlphas");
            var upArrow:Boolean = (name.charAt(0) == 'u');
            
            //------------------------------
            //  background
            //------------------------------
            
            var g:Graphics = graphics;
            g.clear();
            
            if (isNaN(backgroundColor))
                backgroundColor = 0xFFFFFF;                        
    
            // fill with zero alpha in order to catch mouse events
            drawRoundRect(1, 1, w-2, h-2, 0, backgroundColor, 0.0);    
    
            switch (name)
            {
                case "upArrowUpSkin":
                case "downArrowUpSkin":
                {
                    drawFill(w, h, fillAlphas);
                    break;
                }
                
                case "upArrowOverSkin":
                case "downArrowOverSkin":
                {
                    drawFillOver(w, h, fillAlphas);
                    break;
                }
                
                case "upArrowDownSkin":
                case "downArrowDownSkin":
                {
                   drawFill(w, h, fillAlphas);
                   break;
                }
                
                default:
                {
                    drawRoundRect(
                        0, 0, w, h, 0,
                        0xFFFFFF, 0);
                    
                    return;
                    break;
                }
            }
            
            g.beginFill(arrowColor);
			if (upArrow)
			{
				g.moveTo(w / 2, 6);
				g.lineTo(w - 5, h - 6);
				g.lineTo(5, h - 6);
				g.lineTo(w / 2, 6);
			}
			else
			{
				g.moveTo(w / 2, h - 6);
				g.lineTo(w - 5, 6);
				g.lineTo(5, 6);
				g.lineTo(w / 2, h - 6);
			}
			g.endFill();
        }
        
        private function drawBorder(w:int, h:int, borderColor:uint):void
        {
            drawRoundRect(0, 0, w, h, 0, [borderColor, borderColor], [1.0, 0.5],
                null, GradientType.LINEAR, null, 
                { x: 1, y: 1, w: w - 2, h: h - 2, r: 0 });  
        }
        
        private function drawFill(w:int, h:int, fillAlphas : Array):void
        {
        	var upFillAlphas:Array;
        	if (fillAlphas.length > 2)
        		upFillAlphas = [ fillAlphas[2], fillAlphas[3] ];
  			else
				upFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
				
        	drawRoundRect(
					1, 1, w - 2, h - 2, 0,
					[0x939393, 0x939393], fillAlphas,
					verticalGradientMatrix(0, 0, w - 2, h - 2)); 
        }
        
        private function drawFillOver(w:int, h:int, fillAlphas : Array):void
        {
        	var overFillAlphas:Array;
				if (fillAlphas.length > 2)
					overFillAlphas = [ fillAlphas[2], fillAlphas[3] ];
  				else
					overFillAlphas = [ fillAlphas[0], fillAlphas[1] ];
        	
        	drawRoundRect(
					1, 1, w - 2, h - 2, 0,
					[0xB7B7B7, 0xB7B7B7], overFillAlphas,
					verticalGradientMatrix(0, 0, w - 2, h - 2)); 
        }
    }
}
