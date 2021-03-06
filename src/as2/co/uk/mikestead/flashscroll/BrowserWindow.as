/*
The MIT License

Copyright (c) 2009 Mike Stead

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
import co.uk.mikestead.flashscroll.IBrowserWindowListener;

import flash.external.ExternalInterface;

/**
 * Responsible for controlling the height and position of the browser's scroll bar.
 *
 * Also responsible for notifying interested parties of any change in scroll bar position.
 *
 * Copyright (C) Mike Stead, 2009
 *
 * Usage:
 *
 * @code
 * // listen for changes in scroll position (either by user or by code)
 * BrowserWindow.addEventListener(this);
 *
 * // Set the content height, i.e. the height of the MovieClip you will be scrolling over
 * BrowserWindow.contentHeight = 2000;
 *
 * // Triger a change in the scroll position through code
 * BrowserWindow.scrollTo(0, 1000);
 *
 * // Handle scroll position change events
 * public function onBrowserWindowScroll(xScroll, yScroll):Void
 * {
 *     myContentMC._y = yScroll;
 * }
 * @endcode
 */
class co.uk.mikestead.flashscroll.BrowserWindow
{
	/**
	 * The default incremental pixel step when scrolling up or down.
	 */
	public static var DEFAULT_SCROLL_STEP:Number = 20;
	
	/**
	 * The incremental pixel step when scrolling up or down.
	 * 
	 * Must be greater then 0.
	 * 
	 * Defaults to @c DEFAULT_SCROLL_STEP.
	 */
	public static var scrollStep:Number = DEFAULT_SCROLL_STEP;

	/** Static class initializer. */
	private static var init:Boolean = classInit();

	/** Event listeners. */
	private static var listeners:Array;

	/**
	 * Constructor.
	 */
	private function BrowserWindow()
	{}
	
	/**
	 * Scroll the browser window up by @c scrollStep.
	 */
	public static function scrollUp():Void
	{
		scrollBy(0, -scrollStep);
	}
	
	/**
	 * Scroll the browser window down by @c scrollStep.
	 */
	public static function scrollDown():Void
	{
		scrollBy(0, scrollStep);
	}
	
	/**
	 * Scroll the browser window up by a defined @c scrollStep.
	 * 
	 * @param hStep The horizontal pixel step to scroll with window by. 
	 *              Positive values will scroll the window right, negative 
	 *              values will scroll the window left.
	 *
	 * @param vStep The horizontal pixel step to scroll with window by. 
	 *              Positive values will scroll the window down, negative 
	 *              values will scroll the window up.
	 */
	public static function scrollBy(hStep:Number, vStep:Number):Void
	{
		ExternalInterface.call("flashscroll.scrollContentBy", hStep, vStep);
	}

	/**
	 * Scroll the browser window to a specific position.
	 * 
	 * @param hPostion The horizontal position to scroll the browser window to
	 * @param vPostion The vertical position to scroll the browser window to
	 */	
	public static function scrollTo(hPostion:Number, vPosition:Number):Void
	{
		ExternalInterface.call("flashscroll.scrollContentTo", hPostion, vPosition);		
	}

	/**
	 * Scroll the browser window to the top most position.
	 */	
	public static function scrollToTop():Void
	{
		ExternalInterface.call("flashscroll.scrollContentTo", 0, 0);
	}

	/**
	 * Scroll the browser window to the bottom most position.
	 */
	public static function scrollToBottom():Void
	{
		ExternalInterface.call("flashscroll.scrollContentTo", 0, contentHeight);
	}

	/**
	 * Set the content height of the browser window.
	 */	
	public static function set contentHeight(height:Number):Void
	{
		ExternalInterface.call("flashscroll.setContentHeight", height);		
	}

	/**
	 * Get the content height of the browser window.
	 * 
	 * @param Scrollable height of the browser window
	 */	
	public static function get contentHeight():Number
	{
		return Number(ExternalInterface.call("flashscroll.getContentHeight"));
	}

	/**
	 * Set the content width of the browser window.
	 */	
	public static function set contentWidth(width:Number):Void
	{
		ExternalInterface.call("flashscroll.setContentWidth", width);		
	}

	/**
	 * Get the content width of the browser window.
	 * 
	 * @param Scrollable width of the browser window
	 */	
	public static function get contentWidth():Number
	{
		return Number(ExternalInterface.call("flashscroll.getContentWidth"));
	}

	/**
	 * Listen for scroll events.
	 * 
	 * @param listener The listener wishing to be notified of changes in scroll position
	 */	
	public static function addEventListener(listener:IBrowserWindowListener):Void
	{
		var i:Number = listeners.length;
		while (i--)
			if (listeners[i] == listener)
				return;

		listeners.push(listener);
	}
	
	/**
	 * Stop listening for scroll events.
	 * 
	 * @param listener The listener no longer wishing to be notified of changes in scroll position
	 */	
	public static function removeEventListener(listener:IBrowserWindowListener):Void
	{
		var i:Number = listeners.length;
		while (i--)
		{
			if (listeners[i] == listener)
			{
				listeners.splice(i, 1);
				break;
			}
		}
	}

	/**
	 * Static initializer.
	 */
	private static function classInit():Boolean
	{
		ExternalInterface.addCallback("contentLoadComplete", BrowserWindow, onLoad);
		ExternalInterface.addCallback("setScrollPosition", BrowserWindow, onScroll);
		listeners = [];
		return true;
	}

	/**
	 * Event handler for changes in browser scroll position.
	 * 
	 * This propagates scroll events on to all subscribed listeners.
	 * 
	 * @param hScroll The new horizontal scroll position
	 * @param vScroll The new vertical scroll position
	 */
	private static function onLoad():Void
	{	
		var i:Number = listeners.length;
		while (i--)
			listeners[i].onBrowserContentLoadComplete();
	}

	/**
	 * Event handler for changes in browser scroll position.
	 * 
	 * This propagates scroll events on to all subscribed listeners.
	 * 
	 * @param hScroll The new horizontal scroll position
	 * @param vScroll The new vertical scroll position
	 */
	private static function onScroll(hScroll:Number, vScroll:Number):Void
	{
		var i:Number = listeners.length;
		while (i--)
			listeners[i].onBrowserWindowScroll(hScroll, vScroll);
	}
}
