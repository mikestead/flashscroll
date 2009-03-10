
/**
 * @author mikes
 */
import co.uk.mikestead.flashscroll.BrowserWindow;
import co.uk.mikestead.flashscroll.IBrowserWindowListener;

import mx.utils.Delegate;

class FlashScrollEg implements IBrowserWindowListener
{
	public static var PIXEL_STEP:Number = 200;
	public static var MIN_MARK:Number = 1;
	
	private var hCount:Number;
	private var vCount:Number;
	
	private var offset:Number;
	
	private var contentHolderMC:MovieClip;
	private var hMarkContainerMC:MovieClip;
	private var vMarkContainerMC:MovieClip;
	private var hStepperMC:MovieClip;
	private var vStepperMC:MovieClip;
	
	public function FlashScrollEg(containerMC:MovieClip)
	{
		contentHolderMC = containerMC.createEmptyMovieClip("contentHolderMC", containerMC.getNextHighestDepth());
		Stage.align = "TL";
		Stage.scaleMode = "noScale";
		Stage.addListener(this);
		BrowserWindow.addEventListener(this);
		
		setup();
		layout();
	}

	private function setup():Void
	{
		var depth:Number = 0;

		hMarkContainerMC = contentHolderMC.createEmptyMovieClip("hMarkContainerMC", depth++);
		vMarkContainerMC = contentHolderMC.createEmptyMovieClip("vMarkContainerMC", depth++);

		hStepperMC = contentHolderMC.attachMovie("hStepperMC", "hStepperMC", depth++);
		vStepperMC = contentHolderMC.attachMovie("vStepperMC", "vStepperMC", depth++);
		
		hStepperMC.plusMC.onRelease = Delegate.create(this, incWidth);
		hStepperMC.minusMC.onRelease = Delegate.create(this, decWidth);

		vStepperMC.plusMC.onRelease = Delegate.create(this, incHeight);
		vStepperMC.minusMC.onRelease = Delegate.create(this, decHeight);
		
		hCount = MIN_MARK;
		vCount = MIN_MARK;
		offset = MIN_MARK  * PIXEL_STEP;
	}

	private function layout():Void
	{
		hStepperMC._x = (Stage.width - hStepperMC._width) / 2;
		hStepperMC._y = 50;
		
		vStepperMC._x = 50;
		vStepperMC._y = (Stage.height - hStepperMC._height) / 2;
	}
	
	private function incWidth():Void
	{
		var textMC:MovieClip = hMarkContainerMC.attachMovie("textMC", "textMC" + hCount, hCount);
		textMC._x = hCount++ * PIXEL_STEP;
		textMC.textField.text = hStepperMC.textField.text = textMC._x + "px";
		BrowserWindow.contentWidth = offset + hMarkContainerMC._width;
	}
	
	private function decWidth():Void
	{
		if (hCount > MIN_MARK)
		{
			hMarkContainerMC["textMC" + hCount--].removeMovieClip();
			hStepperMC.textField.text = (hCount * PIXEL_STEP) + "px";
			BrowserWindow.contentWidth = offset + hMarkContainerMC._width;
		}
	}
	
	private function incHeight():Void
	{
		var textMC:MovieClip = vMarkContainerMC.attachMovie("textMC", "textMC" + vCount, vCount);
		textMC._y = vCount++ * PIXEL_STEP;
		textMC.textField.text = vStepperMC.textField.text = textMC._y + "px";
		BrowserWindow.contentHeight = offset + vMarkContainerMC._height;
	}
	
	private function decHeight():Void
	{
		if (vCount > MIN_MARK)
		{
			vMarkContainerMC["textMC" + vCount--].removeMovieClip();
		    vStepperMC.textField.text = (vCount * PIXEL_STEP) + "px";
			BrowserWindow.contentHeight = offset + vMarkContainerMC._height;
		}
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
	
	private function onResize():Void
	{
		layout();
	}
}
