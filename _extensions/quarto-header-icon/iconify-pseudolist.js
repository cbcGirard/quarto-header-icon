window.addEventListener('load', listify, false)


function listify() {
    let LIs = document.querySelectorAll("li");

    LIs.forEach(li => {
        let sp = li.querySelector('span');
        if (sp != null) {
            if (sp.hasAttribute('data-ico')) {
                let ico = sp.getAttribute('data-ico');
                url = 'https://api.iconify.design/' + ico.replace(":", "/") + ".svg?height=1em"
                li.style.listStyleImage = 'url(' + url + ')'
                inner = li.querySelector('iconify-icon')
                inner.remove();
            }
        }
    }
    );
}