let fill_expansions = function() {
    document.querySelectorAll(".unfetched-expansion").forEach((container) => {
        let inlined_info = container.querySelector(".inlined-expansion-information");
        let open_summary = document.createElement("span")
        let suffix = document.createElement("span")
        let closed_summary = container.querySelector(".closed-summary");
        let src = inlined_info.getAttribute("data-src");
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                let element_container = document.createElement("html");
                element_container.innerHTML = this.responseText;
                let sanitize = function(el) {
                    el.querySelectorAll("[id], [name]").forEach((elem) => {
                        elem.removeAttribute("id");
                        elem.removeAttribute("name");
                    });
                    el.querySelectorAll("a[href]").forEach((elem) => {
			let base_url = new URL(src, window.location);
                        let href = elem.getAttribute("href");
			let url = new URL(href, base_url);
                        elem.href=url.href;
                    });
                    // el.querySelectorAll(".expansion-details .expansion-details").forEach((elem) => {
		    //     console.log(elem);
                    //     let d = document.createElement('div');
                    //     d.innerHTML = elem.innerHTML;
                    //     d.className = elem.className;
                    //     elem.parentNode.replaceChild(d, elem);
                    // })
                }
                let preamble = element_container.querySelector(".odoc-preamble");
                let content = element_container.querySelector(".odoc-content");
                container.innerHTML = "";
                let details = document.createElement("details");
                let inlined = document.createElement("div");
		inlined.classList.add("inlined-expansion");
                let summary = document.createElement("summary");
                summary.appendChild(closed_summary);
                summary.appendChild(open_summary);
                details.appendChild(summary);
		open_summary.outerHTML = inlined_info.getAttribute("data-summary");
                if(preamble) {
                    sanitize(preamble);
                    inlined.appendChild(preamble);
                }
                if(content) {
                    sanitize(content);
                    inlined.appendChild(content);
                }
                details.appendChild(inlined);		
                details.appendChild(suffix);
		suffix.outerHTML = inlined_info.getAttribute("data-suffix");
                container.appendChild(details);
            }
        };
        xhttp.open("GET", src, true);
        xhttp.send();
    })
}

window.addEventListener("load", fill_expansions);
