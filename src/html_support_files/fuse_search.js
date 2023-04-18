document.querySelector(".search-bar").addEventListener("input", (event) => {
    let results = idx_fuse.search(event.target.value);
    let search_result = document.querySelector(".search-result");
    search_result.innerHTML = "";
    let f = (entry) => {
        let container = document.createElement("a");
        container.href = base_url + entry.item.url;
        container.classList.add("search-entry", entry.item.kind);
        let title = document.createElement("code");
        title.classList.add("entry-title");
        let kind = document.createElement("span");
        kind.innerText = entry.item.kind;
        kind.classList.add("entry-kind");
        let prefixname = document.createElement("span");
        prefixname.classList.add("prefix-name");
        prefixname.innerText = entry.item.prefixname != "" ? entry.item.prefixname+ "." : entry.item.prefixname;
        let name = document.createElement("span");
        name.classList.add("entry-name");
        name.innerText = entry.item.name;

        title.appendChild(kind);
        title.appendChild(prefixname);
        title.appendChild(name);

        let comment = document.createElement("div");
        comment.innerText = entry.item.comment;
        comment.classList.add("entry-comment");

        container.appendChild(title);
        container.appendChild(comment);

        search_result.appendChild(container);
    };
    results.map(f);
});
