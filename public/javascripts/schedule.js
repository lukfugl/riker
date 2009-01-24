Schedule = Class.create({
  initialize: function(table) {
    today = new Date();
    today.setHours(12);
    sunday = new Date(today.getTime() - 86400000 * today.getDay());

    this.table = table;
    this.anchorDate = sunday;
    this.cells = new Hash();

    this.table.hide();
    this.buildTable();
    this.populateTable();
    this.table.show();
  },

  indexCell: function(date, hour) {
    return date + "|" + hour;
  },

  dateForColumn: function(col) {
    return new Date(this.anchorDate.getTime() + col * 86400000);
  },

  hourForRow: function(row) {
    return 8 + row;
  },

  adjustAnchorDate: function(days) {
    this.anchorDate = new Date(this.anchorDate.getTime() + 86400000 * days);
  },
      
  anchorToPreviousDay: function() {
    adjustAnchorDate(-1);
  },
      
  anchorToNextDay: function() {
    adjustAnchorDate(1);
  },
      
  anchorToPreviousSunday: function() {
    if (this.anchorDate.getDay() == 0) {
      // on sunday, slide a full week
      adjustAnchorDate(-7);
    } else {
      // slide to sunday
      adjustAnchorDate(-1 * this.anchorDate.getDay());
    }
  },

  anchorToNextSunday: function() {
    adjustAnchorDate(7 - this.anchorDate.getDay());
  },

  buildSpacerHeader: function() {
    var header = document.createElement("th");
    header.setAttribute("class", "spacerHeader");
    return header;
  },

  buildDateHeader: function(date) {
    var header = document.createElement("th");
    header.innerHTML = date.strftime("%A<br/>%b %d, %Y");
    header.setAttribute("class", "dateHeader");
    return header;
  },

  buildDateHeaderRow: function() {
    var row = document.createElement("tr");
    row.appendChild(this.buildSpacerHeader());
    for (var i = 0; i < 7; i++) {
      var date = this.dateForColumn(i);
      row.appendChild(this.buildDateHeader(date));
    }
    return row;
  },

  buildHourHeader: function(hour) {
    var header = document.createElement("th");
    var am_pm = (hour >= 12 ? "pm" : "am");
    hour = (hour - 1) % 12 + 1
    header.innerHTML = hour + ":00" + am_pm;
    header.setAttribute("class", "hourHeader");
    return header;
  },

  buildCell: function(date, hour) {
    var index = this.indexCell(date, hour);
    this.cells[index] = document.createElement("td");
    return this.cells[index];
  },

  buildHourRow: function(hour) {
    var row = document.createElement("tr");
    row.appendChild(this.buildHourHeader(hour));
    for (var j = 0; j < 7; j++) {
      var date = this.dateForColumn(j);
      row.appendChild(this.buildCell(date, hour));
    }
    return row;
  },

  buildTable: function() {
    this.table.appendChild(this.buildDateHeaderRow());
    for (var i = 0; i < 14; i++) {
      var hour = this.hourForRow(i);
      this.table.appendChild(this.buildHourRow(hour));
    }
  },

  populateCell: function(date, hour) {
    var index = this.indexCell(date, hour);
    // fetch value from server ...
  },

  populateColumn: function(date) {
    for (var i = 0; i < 14; i++) {
      var hour = this.hourForRow(i);
      this.populateCell(date, hour);
    }
  },

  populateTable: function() {
    for (var j = 0; j < 7; j++) {
      var date = this.dateForColumn(j);
      this.populateColumn(date);
    }
  },
});
