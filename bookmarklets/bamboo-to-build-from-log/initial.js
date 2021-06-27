var initUrl = window.location;
var logFileName = initUrl.href.substring(initUrl.href.lastIndexOf('/') + 1);
var buildNumber = logFileName.split('.').slice(0, -1).join('.')
var baseUrl = initUrl.protocol + "//" + initUrl.host + "/browse/" + buildNumber;
var win = window.open(baseUrl, '_blank');
