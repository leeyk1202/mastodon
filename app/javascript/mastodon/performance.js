//
// Tools for performance debugging, only enabled in development mode.
// Open up Chrome Dev Tools, then Timeline, then User Timing to see output.
// Also see config/webpack/loaders/mark.js for the webpack loader marks.
//

let marky;

if (process.env.NODE_ENV === 'development') {
  marky = require('marky');
  require('react-addons-perf').start();
}

export function start(name) {
  if (process.env.NODE_ENV === 'development') {
    marky.mark(name);
  }
}

export function stop(name) {
  if (process.env.NODE_ENV === 'development') {
    marky.stop(name);
  }
}
