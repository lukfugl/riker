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

  populateColumn: function(date) {
    var values = this.fetchColumnValues(date);
    var schedule = this; // since +this+ will change inside the block
    values.each(function(pair) {
      var index = schedule.indexCell(date, pair.key);
      schedule.cells[index].innerHTML = pair.value.volunteer;
    });
  },

  populateTable: function() {
    for (var j = 0; j < 7; j++) {
      var date = this.dateForColumn(j);
      this.populateColumn(date);
    }
  },

  fetchColumnValues: function(date) {
    // TODO: fetch values from server. for now build some random values
    var values = new Hash();
    for (var i = 0; i < 14; i++) {
      var hour = this.hourForRow(i);
      values.set(hour, { volunteer: [ '', 'Hans', 'Jacob', 'Von' ][(date % hour) % 4] });
    }
    return values;
  },

  adjustAnchorDate: function(days) {
    this.anchorDate = new Date(this.anchorDate.getTime() + 86400000 * days);
  },
      
  anchorToPreviousDay: function() {
    this.adjustAnchorDate(-1);

    // add new date header and remove last date header
    var row = this.table.childNodes[1];
    row.insertBefore(this.buildDateHeader(this.anchorDate), row.childNodes[1]);
    row.removeChild(row.lastChild);

    // for each hour, add new cell and remove last cell
    for (var i = 0; i < 14; i++) {
      row = row.nextSibling;
      var hour = this.hourForRow(i);
      row.insertBefore(this.buildCell(this.anchorDate, hour), row.childNodes[1]);
      row.removeChild(row.lastChild);
    }

    // fill the new column
    this.populateColumn(this.anchorDate);
  },
      
  anchorToNextDay: function() {
    this.adjustAnchorDate(1);

    // remove first date header and add new date header
    var row = this.table.childNodes[1];
    row.removeChild(row.childNodes[1]);
    row.appendChild(this.buildDateHeader(this.dateForColumn(6)));

    // for each hour, add new cell and remove last cell
    for (var i = 0; i < 14; i++) {
      row = row.nextSibling;
      var hour = this.hourForRow(i);
      row.removeChild(row.childNodes[1]);
      row.appendChild(this.buildCell(this.dateForColumn(6), hour));
    }

    // fill the new column
    this.populateColumn(this.dateForColumn(6));
  },
      
  anchorToPreviousSunday: function() {
    var n = this.anchorDate.getDay();
    if (n == 0) { n = 7; }
    for (var i = 0; i < n; i++) {
      this.anchorToPreviousDay();
    }
  },

  anchorToNextSunday: function() {
    var n = 7 - this.anchorDate.getDay();
    for (var i = 0; i < n; i++) {
      this.anchorToNextDay();
    }
  },
});
