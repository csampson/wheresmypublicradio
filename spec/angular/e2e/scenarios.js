var path = require('path'),
    fs   = require('fs');

describe('wheresMyNpr', function() {
  beforeEach(function() {
    browser.get('http://localhost:9292');
  });

  it('should be able to display the best station by zipcode', function() {
    element(by.model('zipcode')).sendKeys('70130');
    $('.search-by-zip-field button').click();

    $('.best-station, .best-station-controls, .best-station-summary').isDisplayed().then(function(result) {
      expect(result).toBe(true);
    });

    expect($('.best-station-label').getText()).toBe('89.9 FM - WWNO');
  });

  it('should be able to display the best station by geolocation', function() {
    var geomockScript = fs.readFileSync(path.join(__dirname, '/geomock.js'), 'utf-8');

    browser.executeScript(geomockScript);
    browser.executeScript('navigator.geolocation.waypoints = [{ coords: {  longitude: -90.0500, latitude: 29.9667 } }];'); // mock nola's cooardinates

    $('.search-by-geolocation').click();

    browser.sleep(1000); // exact 1000ms delay from geomock

    $('.best-station, .best-station-controls, .best-station-summary').isDisplayed().then(function(result) {
      expect(result).toBe(true);
      expect($('.best-station-label').getText()).toBe('89.9 FM - WWNO');
    });
  });
});
