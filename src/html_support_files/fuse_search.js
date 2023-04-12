document.querySelector(".search-bar").addEventListener("input", (event) => {
    let results = idx_fuse.search(event.target.value);
    let search_result = document.querySelector(".search-result");
    search_result.innerHTML = "";
    let f = (entry) => {
        let container = document.createElement("a");
        container.style = "display:flex; margin: 10px;"
        let name = document.createElement("div");
        name.style = "padding-right: 10px;"
        name.innerText = entry.item.name;
        let kind = document.createElement("div");
        kind.style = "padding-left: 10px;"
        kind.innerText = entry.item.kind;
        let comment = document.createElement("div");
        comment.innerText = entry.item.comment;
        container.href = base_url + entry.item.url;
        container.appendChild(name);
        container.appendChild(comment);
        container.appendChild(kind)
        search_result.appendChild(container);
    };
    results.map(f);
});