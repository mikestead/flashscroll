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
 
/**
 * Interface which all objects subscribing to BrowserWindow change events should implement.
 *
 * Copyright (C) Mike Stead, 2009
 */
interface co.uk.mikestead.flashscroll.IBrowserWindowListener 
{
	/**
	 * Event handler for load completion of browser's content.
	 */
	function onBrowserContentLoadComplete():Void;
	
	/**
	 * Event handler for changes in scroll position.
	 * 
	 * @param hScroll The new horizontal scroll position
	 * @param vScroll The new vertical scroll position
	 */
	function onBrowserWindowScroll(hScroll:Number, vScroll:Number):Void;
}
