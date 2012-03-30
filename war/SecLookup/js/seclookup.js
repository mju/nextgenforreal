$(function() {
	
	function log( message ) {
		message.reverse();
		$( "#log" ).replaceWith("<div id=\"log\" style=\"height: 200px; width: 300px; overflow: auto;\" class=\"ui-widget-content\"></div>");
		for (var i in message) {
			var line = message[i];
			$( "<div/>" ).text( line ).prependTo( "#log" );
		}
		$( "#log" ).scrollTop( 0 );
	}
	
	$( "#seclookup" ).autocomplete({
		source: function( request, response ) {
		    $.ajax({
		        /* Snip */
		    	url: "/seclookup",
		    	dataType: "jsonp",
				data: {
					featureClass: "P",
					style: "full",
					maxRows: 12,
					name_startsWith: request.term
				},
		    	statusCode: {
		    		200: function(data) {
		    			response( $.map( data.securities, function( item ) {
							return {
								label: item.label + ': ' + item.value,
								value: item.value,
								price: item.price,
								marketCap: item.marketCap
							}
						}));
		    			//alert("page not found");
	        	    }
		    	}
		    });
		},
		select: function( event, ui ) {
			var secVals = new Array();
			if(ui.item) {
				secVals[0] = "Selected   : " + ui.item.label;
				secVals[1] = "Price      : " + ui.item.price;
				secVals[2] = "Market Cap : " + ui.item.marketCap;
			}
			
			log( secVals );
		}
	});
});