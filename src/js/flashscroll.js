
var flashscroll = function() {
	
	var isIE = navigator.appName.indexOf("Microsoft") != -1;
	var _swfDivId;
	var _boundsEnforcerDivId;
	var w, h;
	var swfInstance;
	var boundsEnforcer;
	
	function onPageLoad() {
		swfInstance = isIE ? window[_swfDivId] : document[_swfDivId];
	    boundsEnforcer = document.createElement("div");
	    boundsEnforcer.setAttribute("id", "boundsEnforcer");
	    document.body.appendChild(boundsEnforcer);

	    if (w != null)
	        flashscroll.setContentWidth(w);
	    if (h != null)
	        flashscroll.setContentHeight(h);

	    swfInstance.contentLoadComplete();
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
    	swfInstance.setScrollPosition(-hScroll, -vScroll);
    }

	/* Cross-browser onload by James Edwards 
	 * http://brothercake.com/site/resources/scripts/onload/
	 */
    function addLoadHandler(func) {
	    if(typeof window.addEventListener != 'undefined') {
	    	window.addEventListener('load', func, false);
	    }
	    else if(typeof document.addEventListener != 'undefined') {
	    	document.addEventListener('load', func, false);
	    }
	    else if(typeof window.attachEvent != 'undefined') {
	    	window.attachEvent('onload', func);
	    }
	    else if(typeof window.onload == 'function') {
    		var existing = onload;
    		window.onload = function() {
    			existing();
    			func();
    		};
    	}
    	else {
    		window.onload = func;
    	}
    }

    function addScrollHandler(func) {
    	if(typeof window.onscroll == 'function') {
    		var existing = onload;
    		window.onscroll = function() {
    			existing();
    			func();
    		};
    	}
    	else {
    		window.onscroll = func;
    	}
    }

	return {
	    init : function(swfDivId) {
	        _swfDivId = swfDivId;
			addLoadHandler(onPageLoad)
		    addScrollHandler(onScrollUpdate)
	        return this;
	    },
	    setContentHeight : function(height) {
   	        if (boundsEnforcer)
            	boundsEnforcer.style.height = (height + "px");
            else
                h = height;
        },
        getContentHeight : function() {
    	    return boundsEnforcer.style.height;
        },
        setContentWidth : function(width) {
            if (boundsEnforcer)
            	boundsEnforcer.style.width = (width + "px");
            else
                w = width;
        },
        getContentWidth : function() {
        	return boundsEnforcer.style.width;
        }
    };
}();