// requires sprintf.js

Label = {
  zeropad: function(n) { return n > 9 ? n : '0' + n; },

  buildDayUrl: function(day) {
    return '/' + day.replace(/-/g,'/')
  },

  buildFullUrl: function(day, hour, layer) {
    return sprintf("%s/%02d/%s", this.buildDayUrl(day), hour, layer);
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

  buildSlotID: function(day, hour) { 
    return sprintf('s%sT%02d', day, hour); 
  },

  buildIPE: function(day, hour) {
    // the layer is hard-coded for now. how to dynamically change it?
    return new Ajax.InPlaceEditor(this.buildSlotID(day, hour), '', this.buildFullUrl(day, hour, 'shifts'));
  }

};

// vim: sw=2
