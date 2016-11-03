document.addEventListener("DOMContentLoaded", function() {
	var savedmessagetitle = document.querySelector('#saved h3');
	if (savedmessagetitle) savedmessagetitle.addEventListener('click', function () {
		savedmessagetitle.parentNode.dataset.collapse = savedmessagetitle.parentNode.dataset.collapse != "true";
	});

	/**
	 * Check the validity of a field on page load and each time the field changes
	 **/
	function addChecks(input, group) {
		function checkValidity() {
			var classes = group.getAttribute("class") == null ? "" : group.getAttribute("class");
			if(!input.value) {
				group.setAttribute("class", classes);
			} else if(input.checkValidity()){
				group.setAttribute("class", classes + " o-forms--valid");
			} else {
				group.setAttribute("class", classes + " o-forms--error");
			}
		}
		input.addEventListener('change', checkValidity);
		checkValidity();
	}

	var idinput = document.querySelector('#id');
	addChecks(idinput, idinput.parentNode);

	var nameinput = document.querySelector('#name');
	addChecks(nameinput, nameinput.parentNode);

	var descinput = document.querySelector('#description');
	addChecks(descinput, descinput.parentNode);

	var tierinput = document.querySelector('#serviceTier');
	addChecks(tierinput, tierinput.parentNode);

	var stageinput = document.querySelector('#lifecycleStage');
	addChecks(stageinput, stageinput.parentNode);

	var primaryinput = document.querySelector('#primary_name');
	addChecks(primaryinput, primaryinput.parentNode);

	var secondaryinput = document.querySelector('#secondary_name');
	addChecks(secondaryinput, secondaryinput.parentNode);

	var programmeinput = document.querySelector('#prog_name');
	addChecks(programmeinput, programmeinput.parentNode);

	var productownerinput = document.querySelector('#prod_name');
	addChecks(productownerinput, productownerinput.parentNode);

	var techleadinput = document.querySelector('#tech_name');
	addChecks(techleadinput, techleadinput.parentNode);

	var architecvtureinput = document.querySelector('#architectureDiagram');
	addChecks(architectureinput, architectureinput.parentNode);

	var repoinput = document.querySelector('#gitRepository');
	addChecks(repoinput, repoinput.parentNode);

	var hostinput = document.querySelector('#hostPlatform');
	addChecks(hostinput, hostinput.parentNode);

	var moreinput = document.querySelector('#moreInformation');
	addChecks(moreinput, moreinput.parentNode);
});
