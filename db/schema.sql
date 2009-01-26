CREATE TABLE "slots" (
	"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	"day" date,
	"hour" integer,
	"layer" varchar(255),
	"label" varchar(255)
);
CREATE UNIQUE INDEX "slots_primary_key" ON "slots" ("day", "hour", "layer");
CREATE INDEX "slots_index_day_hour" ON "slots" ("day", "hour");
CREATE INDEX "slots_index_day_layer" ON "slots" ("day", "layer");
CREATE INDEX "slots_index_day" ON "slots" ("day");
