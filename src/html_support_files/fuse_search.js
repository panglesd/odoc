document.querySelector(".search-bar").addEventListener("input", (event) => {
  let results = idx_fuse.search(event.target.value);
  let search_result = document.querySelector(".search-result");
  search_result.innerHTML = "";
  let f = (entry) => {
    let container = document.createElement("a");
    container.href = base_url + entry.item.url;
    container.classList.add("search-entry", entry.item.kind);

    let name = document.createElement("div");
    name.classList.add("entry-name");
    name.innerText = entry.item.name;

    let comment = document.createElement("div");
    comment.innerText = entry.item.comment;
    comment.classList.add("entry-comment");

    container.appendChild(name);
    container.appendChild(comment);

    search_result.appendChild(container);
  };
  results.map(f);
});
