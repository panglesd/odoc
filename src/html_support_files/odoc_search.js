function createWebWorker() {
  var parts = document.location.href.split("/");
  parts[parts.length - 1] = search_url;
  var blobContents = ['importScripts("' + parts.join("/") + '");'];
  var blob = new Blob(blobContents, { type: "application/javascript" });
  var blobUrl = URL.createObjectURL(blob);

  var worker = new Worker(blobUrl);
  URL.revokeObjectURL(blobUrl);

  return worker;
}

var worker = createWebWorker();

document.querySelector(".search-bar").addEventListener("input", (ev) => {
  worker.postMessage(ev.target.value);
});

function hasType(kind) {
  return kind === "val" || kind === "constructor" || kind === "field";
}

function hasName(kind) {
  return true;
}

worker.onmessage = (e) => {
  let results = e.data;
  let search_result = document.querySelector(".search-result");
  search_result.innerHTML = "";
  let f = (entry) => {
    entry.kind = entry.id[entry.id.length - 1].kind;
    let container = document.createElement("a");
    container.href = base_url + entry.url;
    container.classList.add("search-entry", entry.kind.replace(" ", "-"));
    let title = document.createElement("code");
    title.classList.add("entry-title");
    let kind = document.createElement("span");
    kind.innerText = entry.kind;
    kind.classList.add("entry-kind");
    let prefixname = document.createElement("span");
    prefixname.classList.add("prefix-name");
    prefixname.innerText =
      entry.id
        .slice(0, entry.id.length - 1)
        .map((x) => x.name)
        .join(".") + (entry.id.length > 1 && entry.name != "" ? "." : "");

    title.appendChild(kind);
    title.appendChild(prefixname);

    let has_name = hasName(entry.kind);
    if (has_name) {
      let name = document.createElement("span");
      name.classList.add("entry-name");
      name.innerText = entry.id[entry.id.length - 1].name;
      title.appendChild(name);
    }
    let has_type = hasType(entry.kind);
    if (has_type) {
      let type = document.createElement("code");
      type.classList.add("entry-type");
      type.innerHTML = ": " + entry.type;
      title.appendChild(type);
    }
    let comment = document.createElement("div");
    comment.innerHTML = entry.doc.html;
    comment.classList.add("entry-comment");

    container.appendChild(title);
    container.appendChild(comment);

    search_result.appendChild(container);
  };
  results.map(f);
};
