window.addEventListener('load', listify, false)


function listify() {
    let LIs = document.querySelectorAll("li");

    LIs.forEach(li => {
        let sp = li.querySelector('span');
        if (sp != null) {
            if (sp.hasAttribute('data-ico')) {
                if (!sp.classList.contains('no-bullet')) {
                    let ico = sp.getAttribute('data-ico');
                    color = RGBToHex(getComputedStyle(sp).color)
                    height = getComputedStyle(sp).fontSize
                    url = 'https://api.iconify.design/' + ico.replace(":", "/") + ".svg?height=" + height +"&color=" + color

                    var css ='url(' + url + ')'
                    li.style.listStyleImage = css
                    // li.style.setProperty('listStyleImage',css)
                    inner = li.querySelector('iconify-icon')
                    if (inner != null) {
                        inner.remove();
                    }
                }
            }
        }
    }
    );
}


// sniped from https://css-tricks.com/converting-color-spaces-in-javascript/
function RGBToHex(rgb) {
    // Choose correct separator
    let sep = rgb.indexOf(",") > -1 ? "," : " ";
    // Turn "rgb(r,g,b)" into [r,g,b]
    rgb = rgb.substr(4).split(")")[0].split(sep);
  
    let r = (+rgb[0]).toString(16),
        g = (+rgb[1]).toString(16),
        b = (+rgb[2]).toString(16);
  
    if (r.length == 1)
      r = "0" + r;
    if (g.length == 1)
      g = "0" + g;
    if (b.length == 1)
      b = "0" + b;
  
    return "%23" + r + g + b;
  }