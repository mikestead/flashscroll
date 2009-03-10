
var flashscroll = function() {
	
	var isIE = navigator.appName.indexOf("Microsoft") != -1;
	var _swfId;
	var w, h;
	var locateSwfAttemptCount = 0;
	var swfInstance;
	var boundsEnforcer;
	var viewport;

    function locateSwfInstance() {
        swfInstance = document.getElementById(_swfId);
        
        /* wait until we have ref to both swf and its ExternalInterface applied proxy method(s) */
        if (!swfInstance || !swfInstance.contentLoadComplete) {
            if (locateSwfAttemptCount++ < 5)
            	setTimeout("flashscroll.__locateSwfInstance()", 200);            
            return;
        }

	    swfInstance.contentLoadComplete();

        /* if flash has tried to set width or height before swf callback methods were ready, 
         * then apply those saved values now we're all connected up.
         */
	    if (w != null)
	        flashscroll.setContentWidth(w);
	    if (h != null)
	        flashscroll.setContentHeight(h);

        delete flashscroll.__locateSwfInstance;
    }

    function getViewportSize() {
        var e, a;
        if (!('innerWidth' in window)) {
            a = 'client';
            e = document.documentElement || document.body;
        }
        else {
            a = 'inner';
            e = window;
        }

        return {width : e[a + 'Width'] , height : e[a + 'Height']}
    }

	function onPageLoad() {
	    boundsEnforcer = document.createElement("div");
	    boundsEnforcer.setAttribute("id", "boundsEnforcer");
	    boundsEnforcer.style.width = "1px";
	    boundsEnforcer.style.height = "1px";
	    document.body.appendChild(boundsEnforcer);

        locateSwfInstance();

	    onWindowResize();
	}

    function onScrollUpdate() {
    	var vScroll, hScroll;
    	if (!isIE) {
    		hScroll = window.scrollX;
    		vScroll = window.scrollY;
    	}
    	else {
    		hScroll = document.documentElement.scrollLeft;
    		vScroll = document.documentElement.scrollTop;
    	}
       	if (swfInstance)
    	    swfInstance.setScrollPosition(-hScroll, -vScroll);
    }
    
    function onWindowResize() {
        viewport = getViewportSize();

//        alert(">>>");
//        hideUnusedScrollBars(flashscroll.getContentWidth(), flashscroll.getContentHeight());
    }

    function hideUnusedScrollBars(w, h) {
//        alert(viewport.width + " " + viewport.height);
        document.body.style['overflow-x'] = (w < viewport.width) ? "hidden" : "visible";
        document.body.style['overflow-y'] = (h < viewport.height) ? "hidden" : "visible";
    }
    
    function addWindowEventHandler(eventName, handler) {
	    if(window.addEventListener) {
	    	window.addEventListener(eventName, handler, false);
	    }
	    else if(document.addEventListener) {
	    	document.addEventListener(eventName, handler, false);
	    }
	    else if(window.attachEvent) {
	    	window.attachEvent(('on' + eventName), handler);
	    }
	    else if(typeof window['on' + eventName] == 'function') {
    		var existing = window['on' + eventName];
    		window['on' + eventName] = function() {
    			existing();
    			handler();
    		};
    	}
    	else {
    		window['on' + eventName] = func;
    	}    
    }    

	return {
	    init : function(swfId) {
	        _swfId = swfId;
	        
	        addWindowEventHandler("load", onPageLoad);
	        addWindowEventHandler("scroll", onScrollUpdate);
	        addWindowEventHandler("resize", onWindowResize);
	        
	        return this;
	    },
	    setContentHeight : function(height) {
	        if (height < 1)
	            height = 1;
   	        if (boundsEnforcer)
   	        {
            	boundsEnforcer.style.height = height + "px";
 //               hideUnusedScrollBars(getContentWidth(), height);
            }
            else
                h = height;
        },
        getContentHeight : function() {
    	    return boundsEnforcer.style.height;
        },
        setContentWidth : function(width) {
	        if (width < 1)
	            width = 1;
            if (boundsEnforcer)
            {
            	boundsEnforcer.style.width = width + "px";
//                hideUnusedScrollBars(width, getContentHeight());
            }
            else
                w = width;
        },
        getContentWidth : function() {
        	return boundsEnforcer.style.width;
        },
        __locateSwfInstance : locateSwfInstance
    };
}();