var path = require('path'),
    fs   = require('fs');

describe('app', function() {
  var geomockScript = fs.readFileSync(path.join(__dirname, '/geomock.js'), 'utf-8');
  browser.executeScript(geomockScript);
  browser.executeScript('navigator.geolocation.waypoints = [{ coords: {  longitude: -90.0500, latitude: 29.9667 } }];'); // mock nola's cooardinates

  beforeEach(function() {
    browser.get('http://localhost:9292');
  });

  it('should be able to display the best station by geolocation', function() {
    $('.location-field button').click();
    browser.sleep(1000); // sleep for the exact 1 second geomock.js will artificially delay for
    $('.submit-form').click();

    $('.best-station, .best-station-controls, .best-station-summary').isDisplayed().then(function(result) {
      expect(result).toBe(true);
    });

    expect($('.best-station-label').getText()).toBe('89.9 FM - WWNO');
  });

  it('should be able to display the best station by manually-entered address', function() {
    element(by.model('location')).sendKeys('70130');

    $('.submit-form').click();

    $('.best-station, .best-station-controls, .best-station-summary').isDisplayed().then(function(result) {
      expect(result).toBe(true);
    });

    expect($('.best-station-label').getText()).toBe('89.9 FM - WWNO');
  });
});
