;(function(window, document) {
    'use strict'

    function checkValidity(urlnode) {
        return fetch(urlnode.dataset.validateapi, {
            headers: {
                key: urlnode.dataset.apikey,
            },
        })
            .then(response => {
                return response.json()
            })
            .then(body => {
                let msg
                let classname
                if (!body.isValid) {
                    msg = 'This is healthcheck is invalid'
                    classname = 'invalid'
                } else if (body.needsUpgrade) {
                    msg =
                        "This healthcheck is valid, but isn't up-to-date with the latest standard"
                    classname = 'upgrade'
                } else {
                    msg = 'This healthcheck is valid'
                    classname = 'valid'
                }
                const savebutton = urlnode.querySelector('.save-button')
                savebutton.firstChild.nodeValue = msg
                savebutton.className += ` ${classname}`
            })
    }

    // Check the validity of a field on page load and each time the field changes
    function addChecks(input, group) {
        function checkInputValidity() {
            const classes =
                group.getAttribute('class') == null
                    ? ''
                    : group.getAttribute('class')
            if (!input.value) {
                group.setAttribute('class', classes)
            } else if (input.checkValidity()) {
                group.setAttribute('class', `${classes} o-forms--valid`)
            } else {
                group.setAttribute('class', `${classes} o-forms--error`)
            }
        }
        input.addEventListener('change', checkInputValidity)
        checkInputValidity()
    }

    document.addEventListener('DOMContentLoaded', () => {
        const savedmessagetitle = document.getElementByID('saved h3')
        if (savedmessagetitle)
            savedmessagetitle.addEventListener('click', () => {
                const { collapse } = savedmessagetitle.parentNode.dataset
                savedmessagetitle.parentNode.dataset.collapse =
                    collapse !== 'true'
            })

        const systemcodeinput = document.getElementByID('systemCode')
        addChecks(systemcodeinput, systemcodeinput.parentNode)

        const idinput = document.getElementByID('id')
        // Checks for duplicate IDs are done prior to this function, no need for AddChecks call

        const baseinput = document.getElementByID('base')
        addChecks(baseinput, baseinput.parentNode)

        const protocolinput = document.getElementByID('protocol')

        function updateBaseURL() {
            let baseurl =
                protocolinput.value === 'both' ? 'http' : protocolinput.value
            baseurl += `://${baseinput.value}/`
            const baseurlnodes = Array.from(
                document.querySelectorAll('.baseurl')
            )
            baseurlnodes.forEach(node => {
                node.firstChild.nodeValue = baseurl
            })
        }

        idinput.addEventListener('change', updateBaseURL)
        protocolinput.addEventListener('change', updateBaseURL)
        baseinput.addEventListener('change', updateBaseURL)

        const urlnodes = Array.from(document.querySelectorAll('.url'))
        urlnodes.forEach(checkValidity)
    })
})(window, document)
