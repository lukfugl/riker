Label = {
  zeropad: function(n) { return n > 9 ? n : '0' + n; },

  buildDayUrl: function(day) {
    return "/" + day.getFullYear() +
      "/" + this.zeropad(day.getMonth() + 1) +
      "/" + this.zeropad(day.getDate());
  },

  buildHourUrl: function(day, hour) {
    var url = this.buildDayUrl(day) + "/";
    if (hour < 10) { url += "0"; }
    url += hour;
    return url;
  },

  buildFullUrl: function(day, hour, layer) {
    return this.buildHourUrl(day, hour) + "/" + layer;
  },

  get: function(day, hour, layer) {
    new Ajax.Request(this.buildFullUrl(day, hour, layer), { method: 'get' })
  },

  get_all: function(day) {
    new Ajax.Request(this.buildDayUrl(day), { method: 'get' })
  },

  set: function(day, hour, layer, label) {
    new Ajax.Request(this.buildFullUrl(day, hour, layer), {
      method: 'post',
      contentType: 'text/plain',
      postBody: label
    })
  },
};
