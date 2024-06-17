import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["editor", "suggestions"];

  connect() {
    if (this.editorTarget.type == 'text'){
      this.editorTarget.addEventListener('input', this.checkForHashtag.bind(this));
    }else{
      this.editorTarget.addEventListener('trix-change', this.checkForHashtag.bind(this));
    }
  }

  checkForHashtag(event) {
    const content = this.editorTarget.value;
    const hashtagPattern = /#(\w+)/g;

    let matching;
    const hashtags = [];
    while ((matching = hashtagPattern.exec(content)) !== null) {
      hashtags.push(matching[1]);
    }

    if (hashtags.length > 0) {
      const currentHashtag = hashtags[hashtags.length - 1];
      this.fetchSuggestions(currentHashtag);
    } else {
      this.hideSuggestions();
    }
  }

  fetchSuggestions(query) {
    fetch(`/home/suggest?query=${query}`)
      .then(response => response.json())
      .then(data => {
        this.showSuggestions(data);
      })
      .catch(error => {
        console.error('Error fetching suggestions:', error);
        this.hideSuggestions();
      });
  }

  showSuggestions(suggestions) {
    if (suggestions.length > 0) {
        this.suggestionsTarget.innerHTML = '';
        suggestions.map(element => {
          const item = document.createElement('div')
          item.style.cursor = 'pointer'
          item.style.width = '30vh'
          item.style.color = 'blue'
          item.textContent = `${element}`
          this.suggestionsTarget.appendChild(item)
          item.addEventListener('click', () => this.selectElement(element))
        });
        this.suggestionsTarget.style.display = 'block';
    } else {
      this.hideSuggestions();
    }
  }

  hideSuggestions() {
    this.suggestionsTarget.style.display = 'none';
  }

  selectElement(element) {
    const content = this.editorTarget.textContent;
    const hashtagPattern = /(#\w+)$/;
    const newContent = content.replace(hashtagPattern, `${element}`);
    this.editorTarget.value = newContent
    this.hideSuggestions();
    }
}
