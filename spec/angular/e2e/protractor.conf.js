exports.config = {

  seleniumAddress: 'http://localhost:4444/wd/hub',

  specs: [
    './scenarios.js',
  ],

  capabilities: {
    'browserName': 'chrome'
  },

  baseUrl: 'http://localhost:8000',

  framework: 'jasmine',
  
  jasmineNodeOpts: {
    isVerbose: true,
    showColors: true,
    includeStackTrace: true
  }
};
