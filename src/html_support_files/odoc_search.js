function hasType(kind) {
  return (kind === "val" || kind === "constructor" || kind === "field");
}

function hasName(kind) {
  return true;
}

document.querySelector(".search-bar").addEventListener("input", (event) => {
  let results = odoc_search(event.target.value);
  let search_result = document.querySelector(".search-result");
  search_result.innerHTML = "";
  let f = (entry) => {
    entry.kind = entry.id[entry.id.length-1].kind;
    let container = document.createElement("a");
    container.href = base_url + entry.url;
    container.classList.add("search-entry", entry.kind.replace(' ', '-'));
    let title = document.createElement("code");
    title.classList.add("entry-title");
    let kind = document.createElement("span");
    kind.innerText = entry.kind;
    kind.classList.add("entry-kind");
    let prefixname = document.createElement("span");
    prefixname.classList.add("prefix-name");
    prefixname.innerText =
      entry.id.slice(0,entry.id.length -1).map(x => x.name).join('.') +
      (entry.prefixname != "" && entry.name != "" ? "." : "");

    title.appendChild(kind);
    title.appendChild(prefixname);

    let has_name = hasName(entry.kind);
    if (has_name) {
      let name = document.createElement("span");
      name.classList.add("entry-name");
      name.innerText = entry.id[entry.id.length-1].name;
      title.appendChild(name);
    }
    let has_type = hasType(entry.kind);
    if (has_type) {
      let type = document.createElement("code");
      type.classList.add("entry-type");
      type.innerHTML = ": " + entry.type
      title.appendChild(type);
    }
    let comment = document.createElement("div");
    comment.innerText = entry.doc;
    comment.classList.add("entry-comment");

    container.appendChild(title);
    container.appendChild(comment);

    search_result.appendChild(container);
  };
  results.map(f);
});
