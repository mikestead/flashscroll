
/**
 * @author mikes
 */
import co.uk.mikestead.flashscroll.BrowserWindow;
import co.uk.mikestead.flashscroll.IBrowserWindowListener;

class FlashScrollEg implements IBrowserWindowListener
{
	public static var MAX_WIDTH:Number = 3000;
	public static var MAX_HEIGHT:Number = 2000;
	
	private var contentHolderMC:MovieClip;
	private var vMarkContainerMC:MovieClip;
	private var hMarkContainerMC:MovieClip;
	
	public function FlashScrollEg(containerMC:MovieClip)
	{
		Stage.align = "TL";
		Stage.scaleMode = "noScale";
		contentHolderMC = containerMC.createEmptyMovieClip("contentHolderMC", containerMC.getNextHighestDepth());
		addContent();
		BrowserWindow.addEventListener(this);
	}
	
	private function addContent():Void
	{
		var depth:Number = 0;
		vMarkContainerMC = contentHolderMC.createEmptyMovieClip("vMarkContainerMC", depth++);
		hMarkContainerMC = contentHolderMC.createEmptyMovieClip("hMarkContainerMC", depth++);
		
		// Add the markers along the vertical axes
		var i:Number = 1;
		var c:Number = 100;
		var textMC:MovieClip;
		while (true)
		{
			textMC = vMarkContainerMC.attachMovie("textMC", "textMC" + i, i);
			textMC.tf.text = ">" + (i * c) + "px";
			
			textMC._x = 5;
			textMC._y = i * c;
			
			if (textMC._y >= MAX_HEIGHT)
				break;
				
			i++;
		}

		// Add the markers along the horizontal axes
		i = 1;
		c = 100;
		while (true)
		{
			textMC = hMarkContainerMC.attachMovie("textMC", "textMC" + i, i);
			textMC.tf.text = ">" + (i * c) + "px";
			
			textMC._x = i * c;
			
			if (textMC._x >= MAX_WIDTH)
				break;
				
			i++;
		}

		// Set the browsers scrollable content bounds
		BrowserWindow.contentWidth = MAX_WIDTH;
		BrowserWindow.contentHeight = MAX_HEIGHT;
	}

	/**
	 * Event handler for changes in scroll position.
	 * 
	 * @param hScroll The new horizontal scroll position
	 * @param vScroll The new vertical scroll position
	 */
	public function onBrowserWindowScroll(hScroll:Number, vScroll:Number):Void
	{
		hMarkContainerMC._x = hScroll;
		vMarkContainerMC._y = vScroll;
	}
	
	/**
	 * Event handler for load completion of browser's content.
	 */
	public function onBrowserContentLoadComplete():Void
	{
		
	}
}
