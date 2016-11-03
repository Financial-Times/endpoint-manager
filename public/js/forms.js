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
			if(!input.value) {
				group.setAttribute("class","o-forms-group");
			} else if(input.checkValidity()){
				group.setAttribute("class","o-forms-group o-forms--valid");
			} else {
				group.setAttribute("class","o-forms-group o-forms--error");
			}
		}
		input.addEventListener('change', checkValidity);
		checkValidity();
	}
	var systemcodeinput = document.querySelector('#systemCode');
	addChecks(systemcodeinput, systemcodeinput.parentNode);

	var idinput = document.querySelector('#id');
	// checks for duplicate IDs are done prior to this function, no need for AddChecks call

	var baseinput = document.querySelector('#base');
	addChecks(baseinput, baseinput.parentNode);

	var protocolinput = document.querySelector('#protocol');

	function updateBaseURL() {
		var baseurl = (protocolinput.value == "both") ? "http" : protocolinput.value;
		baseurl += "://" + baseinput.value + "/";
		var baseurlnodes = document.querySelectorAll(".baseurl"), i;
		for (i = 0; i < baseurlnodes.length; i++) {
			baseurlnodes[i].firstChild.nodeValue = baseurl;
		}
	}
	idinput.addEventListener('change', updateBaseURL);
	protocolinput.addEventListener('change', updateBaseURL);
	baseinput.addEventListener('change', updateBaseURL);

	var urlnodes = document.querySelectorAll(".url"), i;
	for (i = 0; i < urlnodes.length; i++) {
		checkValidity(urlnodes[i]);
	}
	function checkValidity(urlnode) {
		fetch(urlnode.dataset.validateapi, {headers:{
			key: urlnode.dataset.apikey,
		}}).then(function (response) {
			return response.json();
		}).then(function (body) {
			var msg, classname;
			console.log(body);
			if (!body.isValid) {
				msg = "This is healthcheck is invalid";
				classname = "invalid";
			} else if(body.needsUpgrade) {
				msg = "This healthcheck is valid, but isn't up-to-date with the latest standard";
				classname = "upgrade";
			} else {
				msg = "This healthcheck is valid";
				classname = "valid";
			}
			var savebutton = urlnode.querySelector(".save-button");
			savebutton.firstChild.nodeValue = msg;
			savebutton.className += " " + classname;
		})
	}
});
