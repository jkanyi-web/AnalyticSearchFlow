console.log('search.js loaded');

export function start() {
  var searchBox = document.getElementById('search-box');
  var searchButton = document.getElementById('search-button');
  var sessionId = Date.now();
  var maxRetries = 3;
  var timer;
  var delay = 2500;

  var fetchAndLogAnalytics = function () {
    console.log('fetchAndLogAnalytics called');
    fetch('/analytics', {
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
    })
      .then(response => response.json())
      .then(mostCommonQueries => {
        localStorage.setItem('mostCommonQueries', JSON.stringify(mostCommonQueries));
        displayMostCommonQueries(mostCommonQueries);
      });
  };

  var displayMostCommonQueries = function(mostCommonQueries) {
    var mostCommonQueriesList = document.getElementById('most-common-queries');
    mostCommonQueriesList.innerHTML = '';

    for (var query in mostCommonQueries) {
      var listItem = document.createElement('li');
      listItem.textContent = `${query}: ${mostCommonQueries[query]}`;
      mostCommonQueriesList.appendChild(listItem);
    }
  };

  var sendSearchQuery = function() {
    if (searchBox.value.trim() !== '') {
      var retries = 0;
      var executeFetch = function() {
        fetch('/searches', {
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
        })
        .then(response => {
          if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
          }
          return response.json();
        })
        .then(json => {
          console.log(json);
          fetchAndLogAnalytics();
        })
        .catch(error => {
          console.log('There was a problem with the fetch operation: ' + error.message);
          if (retries < maxRetries) {
            retries++;
            console.log(`Retry ${retries} of ${maxRetries}`);
            executeFetch();
          } else {
            console.log('Failed to record search after multiple attempts.');
          }
        });
      };
      executeFetch();
    }
  };

  var storedMostCommonQueries = localStorage.getItem('mostCommonQueries');
  if (storedMostCommonQueries) {
    displayMostCommonQueries(JSON.parse(storedMostCommonQueries));
  }

  searchButton.addEventListener('click', function() {
    clearTimeout(timer);
    sendSearchQuery();
  });

  searchBox.addEventListener('input', function(event) {
    clearTimeout(timer);
    timer = setTimeout(sendSearchQuery, delay);
  });

  searchBox.addEventListener('keydown', function(event) {
    if (event.key === 'Enter') {
      clearTimeout(timer);
      sendSearchQuery();
    }
  });
}
