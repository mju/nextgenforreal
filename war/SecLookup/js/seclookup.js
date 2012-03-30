$(function() {
	/*
	var availableTags = [
		"ActionScript",
		"AppleScript",
		"Asp",
		"BASIC",
		"C",
		"C++",
		"Clojure",
		"COBOL",
		"ColdFusion",
		"Erlang",
		"Fortran",
		"Groovy",
		"Haskell",
		"Java",
		"JavaScript",
		"Lisp",
		"Perl",
		"PHP",
		"Python",
		"Ruby",
		"Scala",
		"Scheme"
	];
	*/
	
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
								label: item.label,
								value: item.value
							}
						}));
		    			//alert("page not found");
	        	    }
		    	}
		    });
		}
	});
});