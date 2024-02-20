document.addEventListener('DOMContentLoaded', function() {
  var searchBox = document.querySelector('#search-box');
  var sessionId = Date.now(); // Generate a unique sessionId

  var sendSearchQuery = debounce(function() {
    fetch('/searches', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({
        search: {
          query: searchBox.value,
          session_id: sessionId // Include the sessionId in the request
        }
      })
    });
  }, 300);

  var finalizeSearch = function() {
    fetch('/searches/finalize_search', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({
        search: {
          query: searchBox.value,
          session_id: sessionId
        }
      })
    });
  };

  searchBox.addEventListener('input', sendSearchQuery);
  searchBox.addEventListener('blur', finalizeSearch);
});

function debounce(func, wait) {
  var timeout;

  return function executedFunction() {
    var context = this;
    var args = arguments;
    
    var later = function() {
      timeout = null;
      func.apply(context, args);
    };
    
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
};
